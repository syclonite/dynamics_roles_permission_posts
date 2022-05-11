class RemoveApproveStatusFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :approved_status
  end
end
