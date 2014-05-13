class User < ActiveRecord::Base

  has_many :submitted_projects, foreign_key: 'user_id', class_name: 'Project'
  has_many :applications
  has_many :projects, through: :applications

  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true


  def is?(role)
    self.role == role
  end 

  def project_applications   #used to see a list of applications to the projects the user has created

        self.submitted_projects.inject([]) { |applications, project|
            applications.push(project.applications.where("status not like 'shortlist'")) 
            applications
        }.flatten

  end 

  def projects

    self.projects.where()

  end 

end
