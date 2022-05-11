class RemoveUserIdFromPermissions < ActiveRecord::Migration[6.0]
  def change
    remove_column :permissions, :user_id
  end
end
