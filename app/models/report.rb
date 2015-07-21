class Report < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  has_and_belongs_to_many :templates
  has_many :values
  accepts_nested_attributes_for :values
  has_many :fields, through: :values
  #validates :title, format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_ ]*\z/,
  #	message: " must contain at least 1 letter and only letters and numbers" }
end