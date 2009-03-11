#
# Cookbook Name:: postgresql
# Recipe:: default
#
if postgresql[:hard_masked]
  execute "unmask-postgresql" do
    command %Q{
      mkdir -p /etc/portage
      echo "=dev-db/postgresql-#{postgresql[:version]}" >> /etc/portage/package.unmask
    }
  end
end

package "postgresql" do
  version postgresql[:version]
  action :install
end

directory "/db/postgresql/data" do
  owner "postgresql"
  group "postgresql"
  mode 0755
  recursive true
end