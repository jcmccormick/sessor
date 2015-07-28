# A Template is the starting point of the system. A Template contains all of the information needed to visually create an HTML form using AngularJS.

class Template < ActiveRecord::Base

	# Relate to Admins.
	has_and_belongs_to_many :admins

	# Relate to Users.
	has_and_belongs_to_many :users

	# Relate to Reports.
	has_and_belongs_to_many :reports

	# Relate to Sections.
	has_many :sections, dependent: :destroy

	# Saving a Template saves its associated Sections.
	accepts_nested_attributes_for :sections

	# Chain-relationship to allow for `Template.fields` usage.
	has_many :fields, through: :sections

	# Create a scope that assures the loading of all Template associations in a single DB call. Used as `Templates.minned`.
	scope :minned, ->{eager_load(:sections => {:columns => { :fields => [:values, :options]}})}

	# Titles must start with a letter and only contain letters and numbers. 
	validates :name, format: { with: /\A[a-zA-Z ]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }

	# Link up Template defaults method on creation.
	before_create :set_defaults

	# Upon Template creation, set Draft and Private World to true. Setting Private World to true means the Template will be publically available for other Users to search for and add to their own Reports.
	def set_defaults
		self.draft = true
		self.private_world = true
	end

	# Override standard JSON response.
	#
	# * Return only the ID, Name, Creator UID, Private Group, Private World, Group Edit, Group Editors, Allow Title, and Draft fields.
	# * Merge associated Sections.
	def as_json(jsonoptions={})
		super(:only => [:id, :name, :creator_uid, :private_group, :private_world, :group_edit, :group_editors, :allow_title, :draft]).merge(:sections => sections)
	end
end
