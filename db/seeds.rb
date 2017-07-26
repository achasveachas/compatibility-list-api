      @user = User.create(name: "Test User", username: "testuser", password: "testtest")
      3.times do |i|
        @user.applications.create(software: "Software number #{i + 1}")
      end