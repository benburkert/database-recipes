haproxy Mash.new unless attribute?('haproxy')

haproxy[:user]        = @attribute[:owner_name]
haproxy[:password]    = @attribute[:owner_pass]
haproxy[:application] = @attribute[:applications].keys.first

# TODO: replace this with recipes('nginx') in the future
haproxy[:upstream_port] = 4999
haproxy[:ports]         = 5000..5004