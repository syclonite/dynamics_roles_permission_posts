json.extract! user, :id, :name, :slug, :email, :encrypted_password, :status, :role_id, :created_at, :updated_at
json.url user_url(user, format: :json)
