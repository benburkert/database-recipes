#
# Cookbook Name:: postgresql
# Recipe:: default
#

node[:postgresql][:db_user]    = node[:owner_name]
node[:postgresql][:db_pass]    = node[:owner_pass]

execute 'set-shared-buffer-space' do
  command %Q{
    sysctl -w kernel.shmmax=#{node[:postgresql][:shared_buffer_space]}
    sysctl -w vm.overcommit_memory=2
  }

  not_if "sysctl -n kernel.shmmax | grep #{node[:postgresql][:shared_buffer_space]}"
end

execute 'generate-.postgresql.backups.yml-file' do
  command %Q{
    mv /etc/.mysql.backups.yml /etc/.postgresql.backups.yml
  }

  not_if 'ls /etc/.postgresql.backups.yml'
end

gem_package 'benburkert-ey-backup' do
  action :install
  version '0.0.3.2'
  source "http://gems.github.com"
end

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

template "/db/postgresql/data/postgresql.conf" do
  owner 'postgres'
  group 'postgres'
  mode 0600
  source "postgresql.conf.erb"
  variables node[:postgresql]['postgresql.conf']
end

template "/db/postgresql/data/pg_hba.conf" do
  owner 'postgres'
  group 'postgres'
  mode 0600
  source "pg_hba.conf.erb"
  variables :databases  => node[:postgresql][:databases],
            :user       => node[:postgresql][:db_user]
end

execute 'symlink-pg_xlog' do
  command %Q{
    mv /db/postgresql/data/pg_xlog /mnt
    ln -s /mnt/pg_xlog /db/postgresql/data/pg_xlog
  }
  not_if "ls -al /db/postgresql/data/pg_xlog | grep '/db/postgresql/data/pg_xlog -> /mnt/pg_xlog'"
end

execute 'add-postgresql-to-default-run-level' do
  command %Q{
    rc-update add postgresql-8.3 default
  }

  not_if 'rc-status | grep postgresql-8.3'
end

execute 'stop-mysql' do
  command %Q{
    /etc/init.d/mysql stop
  }

  not_if "ps ax | grep mysqld | grep -v grep"
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
    su - postgres -c "psql -c \\"ALTER USER #{node[:postgresql][:db_user]} WITH ENCRYPTED PASSWORD '#{node[:postgresql][:db_pass]}'\\""
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