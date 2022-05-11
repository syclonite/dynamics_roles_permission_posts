class Permission < ApplicationRecord
  include Discard::Model
  has_many :user_roles_permissions, dependent: :destroy
  has_many :users, through: :user_role_permissions
  has_many :roles, through: :user_role_permissions
end
