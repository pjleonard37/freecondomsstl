class State
  include Mongoid::Document

  has_many :sites

  field :name

  rails_admin do
    exclude_fields :_id
  end
end
