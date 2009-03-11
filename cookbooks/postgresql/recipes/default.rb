#
# Cookbook Name:: postgresql
# Recipe:: default
#

directory "/db/postgresql/data" do
  owner "postgresql"
  group "postgresql"
  mode 0755
  recursive true
end

template "/etc/conf.d/postgresql" do
  owner 'root'
  group 'root'
  mode 0644
  source "postgresql.erb"
  variables :basedir  => '/db/postgresql',
            :user     => 'postgres',
            :group    => 'postgres'
end