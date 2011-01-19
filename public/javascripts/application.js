/*jslint white: false, rhino: true, browser: true, nomen: false, plusplus: false, regexp: false */
/*global jQuery: true, $: true, window: true */

var CAPHelper = {
  throttle: function(f, delay) {
      var timer = null;
      return function(){
          var context = this, args = arguments;
          clearTimeout(timer);
          timer = window.setTimeout(function(){
              f.apply(context, args);
          },
          delay || 500);
      };
  },

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

  geoCoder: function() {
    var json_source, addr, latlng;
    json_source = window.location.href.replace(/\/conferences.*/,
                                          '/conferences/geocode_address');
    if ($('#location_latlng').length && $('#location').length) {
      $('#location').keypress(CAPHelper.throttle(function() {
        addr = $(this).val();
        jQuery.ajax({
                      'url' : json_source,
                      'dataType' : 'json',
                      'data' : 'q='+addr,
                      'async' : false,
                      'success' : function (r) {
                        $('#location_latlng').val(r.latlng);
                      }
                  });
      }), 250);
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
    this.geoCoder();
    this.addDatepicker();
  }
};

$(document).ready(function() { CAPHelper.documentReady(); });
