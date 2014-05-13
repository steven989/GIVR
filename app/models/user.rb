class User < ActiveRecord::Base

  has_many :submitted_projects, foreign_key: 'user_id', class_name: 'Project'
  has_many :projects, through: :applications

  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true


  def is?(role)
    self.role == role
  end 

end
