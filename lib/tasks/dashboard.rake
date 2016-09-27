namespace :dashboard do
  desc 'create Olympia as admin user'
  task create_first_admin: :environment do
    service = Admin::CreateUser.new({
      email: 'olympia.belay@acf.hhs.gov',
      role: 'Admin'
    })
    service.call
    if service.saved?
      puts "Successfully added Olympia to the system"
    else
      puts "Something went wrong"
      exit(1)
    end
  end
end
