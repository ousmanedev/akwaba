require 'sinatra'
require 'dotenv/load'
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir('.')
loader.push_dir('lib')
loader.push_dir('services')
loader.push_dir('views')
loader.enable_reloading # you need to opt-in before setup
loader.setup

# Demo comment form
get '/', provides: 'html' do
    erb :index
end

# Comment submission
post '/comments/:database_id' do |database_id|
    form_data = params.slice(:email, :name, :body)

    Notion::SubmitComment.call(database_id: database_id, form_data: form_data)

    redirect to(params.fetch(:redirect_uri, request.referrer))
end