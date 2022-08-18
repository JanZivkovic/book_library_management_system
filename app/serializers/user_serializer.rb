class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :username, :email
end
