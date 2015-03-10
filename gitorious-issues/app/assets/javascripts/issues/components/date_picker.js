this.gts.datePicker = (function() {

  return function(input) {
    $(input).datepicker({ dateFormat: "yy-mm-dd" });
  };

}());
