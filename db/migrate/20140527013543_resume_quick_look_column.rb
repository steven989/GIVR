class ResumeQuickLookColumn < ActiveRecord::Migration
  def change
    add_column :users, :resume_quick_look, :string
  end
end
