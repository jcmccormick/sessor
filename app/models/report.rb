# A Report can be created by Admins and Users, and may in the future be linked to a User's Group. A Report itself contains a database relationship to a Template, which means that when a Report is called from the DB, it will automatically have reference to all the Templates it might contain. However, a Report is not a duplicate of a Template. So when a Template is updated, the Fields of the Report will also be updated. When taking on a new or updated Template relationship, a Report will essentially make copies for the Values associated with its Templates' Fields, allowing for default Field Values and unique Report Values.
# ==== Fields
# * Title - String
# * Allow_Title - Boolean
# * Submission - UNUSED
# * Response - UNUSED
# * Active - UNUSED
# * Location - UNUSED
# ==== Use Case
# * Belongs to many Admins.
# * Belongs to many Users.
# * Belongs to many Templates.
# * Has many Fields through Templates.
# * Has many Values.
# * Saving a Report saves its associated Values.
# * Report title must start with a letter and only contain letters and numbers.
# * Holds a scope that assures the loading of all Template associations in a single DB call. Use `Reports.minned`.
# * New Reports check for new Values incoming from added Templates.
# * Updated Reports check for new Values incoming from added Templates.

class Report < ActiveRecord::Base

  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  has_and_belongs_to_many :templates
  has_many :fields, through: :templates
  has_many :values
  accepts_nested_attributes_for :values
  scope :minned, ->{eager_load([:users, :values, :templates => { :sections => {:columns => { :fields => [:values, :options]}}}])}
  validates :title, format: { with: /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }
  after_create :populate_values
  before_update :populate_values

  # Populate the Values of the Fields associated with the Report.
  # (A Report cannot contain the same Values as a Template, or every Report would have the same Values. Therefore creating a Report must somehow create a new Value in the DB, linked to a Report, and based on a Template's default Values. The following describes that process.)
  # 1. Loop through each Template Field associated with the Report.
  # 2. Create a `value` object based on the first Value found with the same Report and Field ID. If none is found, create a Value tied to the Report and Field. (A Value will have a Field ID, as this is needed upon Value creation. However, if a Value has no Report ID associated with it, that means it must be the first Value created for the Field. This is a Field's default Value.
  # 3. If a Value has no input, set it as the original Field's default Value input. If the default Value's input is nil, no harm done. Otherwise, the default Value's input will be placed into the newly created Report Value's input.
  # 4. Save the newly created Report Value.
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
  # * Return only the ID, Title, and Allow_Title fields.
  # * Merge associated Templates and Values into the response.  
  def as_json(jsonoptions={})
    super(:only => [:id, :title, :allow_title]).merge(values: values).merge(templates: templates).merge(users: users)
  end
end