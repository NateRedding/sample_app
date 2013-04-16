require 'faker'

namespace :db do

  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin_password = 'foobar'
    admin = User.create!(:name => 'Example User', :email => 'example@railstutorial.org', :password => admin_password, :password_confirmation => admin_password)
    #seem to need to reset the password and confirmation in order for toggle! not to change them
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = 'password'
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
    end

  end

end