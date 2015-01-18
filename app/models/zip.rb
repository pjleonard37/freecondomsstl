class Zip
  include Mongoid::Document

  field :code, type: String

  
  has_many :sites

  rails_admin do
    object_label_method :code
    exclude_fields :_id
  end
end
