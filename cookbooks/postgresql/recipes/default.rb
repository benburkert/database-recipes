#
# Cookbook Name:: postgresql
# Recipe:: default
#

package "postgresql" do
  version "8.3.1"
  action :install
end

directory "/db/postgresql/data" do
  owner "postgresql"
  group "postgresql"
  mode 0755
  recursive true
end