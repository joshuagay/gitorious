module Issues

  module ApplicationHelper

    def gts_form_for(object, *args, &block)
      options = args.extract_options!
      (options[:html] ||= {}).update(:class => 'form-horizontal')
      form_args = args << options.merge(builder: FormBuilder)
      form_for(object, *form_args, &block)
    end

    def label_button(name, options = {}, &block)
      active = options.fetch(:active, true)
      tag    = options.fetch(:tag, :button)
      color  = options[:color]

      classes = %w(btn btn-label)
      classes << 'btn-inactive' unless active
      classes += Array(options.fetch(:class, []))

      tag_opts = { :class => classes }

      tag_opts.update(:style => "background-color: #{color}") if color
      tag_opts.update(options.except(:active, :tag))

      content_tag(tag, tag_opts) {
        inner_html = name.dup
        inner_html << capture(&block) if block
        inner_html.html_safe
      }
    end
  end

end
