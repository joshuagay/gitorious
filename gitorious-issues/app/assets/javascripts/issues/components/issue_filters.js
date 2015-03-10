this.gts.issueFilters = (function() {

  return function(form) {
    var $form = $(form);

    $form.on('change', '.btn-label input', function(e) {
      var $chk = $(this);
      var $btn = $chk.parent();
      $btn.toggleClass('btn-inactive', !$chk.prop('checked'));
    });

    $form.on('click', '[data-behavior=submit-buttons] a', function(e) {
      e.preventDefault();

      var $btn = $(this);
      var url  = $btn.attr('href');

      if ($btn.data('behavior') == 'filter') {
        url = [url, '?', $form.serialize()].join('');
      }

      $.pjax({ url: url, container: '#gts-pjax-container' });
    });
  };

}());
