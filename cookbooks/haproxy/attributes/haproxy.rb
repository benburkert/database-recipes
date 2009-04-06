haproxy Mash.new unless attribute?('haproxy')

@attribute[:user]         = @attribute[:users].first[:username]
@attribute[:group]        = @attribute[:users].first[:username]
@attribute[:password]     = @attribute[:users].first[:password]
@attribute[:application]  = @attribute[:applications].keys.first

@attribute[:upstream_port]  = 5000
@attribute[:ports]          = 5001..5005
@attribute[:current_path]   = "/data/#{@attribute[:application]}/current"
@attribute[:shared_path]    = "/data/#{@attribute[:application]}/shared"
@attribute[:env]    = @attribute[:environment][:role]

haproxy[:user]        = @attribute[:user]
haproxy[:password]    = @attribute[:password]
haproxy[:application] = @attribute[:application]

haproxy[:upstream_port] = @attribute[:upstream_port]
haproxy[:ports]         = @attribute[:ports]