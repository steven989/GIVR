class User < ActiveRecord::Base

  has_many :submitted_projects, foreign_key: 'user_id', class_name: 'Project'
  has_many :made_applications, foreign_key: 'user_id', class_name: 'Application'
  has_many :projects, through: :applications
  has_many :applications, through: :submitted_projects

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :causes
  has_and_belongs_to_many :locations

  mount_uploader :resume, ResumeUploader

  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true


  def is?(role)
    self.role == role
  end 


  def completed_projects
    self.projects.where("status like 'completed'")
  end 

end
