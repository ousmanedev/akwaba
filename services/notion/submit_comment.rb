module Notion
    class SubmitComment < Base
        attr_reader :database_id, :form_data

        def initialize(database_id:, form_data:)
            @database_id = database_id
            @form_data = form_data
        end

        def call
            client.create_page(database_id: database_id, properties: build_properties)
        end

        private

        def build_properties
            form_data.map do |property_name, _|
                [
                    property_name,
                    [
                        {
                            type: 'text',
                            text: { content: form_data[property_name] }
                        }
                    ]
                ]
            end.to_h
        end

        def client
            @client ||= NotionClient.new(ENV['NOTION_TOKEN'])
        end
    end
end