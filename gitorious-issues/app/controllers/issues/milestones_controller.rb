module Issues

  class MilestonesController < Issues::ApplicationController
    before_filter :login_required
    before_filter :find_project
    before_filter :require_admin
    before_filter :find_milestone, :only => [:edit, :update, :destroy]
    before_filter :find_milestones, :only => [:index]

    helper 'issues/application'
    layout 'issues'

    attr_reader :project, :milestone, :milestones

    def index
      render(
        :template => 'issues/milestones/index',
        :locals => { :project => ProjectPresenter.new(project), :milestones => milestones, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def new
      milestone = Issues::Milestone.new(:project => project)
      render_form(milestone)
    end

    def edit
      render_form(milestone)
    end

    def update
      if milestone.update_attributes(params[:milestone])
        flash[:notice] = 'Milestone updated successfuly'
        redirect_to [project, :issue, :milestones]
      else
        render_form(milestone)
      end
    end

    def create
      milestone = Issues::Milestone.new(params[:milestone])
      milestone.project = project
      milestone.save

      if milestone.persisted?
        flash[:notice] = 'Milestone added successfuly'
        redirect_to [project, :issue, :milestones]
      else
        render_form(milestone)
      end
    end

    def destroy
      milestone.destroy
      head :ok
    end

    private

    def find_milestone
      @milestone = Issues::Milestone.find(params[:id])
    end

    def find_milestones
      @milestones = Issues::Milestone.where(:project_id => project.id).sorted
    end

    def render_form(milestone)
      render(
        :template => 'issues/milestones/new',
        :locals => { :project => ProjectPresenter.new(project), :milestone => milestone, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

  end

end
