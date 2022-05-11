class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :permission_name
      t.string :permission_slug
      t.integer :status
      t.integer :user_id
      t.string :flag

      t.timestamps
    end
  end
end
