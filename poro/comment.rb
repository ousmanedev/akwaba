require 'date'

class Comment
    attr_reader :data, :children

    FIELDS = %w(name email body url parent_id).freeze

    def initialize(data)
        @data = data
        @children = []
    end

    def id
        @data['id']
    end

    def date
        Date.parse(@data['created_time']).strftime("%B %d, %Y")
    end

    def <<(comment)
        @children << comment
    end

    FIELDS.each do |field|
        define_method field do
            content = Array(@data.dig('properties', field, 'rich_text'))[0]
            Hash(content).dig('text', 'content')
        end
    end
end