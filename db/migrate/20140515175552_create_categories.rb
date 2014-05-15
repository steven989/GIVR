class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
        t.string :category
        t.string :description
      t.timestamps
    end

    create_table :categories_users do |t|
        t.belongs_to :category
        t.belongs_to :user
      t.timestamps
    end

  end
end
