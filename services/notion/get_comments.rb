module Notion
    class GetComments < Base
        attr_reader :database_id

        def initialize(database_id:, url:)
            @database_id = database_id
            @url = url
        end

        def call
            comments = fetch_comments.map { |comment_data| Comment.new(comment_data) }
            comment_tree = build_comment_tree(comments)
            comment_tree.to_a
        end

        private

        def fetch_comments
            client.query_database(
                database_id: database_id,
                filter: { and: filters },
                sorts: [{ timestamp: 'created_time', direction: 'ascending' }]
            )['results']
        end

        def build_comment_tree(comments)
            map = {}
            comments.each { |comment| map[comment.id] = comment }
            comment_tree =  CommentTree.new
            comments.each do |comment|
                parent = map.fetch(comment.parent_id) { comment_tree }
                parent << comment
            end
            comment_tree
        end

        def filters
            filters = [url_filter]
            filters.push(is_approved_filter) if Comment.moderation_on?
            filters
        end

        def url_filter
            { property: 'url', text: { equals: @url } }
        end

        def is_approved_filter
            { property: 'is_approved', checkbox: { equals: true } }
        end
    end
end