haproxy Mash.new unless attribute?('haproxy')

haproxy[:user]        = @attribute[:users].first[:username]
haproxy[:password]    = @attribute[:users].first[:username]
haproxy[:application] = @attribute[:applications].keys.first

haproxy[:upstream_port] = 5000
haproxy[:ports]         = 5001..5005