this.gts.issueLabelAutocomplete = (function() {

  return function(input, labels_json) {
    var labels = $.parseJSON(labels_json);

    var $input = $(input);
    var $list  = $input.parents('.issue-label-widget').find('.issue-labels');

    function createButton(item) {
      var value, label, color, $li;

      value = item.id;
      label = item.label;
      color = item.color;

      $li = $('<li/>');

      $li.append(
        $('<button class="btn btn-mini btn-label"></button>')
          .css({ backgroundColor: color })
          .html('<i class="icon-remove icon-white"></i>'+label)
          .attr('id', 'label-'+value)
      );

      $li.append(
        $('<input type="hidden" name="issue[label_ids][]"/>').val(value)
      );

      return $li;
    }

    function appendLabel(item) {
      $list.append(createButton(item));
    }

    function findLabel() {
      var name = $input.val();
      return cull.first(function(el) { return el.label == name }, labels);
    }

    function onConfirm() {
      var item = $input.data('item');
      if (!item) item = findLabel();
      if (item) {
        if ($list.find('#label-'+item.id).length > 0) return;
        appendLabel(item);
        $input.val('');
      }
    }

    $input.next('a[data-behavior="add-label"]').click(function(e) {
      e.preventDefault();
      onConfirm();
    });

    $input.keydown(function(e) {
      if (e.which == 13) {
        e.preventDefault();
        onConfirm();
        $input.autocomplete('close');
      }
    });

    $input.autocomplete({
      source: labels,
      appendTo: $input.parents('.autocomplete-widget'),
      select: function(e, ui) {
        var item = ui.item;
        $input.val(item.label);
        $input.data('item', item);
        onConfirm();
        e.preventDefault();
      }
    });

    $list.on('click', 'button', function(e) {
      e.preventDefault();
      $(this).parent().remove();
    });
  };

}());
