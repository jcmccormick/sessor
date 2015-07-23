class Report < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  has_and_belongs_to_many :templates
  has_many :fields, through: :templates
  has_many :values
  accepts_nested_attributes_for :values
  #validates :title, format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_ ]*\z/,
  #	message: " must contain at least 1 letter and only letters and numbers" }

  before_update :populate_values
  after_create :populate_values

  def populate_values
  	fields.each { |f| self.values.where(report: self, field: f, :input => f.values.first.input).first_or_create }
  end
end