require 'date'

class Comment
    attr_reader :data

    def initialize(data)
        @data = data
    end

    def id
        @data['id']
    end

    def date
        Date.parse(@data['created_time']).strftime("%B %d, %Y")
    end

    %w(name email body).each do |field|
        define_method field do
            content = Array(@data.dig('properties', field, 'rich_text'))[0]
            Hash(content).dig('text', 'content')
        end
    end
end