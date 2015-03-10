module Issues

  class IssueFilter
    attr_reader :issues, :query

    def self.call(query)
      new(Issue.sorted, query).issues
    end

    def initialize(issues, query)
      @issues = issues
      @query  = query
      filter!
    end

    private

    def filter!
      @issues = issues.where(:project_id => query.project.id)

      if query.state_ids.any?
        @issues = issues.where(:state => query.state_ids)
      end

      if query.state_ids.none? { |state| state == Issues::Issue::STATE_RESOLVED }
        @issues = issues.not_resolved
      end

      if query.milestone_id.present?
        @issues = issues.where(:milestone_id => query.milestone_id)
      end

      if query.priority_ids.any?
        @issues = issues.where(:priority => query.priority_ids)
      end

      if query.label_ids.any?
        @issues = issues.joins(:labels).where(:issues_labels => { :id => query.label_ids })
      end

      @issues = @issues.group(:id).map { |issue| Issues::Presenters::IssuePresenter.new(issue) }
    end
  end

end
