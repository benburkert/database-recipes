#
# Cookbook Name:: postgresql
# Recipe:: server
#

package "postgresql" do
  version "0.8.3"
  action :install
end

directory "/db/postgresql/data" do
  owner "postgresql"
  group "postgresql"
  mode 0755
  recursive true
end