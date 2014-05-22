class Project < ActiveRecord::Base

  belongs_to :user
  has_many :applications
  has_many :users, through: :applications
  belongs_to :category
  belongs_to :cause
  belongs_to :location
  has_many :statuses, foreign_key: 'project_id', class_name: 'ProjectStatuses'
  has_many :views, foreign_key: 'project_id', class_name: 'ProjectView'

  accepts_nested_attributes_for :category, :cause, :location

  validates :category, presence: true
  validates :location, presence: true
  
  validates :title, presence: true
  validates :description, presence: true
  validates :number_of_positions, presence: true



  def statuses= (status_value)
    if status_value
      self.statuses.new(status: status_value).save    # add a record to the status table to keep a running tab of statuses
      self.update_attribute(:status, status_value)     # change the status on the main table as well
    end
  end 

  def attempt_close
    self.statuses= 'filled' if self.applications.where("status in ('engage','complete')").length >= self.number_of_positions
  end


end
