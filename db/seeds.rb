@user = User.create(name: "Test User", username: "testuser", password: "testtest")

User.all.each do |user|
  3.times do |i|
    user.applications.create(software: "Software number #{i}")
  end
end
