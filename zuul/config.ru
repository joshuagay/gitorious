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

environmentrb = File.join(ENV["GITORIOUS_HOME"], "config/environment.rb")

if !ENV["GITORIOUS_HOME"] ||
    !File.exists?(ENV["GITORIOUS_HOME"]) ||
    !File.exists?(environmentrb)
  $stderr.puts <<-OUT
Please make sure $GITORIOUS_HOME is set and points to a working
Gitorious installation, either by exporting it or bootstrapping
this application like this:

    env GITORIOUS_HOME=/var/www/gitorious/app rackup config.ru
  OUT
  exit 1
end

require environmentrb
require "zuul/app"
dir = File.dirname(__FILE__)
require File.join(dir, "config/routes")

require "zuul/request"

module GitoriousAuthenticator
  def self.authenticate(login, password)
    credentials = Gitorious::Authentication::Credentials.new
    credentials.username = login
    credentials.password = password
    Gitorious::Authentication.authenticate(credentials)
  end
end

Zuul::Request.authenticator = GitoriousAuthenticator

Zuul::App.set(:environment, :production)
run Zuul::App.new(File.join(dir, "public"))
