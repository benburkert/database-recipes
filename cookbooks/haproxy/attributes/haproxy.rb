haproxy Mash.new unless attribute?('haproxy')

haproxy[:user]        = @attribute[:user]
haproxy[:password]    = @attribute[:password]
haproxy[:application] = @attribute[:application]

haproxy[:upstream_port] = @attribute[:upstream_port] || 5000
haproxy[:ports]         = @attribute[:ports] || 5001..5005