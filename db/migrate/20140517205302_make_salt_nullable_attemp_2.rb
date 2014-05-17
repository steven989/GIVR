class MakeSaltNullableAttemp2 < ActiveRecord::Migration
  def change
    change_column :users, :salt, :string, null: true
  end
end
