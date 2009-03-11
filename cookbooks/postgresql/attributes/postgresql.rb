require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)

postgresql Mash.new unless attribute?('postgresql')

case instance_type
when 'm1.large'
  postgresql[:buffer] = 100
end