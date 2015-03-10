module Issues
  module Renderers
    class LabelRenderer
      include Charlatan.new(:view)

      def label_link(issue, label)
        html_options = { :class => 'label', :style => "background-color: #{label.color}" }
        path = project_issues_path(issue.project, :label_ids => label.id)
        link_to(label.name, path, html_options)
      end
    end
  end
end

