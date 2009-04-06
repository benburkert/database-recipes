require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)

@attribute[:user]         = @attribute[:users].first[:username]
@attribute[:group]        = @attribute[:users].first[:username]
@attribute[:password]     = @attribute[:users].first[:password]
@attribute[:application]  = @attribute[:applications].keys.first

@attribute[:upstream_port]  = 5000
@attribute[:ports]          = 5001..5005
@attribute[:current_path]   = "/data/#{@attribute[:application]}/current"
@attribute[:shared_path]    = "/data/#{@attribute[:application]}/shared"
@attribute[:environment]    = @attribute[:environment][:role]