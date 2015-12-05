# Fields are created at-will and linked to their parent Column. They contain Options in the case of Radio or Dropdown fields, and a Value that contains no Report ID (the Default Value).
class Field < ActiveRecord::Base

    validates :template, :fieldtype, presence: true

    belongs_to :template
    
    serialize :o, JSON

    before_save { o == 'destroy' || o['name'].present? }

    after_save { template.touch }

end
