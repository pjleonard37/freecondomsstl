class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :type

  def id
    object._id.to_s
  end

  def type
    object.class.to_s
  end
end
