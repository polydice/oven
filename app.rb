require 'sinatra'
require 'sinatra/partial'
require 'sinatra/flash'
require 'sinatra_auth_github'
require 'fog'
require 'plist'

module Oven
  class App < Sinatra::Base
    # For delete
    use Rack::MethodOverride

    # Session
    enable :sessions

    # Flash
    register Sinatra::Flash

    # Partial
    register Sinatra::Partial
    set :partial_template_engine, :erb

    # GitHub auth
    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }
    register Sinatra::Auth::Github

    # Some helpers
    helpers do
      def title
        @title ? @title + " | Oven" : "Oven"
      end
    end

    # Fog
    def connection
      @connection ||= Fog::Storage.new({
        :provider                 => 'AWS',
        :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
        :region => ENV['AWS_REGION']
      })
    end

    def directory
      connection.directories.get(ENV['S3_BUCKET_NAME'])
    end

    # Check authentication
    before do
      github_team_authenticate!(ENV['GITHUB_AUTHENTICATION_TEAM'].to_i)
    end

    get '/' do
      @files = directory.files
      erb :index
    end

    get '/plists/new' do
      @title = "New Plist"
      erb :new
    end

    get '/plists/:key/edit' do
      file = directory.files.get(params[:key])
      @filename = params[:key]
      @content = file.body
      @title = "Edit Plist"

      erb :new
    end

    post '/plists' do
      @title = "New Plist"
      @filename = params[:filename]
      @content = params[:content]

      begin
        data = Plist::parse_xml(@content)
      rescue Exception => e
        data = nil
      end

      if !@filename =~ /.plist$/
        flash[:error] = 'Your filename should end with ".plist" to be right format.'
        erb :new
      elsif data.nil?
        flash[:error] = 'Your plist content cannot be parsed. Please check again.'
        erb :new
      else
        file = directory.files.create(
          :content_type => "application/x-plist",
          :key                => params[:filename],
          :body              => params[:content],
          :public            => true
        )

        flash[:succss] = "The file has been created."
        redirect '/'
      end
    end

    delete '/plists/:key' do
      file = directory.files.get(params[:key])
      file.destroy

      flash[:info] = "The file has been deleted."
      redirect '/'
    end

    get '/logout' do
      logout!
      redirect 'http://icook.tw/'
    end
  end
end
