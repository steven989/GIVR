class AddCompletedInfoToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :hours, :integer
    add_column :applications, :rating_for_professional, :integer
    add_column :applications, :work_again, :string
    add_column :applications, :comments_for_professional, :text
  end
end
