      @user = User.create(name: "Test User", username: "testuser", password: "testtest")
      i = 1
      User.all.each do |user|
        3.times do
          user.applications.create(software: "Software number #{i}")
          i += 1
        end
      end
