module Issues

  class FormBuilder < SimpleForm::FormBuilder

    def submit_button(name = 'Save')
      submit(name, :class => 'btn btn-primary btn-large')
    end

    def actions(&block)
      template.content_tag(:div, :class => 'form-actions') {
        template.capture(&block)
      }
    end

  end

end
