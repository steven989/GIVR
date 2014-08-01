class AddProjectApprovalDate < ActiveRecord::Migration
  def change
    add_column :projects, :approval_date, :datetime
  end
end
