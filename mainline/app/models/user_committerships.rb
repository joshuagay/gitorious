# encoding: utf-8
#--
#   Copyright (C) 2014 Gitorious AS
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

class UserCommitterships
  def initialize(user)
    @user = user
  end

  def reviewers
    all.reviewers
  end

  def all
    user._committerships
  end

  def count
    all.count
  end

  def commit_repositories
    all.joins(:repository)
       .where("repositories.kind NOT IN (?)", Repository::KINDS_INTERNAL_REPO)
       .map(&:repository)
  end

  def destroy_all
    all.each { |c| c.destroy }
  end

  private

  attr_reader :user
end
