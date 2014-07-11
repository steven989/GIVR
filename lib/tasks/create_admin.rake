namespace :user do
    desc 'change an existing user to admin'
    task :make_admin, [:email] => [:environment] do |t, args|
        if User.find_by_email(args[:email])
            User.find_by_email(args[:email]).update_attribute(:role, 'admin') 
            puts "#{args[:email]} successfully made into an admin."
        else 
            puts "User cannot be found."
        end
    end
end

namespace :user do
    desc 'remove admin status from user'
    task :remove_admin, [:email] => [:environment] do |t, args|
        if User.find_by_email(args[:email])
            User.find_by_email(args[:email]).update_attribute(:role, '') 
            puts "Admin privileges successfully removed from #{args[:email]}."
        else 
            puts "User cannot be found."
        end
    end
end