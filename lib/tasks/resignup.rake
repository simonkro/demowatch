namespace :demowatch do
  desc "send resignup notifications"
  task :resignup => :environment do
    users = User.all(:conditions => 'activation_code is not null')
    users.each do |user|
      puts user.login
    end
  end
end

