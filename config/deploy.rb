# set :stages, %w(staging qc uat production)
# set :default_stage, 'production'

# require 'capistrano/ext/multistage'

load 'config/recipes/base'
# load 'config/recipes/check'
load 'config/recipes/daemon'

set :application, 'simpleserver'
set :user, 'deployer'
# set :deploy_vid, :remote_cache
set :use_sudo, false

set :deploy_to, "/home/#{user}/#{application}"

set :scm, 'git'
set :repository, 'git@github.com:seaneshbaugh/simpleserver.git'
set :branch, 'master'
set :scm_verbose, true

set :gopath, deploy_to
set :pid_file, deploy_to + '/pids/PIDFILE'
set :symlinks, { 'pids' => 'pids' }

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

task :production do
  server '192.168.1.4', :app
end

after 'deploy:update_code', 'go:build'

namespace :go do
  task :build do
    with_env('GOPATH', gopath) do
      run 'go get -u github.com/seaneshbaugh/simpleserver'
      run "mkdir #{release_path}/bin"
      run "cp /home/#{user}/go/bin/#{application} #{release_path}/bin/"
    end
  end
end

# namespace :deploy do
  # task :start do
  #   run "#{release_path}/bin/#{application}"
  #   run "echo $! > #{shared_path}/pids/#{application}.pid"
  # end
  #
  # task :stop do
  #   run "kill -TERM $(cat #{shared_path}/pids/#{application}.pid)"
  # end

  # task :restart do
  #   run "kill -TERM $(cat #{shared_path}/pids/#{application}.pid)" rescue nil
  #   run "nohup #{release_path}/bin/#{application} >/dev/null 2>&1 &"
  #   run "echo $! > #{shared_path}/pids/#{application}.pid"
  # end
# end
