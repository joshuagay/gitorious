module Issues
  module Presenters
    class IssuePresenter
      include Charlatan.new(:issue)

      def self.model_name
        Issue.model_name
      end

      def to_param
        @issue.to_param
      end

      def to_s
        title
      end

      def user_name
        user.fullname || user.login
      end

      def priority_name
        Issue::PRIORITIES[priority]
      end

      def renderer(view)
        Renderers::IssueRenderer.new(view, self)
      end
    end
  end
end
