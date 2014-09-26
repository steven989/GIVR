class Project < ActiveRecord::Base

  belongs_to :user
  has_many :applications, dependent: :destroy
  has_many :users, through: :applications, dependent: :destroy
  belongs_to :category
  belongs_to :cause
  belongs_to :location
  has_many :statuses, foreign_key: 'project_id', class_name: 'ProjectStatuses', dependent: :destroy
  has_many :views, foreign_key: 'project_id', class_name: 'ProjectView', dependent: :destroy

  accepts_nested_attributes_for :category, :cause, :location

  validates :category, presence: true
  validates :location, presence: true
  validates :cause, presence: true
  
  validates :title, presence: true
  validates :deliverable, presence: true
  validates :required_date, presence: true
  validates :description, presence: true
  validates :why_we_need_this, presence: true
  # validates :how_output_will_be_used, presence: true
  validates :overseer, presence: true


  def self.count(status=nil)
        if status.nil?
            Project.all.length
        else
            Project.where("status like '#{status}'").length
        end
  end

  def statuses= (status_value)
    if status_value
      self.statuses.new(status: status_value).save    # add a record to the status table to keep a running tab of statuses
      self.update_attribute(:status, status_value)     # change the status on the main table as well
    end
  end 

  def self.marketplace_status_update
    take_count = [Project.where("status not in ('under review', 'complete')").length - 100,0].max
    Project.where("status not in ('under review', 'complete')").order('approval_date ASC').take(take_count).each do |project|
      project.statuses= 'off market' if project.statuses != 'off market'
    end
  end

  def secure_title
    if self.hide_name == "1"
      if ["a","e","i","o","u"].include? self.cause.cause[0].downcase
        "an #{self.cause.cause.downcase} organization"
      else
        "a #{self.cause.cause.downcase} organization"
      end
    else
      self.user.org_name
    end
  end

  # def attempt_close
  #   self.statuses= 'filled' if self.applications.where("status in ('engage','complete')").length >= self.number_of_positions
  # end


end
