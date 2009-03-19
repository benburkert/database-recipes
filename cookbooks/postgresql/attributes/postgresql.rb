require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)
ipv4(open('http://169.254.169.254/latest/meta-data/ipv4').gets)

postgresql Mash.new unless attribute?('postgresql')

postgresql[:db_user]    = owner_name
postgresql[:db_pass]    = owner_pass
postgresql[:databases]  = applications.keys.map {|a| "#{a}_#{environment[:role]}"}

case instance_type
when 'm1.large' #standalone db server
  postgresql[:buffer] = 100
end