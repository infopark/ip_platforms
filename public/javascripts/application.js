/*jslint white: false, rhino: true, browser: true, nomen: false, plusplus: false */
/*global jQuery: true, $: true, window: true */

var CAPHelper = {
  autoFocus: function() {
    $('.auto_focus_form:first input[type=text]:first').focus();
  },

  documentReady: function() {
    this.autoFocus();
  }
};

$(document).ready(function() { CAPHelper.documentReady(); });
