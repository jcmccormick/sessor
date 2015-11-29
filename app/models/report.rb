# A Report can be created by Admins and Users, and may in the future be linked to a User's Group. A Report itself contains a database relationship to a Template, which means that when a Report is called from the DB, it will automatically have reference to all the Templates it might contain. However, a Report is not a duplicate of a Template. So when a Template is updated, the Fields of the Report will also be updated. When taking on a new or updated Template relationship, a Report will essentially make copies for the Values associated with its Templates' Fields, allowing for default Field Values and unique Report Values.
# ==== Fields
# * Title - String
# * Allow_Title - Boolean
# * Submission - UNUSED
# * Response - UNUSED
# * Active - UNUSED
# * Location - UNUSED
# ==== Use Case
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
	has_and_belongs_to_many :users
	has_and_belongs_to_many :templates
	has_many :values, dependent: :destroy
	serialize :template_order, Array
	accepts_nested_attributes_for :values

	# Populate the Values of the Fields associated with the Report.
	# Look over all the templates to see which are not yet associated with the report
	# For unassociated templates, iterate through its fields and create report values
	# Ussable on single report objects

	def populate_values(google_drive)
		template_order.each do |template_id|
			template = Template.find(template_id)
			templates << template unless templates.include?(template)
			if template.fields.length
				spreadsheet = google_drive.file_by_id(template.gs_id)
				worksheet = spreadsheet.worksheets[0]


				field_ids = template.fields.map { |x| x.id }
				if template.fields.where.not(fieldtype: 'labelntext').count > values.where(field_id: field_ids).count
					template.fields.where.not(fieldtype: 'labelntext').each do |field|
						Value.where(report_id: self.id, field_id: field.id).first_or_create do |value|
							value.input = field.default_value
						end
					end
				end
			end
		end
		if self.changed?
			exclude_ids = Field.where(template_id: template_order).where.not(fieldtype: 'labelntext').map { |x| x.id }
			pp exclude_ids
			values.where.not(field_id: exclude_ids).destroy_all
		end
	end

	def disassociate_template(did, unvalued=[])
		template = templates.find(did)
		template.fields.each do |field|
			values.each do |value|
				if field.id == value.field_id
					unvalued.push value.id
				end
			end
		end
		values.where(:id => unvalued).destroy_all
		templates.delete(template)
	end

end