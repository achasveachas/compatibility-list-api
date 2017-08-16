json.user do
  json.(@user, :id, :username, :name, :admin)
end
json.token(Auth.create_token(@user.id))
