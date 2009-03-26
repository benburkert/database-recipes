# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

# uncomment to turn your instance into an integrity CI server
#require_recipe "integrity"

case node[:instance_type]
when 'c1.medium'  #app server
  require_recipe "haproxy"
  require_recipe "monit"
when 'm1.large', 'm1.xlarge'   #database server
  require_recipe "postgresql"
end