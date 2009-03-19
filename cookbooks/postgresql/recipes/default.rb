#
# Cookbook Name:: postgresql
# Recipe:: default
#

directory "/db/postgresql" do
  owner "postgres"
  group "postgres"
  mode 0755
  recursive false
end

directory "/db/postgresql/data" do
  owner "postgres"
  group "postgres"
  mode 0700
  recursive false
end

template "/etc/conf.d/postgresql-8.3" do
  owner 'root'
  group 'root'
  mode 0644
  source "postgresql-8.3.erb"
  variables :basedir  => '/db/postgresql',
            :user     => 'postgres',
            :group    => 'postgres'
end

execute 'init-postgres-database' do
  command %Q{
    su - postgres -c "initdb --locale=en_US.UTF-8 -E=UNICODE /db/postgresql/data"
  }

  not_if { not Dir["/db/postgresql/data/*"].empty? }
end