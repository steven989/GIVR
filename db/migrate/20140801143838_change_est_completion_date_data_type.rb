class ChangeEstCompletionDateDataType < ActiveRecord::Migration
  def change
    change_column :applications, :est_completion_date, :date
  end
end
