require 'httparty'

class NotionClient
    BASE_URI = 'https://api.notion.com/v1'

    def initialize(access_token)
        @access_token = access_token
    end

    def create_page(parent:, properties:)
        post('pages', body: { parent: parent, properties: properties }.to_json)
    end

    def query_database(database_id:)
        post("databases/#{database_id}/query")
    end

    private

    def post(uri, options = {})
        HTTParty.post(
            "#{BASE_URI}/#{uri}",
            options.merge(
                headers: {
                    'Authorization' => "Bearer #{@access_token}",
                    'Content-Type' => 'application/json'
                },
                debug_output: $stdout,
            )
        )
    end
end