
postgresql Mash.new unless attribute?('postgresql')

postgresql[:version]    = "8.3.1"
postgresql[:hard_masked]  = true

#case instance_type
#when 'm1.large'
#  postgresql[:buffer] = 100
#end