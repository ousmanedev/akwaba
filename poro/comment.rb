require 'date'

class Comment
    attr_reader :data, :children

    FIELDS = %w(name email body url parent_id).freeze
    class << self
        def moderation_on?
            !ENV['MODERATION_ON'].nil?
        end
    end

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

    def approved?
        return true unless Comment.moderation_on?

        @data['properties']['is_approved']['checkbox']
    end

    def <<(comment)
        @children << comment
    end

    FIELDS.each do |field|
        define_method field do
            property_object = @data.dig('properties', field)
            content_object = Array(property_object[property_object['type']])[0]
            content = Hash(content_object).dig('text', 'content')

            Rack::Utils.escape_html(content)
        end
    end
end