default_run_options[:pty] = true
set :application, "sitdown"
set :repository,  "git@github.com:aaronkhawkins/sitdown.git"
set :domain, "172.31.0.202"
set :user, "aaron"
set :server_name, "codesmack"
set :branch, "origin/master"
set :deploy_via, :remote_cache
set :gateway, 'openvz.shawkvalue.com'
set :ssh_options, { :forward_agent => true }

set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :deploy_via, :copy 

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "172.31.0.202"
role :web, "172.31.0.202"
role :db,  "172.31.0.202", :primary => true


desc 'Creates a virtual server configuration on apache to your application'
task :create_server_config, :roles => :web do	template = File.read( File.dirname(__FILE__) + '/vhost_config.erb' )
    buffer = ERB.new(template).result(binding)
    puts 'Rendering template file'
    put buffer, "#{shared_path}/#{application}-vhost"
    puts 'Copying virtual server config to apache folder'
    sudo "cp #{shared_path}/#{application}-vhost /etc/apache2/sites-available/#{application}-vhost"
    puts 'Enabling the site on apache'
    sudo "a2ensite #{application}-vhost"
end

task :restart_apache do
    puts 'Restarting the apache server'
    sudo 'apache2ctl restart'
end

desc 'Restarting the application'
task :restart_app do
    puts 'Restarting the application'
    run "touch #{deploy_to}/current/tmp/restart.txt"
end