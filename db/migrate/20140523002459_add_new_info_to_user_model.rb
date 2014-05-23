class AddNewInfoToUserModel < ActiveRecord::Migration
  def change
    add_column :users, :org_name, :string
    add_column :users, :cause_id, :integer
    add_column :users, :mission, :text
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
    add_column :users, :website, :string
    add_column :users, :contact_first_name, :string
    add_column :users, :contact_last_name, :string
    add_column :users, :phone, :string
    add_column :users, :extension, :string
    add_column :users, :fax, :string
    add_column :users, :years_of_experience, :integer
    add_column :users, :organization_size, :integer
  end
end
