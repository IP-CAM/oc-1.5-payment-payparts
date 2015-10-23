<?php
class ControllerPaymentpayparts extends Controller {
    
  protected function index() {
      
    $this->load->language('payment/payparts');
    
    $this->_setData(array(
        'button_confirm',
        'text_pay_type_II',
        'text_pay_type_PP',
        'entry_type',
        'entry_quantity',
        'entry_month_payment'
    ));
    
    $this->load->model('checkout/order');

    $order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);
    
    $this->data['payparts_pay_type'] = $this->config->get('payparts_pay_type');
    
    if ($this->currency->getSymbolLeft() != '') {
        $this->data['text_currency'] = $this->currency->getSymbolLeft();
    } else {
        $this->data['text_currency'] = $this->currency->getSymbolRight();
    }
    
    $this->data['total'] = $this->currency->format($order_info['total']);
    $this->data['total_price'] = $order_info['total'];

    if ($this->request->get['route'] != 'checkout/guest_step_3') {
      $this->data['cancel_return'] = HTTPS_SERVER . 'index.php?route=checkout/payment';
    } else {
      $this->data['cancel_return'] = HTTPS_SERVER . 'index.php?route=checkout/guest_step_2';
    }

    if ($this->request->get['route'] != 'checkout/guest_step_3') {
      $this->data['back'] = HTTPS_SERVER . 'index.php?route=checkout/payment';
    } else {
      $this->data['back'] = HTTPS_SERVER . 'index.php?route=checkout/guest_step_2';
    }

