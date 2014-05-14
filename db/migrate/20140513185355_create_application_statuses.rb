class CreateApplicationStatuses < ActiveRecord::Migration
  def change
    create_table :application_statuses do |t|
        t.integer :application_id
        t.string :status
      t.timestamps
    end
  end
end
