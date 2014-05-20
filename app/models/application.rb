 class Application < ActiveRecord::Base

  belongs_to :user
  belongs_to :project
  has_many :statuses, foreign_key: 'application_id', class_name: 'ApplicationStatus'

  # validate :professional_cannot_apply_twice_to_same_project

  def statuses= (status_value)
      self.statuses.new(status: status_value).save    # add a record to the status table to keep a running tab of statuses
      self.update_attribute(:status, status_value)     # change the status on the main table as well
  end 

  # def professional_cannot_apply_twice_to_same_project
  #   if self.project_id == project_id
  #     errors.add_to_base("You've already applied to this project.")
  #   end
  # end

end
