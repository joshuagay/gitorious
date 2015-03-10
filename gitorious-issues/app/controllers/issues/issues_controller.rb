module Issues

  class IssuesController < Issues::ApplicationController
    include IssueAuthorization

    before_filter :login_required, :except => [:index, :show]
    before_filter :find_project
    before_filter :find_issues, :only => [:index]
    before_filter :find_issue,  :only => [:show, :edit, :update, :destroy]
    before_filter :find_queries, :only => [:index]
    before_filter :build_issue, :only => [:create]
    before_filter :authorize, :only => [:edit, :update, :destroy]

    helper 'issues/application'
    layout 'issues'

    attr_reader :project, :issues, :issue, :query, :public_queries, :private_queries
    helper_method :project

    def index
      render_index
    end

    def new
      issue = Issue.new(:project_id => project.id,
                        :state => Issue::DEFAULT_STATE,
                        :priority => Issue::DEFAULT_PRIORITY)
      render_form(issue)
    end

    def create
      issue = UseCases::CreateIssue.call(:user => current_user, :project => project, :params => params[:issue])

      if issue.persisted?
        if pjax_request?
          render_index
        else
          flash[:notice] = 'Issue created successfuly'
          redirect_to [project, :issues]
        end
      else
        render_form(issue)
      end
    end

    def show
      render(
        :template => 'issues/issues/show',
        :locals => { :project => ProjectPresenter.new(project), :issue => issue, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def edit
      render(
        :template => 'issues/issues/edit',
        :locals => { :project => ProjectPresenter.new(project), :issue => issue, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def update
      if UseCases::UpdateIssue.call(:issue => issue, :params => params[:issue]).persisted?
        if pjax_request?
          render_index
        else
          flash[:notice] = 'Issue updated successfuly'
          redirect_to [project, :issues]
        end
      else
        render_form(issue)
      end
    end

    def destroy
      issue.destroy
      flash[:notice] = 'Issue was deleted'
      redirect_to [project, :issues]
    end

    private

    def find_issues
      build_query
      @issues = IssueFilter.call(query)
    end

    def find_issue
      issue = Issue.find_by_project_id_and_issue_id!(project.id, params[:issue_id])
      @issue = Presenters::IssuePresenter.new(issue)
    end

    def find_queries
      find_public_queries
      find_private_queries
    end

    def find_public_queries
      @public_queries = Query.where(:project_id => project.id).public.sorted
    end

    def find_private_queries
      @private_queries = Query.where(:project_id => project.id).private.sorted
    end

    def build_issue
      @issue = Issue.new(params[:issue])
      @issue.user = current_user
      @issue.project = project
    end

    def build_query
      @query = IssueQuery.new(params, project)
    end

    def render_index
      render(
        :template => 'issues/issues/index',
        :locals => {
          :project => ProjectPresenter.new(project),
          :issues => issues,
          :query => query,
          :public_queries => public_queries,
          :private_queries => private_queries,
          :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def render_form(issue)
      render(
        :template => 'issues/issues/new',
        :locals => { :project => ProjectPresenter.new(project), :issue => issue, :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

  end

end
