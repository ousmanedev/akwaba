require 'sinatra'
require 'sinatra/cors'
require 'dotenv/load'
require "zeitwerk"
require 'byebug'

set :public_folder, File.join(Dir.pwd, 'public')

loader = Zeitwerk::Loader.new
AUTOLOAD_PATHS =  %W(#{Dir.pwd} lib services poro views public)
AUTOLOAD_PATHS.each { |path| loader.push_dir(path) }
loader.enable_reloading
loader.setup

set :allow_origin, ENV['CLIENT_HOST']
set :allow_methods, "GET, POST"
set :allow_headers, "content-type,if-modified-since"
set :expose_headers, "location,link"

# Demo
get '/', provides: 'html' do
    erb :index
end

# Submit a comment
post '/comments/:database_id' do |database_id|
    content_type :json

    form_data = params.slice(*Comment::FIELDS)
    response = Notion::SubmitComment.call(database_id: database_id, form_data: form_data)

    comment = Comment.new(response)
    {
        id: comment.id,
        html: erb(:comment, locals: { comment: comment, database_id: database_id })
    }.to_json
end

# Get all comments + commenting form
get '/comments/:database_id' do |database_id|
    comments = Notion::GetComments.call(database_id: database_id, url: params[:url])

    erb :comments, locals: { comments: comments, database_id: database_id }
end