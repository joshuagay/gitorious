module Issues
  module Renderers
    class IssueRenderer
      include Charlatan.new(:view)

      attr_reader :issue

      delegate :title, :issue_id, :project, :creator?, :to => :issue

      def initialize(view, issue)
        super
        @issue = issue
      end

      def state
        content_tag(:span, issue.state, :class => 'label')
      end

      def title_link
        link_to("##{issue_id} #{title}", project_issue_path(project, :issue_id => issue_id))
      end

      def user_link
        link_to(issue.user_name, main_app.user_path(issue.user))
      end

      def edit_link
        link_to('Edit', edit_project_issue_path(issue.project, :issue_id => issue_id))
      end

      def delete_link
        link_to('Delete', project_issue_path(issue.project, :issue_id => issue_id),
                :method => 'delete', :confirm => 'Are you sure?')
      end

      def created_at
        "created #{time_ago(issue.created_at)}".html_safe
      end

      def labels
        content_tag(:ul) {
          issue.labels.map { |label|
            content_tag(:li) {
              LabelRenderer.new(@view).label_link(issue, label)
            }
          }.join.html_safe
        }
      end

      def user_avatar
        avatar(issue.user, :size => 16)
      end

    end

  end
end
