json.extract! comment, :id, :body, :user_id, :commentable, :created_at, :updated_at
json.url comment_url(comment, format: :json)
