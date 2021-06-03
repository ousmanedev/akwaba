require 'sinatra'
require 'dotenv/load'
require "zeitwerk"

set :public_folder, File.join(Dir.pwd, 'public')

loader = Zeitwerk::Loader.new
AUTOLOAD_PATHS =  %W(#{Dir.pwd} lib services poro views public)
AUTOLOAD_PATHS.each { |path| loader.push_dir(path) }
loader.enable_reloading
loader.setup

# Demo
get '/', provides: 'html' do
    erb :index
end

# Submit a comment
post '/comments/:database_id' do |database_id|
    form_data = { 'url' => request.referrer }.merge(params.slice(:email, :name, :body, :parent_id))

    response = Notion::SubmitComment.call(database_id: database_id, form_data: form_data)

    if response.success?
        redirect to(params.fetch(:redirect_uri, request.referrer))
    else
        body response.inspect
    end
end

# Get all comments + commenting form
get '/comments/:database_id' do |database_id|
    comments = Notion::GetComments.call(database_id: database_id, url: params[:url])

    erb :comments, locals: { comments: comments, database_id: database_id }
end