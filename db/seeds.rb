# @user = User.create(name: "Test User", username: "testuser", password: "testtest")

# User.all.each do |user|
#   3.times do |i|
#     user.applications.create(software: "Software number #{i}")
#   end
# end

Application.all.each do |app|
  app.comments.create(body: app.notes, user: User.last)
end