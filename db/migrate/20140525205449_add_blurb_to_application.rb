class AddBlurbToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :message, :text
  end
end
