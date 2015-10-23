<?php echo $header; ?>
<div id="content">
    <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
    </div>
    
    <?php if ($error_warning) { ?>
    <div class="warning"><?php echo $error_warning; ?></div>
    <?php } ?>
    
    <div class="box">
        <div class="left"></div>
        <div class="right"></div>
        <div class="heading">
                <h1><img src="view/image/payment.png" alt="" /> <?php echo $heading_title; ?></h1>
          <div class="buttons"><a onclick="$('#form').submit();" class="button"><span><?php echo $button_save; ?></span></a><a onclick="location='<?php echo $cancel; ?>';" class="button"><span><?php echo $button_cancel; ?></span></a></div>
        </div>
        
        <div class="content">
            
            <div id="tabs" class="htabs">
                <a href="#tab-general"><?php echo $text_tab_general; ?></a>
                <a href="#tab-links"><?php echo $text_tab_links; ?></a>
            </div>
            
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
                <div id="tab-general">
                    <table class="form">
                        <tr>
                            <td width="25%"><span class="required">*</span> <?php echo $entry_merchant; ?></td>
                            <td><input type="text" name="payparts_merchant_id" value="<?php echo $payparts_merchant_id; ?>" />
                            <br />
                            <?php if ($error_merchant) { ?>
                            <span class="error"><?php echo $error_merchant; ?></span>
                            <?php } ?></td>
                        </tr>
                        <tr>
                            <td><span class="required">*</span> <?php echo $entry_secret_key; ?></td>
                            <td><input type="text" name="payparts_secret_key" value="<?php echo $payparts_secret_key; ?>" />
                            <br />
                            <?php if ($error_secret_key) { ?>
                            <span class="error"><?php echo $error_secret_key; ?></span>
                            <?php } ?></td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_ccy; ?></td>
                            <td>
                                <select name="payparts_ccy">
                                    <?php 	$div_ccy = ''; ?>
                                    <?php if (strcasecmp($payparts_ccy, '980') == 0) { 
                                        $div_ccy .= "<option value='980' selected='selected'>UAH</option>";
                                    } else {
                                        $div_ccy .= "<option value='980'>UAH</option>";
                                    }

                                    if (strcasecmp($payparts_ccy, 'USD') == 0) { 
                                        $div_ccy .= "<option value='USD' selected='selected'>USD</option>";
                                    } else {
                                        $div_ccy .= "<option value='USD'>USD</option>";
                                    }

                                    if (strcasecmp($payparts_ccy, 'EUR') == 0) { 
                                        $div_ccy .= "<option value='EUR' selected='selected'>EUR</option>";
                                    } else {
                                        $div_ccy .= "<option value='EUR'>EUR</option>";
                                    }
                                    echo $div_ccy; ?>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Result URL:</td>
                            <td><?php echo $copy_result_url; ?></td>
                        </tr>
                        <tr>
                            <td>Success URL:</td>
                            <td><?php echo $copy_success_url; ?></td>
                        </tr>
                        <tr>
                            <td>Fail URL:</td>
                            <td><?php echo $copy_fail_url; ?></td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_type; ?></td>
                            <td>
                                <?php if (isset($payparts_pay_type['II'])) { ?>
                                <input type="checkbox" name="payparts_pay_type[II]" checked="checked" />
                                <?php } else { ?>
                                <input type="checkbox" name="payparts_pay_type[II]" />
                                <?php } ?>
                                <?php echo $text_pay_type_II; ?><br />
                                
                                <?php if (isset($payparts_pay_type['PP'])) { ?>
                                <input type="checkbox" name="payparts_pay_type[PP]" checked="checked"/>
                                <?php } else { ?>
                                <input type="checkbox" name="payparts_pay_type[PP]" />
                                <?php } ?>
                                <?php echo $text_pay_type_PP; ?><br />
                            <br />
                            </td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_test_mode; ?></td>
                            <td><?php if ($payparts_test_mode) { ?>
                            <input type="radio" name="payparts_test_mode" value="1" checked="checked" />
                            <?php echo $text_yes; ?>
                            <input type="radio" name="payparts_test_mode" value="0" />
                            <?php echo $text_no; ?>
                            <?php } else { ?>
                            <input type="radio" name="payparts_test_mode" value="1" />
                            <?php echo $text_yes; ?>
                            <input type="radio" name="payparts_test_mode" value="0" checked="checked" />
                            <?php echo $text_no; ?>
                            <?php } ?></td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_order_status_ok; ?></td>
                            <td>
                                <select name="payparts_order_status_id_ok">
                                    <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $payparts_order_status_id_ok) { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                    <?php } ?>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_order_status_wait; ?></td>
                            <td>
                                <select name="payparts_order_status_id_wait">
                                    <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $payparts_order_status_id_wait) { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                    <?php } ?>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_order_status_fail; ?></td>
                            <td>
                                <select name="payparts_order_status_id_fail">
                                    <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $payparts_order_status_id_fail) { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                    <?php } ?>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_geo_zone; ?></td>
                            <td><select name="payparts_geo_zone_id">
                            <option value="0"><?php echo $text_all_zones; ?></option>
                            <?php foreach ($geo_zones as $geo_zone) { ?>
                            <?php if ($geo_zone['geo_zone_id'] == $payparts_geo_zone_id) { ?>
                            <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
                            <?php } else { ?>
                            <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
                            <?php } ?>
                            <?php } ?>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_status; ?></td>
                            <td><select name="payparts_status">
                            <?php if ($payparts_status) { ?>
                            <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                            <option value="0"><?php echo $text_disabled; ?></option>
                            <?php } else { ?>
                            <option value="1"><?php echo $text_enabled; ?></option>
                            <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                            <?php } ?>
                            </select></td>
                        </tr>
                        <tr>
                            <td><?php echo $entry_sort_order; ?></td>
                            <td><input type="text" name="payparts_sort_order" value="<?php echo $payparts_sort_order; ?>" size="1" /></td>
                        </tr>
                    </table>
                </div>
                
                <div id="tab-links">
                    <table class="form">
                        <tr>
                            <td><?php echo $entry_allowed; ?></td>
                            <td><input type="text" name="allowed" value="" /></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <div id="payparts_product-allowed" class="scrollbox">
                                <?php $class = 'odd'; ?>
                                <?php foreach ($products_allowed as $product_allowed) { ?>
                                <?php $class = ($class == 'even' ? 'odd' : 'even'); ?>
                                <div id="payparts_product-allowed<?php echo $product_allowed['product_id']; ?>" class="<?php echo $class; ?>"> <?php echo $product_allowed['name']; ?><img src="view/image/delete.png" alt="" />
                                  <input type="hidden" name="product_allowed[]" value="<?php echo $product_allowed['product_id']; ?>" />
                                </div>
                                <?php } ?>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
              
            </form>
            
        </div>
    </div>
</div>

<script type="text/javascript"><!--
$('#tabs a').tabs();

// Related
$('input[name=\'allowed\']').autocomplete({
    delay: 500,
    source: function(request, response) {
        $.ajax({
            url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request.term),
            dataType: 'json',
            success: function(json) {		
                response($.map(json, function(item) {
                    return {
                        label: item.name,
                        value: item.product_id
                    }
                }));
            }
        });
    }, 
    select: function(event, ui) {
        $('#payparts_product-allowed' + ui.item.value).remove();

        $('#payparts_product-allowed').append('<div id="payparts_product-allowed' + ui.item.value + '">' + ui.item.label + '<img src="view/image/delete.png" alt="" /><input type="hidden" name="product_allowed[]" value="' + ui.item.value + '" /></div>');

        $('#payparts_product-allowed div:odd').attr('class', 'odd');
        $('#payparts_product-allowed div:even').attr('class', 'even');

        return false;
    },
    focus: function(event, ui) {
        return false;
    }
});

$('#payparts_product-allowed div img').live('click', function() {
    $(this).parent().remove();

    $('#payparts_product-allowed div:odd').attr('class', 'odd');
    $('#payparts_product-allowed div:even').attr('class', 'even');	
});
//--></script>
<?php echo $footer; ?>