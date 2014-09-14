json.array!(@users) do |user|
  json.extract! user, :id, :username, :password_digest, :instructor_id, :role, :active
  json.url user_url(user, format: :json)
end
