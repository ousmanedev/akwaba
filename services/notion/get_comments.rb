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
                filter: {
                    property: 'url',
                    text: { equals: @url }
                },
                sorts: [
                    {
                        timestamp: 'created_time',
                        direction: 'ascending'
                    }
                ]
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
    end
end