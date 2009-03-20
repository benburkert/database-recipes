require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)
ipv4(open('http://169.254.169.254/latest/meta-data/public-ipv4').gets)

postgresql Mash.new unless attribute?('postgresql')

postgresql[:db_user]    = owner_name
postgresql[:db_pass]    = owner_pass
postgresql[:databases]  = applications.keys.map {|a| "#{a}_#{environment[:role]}"}

case instance_type
when 'm1.large' #standalone db server
  postgresql[:config] ||= Mash.new

  postgresql['postgresql.conf'][:listen_addresses]     = ipv4
  postgresql['postgresql.conf'][:port]                 = 5432
  postgresql['postgresql.conf'][:shared_buffer_space]  = 402653184 #384MB's
  postgresql['postgresql.conf'][:shared_buffers]       = 320
  postgresql['postgresql.conf'][:work_mem]             = 32
  postgresql['postgresql.conf'][:maintenance_work_mem] = 256
  postgresql['postgresql.conf'][:checkpoint_segments]  = 32
  postgresql['postgresql.conf'][:vacuum_cost_delay]    = 200
  postgresql['postgresql.conf'][:effective_cache_size] = 5120 #7.5GB * 2/3
  postgresql['postgresql.conf'][:random_page_cost]     = "3.0"
             'postgresql.conf'
  postgresql['postgresql.conf'][:autovacuum_vacuum_threshold]      = 400
  postgresql['postgresql.conf'][:autovacuum_vacuum_scale_factor]   = "0.05"
  postgresql['postgresql.conf'][:autovacuum_analyze_threshold]     = 200
  postgresql['postgresql.conf'][:autovacuum_analyze_scale_factor]  = "0.01"

end