monit Mash.new unless attribute?('monit')

@attribute[:user]         = @attribute[:users].first[:username]
@attribute[:group]        = @attribute[:users].first[:username]
@attribute[:password]     = @attribute[:users].first[:password]
@attribute[:application]  = @attribute[:applications].keys.first

@attribute[:upstream_port]  = 5000
@attribute[:ports]          = 5001..5005
@attribute[:current_path]   = "/data/#{@attribute[:application]}/current"
@attribute[:shared_path]    = "/data/#{@attribute[:application]}/shared"
@attribute[:env]            = @attribute[:environment][:role]

monit[:master_pidfile]  = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:env]}.main.pid"
monit[:worker_pidfile]  = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:env]}.%s.pid"
monit[:script_pid]      = "#{@attribute[:shared_path]}/pids/#{@attribute[:application]}.#{@attribute[:env]}.script.pid"
monit[:master_log]      = "#{@attribute[:shared_path]}/logs/#{@attribute[:application]}.#{@attribute[:env]}.mongrel.log"
monit[:script_log]      = "#{@attribute[:shared_path]}/logs/#{@attribute[:application]}.#{@attribute[:env]}.script.log"

monit[:application] = @attribute[:application]
monit[:environment] = @attribute[:env]
monit[:current_path] = @attribute[:current_path]
monit[:user] = @attribute[:user]
monit[:group] = @attribute[:group]


monit[:script_name] = "evented_bot"
monit[:script_path] = "#{monit[:current_path]}/script/evented_bot.rb"
monit[:script_port] = @attribute[:ports].last + 1