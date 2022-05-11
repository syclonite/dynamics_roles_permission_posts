class CreateUserRolePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_role_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
