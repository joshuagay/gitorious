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
require "bundler/setup"
require "minitest/autorun"
require "zuul/error_message_hash"
require "stringio"

Bundler.require(:default, :test)

module Zuul
  module App
  end

  module Test
    class Success
      attr_reader :result
      def initialize(result)
        @result = result
      end
      def success?; true; end
    end

    class Failure
      attr_reader :errors
      def initialize(errors)
        @errors = Zuul::ErrorMessageHash.new(errors)
      end
      def success?; false; end
    end

    class Request
      attr_reader :params, :body
      attr_accessor :content_type
      def initialize(params = {}, body = "")
        @body = StringIO.new(body)
        @params = params.inject({}) do |h,kv|
          h[kv[0].to_s] = kv[1]
          h[kv[0].to_s.to_sym] = kv[1]
          h
        end
      end

      def user; nil; end
    end

    class Response
      def headers(headers = nil)
        return @headers || {} if headers.nil?
        @headers = (@headers || {}).merge(headers)
      end

      def uri(str)
        "http://localhost#{str}"
      end

      def link(rel, object)
        { rel => "http://localhost" }
      end
    end
  end
end
