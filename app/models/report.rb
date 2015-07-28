# A Report can be created by Admins and Users, and may in the future be linked somehow to Reports. A Report itself contains a database relationship to a Template, which means that when a Report is called from the DB, it will automatically have reference to all the Templates it might contain. However, a Report is not a duplicate of a Template. So when a Template is updated, the Fields of the Report will also be updated. When taking on a new or updated Template relationship, a Report will essentially make copies for the Values associated with the Template, allowing for default Template Values and unique Report Values.

class Report < ActiveRecord::Base

  # Relate to Admins.
  has_and_belongs_to_many :admins

  # Relate to Users.
  has_and_belongs_to_many :users

  # Relate to Templates.
  has_and_belongs_to_many :templates

  # Relate to a Template's Fields.
  has_many :fields, through: :templates

  # Relate to Values.
  has_many :values

  # Saving a Report saves its associated Values.
  accepts_nested_attributes_for :values

  # Create a scope that assures the loading of all Template associations in a single DB call. Used as `Reports.minned`.
  scope :minned, ->{eager_load([:values, :templates => { :sections => {:columns => { :fields => [:values, :options]}}}])}
  
  # Titles must start with a letter and only contain letters and numbers.
  validates :title, format: { with: /\A[a-zA-Z ]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }

  # New Reports check for new Values.
  after_create :populate_values

  # Updated Reports check for new Values.
  before_update :populate_values

  # Populate the Values of the Fields associated with the Report.
  # 1. Loop through each Template Field associated with the Report.
  # 2. Create a `value` object based on the first Value found with the same Report and Field ID. At least, a Value will have a Field ID, as this is denoted upon Value creation. However, if a Value has no Report associated with it, that means it must be the first Value created for the Field, which can also be thought of as a Field's Default Value.
  # 3. If a Value has no input, set it as the original Field's Default Value input. If the Default Value is nil, no harm done. Otherwise, the Field's Default Value will be placed into the newly created Report Value.
  # 4. Save the newly created Value.
  def populate_values
    fields.each do |f|
      value = values.where(report: self, field: f).first_or_create
      if value.input.blank?
        value.input = f.values.first.input
      end
      value.save
    end
  end

  # Override standard JSON response.
  #
  # * Return only the ID, Title, and ALlow Title fields.
  # * Merge associated Templates and Values into the response.  
  def as_json(jsonoptions={})
    super(:only => [:id, :title, :allow_title]).merge(values: values).merge(templates: templates)
  end
end