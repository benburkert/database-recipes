haproxy Mash.new unless attribute?('haproxy')

haproxy[:user]        = @attribute[:users].first[:username]
haproxy[:password]    = @attribute[:users].first[:password]
haproxy[:application] = @attribute[:applications].keys.first

# TODO: replace this with recipes('nginx') in the future
haproxy[:upstream_port] = 4999
haproxy[:ports]         = 5000..5004