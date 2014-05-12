class Project < ActiveRecord::Base

  belongs_to :user

  validates :description, :title, presence: true
end
