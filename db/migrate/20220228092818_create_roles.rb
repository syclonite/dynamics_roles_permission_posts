class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :role_name
      t.string :slug
      t.integer :status
      t.integer :user_id
      t.string :flag

      t.timestamps
    end
  end
end
