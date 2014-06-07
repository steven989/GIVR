class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :submitted_projects, foreign_key: 'user_id', class_name: 'Project'
  has_many :made_applications, foreign_key: 'user_id', class_name: 'Application'
  has_many :projects, through: :applications
  has_many :applications, through: :submitted_projects
  has_many :authentications, dependent: :destroy
  has_many :projectviews, foreign_key: 'user_id', class_name: 'ProjectView'

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :causes
  has_and_belongs_to_many :locations

  belongs_to :cause

  mount_uploader :resume, ResumeUploader
  mount_uploader :logo, LogoUploader

  authenticates_with_sorcery! do |config|

    config.authentications_class = Authentication

  end

  accepts_nested_attributes_for :authentications
  
  validates :email, presence: true, on: :create
  validates :email, uniqueness: true, on: :create
  validates :email, format: /@/, on: :create
  
  validates :password, presence: true, on: :create
  validates :password, length: 6..20, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  def is?(role)
    self.role == role
  end 


  def completed_projects
    self.projects.where("projects.status like 'complete'")
  end 

  def display_name #this is to get a display name for the user for the navigation bar and other places in the app

    loc = self.email.index('@')
    name_from_email = self.email[0..loc-1]

    self.contact_first_name.nil? || self.contact_first_name.blank? ? name_from_email : contact_first_name

  end

  def points
    points_per_application = self.made_applications.map { |application|
        # put the calcuation here to translate application into points
        application.status == 'complete' ? 3000 : 0
    }

    points_per_application.inject(0) {|total_points, points_per_application|
      total_points+=points_per_application
    }
  end 
end
