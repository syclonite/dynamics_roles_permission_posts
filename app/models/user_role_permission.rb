class UserRolePermission < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :permission
end
