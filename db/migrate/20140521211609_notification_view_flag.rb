class NotificationViewFlag < ActiveRecord::Migration
  def change
    add_column :applications, :notification_view_flag, :string
  end
end
