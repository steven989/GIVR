class CreateCauses < ActiveRecord::Migration
  def change
    create_table :causes do |t|
        t.string :cause
        t.string :description

      t.timestamps
    end

    create_table :causes_users do |t|
        t.belongs_to :cause
        t.belongs_to :user

      t.timestamps
    end

  end
end
