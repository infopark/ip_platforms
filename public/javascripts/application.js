/*jslint white: false, rhino: true, browser: true, nomen: false, plusplus: false */
/*global jQuery: true, $: true, window: true */

var CAPHelper = {
  autoFocus: function() {
    $('.auto_focus_form:first input[type=text]:first').focus();
  },

  geoLocation: function() {
    var lat, lng;
    if ($('#geolocation').length) {
      if(navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          if (position.coords.latitude > 0) {
            lat = position.coords.latitude + 'N';
          } else {
            lat = -position.coords.latitude + 'S';
          }
          if (position.coords.longitude > 0) {
            lng = position.coords.longitude + 'E';
          } else {
            lng = -position.coords.longitude + 'W';
          }
          $('#geolocation').val(lat + ',' + lng);
          $('#city').val(position.address.city);
        });
      }
    }
  },

  addDatepicker: function() {
    $.datepicker.setDefaults({
      dateFormat: 'yy-mm-dd',
      showAnim: 'show',
      showOn: 'both',
      buttonImage: '/images/date.png',
      buttonImageOnly: true
    });
    $('input.datepicker').datepicker();
  },

  documentReady: function() {
    this.autoFocus();
    this.geoLocation();
    this.addDatepicker();
  }
};

$(document).ready(function() { CAPHelper.documentReady(); });
