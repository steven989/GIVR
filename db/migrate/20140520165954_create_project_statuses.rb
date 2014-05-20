class CreateProjectStatuses < ActiveRecord::Migration
  def change
    create_table :project_statuses do |t|
        t.integer  "project_id"
        t.string   "status"
        t.datetime "created_at"
        t.datetime "updated_at"
      t.timestamps
    end
  end
end
