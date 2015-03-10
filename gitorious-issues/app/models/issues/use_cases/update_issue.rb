module Issues
  module UseCases

    class UpdateIssue
      attr_reader :params, :issue

      def self.call(context)
        usecase = new(
          context.fetch(:issue),
          Issues::Params::IssueParams.new(context.fetch(:params))
        )
        usecase.execute.issue
      end

      def initialize(issue, params)
        @issue, @params = issue, params
      end

      def execute
        @issue.update_attributes(params.to_hash)
        self
      ensure
        freeze
      end

    end

  end
end
