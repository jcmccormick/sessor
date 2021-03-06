# A Template is the starting point of the system. A Template contains all of the information needed to visually create an HTML form using AngularJS.
class Template < ActiveRecord::Base
    include Nested

    # Relate to Users.
    has_and_belongs_to_many :users

    # Relate to Reports.
    has_and_belongs_to_many :reports

    # Relate to Fields.
    has_many :fields, inverse_of: :template, dependent: :destroy

    # Saving a Template saves its associated Fields.
    accepts_nested_attributes_for :fields, allow_destroy: true

    # Titles must start with a letter and only contain letters and numbers. 
    validates :name, presence: true

    # Serialize sections.
    serialize :sections, Array

    # Link up Template defaults method on creation.
    before_create :set_defaults

    # Prevent destroy if attached to any reports
    before_destroy :allow_destroy


    # Check for existing report associations
    def allow_destroy
        reports.empty?
    end
    
    private

        # Upon Template creation, set basic stuff
        def set_defaults
            self.draft = true
            self.sections = [{i:1,n:'',c:1}]
        end

end
