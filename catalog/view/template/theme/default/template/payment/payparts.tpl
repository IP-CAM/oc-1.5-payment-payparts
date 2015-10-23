<div class="buttons">
  <div class="right">
    <input type="button" value="<?php echo $button_confirm; ?>" id="button-confirm" class="button" />
  </div>
</div>
<div class="container box-modal" id="payparts_box">
    <div class="box-modal_close arcticmodal-close"><button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button></div>
    
    <div class="row">
	<div class=" col-xs-12 col-sm-12">
            <img src="catalog/view/theme/default/image/privatbank.jpg" class="img-responsive" alt="" style="margin: auto;"/>
            
            <p class="lead text-center">Pассрочка оформляется на стоимость товара <?php echo $total; ?></p>
            
            <div class="well well-sm" style="text-align: justify;">
                Мгновенная рассрочка от ПриватБанка.
                "Оплата частями" доступна владельцам карт ПриватБанка: "Универсальная", "Универсальная Gold" и элитных карт для VIP-клиентов (Platinum, Infinite, World Signia / Ellite). 
            </div>
            

	</div>
    </div>
    
    <div class="row">
        <div class=" col-xs-12 col-sm-12">
            <form accept-charset="utf-8" method="post" id="payparts_form" class="form form-inline" role="form">
                <div class="col-md-4">
                    <label><?php echo $entry_type; ?></label>
                    
                    <select name="merchantType" class="form-control" id="merchantType">
                        <?php if (isset($payparts_pay_type['II'])) { ?>
                            <option value="II"><?php echo $text_pay_type_II; ?></option>
                        <?php } ?>
                        <?php if (isset($payparts_pay_type['PP'])) { ?>
                            <option value="PP"><?php echo $text_pay_type_PP; ?></option>
                        <?php } ?>
                    </select>
                </div>

                <div class="col-md-2">
                    <label><?php echo $entry_quantity; ?></label>
                    <select name="partsCount" class="form-control" id="partsCount">
                        <?php for($i=2; $i<=24; $i++) { ?>
                        <option value="<?php echo $i; ?>"><?php echo $i; ?> </option>
                        <?php } ?>
                    </select>
                </div>
                
                <div class="col-md-2">
                    <label><?php echo $entry_month_payment; ?></label>
                    <div class="form-control"><span id="month_payment"></span> <?php echo $text_currency; ?></div>
                </div>

                <div class="col-md-4">
                <label>&nbsp;</label> <br>
                <a id="payparts_confirm-button" class="btn btn-primary ladda-button" data-style="expand-right" data-size="l"><span class="ladda-label"><?php echo $button_confirm; ?></span></a>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript" src="https://ppcalc.privatbank.ua/pp_calculator/resources/js/calculator.js"></script>
<script type="text/javascript">
$('#button-confirm').live('click', function() {    
    $('#payparts_box').arcticmodal({});
});

$('#payparts_confirm-button').live('click', function(e) {
    e.preventDefault();
    
    var l = Ladda.create(this);

    $.ajax({ 
        type: 'post',
        url: 'index.php?route=payment/payparts/create',
        data: $("#payparts_form input[type='hidden'], #payparts_form input[type='text'], #payparts_form input[type='checkbox']:checked, #payparts_form select"),
        dataType: 'json',
        beforeSend: function() {
            l.start();
            $('.has-error').removeClass('has-error');//.addClass('has-info');
            $('span.help-inline').remove();
        },
        success: function(json) {
            console.log(json);
            if (json['error']) {
                for (i in json['error']) {
                    var $parent = $('#' + i).closest('.form-group').removeClass('has-info').addClass('has-error has-feedback');
                    $('<span>').addClass('help-inline').html(json['error'][i]).appendTo($parent);
                }
            } else if (json['success']) {
                location = json['continue'];
            }

        },
        complete: function() {
            l.stop();
        },
        error: function(xhr, ajaxOptions, thrownError) {
            console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
        }		
    });

});

$('#merchantType').live('change', function() {
    $('#partsCount').trigger('change');
});

$('#partsCount').live('change', function() {
    var resCalc = PP_CALCULATOR.calculatePhys($(this).val(), <?php echo $total_price; ?>);
    
    if ($('#merchantType').val() == 'II') {
        $('#month_payment').html(resCalc.ipValue);
    } else {
        $('#month_payment').html(resCalc.ppValue);
    }
});
</script>