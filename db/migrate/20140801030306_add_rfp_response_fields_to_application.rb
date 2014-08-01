class AddRfpResponseFieldsToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :est_completion_date, :datetime
    add_column :applications, :open_questions, :text
    add_column :applications, :required_resources, :text
  end
end
