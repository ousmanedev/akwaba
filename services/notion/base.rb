module Notion
    class Base
        def self.call(**args)
            new(**args).call
        end

        private

        def client
            @client ||= NotionClient.new(ENV['NOTION_TOKEN'])
        end
    end
end