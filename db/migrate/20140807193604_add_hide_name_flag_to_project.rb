class AddHideNameFlagToProject < ActiveRecord::Migration
  def change
    add_column :projects, :hide_name, :string
  end
end
