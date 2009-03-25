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

execute 'change-nginx-upstream-port' do
  command do
    File.open("/etc/nginx/servers/#{node[:haproxy][:application]}.conf", 'r+') do |f|
      lines = f.read
      lines.gsub!(/server 127.0.0.1:#{node[:haproxy][:ports].first}/, "server 127.0.0.1:#{node[:haproxy][:upstream_port]}")
      node[:haproxy][:ports].each do |port|
        lines.gsub!(/server 127.0.0.1:#{port}/, '')
      end
      f.rewind
      f.write(lines)
      f.flush
    end
  end

  not_if "grep 'server 127.0.0.1:#{node[:haproxy][:upstream_port]}' < /etc/nginx/servers/#{node[:haproxy][:application]}.conf"
end

execute 'restart-nginx' do
  command %Q{
    /etc/init.d/nginx restart
  }
end