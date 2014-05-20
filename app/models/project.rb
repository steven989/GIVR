class Project < ActiveRecord::Base

  belongs_to :user
  has_many :applications
  has_many :users, through: :applications
  belongs_to :category
  belongs_to :cause
  belongs_to :location
  has_many :statuses, foreign_key: 'project_id', class_name: 'ProjectStatuses'
  
  validates :title, presence: true
  validates :description, presence: true


  def statuses= (status_value)
    self.statuses.new(status: status_value).save    # add a record to the status table to keep a running tab of statuses
    self.update_attribute(:status, status_value)     # change the status on the main table as well
  end 

end
