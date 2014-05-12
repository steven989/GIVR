class Project < ActiveRecord::Base

  validates :description, :title, presence: true
end
