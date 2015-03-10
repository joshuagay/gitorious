# encoding: utf-8
#--
#   Copyright (C) 2013 Gitorious AS
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

class UserWatchlistsController < ApplicationController
  def show
    user = User.find_by_login!(params[:id])
    events = filter(user.paginated_events_in_watchlist({ :page => 1 }))
    respond_to do |format|
      format.atom do
        render(:template => "user_feeds/show", :locals => {
            :user => user,
            :events => events
          })
      end
    end
  end
end
