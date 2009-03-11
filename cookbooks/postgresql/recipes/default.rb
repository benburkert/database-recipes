#
# Cookbook Name:: postgresql
# Recipe:: default
#
if node[:postgresql][:hard_masked]
  execute "unmask-postgresql" do
    command %Q{
      echo "=dev-db/libpq-#{node[:postgresql][:version]}" >> /etc/portage/package.unmask
      echo "=dev-db/postgresql-#{node[:postgresql][:version]}" >> /etc/portage/package.unmask
    }

    command %Q{
      echo "=dev-db/libpq-#{node[:postgresql][:version]} ~amd64" >> /etc/portage/package.keywords/ec2
      echo "=dev-db/postgresql-#{node[:postgresql][:version]} ~amd64" >> /etc/portage/package.keywords/ec2
    }
  end
end

package "postgresql" do
  version node[:postgresql][:version]
  action :install
end

directory "/db/postgresql/data" do
  owner "postgresql"
  group "postgresql"
  mode 0755
  recursive true
end