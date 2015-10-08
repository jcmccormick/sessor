# A Template is the starting point of the system. A Template contains all of the information needed to visually create an HTML form using AngularJS.

class Template < ActiveRecord::Base

	# Relate to Users.
	has_and_belongs_to_many :users

	# Relate to Reports.
	has_and_belongs_to_many :reports

	# Relate to Fields.
	has_many :fields, dependent: :destroy

	# Saving a Template saves its associated Fields.
	accepts_nested_attributes_for :fields

	# Create a scope that assures the loading of all Template associations in a single DB call. Used as `Templates.minned`.
	#default_scope { eager_load(:fields) }

	# Titles must start with a letter and only contain letters and numbers. 
	validates :name, format: { with: /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }

	# Serialize sections and columns.
	serialize :sections, Array
	serialize :columns, Array

	# Link up Template defaults method on creation.
	before_create :set_defaults

	# Prevent destroy if attached to any reports
	before_destroy :allow_destroy

	# Use a method to get as little information as needed when viewing all templates. Usable on ActiveRecord Relationship.
	def self.index_minned
		eager_load(:fields).as_json(only: [:id, :name, :sections, :draft])
	end

	# Upon Template creation, set Draft to true.
	def set_defaults
		self.draft = true
	end

	# Check for existing report associations
	def allow_destroy
		reports.empty?
	end

end
