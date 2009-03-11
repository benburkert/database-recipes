#
# Cookbook Name:: postgresql
# Recipe:: default
#
if node[:postgresql][:hard_masked]
  execute "unmask-postgresql" do
    command %Q{
      mkdir -p /etc/portage
      echo "=dev-db/postgresql-#{node[:postgresql][:version]}" >> /etc/portage/package.unmask
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