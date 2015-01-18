class Population
  include Mongoid::Document
  
  field :name
  has_and_belongs_to_many :sites

  rails_admin do
    exclude_fields :_id
  end
end
