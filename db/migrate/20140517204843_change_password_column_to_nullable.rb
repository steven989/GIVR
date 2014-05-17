class ChangePasswordColumnToNullable < ActiveRecord::Migration
  def change
    change_column :users, :crypted_password, :string, null: true
  end
end
