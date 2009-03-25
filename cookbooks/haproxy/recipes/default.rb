#
# Cookbook Name:: haproxy
# Recipe:: default
#

package "haproxy" do
  version "1.3.15.5"
end

template "/etc/haproxy.cfg" do
  owner 'app'
  group 'app'
  mode 0644
  source "haproxy.cfg.erb"
  variables(node[:haproxy])
end

execute 'add-haproxy-to-default-run-level' do
  command %Q{
    rc-update add haproxy default
  }

  not_if 'rc-status | grep haproxy'
end

execute 'ensure-haproxy-is-running' do
  command %Q{
    /etc/init.d/haproxy restart
  }
  not_if "/etc/init.d/haproxy status | grep 'status:  started'"
end

execute 'restart-nginx' do
  command %Q{
    /etc/init.d/nginx restart
  }
end