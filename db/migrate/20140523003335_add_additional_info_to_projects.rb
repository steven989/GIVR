class AddAdditionalInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deliverable, :text
    add_column :projects, :overseer, :string
    add_column :projects, :why_we_need_this, :text
    add_column :projects, :perks, :text
    add_column :projects, :requirements, :text
  end
end
