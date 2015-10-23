<?php
class ControllerPaymentpayparts extends Controller {
    private $error = array();

    public function index() {

        $this->load->language('payment/payparts');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && ($this->validate())) {
            $this->load->model('setting/setting');

            $this->model_setting_setting->editSetting('payparts', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $this->redirect(HTTPS_SERVER . 'index.php?route=extension/payment&token=' . $this->session->data['token']);
        }
        
        $this->_setData(array(
            'heading_title',
            'text_enabled',
            'text_disabled',
            'text_tab_general',
            'text_tab_links',
            'text_all_zones',
            'text_pay_type_II',
            'text_pay_type_PP',
            'entry_order_status_ok',
            'entry_order_status_wait',
            'entry_order_status_fail',
            'entry_status',
            'entry_geo_zone',
            'entry_sort_order',
            'entry_allowed',
            'button_save',
            'button_cancel',
            'text_yes',
            'text_no',
            'entry_merchant',
            'entry_secret_key',
            'entry_ccy',
            'entry_hidden_key',
            'entry_type',
            'entry_test_mode'
        ));

        // URL
        $this->data['copy_result_url'] 	= HTTP_CATALOG . 'index.php?route=payment/payparts/callback';
        $this->data['copy_success_url']	= HTTP_CATALOG . 'index.php?route=payment/payparts/success';
        $this->data['copy_fail_url'] 	= HTTP_CATALOG . 'index.php?route=payment/payparts/fail';
        
        $this->data['token'] = $this->session->data['token'];

        if (isset($this->error['warning'])) {
                $this->data['error_warning'] = $this->error['warning'];
        } else {
                $this->data['error_warning'] = '';
        }

        if (isset($this->error['merchant_id'])) {
                $this->data['error_merchant'] = $this->error['merchant_id'];
        } else {
                $this->data['error_merchant'] = '';
        }

        if (isset($this->error['secret_key'])) {
                $this->data['error_secret_key'] = $this->error['secret_key'];
        } else {
                $this->data['error_secret_key'] = '';
        }

        $this->data['breadcrumbs'] = array();

        $this->data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_home'),
                'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => false
        );

        $this->data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_payment'),
                'href'      => $this->url->link('extension/payment', 'token=' . $this->session->data['token'], 'SSL'),
            'separator' => ' :: '
        );

        $this->data['breadcrumbs'][] = array(
        'text'      => $this->language->get('heading_title'),
                'href'      => $this->url->link('payment/payparts', 'token=' . $this->session->data['token'], 'SSL'),
        'separator' => ' :: '
        );

        $this->data['action'] = $this->url->link('payment/payparts', 'token=' . $this->session->data['token'], 'SSL');
        $this->data['cancel'] = $this->url->link('extension/payment', 'token=' . $this->session->data['token'], 'SSL');

        $this->setDataPost($this->request->post, array(
            'payparts_merchant_id',
            'payparts_secret_key',
            'payparts_ccy',
            'payparts_pay_type',
            'payparts_test_mode',
            'payparts_order_status_id_ok',
            'payparts_order_status_id_wait',
            'payparts_order_status_id_fail',
            'payparts_geo_zone_id',
            'payparts_status',
            'payparts_sort_order',
            'product_allowed',
        ));

        $this->load->model('localisation/order_status');
        $this->data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        $this->load->model('localisation/geo_zone');
        $this->data['geo_zones'] = $this->model_localisation_geo_zone->getGeoZones();
        
//        if (isset($this->request->post['product_allowed'])) {
//                $products = $this->request->post['product_allowed'];
//        } elseif (isset($this->request->get['product_id'])) {		
//                $products = $this->model_catalog_product->getProductRelated($this->request->get['product_id']);
//        } else {
//                $products = array();
//        }
//
//        $this->data['product_allowed'] = array();

        $this->load->model('catalog/product');
        foreach ($this->data['product_allowed'] as $product_id) {
                $related_info = $this->model_catalog_product->getProduct($product_id);

                if ($related_info) {
                        $this->data['products_allowed'][] = array(
                                'product_id' => $related_info['product_id'],
                                'name'       => $related_info['name']
                        );
                }
        }

        $this->template = 'payment/payparts.tpl';
        $this->children = array(
                'common/header',
                'common/footer'
        );

        $this->response->setOutput($this->render(TRUE), $this->config->get('config_compression'));
    }

    private function validate() {
        if (!$this->user->hasPermission('modify', 'payment/payparts')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        if (!$this->request->post['payparts_merchant_id']) {
            $this->error['merchant_id'] = $this->language->get('error_merchant');
        }

        if (!$this->request->post['payparts_secret_key']) {
            $this->error['secret_key'] = $this->language->get('error_secret_key');
        }

        if (!$this->error) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
    
    
}
?>