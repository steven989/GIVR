class AddIpAddressToProjectViewTracking < ActiveRecord::Migration
  def change
    add_column :project_views, :ip_address, :string
  end
end
