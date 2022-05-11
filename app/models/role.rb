class Role < ApplicationRecord
  include Discard::Model
  has_many :user_role_permissions, dependent: :destroy
  has_many :users, through: :user_role_permissions
  has_many :permissions, through: :user_role_permissions
end
