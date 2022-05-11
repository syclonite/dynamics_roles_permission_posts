class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :slug
      t.string :email
      t.string :encrypted_password
      t.integer :status
      t.integer :role_id

      t.timestamps
    end
  end
end
