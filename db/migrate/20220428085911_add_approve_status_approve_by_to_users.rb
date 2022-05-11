class AddApproveStatusApproveByToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :approved_status, :integer
    add_column :users, :approved_by, :integer
  end
end
