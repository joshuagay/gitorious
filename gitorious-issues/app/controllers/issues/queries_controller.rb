module Issues

  class QueriesController < Issues::ApplicationController
    include IssueAuthorization

    before_filter :login_required, :except => [:show]
    before_filter :find_project
    before_filter :find_query, :only => [:show, :update, :destroy]
    before_filter :find_queries, :only => [:show]

    helper 'issues/application'
    layout 'issues'

    attr_reader :project, :issue, :query, :queries, :public_queries, :private_queries

    def create
      query = Query.new(params[:query])
      query.user = current_user
      query.project = project

      if query.save
        flash[:notice] = 'Custom query was saved'
        redirect_to [project, :issue, query]
      else
        render_form(query)
      end
    end

    def show
      issue_query = IssueQuery.build(query)
      issues      = IssueFilter.call(IssueQuery.build(query))

      render(
        :template => 'issues/issues/index',
        :locals => {
          :project => ProjectPresenter.new(project),
          :issues => issues,
          :query => issue_query,
          :public_queries => public_queries,
          :private_queries => private_queries,
          :active => :issues },
        :layout => pjax_request? ? false : true
      )
    end

    def update
      if query.update_attributes(params[:query])
        flash[:notice] = 'Your query was updated'
        redirect_to [project, issue]
      else
        render_form(query)
      end
    end

    def destroy
      query.destroy
      flash[:notice] = 'Query was deleted'
      redirect_to [project, :issues]
    end

    private

    def find_query
      @query = Query.find(params[:id])
    end

    def find_public_queries
      @public_queries = Query.where(:project_id => project.id).public.sorted
    end

    def find_private_queries
      @private_queries = Query.where(:project_id => project.id).private.sorted
    end

    def find_queries
      find_public_queries
      find_private_queries
    end

    def can_delete?
      query.user == current_user || admin?(project, current_user)
    end
    helper_method :can_delete?

    def active_query
      query
    end
    helper_method :active_query

  end

end
