module Issues
  module UseCases

    class CreateIssue
      attr_reader :user, :project, :params, :issue

      def self.call(context)
        usecase = new(
          context.fetch(:user),
          context.fetch(:project),
          Issues::Params::IssueParams.new(context.fetch(:params))
        )
        usecase.execute.issue
      end

      def initialize(user, project, params)
        @user, @project, @params = user, project, params
      end

      def execute
        @issue = Issue.new(params.to_hash)

        @issue.user = user
        @issue.project = project

        @issue.save
        self
      rescue ActiveRecord::RecordNotUnique
        @issue.errors.add(:issue_id, 'must be unique')
        @issue.issue_id = nil
        self
      end

    end

  end
end
