# encoding: utf-8
#--
#   Copyright (C) 2013-2014 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "commit_comment_json_presenter"

class CommitCommentsJSONPresenter
  def initialize(app, comments)
    @app = app
    @comments = comments
  end

  def render_for(user)
    JSON.dump(hash_for(user))
  end

  def hash_for(user)
    { "commit" => commit_comments(comments, user),
      "diffs" => diff_comments(comments, user) }
  end

  protected
  def commit_comments(comments, user)
    comments.select { |c| c.path.nil? }.map { |c| comment_hash(c, user) }
  end

  def diff_comments(comments, user)
    comments = comments.select { |c| !c.path.nil? }.map { |c| comment_hash(c, user) }
    comments.group_by { |c| c["path"] }
  end

  def comment_hash(comment, user)
    CommitCommentJSONPresenter.new(app, comment).hash_for(user)
  end

  attr_reader :app, :comments
end
