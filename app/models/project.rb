class Project < ActiveRecord::Base

  belongs_to :user
  has_many :applications
  has_many :users, through: :applications

  validates :description, :title, presence: true
end
