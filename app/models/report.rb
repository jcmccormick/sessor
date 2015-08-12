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
# * Holds a scope that assures the least amount of data needed to index. Use `current_user.reports.index_minned`.
# * New Reports check for Values associated with the Template.fields and create Values tied to the Report.
# * Updated Reports check for new Values associated with new Template.fields and create Values tied to the Report.

class Report < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :users
  has_and_belongs_to_many :templates
  has_many :fields, through: :templates
  has_many :values
  accepts_nested_attributes_for :values
  validates :title, format: { with: /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }
  after_create :populate_values
  before_update :populate_values

  # Use a method to get as little information as needed when viewing all reports. Usable on ActiveRecord Relation.
  def self.index_minned
    includes(:templates).as_json(only: [:id, :title], include: {templates: {only: :name}})
  end

  # Populate the Values of the Fields associated with the Report.
  # (A Report cannot contain the same Values as a Template, or every Report would have the same Values. Therefore creating a Report must somehow create a new Value in the DB, linked to a Report, and based on a Template's default Values. The following describes that process.)
  # 1. Loop through each Template Field associated with the Report.
  # 2. Create a `value` object based on the first Value found with the same Report and Field ID. If none is found, create a Value tied to the Report and Field. (A Value will have a Field ID, as this is needed upon Value creation. However, if a Value has no Report ID associated with it, that means it must be the first Value created for the Field. This is a Field's default Value.
  # 3. If a Value has no input, set it as the original Field's default Value input. If the default Value's input is nil, no harm done. Otherwise, the default Value's input will be placed into the newly created Report Value's input.
  # 4. Save the newly created Report Value.
  def populate_values
    fields.each do |f|
      if values.where(field: f).blank?
        value = Value.new(report: self, field: f, input: f.values.first.input)
        value.save
      end
    end
  end
end