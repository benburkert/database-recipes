monit Mash.new unless attribute?('monit')

monit[:application] = @attribute[:applications].keys.first