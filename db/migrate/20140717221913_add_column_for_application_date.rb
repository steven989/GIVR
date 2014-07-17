class AddColumnForApplicationDate < ActiveRecord::Migration
  def change
    add_column :applications, :application_date, :datetime
  end
end
