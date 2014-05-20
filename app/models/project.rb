class Project < ActiveRecord::Base

  belongs_to :user
  has_many :applications
  has_many :users, through: :applications
  belongs_to :category
  belongs_to :cause
  belongs_to :location
  
  validates :title, presence: true
  validates :description, presence: true

end
