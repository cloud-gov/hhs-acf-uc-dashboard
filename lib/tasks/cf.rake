namespace :cf do
  task :on_first_instance do
    app_data = ENV['VCAP_APPLICATION']
    app_data = JSON.parse(app_data) rescue {}
    instance_index = app_data['instance_index']

    if instance_index != 0
      exit(0)
    end
  end
end
