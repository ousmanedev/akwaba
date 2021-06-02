module Notion
    class GetComments < Base
        attr_reader :database_id

        def initialize(database_id:)
            @database_id = database_id
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
                sorts: [ { timestamp: 'created_time', direction: 'ascending' } ]
            )['results']
        end

        def build_comment_tree(comments)
            map = {}
            comments.each do |comment|
                map[comment.id] = comment
            end

            comment_tree =  CommentTree.new
            comments.each do |comment|
                parent = map.fetch(comment.parent_id) { comment_tree }
                parent << comment
            end

            comment_tree
        end
    end
end