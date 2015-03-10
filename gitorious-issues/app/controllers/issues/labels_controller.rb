module Issues

  class LabelsController < Issues::ApplicationController
    before_filter :login_required
    before_filter :find_project
    before_filter :require_admin
    before_filter :find_label, :only => [:edit, :update, :destroy]
    before_filter :find_labels, :only => [:index]

    helper 'issues/application'
    layout 'issues'

    attr_reader :project, :label, :labels

    def index
      render(
        :template => 'issues/labels/index',
        :locals => { :project => ProjectPresenter.new(project), :labels => labels, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def new
      label = Issues::Label.new(:project => project)
      render_form(label)
    end

    def edit
      render_form(label)
    end

    def create
      label = Issues::Label.new(params[:label])
      label.project = project
      label.save

      if label.persisted?
        redirect_to [project, :issue, :labels]
      else
        render_form(label)
      end
    end

    def update
      if UseCases::UpdateLabel.call(:label => label, :params => params[:label]).persisted?
        redirect_to [project, :issue, :labels]
      else
        render_form(label)
      end
    end

    def destroy
      label.destroy
      head :ok
    end

    private

    def find_label
      @label = Issues::Label.find(params[:id])
    end

    def find_labels
      @labels = Issues::Label.where(:project_id => project.id).sorted
    end

    def render_form(label)
      render(
        :template => 'issues/labels/new',
        :locals => { :project => ProjectPresenter.new(project), :label => label, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

  end

end
