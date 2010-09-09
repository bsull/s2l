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
    $("#account_target_fiscal_year_end").datepicker({
        numberOfMonths:3,
        stepMonths:3,
        dateFormat: 'yy-mm-dd'
    });
});

