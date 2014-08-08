class AddMoreDateFieldsToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :unapproved_status_view_date, :date
    add_column :applications, :in_progress_date, :date
    add_column :applications, :complete_date, :date
  end
end
