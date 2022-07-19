# frozen_string_literal: true

class SayController < ApplicationController
  skip_authorization_check

  def hello
    # get user ip from request
    @yourip = request.remote_ip

    # use params[:name] to get request parameter value by name
    # @parameter = params[:name]

    # get Ruby version and Rails version
    @ruby_version = RUBY_VERSION
    @rails_version = Rails::VERSION::STRING

    # environment variable 'VCAP_SERVICES' is in JSON format. You may use JSON.parse() to get Ruby hash
    # 'VCAP_SERVICES' is empty if your didn't bind any service to the application
    # @vcap_services = ENV['VCAP_SERVICES']
    # @home = ENV['HOME']
    # @memory_limit = ENV['MEMORY_LIMIT']
    # @port = ENV['PORT']
    # @pwd = ENV['PWD']
    # @tmpdir = ENV['TMPDIR']
    # @user = ENV['USER']
    # 'VCAP_APPLICATION' is in JSON format, use JSON.parse() to get Ruby hash
    # @vcap_app = JSON.parse(ENV['VCAP_APPLICATION'])

    # Variables Defined by Ruby Buildpack
    # @bundle_bin_path = ENV['BUNDLE_BIN_PATH']
    # @bundle_gemfile = ENV['BUNDLE_GEMFILE']
    # @bundle_without = ENV['BUNDLE_WITHOUT']
    # @database_url = ENV['DATABASE_URL']
    # @gem_home = ENV['GEM_HOME']
    # @rack_env = ENV['RACK_ENV']
    # @rails_env = ENV['RAILS_ENV']

    env = {}
    # loop to parse all JSON object
    # @env is available in the view: views/say/hello.html.erb
    ENV.each do |key, value|
      obj = JSON.parse(value)
      env[key] = JSON.pretty_generate(obj)
    rescue StandardError
      env[key] = value
    end
    @env = env
  end
end
