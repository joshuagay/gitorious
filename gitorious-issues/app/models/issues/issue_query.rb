module Issues

  class IssueQuery
    include Virtus.model
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attribute :name,         String
    attribute :project_id,   String, :strict => true
    attribute :milestone_id, Integer
    attribute :state_ids,    Array[String]
    attribute :priority_ids, Array[Integer]
    attribute :label_ids,    Array[Integer]

    attr_reader :project

    def self.build(query)
      new(JSON.parse(query.data).update(:name => query.name), query.project)
    end

    def initialize(params, project)
      super(params)
      @project = project
    end

    def active?
      [:milestone_id, :state_ids, :priority_ids, :label_ids].map { |name| attributes[name] }.any?(&:present?)
    end

    def milestones
      Milestone.where(:project_id => project.id).map { |milestone| [milestone.name, milestone.id] }
    end

    def labels
      Label.where(:project_id => project.id)
    end

    def priorities
      Issues::Issue::PRIORITIES
    end

    def states
      Issues::Issue::STATES
    end

    def label_active?(label)
      label_ids.include?(label.id)
    end

    def priority_active?(id)
      priority_ids.include?(id)
    end

    def state_active?(state)
      state_ids.include?(state)
    end

    def build
      Issues::Query.new(:project => project, :data => to_hash.to_json)
    end

    def persisted?
      false
    end
  end

end
