#
# Cookbook Name:: rsc_apt-cacher-ng
# Recipe:: backup
#
# Copyright (C) 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

include_recipe 'chef_handler::default'

# Create the backup error handler
cookbook_file "#{node['chef_handler']['handler_path']}/apt-cacher-ng_backup.rb" do
  source 'backup_error_handler.rb'
  action :create
end

# Enable the backup error handler so the filesystem is unfrozen in case of a backup failure
chef_handler 'Rightscale::BackupErrorHandler' do
  source "#{node['chef_handler']['handler_path']}/apt-cacher-ng_backup.rb"
  action :enable
end

device_nickname = node['apt-cacher-ng']['device']['nickname']

log "Freezing the filesystem mounted on #{node['apt-cacher-ng']['device']['mount_point']}"

filesystem "freeze #{device_nickname}" do
  label device_nickname
  mount node['apt-cacher-ng']['device']['mount_point']
  action :freeze
end

log "Taking a backup of lineage '#{node['apt-cacher-ng']['backup']['lineage']}'"

rightscale_backup device_nickname do
  lineage node['apt-cacher-ng']['backup']['lineage']
  action :create
end

log "Unfreezing the filesystem mounted on #{node['apt-cacher-ng']['device']['mount_point']}"

filesystem "unfreeze #{device_nickname}" do
  label device_nickname
  mount node['apt-cacher-ng']['device']['mount_point']
  action :unfreeze
end

log 'Cleaning up old snapshots'

rightscale_backup device_nickname do
  lineage node['apt-cacher-ng']['backup']['lineage']
  keep_last node['apt-cacher-ng']['backup']['keep']['keep_last'].to_i
  dailies node['apt-cacher-ng']['backup']['keep']['dailies'].to_i
  weeklies node['apt-cacher-ng']['backup']['keep']['weeklies'].to_i
  monthlies node['apt-cacher-ng']['backup']['keep']['monthlies'].to_i
  yearlies node['apt-cacher-ng']['backup']['keep']['yearlies'].to_i
  action :cleanup
end
