class AddBrowserInfoToViewTracking < ActiveRecord::Migration
  def change
    add_column :project_views, :browser, :text
  end
end
