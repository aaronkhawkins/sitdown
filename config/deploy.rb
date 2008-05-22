set :user, "deploy"  
set :application, "SitDown"
set :domain, "sitdown"
set :server_name, "sitdown"
set :scm, :git
set :repository,  "git@github.com:aaronkhawkins/sitdown.git"
set :branch, "cas"
set :deploy_via, :copy 

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db,  domain, :primary => true


# If you aren't deploying to /var/www/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

before "deploy:setup", :db, :cas
after "deploy:update_code", "db:symlink", "cas:symlink" 

namespace :db do
  desc "Copy database yaml to shared path" 
  task :default do
    run "mkdir -p #{shared_path}/config" 
    put File.read('config/database.yml'), "database.yml"
    # I have no idea why I have to do this - but trying to copy it directly doesn't work
    run "mv database.yml #{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

namespace :cas do
  desc "Copy cas yaml to shared path" 
  task :default do
    run "mkdir -p #{shared_path}/config" 
    put File.read('config/cas.yml'), "cas.yml"
    # I have no idea why I have to do this - but trying to copy it directly doesn't work
    run "mv cas.yml #{shared_path}/config/cas.yml"
  end

  desc "Make symlink for cas yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/cas.yml #{release_path}/config/cas.yml" 
  end
end

desc 'Installs apache 2 and development headers to compile passenger'
task :install, :roles => :web do
    puts 'Preparing the environment'
    puts 'Installing apache 2'
    sudo 'apt-get install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libapr1 libapr1-dev   libaprutil1 libmagic1 libpcre3 libpq5 openssl apache2-prefork-dev -y'
    puts 'Installing needed gems'
    sudo 'gem install fastthread rake rails passenger'
end

desc 'Creates a virtual server configuration on apache to your application'
task :create_server_config, :roles => :web do	template = File.read( File.dirname(__FILE__) + '/vhost_config.erb' )
    buffer = ERB.new(template).result(binding)
    puts 'Rendering template file'
    puts buffer
    put buffer, "{application}-vhost"
    puts 'Copying virtual server config to apache folder'
    sudo "cp #{application}-vhost /etc/apache2/sites-available/#{application}-vhost"
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
