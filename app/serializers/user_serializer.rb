# frozen_string_literal: true

# app/serializers/user_serializer.rb
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email
end
