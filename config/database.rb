task :after_symlink do
    %w{ database.yml}.each do |c|
      run "ln -nsf #{shared_path}/system/config/#{c} #{current_path}/config/#{c}"
    end
end
