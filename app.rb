class HashCode < Sinatra::Base
  register Sinatra::AssetPack
    configure do
    set :views, "app/views"
    set :public_dir, "app/public"
    set :root, __dir__

    # Since Sinatra::AssetPack won't change the load path
    set :sass, { load_paths: [ "#{root}/app/assets/stylesheets/" ] }
    set :scss, { load_paths: [ "#{root}/app/assets/stylesheets" ] }
  end

  assets do
    serve "/javascripts", from: "app/assets/javascripts"
    serve "/components",  from: "app/assets/components"
    serve "/stylesheets", from: "app/assets/stylesheets"
    serve "/images",      from: "app/assets/images"

    js :application, "/javascripts/application.js", [
      "/components/d3/d3.js",
    ]

    css :application, "/stylesheets/application.css", [
      "/stylesheets/style.css",
      "/stylesheets/app.css"
    ]

    js_compression  :jsmin
    css_compression :sass
  end

  get "/" do
    @stats = Stats.last.sorted_stats
    erb :index
  end

  get '/stats.js' do
    content_type 'text/javascript'
    @stats = Stats.last.sorted_stats
    erb :json, :layout => false
  end
end
