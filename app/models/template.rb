class Template < ActiveRecord::Base
	has_and_belongs_to_many :admins
	has_and_belongs_to_many :users
	has_and_belongs_to_many :reports
	has_many :sections, dependent: :destroy
	accepts_nested_attributes_for :sections
	has_many :fields, through: :sections

	scope :minned, ->{eager_load(:sections => {:columns => { :fields => [:values, :options]}})}

	validates :name, format: { with: /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }

	before_create :set_defaults

	def set_defaults
		self.draft = true
		self.private_world = true
	end

	def as_json(jsonoptions={})
		super(:only => [:id, :name, :creator_uid, :private_group, :private_world, :group_edit, :group_editors, :allow_title, :draft]).merge(:sections => sections)
	end
end
