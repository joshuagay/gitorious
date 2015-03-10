module Issues

  class CommentsController < Issues::ApplicationController
    before_filter :login_required, :only => [:create, :edit, :update]
    before_filter :find_project
    before_filter :find_issue
    before_filter :find_comment, :only => [:edit, :update]
    before_filter :find_comments, :only => [:index]

    helper 'issues/application'
    layout 'issues'

    attr_reader :comments, :project, :issue, :comment

    def create
      comment = issue.comments.build(params[:comment])
      comment.user = current_user

      if comment.save
        flash[:notice] = 'Comment added successfuly'
        redirect_to [project, issue]
      else
        render_form(comment)
      end
    end

    def edit
      render_form(comment)
    end

    def update
      if comment.update_attributes(params[:comment])
        flash[:notice] = 'Your comment was updated'
        redirect_to [project, issue]
      else
        render_form(comment)
      end
    end

    private

    def find_comments
      @comments = issue.comments
    end

    def find_issue
      @issue = Issue.find_by_project_id_and_issue_id!(project.id, params[:issue_id])
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end

    def render_form(comment)
      render(
        :template => 'issues/comments/edit',
        :locals => {
          :comment => comment,
          :issue => issue,
          :project => ProjectPresenter.new(project),
          :active => :issues
        },
        :layout => pjax_request? ? false : true
      )
    end

  end

end
