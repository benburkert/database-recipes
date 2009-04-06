monit = Mash.new unless attribute?('monit')

monit[:master_pidfile]  = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:environment]}.main.pid"
monit[:worker_pidfile]  = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:environment]}.%s.pid"
monit[:script_pid]      = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:environment]}.script.pid"
monit[:master_log]      = "#{@attribute[:shared_path]}/logs/#{@attribute[:application]}.#{@attribute[:environment]}.mongrel.log"
monit[:script_log]      = "#{@attribute[:shared_path]}/logs/#{@attribute[:application]}.#{@attribute[:environment]}.script.log"
script_log

monit[:application] = @attribute[:application]
monit[:environment] = @attribute[:environment]
monit[:current_path] = @attribute[:current_path]
monit[:user] = @attribute[:user]
monit[:group] = @attribute[:group]


monit[:script_name] = "evented_bot"
monit[:script_path] = "#{monit[:current_path]}/script/evented_bot.rb"
monit[:script_port] = @attribute[:ports].last + 1