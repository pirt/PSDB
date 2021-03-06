//= require jquery.min
//= require jquery_ujs
//= require jquery-ui.min
//= require tabs
//= require gauge.min
//= require jquery.gauge.min
//= require waveplate-gauge
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function (){  
  var dates = $( "#from_date, #to_date" ).datepicker({
			defaultDate: "-1d",
			changeMonth: true,
			numberOfMonths: 3,
            firstDay: 1,
            showWeek: true,
            showCurrentAtPos: 2,
            dateFormat: 'dd.mm.yy',
			onSelect: function( selectedDate ) {
				var option = this.id == "from_date" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
});
// error flash messages should nicely disappear after a while.
$(function(){
  $('#errorflash').delay(5000).slideUp('slow');
});
