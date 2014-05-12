class User < ActiveRecord::Base

  has_many :projects

  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true


  def is?(role)
    self.role == role
  end 

end
