set :application, "planetrubyonrails.net"
set :repository,  "git://github.com/anildigital/planet.git"

set :deploy_via, :remote_cache 
set :deploy_to, "/var/www/#{application}"
#set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

set :port, 22

set :scm, :git

set :branch, "rails_3.1"

ssh_options[:paranoid] = false

set :user, :anil
set :runner, user
set :use_sudo, false

role :app, application
role :web, application
role :db,  application, :primary => true

#desc "Reload Nginx"
#task :reload_nginx do 
#  sudo "/etc/init.d/nginx reload" 
#end

#after "deploy", "reload_nginx"


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

after "deploy", "deploy:cleanup"