    if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/payparts.tpl')) {
      $this->template = $this->config->get('config_template') . '/template/payment/payparts.tpl';
    } else {
      $this->template = 'default/template/payment/payparts.tpl';
    }

    $this->response->setOutput($this->render());
  }

  public function fail() {
    $this->redirect(HTTPS_SERVER . 'index.php?route=checkout/checkout');
  }

    public function success() {
        
        $signature = base64_encode(sha1(
            $this->config->get('payparts_secret_key') .
            $this->config->get('payparts_merchant_id') .
            $this->session->data['order_id'] .
            $this->config->get('payparts_secret_key'), true
        ));
        
        $data = array(
            'storeId' => $this->config->get('payparts_merchant_id'),
            'orderId' => $this->session->data['order_id'],
            'signature' => $signature,
        );
        
        $url = "https://payparts2.privatbank.ua/ipp/v2/payment/state";    
        $content = json_encode($data);
        
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array("Accept: application/json","Accept-Encoding: UTF-8","Content-type: application/json; charset=UTF-8"));
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

        $json_response = curl_exec($curl);
        curl_close($curl);

        $response = json_decode($json_response, true);

        if (isset($response['state']) && $response['state'] == 'SUCCESS') {
            if ($response['paymentState'] == 'SUCCESS') {
                $this->redirect($this->url->link('checkout/success', '', 'SSL'));
            } else {
                $this->redirect($this->url->link('checkout/checkout', '', 'SSL'));
            }
        }
    
  }

    public function callback() 
    {
        $this->load->model('checkout/order');
        $order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);

        if ($order_info && isset($this->request->post['paymentState'])) {
            
            if ($this->request->post['paymentState'] == 'SUCCESS') {
                $payment_status = $this->config->get('payparts_order_status_id_success');
            } elseif ($this->request->post['paymentState'] == 'CLIENT_WAIT') {
                $payment_status = $this->config->get('payparts_order_status_id_wait');
            } elseif ($this->request->post['paymentState'] == 'FAIL') {
                $payment_status = $this->config->get('payparts_order_status_id_fail');
            } else {
                $payment_status = $this->config->get('payparts_order_status_id_fail');
                $comment .= 'Payment Satatus: ' . $this->request->post['paymentState'] .'. ';
            }
            
            $comment  = isset($this->request->post['message']) ? isset($this->request->post['message']) : '';
            
            $this->model_checkout_order->confirm($order_info['order_id'], $payment_status, $comment, true);
            $this->redirect($this->url->link('checkout/success', '', 'SSL'));
        } else {
                $this->response->addHeader($this->request->server['SERVER_PROTOCOL'] . '/1.1 404 Not Found');
        }
    }
  
  public function create() {
    $json = array();
    $products_string = '';
      
    if(!$json) {
        $this->load->model('checkout/order');
        $this->load->model('payment/pay_later');

        $responseUrl = $this->url->link('payment/payparts/callback');
        $redirectUrl = $this->url->link('payment/payparts/success');
            
        $order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);
        
        $products = $this->cart->getProducts();
        foreach ($products as $product) {
            
            // Display prices
            if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                    $price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')));
            } else {
                    $price = false;
            }

            // Display prices
//            if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
//                    $total = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity']);
//            } else {
//                    $total = false;
//            }

            $products_data[] = array(
                'name'  => $product['name'],
                'price' => number_format($product['price'], 2, '.', ''),
                'count' => $product['quantity']
            );
            
            $products_string .= $products_string . $product['name'] . $product['quantity'] . number_format($product['price'], 2, '', '');
        }
        
        if (isset($this->session->data['shipping_method']) && $this->session->data['shipping_method']['cost'] > 0) {
            
            $products_data[] = array(
                'name'  => $this->session->data['shipping_method']['title'],
                'price' => number_format($this->session->data['shipping_method']['cost'], 2, '.', ''),
                'count' => 1
            );
            
            $products_string .= $this->session->data['shipping_method']['title'] . '1' . number_format($this->session->data['shipping_method']['cost'], 2, '', '');
        }
        
        $signature = base64_encode(sha1(
            $this->config->get('payparts_secret_key') .
            $this->config->get('payparts_merchant_id') .
            $this->session->data['order_id'] .
            number_format($order_info['total'], 2, '', '') .
            $this->config->get('payparts_ccy') .
            $this->request->post['partsCount'] .
            $this->request->post['merchantType'] .
            $responseUrl .
            $redirectUrl .
            $products_string .
            $this->config->get('payparts_secret_key'), true
        ));
        
        $data = array(
            'storeId' => $this->config->get('payparts_merchant_id'),
            'orderId' => $this->session->data['order_id'],
            'amount' => number_format($order_info['total'], 2, '.', ''),
            'currency' => $this->config->get('payparts_ccy'),
            'partsCount' => $this->request->post['partsCount'],
            'merchantType' => $this->request->post['merchantType'],
            'products' => $products_data,
            'responseUrl' => $responseUrl,
            'redirectUrl' => $redirectUrl,
            'signature' => $signature,
        );
        
        $url = "https://payparts2.privatbank.ua/ipp/v2/payment/create";    
        $content = json_encode($data);
        
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array("Accept: application/json","Accept-Encoding: UTF-8","Content-type: application/json; charset=UTF-8"));
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

        $json_response = curl_exec($curl);
        curl_close($curl);

        $response = json_decode($json_response, true);
        
        $json['response'] = $response;
        $json['data'] = $data;
        $json['signature'] = $signature;
        $json['products_string'] = $products_string;


        if (isset($response['state']) && $response['state'] == 'SUCCESS') {
            $json['success'] = TRUE;
            $json['continue'] = 'https://payparts2.privatbank.ua/ipp/v2/payment?token=' . $response['token'];
            
            $this->model_checkout_order->confirm($this->session->data['order_id'], $this->config->get('payparts_order_status_id_wait'), '', true);
        } else {
            $json['success'] = FALSE;
            $json['error']['state'] = 'FAIL';
            $json['error']['message'] = $response['message'];
        }
        
      }
      
      $this->response->setOutput(json_encode($json));
  }
  
    public function setPayment() {
      
        $json = array();
        
        $this->session->data['payment_method']['code'] = 'payparts';
        
        $json['success'] = TRUE;
        $json['redirect'] = $this->url->link('checkout/checkout', '', 'SSL');
        
        $this->response->setOutput(json_encode($json));
    }

}
?>