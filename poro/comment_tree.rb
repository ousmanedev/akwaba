class CommentTree
    def initialize
        @comments = {}
    end

    def <<(comment)
        @comments[comment.id] = comment
    end

    def to_a
        @comments.values.reverse
    end
end