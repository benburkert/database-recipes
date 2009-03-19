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

execute 'add-postgresql-to-default-run-level' do
  command %Q{
    rc-update add postgresql-8.3 default
  }

  not_if 'rc-status | grep postgresql-8.3'
end

execute 'ensure-postgresql-is-running' do
  command %Q{
    /etc/init.d/postgresql-8.3 restart
  }
  not_if "/etc/init.d/postgresql-8.3 status | grep 'status:  started'"
end

execute 'add-database-user' do
  command %Q{
    su - postgres -c "createuser -S -D -R -l -i -E #{node[:postgresql][:db_user]}"
    su - postgres -c "psql -c \\"ALTER USER #{node[:postgresql][:db_user]} WITH ENCRYPTED PASSWORD '#{node[:postgresql][:db_user]}'\\""
  }

  not_if "su - postgres -c \"psql -c\\\"SELECT * FROM pg_roles\\\"\" | grep #{node[:postgresql][:db_user]}"
end

node[:postgresql][:databases].each do |database|
  execute "add-#{database}-database" do
    command %Q{
      su - postgres -c "createdb -E=UTF8 -O #{node[:postgresql][:db_user]} #{database}"
    }

    not_if "su - postgres -c \"psql -c \\\"SELECT * FROM pg_database\\\"\" | grep #{database}"
  end
end