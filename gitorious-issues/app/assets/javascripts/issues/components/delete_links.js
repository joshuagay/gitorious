this.gts.deleteLinks = (function() {

  return function(table) {
    var $table = $(table);

    $table.find('a.btn-danger').on('ajax:success', function(e) {
      e.preventDefault();
      var $el = $(this);
      $tr = $el.parents('tr');
      $tr.fadeOut('fast', function() { $tr.remove(); });
    });

    $table.find('a.btn-danger').on('click', function(e) {
      e.preventDefault();

      if (confirm('Are you sure?')) {
        var $el = $(this);

        $.ajax({
          url: this.href,
          method: 'delete',
          success: function(e) { $el.trigger('ajax:success'); }
        });
      }
    });
  };

}());
