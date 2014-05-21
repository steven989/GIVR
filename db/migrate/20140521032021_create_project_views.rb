class CreateProjectViews < ActiveRecord::Migration
  def change
    create_table :project_views do |t|
        t.integer :project_id
        t.integer :user_id
        t.datetime :view_start_time
        t.datetime :view_end_time

      t.timestamps
    end
  end
end
