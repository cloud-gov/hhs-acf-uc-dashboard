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

  desc 'import csv given a path'
  task import_csv: :environment do
    path = ARGV[1]

    if !path
      puts "Must provide path to file: rake dashboard:import_csv ../some/path-to/example.csv"
      exit(1)
    end

    Import::FromCSV.new(path).call
    puts "imported!"
  end
end
