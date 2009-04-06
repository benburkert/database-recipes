require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)
ipv4(open('http://169.254.169.254/latest/meta-data/public-ipv4').gets)

postgresql Mash.new unless attribute?('postgresql')

postgresql[:databases]  = applications.keys.map {|a| "#{a}_#{environment[:role]}"}

case instance_type
when 'm1.large' #standalone db server
  bytes = 8053207040  #7.5 GB's of RAM
  kbs   = 7864460
when 'm1.xlarge'
  bytes = 16106270720 #15 GB's of RAM
  kbs   = 15728780
  mbs   = 15360.13672
end

case instance_type
when 'm1.large', 'm1.xlarge'
  postgresql['postgresql.conf'] ||= Mash.new
  postgresql['postgresql.conf'][:listen_addresses]  = '*' #ifconfig lists nothing about the ipv4 address
  postgresql['postgresql.conf'][:port]              = 5432
  
  # Optimize'able stuff
  postgresql[:shared_buffer_space]                      = (bytes * 0.11).to_i #11% of the total RAM
  postgresql['postgresql.conf'][:shared_buffers]        = (mbs * 0.10).to_i   #91% of the buffer space
  postgresql['postgresql.conf'][:effective_cache_size]  = (mbs * 0.75).to_i   #75% of the total RAM
  
  postgresql['postgresql.conf'][:maintenance_work_mem]  = 384 #384MB
  postgresql['postgresql.conf'][:work_mem]              = 64  #64MB
  postgresql['postgresql.conf'][:temp_buffers]          = 64  #64MB
  
  postgresql['postgresql.conf'][:checkpoint_segments]       = 128
  postgresql['postgresql.conf'][:default_statistics_target] = 100
  
  postgresql['postgresql.conf'][:vacuum_cost_delay]    = 200
  postgresql['postgresql.conf'][:random_page_cost]     = "3.0"
  
  postgresql['postgresql.conf'][:autovacuum_vacuum_threshold]      = 400
  postgresql['postgresql.conf'][:autovacuum_vacuum_scale_factor]   = "0.05"
  postgresql['postgresql.conf'][:autovacuum_analyze_threshold]     = 200
  postgresql['postgresql.conf'][:autovacuum_analyze_scale_factor]  = "0.01"
end