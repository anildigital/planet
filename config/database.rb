require 'erb'

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
              base: &base
                adapter: mysql
                socket: /var/run/mysqld/mysqld.sock
                username: #{user}
                      password: #{password}

                          development:
                            database: #{application}_dev
                            <<: *base

                          test:
                            database: #{application}_test
                            <<: *base

                          production:
                            database: #{application}_production
                            <<: *base
                          EOF

                      run "mkdir -p #{shared_path}/config"
                      put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
