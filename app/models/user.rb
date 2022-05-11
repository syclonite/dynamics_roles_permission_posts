class User < ApplicationRecord
  include Discard::Model
  devise :database_authenticatable
  has_many :user_role_permissions, dependent: :destroy
  has_many :roles, through: :user_role_permissions
  has_many :permissions, through: :user_role_permissions
  has_many :posts
end
