haproxy Mash.new unless attribute?('haproxy')

haproxy[:user]        = @attribute[:user]
haproxy[:password]    = @attribute[:password]
haproxy[:application] = @attribute[:application]

haproxy[:upstream_port] = @attribute[:upstream_port]
haproxy[:ports]         = @attribute[:ports]