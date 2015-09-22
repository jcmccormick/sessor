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
  has_many :values, dependent: :destroy
  serialize :template_order, Array
  accepts_nested_attributes_for :values
  validates :title, format: { with: /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*\z/ }

  default_scope { eager_load([{:templates => :fields}, :values])}

  # Use a method to get as little information as needed when viewing all reports. Usable on ActiveRecord Relation.
  def self.index_minned
    includes(:templates).as_json(only: [:id, :title, :template_order], include: {templates: {only: [:id, :name]}})
  end

  # Populate the Values of the Fields associated with the Report.
  # Look over all the templates to see which are not yet associated with the report
  # For unassociated templates, iterate through its fields and create report values
  # Ussable on single report objects

  def populate_values
    template_order.each do |template_id|
      template = Template.find(template_id)
      unless templates.include?(template)
        templates << template
        Template.find_by_id(template_id).fields.each do |field|
          values.new(report: self, field_id: field.id, input: field.default_value)
        end
      end
    end
  end
end