this.gts.issueAssigneeAutocomplete = (function() {

  return function(input, assignees_json) {
    var assignees = $.parseJSON(assignees_json);

    var $input = $(input);
    var $list  = $input.parents('.issue-assignee-widget').find('.issue-assignees');

    function createButton(item) {
      var value, label;

      value = item.id;
      label = item.label;

      var $li = $('<li/>');

      $li.append(
        $('<button class="btn"></button>')
          .val(value).html('<i class="icon-remove"></i>'+label).addClass('btn')
      );

      $li.append(
        $('<input type="hidden" name="issue[assignee_ids][]"/>').val(value)
      );

      return $li;
    }

    function appendAssignee(item) {
      $list.append(createButton(item));
    }

    function findUser() {
      var login = $input.val();
      return cull.first(function(el) { return el.label == login }, assignees);
    }

    function onConfirm() {
      var item = $input.data('item');
      if (!item) item = findUser();
      if (item) {
        appendAssignee(item);
        $input.val('');
      }
    }

    $input.next('a[data-behavior="assign-user"]').click(function(e) {
      e.preventDefault();
      onConfirm();
    });

    $input.keydown(function(e) {
      if (e.which == 13) {
        e.preventDefault();
        onConfirm();
      }
    });

    $list.on('click', 'button', function(e) {
      e.preventDefault();
      $(this).parent().remove();
    });

    $input.autocomplete({
      source: assignees,
      appendTo: $input.parents('.autocomplete-widget'),
      select: function(e, ui) {
        var item = ui.item;
        $input.val(item.label);
        $input.data('item', item);
        onConfirm();
        e.preventDefault();
      }
    });
  };

}());
