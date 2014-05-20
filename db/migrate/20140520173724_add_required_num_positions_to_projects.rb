class AddRequiredNumPositionsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :number_of_positions, :integer
  end
end
