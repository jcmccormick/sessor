class Template < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  has_many :reports
  has_many :sections, dependent: :destroy
  accepts_nested_attributes_for :sections
  has_many :columns, through: :sections, dependent: :destroy
  has_many :fields, through: :columns, dependent: :destroy
  has_many :options, through: :fields, dependent: :destroy
end
