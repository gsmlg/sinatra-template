require 'bundler/setup'
Bundler.require :app

class App < Sinatra::Base
    Bundler.require environment
    require 'sinatra/cookies'

    configure do
        set :root, File.dirname(__FILE__)
        set :sprockets, Sprockets::Environment.new(root)

        set :assets_prefix, 'assets'
        set :assets_path, -> { File.join(public_folder, assets_prefix) }
        set :assets_manifest_path, -> { File.join(assets_path, 'manifest.json') }
        set :assets_compile, %w(*.png modernizr.js application.js application.css)

        Sprockets::Helpers.configure do |config|
            config.environment = sprockets
            config.prefix = "/#{assets_prefix}"
            config.digest = false
            config.public_path = public_folder
        end

        %w(javascript stylesheet image font).each do |type|
            sprockets.append_path root + "/app/#{type}"
            sprockets.append_path root + "/vendor/#{type}"
            sprockets.append_path root + "/lib/#{type}"
        end

        %w(compass blueprint).each do |name|
            sprockets.append_path Compass.base_directory + "/framworks/#{name}/stylesheets"
            sprockets.append_path Compass.base_directory + "/framworks/#{name}/stylesheets"
        end

        Compass.configuration.images_path = root + '/app/image'
    end

    configure :development do
        register Sinatra::Reloader

        use BetterErrors::Middleware
        BetterErrors.application_root = root
    end

    configure :test do

    end

    configure :production do

    end

    helpers do
        include Sprockets::Helpers
    end

    get '/' do
        erb :index
    end

end
