class MakeSaltNullable < ActiveRecord::Migration
  def change
    change_column :users, :salt, :string, nullable: true
  end
end
