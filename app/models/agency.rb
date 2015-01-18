class Agency
  include Mongoid::Document

  field :title
  field :details
  field :contact_information
  
  has_many :sites

  rails_admin do
    exclude_fields :_id
  end
end
