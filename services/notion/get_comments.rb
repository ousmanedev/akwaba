module Notion
    class GetComments < Base
        attr_reader :database_id

        def initialize(database_id:)
            @database_id = database_id
        end

        def call
            get_database_pages.map { |page| Comment.new(page) }
        end

        private

        def get_database_pages
            client.query_database(database_id: database_id)['results']
        end
    end
end