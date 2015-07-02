class Report < ActiveRecord::Base
  belongs_to :template
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  validates :title, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*\z/,
  	message: " must contain at least 1 letter and only letters and numbers" }
end