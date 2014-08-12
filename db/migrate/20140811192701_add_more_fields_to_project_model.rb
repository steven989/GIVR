class AddMoreFieldsToProjectModel < ActiveRecord::Migration
  def change
    add_column :projects, :how_output_will_be_used, :text
    add_column :projects, :required_date, :date
  end
end
