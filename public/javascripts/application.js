// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
    $("#customer_name").autocomplete("/customers.js", {
        autoFill:true,
        selectFirst:true
    });
});

$(function() {
    $("#opportunity_order_date").datepicker({
        numberOfMonths:3,
        stepMonths:3,
        dateFormat: 'yy-mm-dd'
    });
});

$(function() {
    $(".pick_a_date").datepicker({
        numberOfMonths:3,
        stepMonths:3,
        dateFormat: 'yy-mm-dd'
    });
});

$(function() {
    $("#account_target_fiscal_year_end").datepicker({
        numberOfMonths:3,
        stepMonths:3,
        dateFormat: 'yy-mm-dd'
    });
});


$(function() {
	var dates = $( "#from, #to" ).datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 3,
		stepMonths:3,
        dateFormat: 'yy-mm-dd',
		onSelect: function( selectedDate ) {
			var option = this.id == "from" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );
		}
	});
});


jQuery(function(){
	jQuery('ul.sf-menu').superfish();
});

$(document).ready( function() {
   $('input.initial-focus:first').focus(); // choose first just in case
});

// using the jquery.calculation plugin
$('.add_me_up').live('keyup', function(){
  $('.add_me_up').sum('keyup', '#opportunity_order_value');
  $('#opportunity_order_value').trigger('keyup');
});
 
// using the jquery.formatCurrency plugin
$('.format_currency').live('keyup', function(){
	$('.format_currency').blur(function () {
	  $(this).formatCurrency({
	    colorize: true,
	    negativeFormat: '-%s%n',
	    roundToDecimalPlace: 2
	  });
	}).keyup(function (e) {
	  var e = window.event || e;
	  var keyUnicode = e.charCode || e.keyCode;
	  if(e !== undefined) {
	    switch(keyUnicode) {
	     case 9:
	      break; // Tab
	    case 16:
	      break; // Shift
	    case 17:
	      break; // Ctrl
	    case 18:
	      break; // Alt
	    case 27:
	      this.value = '';
	      break; // Esc: clear entry
	    case 35:
	      break; // End
	    case 36:
	      break; // Home
	    case 37:
	      break; // cursor left
	    case 38:
	      break; // cursor up
	    case 39:
	      break; // cursor right
	    case 40:
	      break; // cursor down
	    case 78:
	      break; // N (Opera 9.63+ maps the "." from the number key section to the "N" key too!) (See: http://unixpapa.com/js/key.html search for ". Del")
	    case 110:
	      break; // . number block (Opera 9.63+ maps the "." from the number block to the "N" key (78) !!!)
	    case 190:
	      break; // .
	    default:
	      $(this).formatCurrency({
	        colorize: true,
	        negativeFormat: '-%s%n',
	        roundToDecimalPlace: -1,
	        eventOnDecimalsEntered: true
	      });
	    }
	  }
	});
});