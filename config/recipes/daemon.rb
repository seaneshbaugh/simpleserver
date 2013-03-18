set_default(:daemon_user) { user }
set_default(:daemon_pid) { "#{current_path}/tmp/pids/#{application}.pid"}

namespace :daemon do
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'daemon.erb', "/tmp/#{application}_daemon"
    run "chmod +x /tmp/#{application}_daemon"
    run "#{sudo} mv /tmp/#{application}_daemon /etc/init.d/#{application}_daemon"
    run "#{sudo} chkconfig #{application}_daemon on"
  end
  after 'deploy:setup', 'daemon:setup'

  %w[start stop restart].each do |command|
    desc "#{command.capitalize} the server"
    task command, :roles => :app do
      run "/etc/init.d/#{application}_daemon #{command}"
    end
    after "deploy:#{command}", "daemon:#{command}"
  end
end
