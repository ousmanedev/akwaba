module Notion
    class SubmitComment < Base
        attr_reader :database_id, :form_data

        def initialize(database_id:, form_data:)
            @database_id = database_id
            @form_data = form_data
        end

        def call
            client.create_page(parent: { database_id: database_id }, properties: build_properties)
        end

        private

        def build_properties
            Comment::FIELDS.map do |property_name|
                [
                    property_name,
                    [
                        {
                            type: 'text',
                            text: { content: Rack::Utils.escape_html(form_data[property_name]) }
                        }
                    ]
                ]
            end.to_h
        end
    end
end