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
require "pathname"
module Gitoriousd
  module Daemon
    def pidfile_path
      libexec_dir = Pathname(__FILE__).dirname
      application_name = libexec_dir.basename.to_s
      script_name = @name
      slash_root = libexec_dir + "../../../"
      run_dir = slash_root + "var/run/#{application_name}"
      "#{run_dir}/#{script_name}.pid"
    end

    def write_pidfile(pid)
      File.open(pidfile_path,"w") {|f| f.write(pid.to_s)}
    end

    def remove_pidfile
      File.unlink pidfile_path
    end

    def daemonize_app
      if RUBY_VERSION < "1.9"
        exit if fork
        Process.setsid
        exit if fork
        Dir.chdir "/"
        STDIN.reopen "/dev/null"
        STDOUT.reopen "/dev/null", "a"
        STDERR.reopen "/dev/null", "a"
      else
        Process.daemon
      end
      write_pidfile(Process.pid)
      yield
    end

    def write_to_log_file(message)
      File.open("/tmp/#{@name}.log","a") {|f| f.puts message}
    end
  end
end
