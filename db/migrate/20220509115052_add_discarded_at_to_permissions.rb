class AddDiscardedAtToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :discarded_at, :datetime
    add_index :permissions, :discarded_at
  end
end
