 class Application < ActiveRecord::Base

    belongs_to :user
    belongs_to :project
    has_many :statuses, foreign_key: 'application_id', class_name: 'ApplicationStatus'

    validate :cannot_apply_to_filled_projects
    validate :professional_cannot_apply_twice_to_same_project
    
    def statuses= (status_value)
        if status_value
            self.statuses.new(status: status_value).save    # add a record to the status table to keep a running tab of statuses
            self.update_attribute(:status, status_value)     # change the status on the main table as well
        end
    end 

    def professional_cannot_apply_twice_to_same_project
        if self.project.applications.where("applications.status not in ('shortlist')").map {|application| application.user_id}.include? self.user_id
          self.errors[:base] << "You've already applied to this project."
        end
    end

    def cannot_apply_to_filled_projects
        self.errors[:base] << 'This position is already filled.' if self.project.status == 'filled'
    end

    def cannot_shortlist_more_than_once
        if self.project.applications.where("applications.status in ('shortlist')").map {|application| application.user_id}.include? self.user_id
          self.errors[:base] << "You've already shortlisted to this project."
        end     
    end

    def must_include_message
        self.errors.add(:message, "cannot be blank.") if self.message.blank? || self.message.nil? || self.message.scan(/\S/).length == 0
    end

end
