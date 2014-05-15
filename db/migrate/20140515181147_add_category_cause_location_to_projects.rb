class AddCategoryCauseLocationToProjects < ActiveRecord::Migration
  def change

    add_column :projects, :category_id, :integer
    add_column :projects, :cause_id, :integer
    add_column :projects, :location_id, :integer

  end
end
