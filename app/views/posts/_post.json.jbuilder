json.extract! post, :id, :post_title, :slug, :status, :user_id, :created_at, :updated_at
json.url post_url(post, format: :json)
