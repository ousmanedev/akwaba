require 'httparty'

class NotionClient
    BASE_URI = 'https://api.notion.com/v1'

    def initialize(access_token)
        @access_token = access_token
    end

    def create_page(parent:, properties:)
        post('pages', body: { parent: parent, properties: properties }.to_json)
    end

    def query_database(database_id:, filter: {}, sorts: [])
        post("databases/#{database_id}/query", body: { filter: filter, sorts: sorts }.to_json)
    end

    private

    def post(uri, options = {})
        HTTParty.post(
            "#{BASE_URI}/#{uri}",
            options.merge(
                headers: {
                    'Authorization' => "Bearer #{@access_token}",
                    'Content-Type' => 'application/json',
                    'Notion-Version' => '2021-05-13'
                },
                debug_output: $stdout,
            )
        )
    end
end