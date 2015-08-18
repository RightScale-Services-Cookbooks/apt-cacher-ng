#
# Cookbook Name:: rsc_apt-cacher-ng
# Recipe:: enable_scheduled_backups
#
# Copyright (C) 2015 RightScale, Inc.
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

marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end

schedule_hour = node['apt-cacher-ng']['backup']['schedule']['hour']
schedule_minute = node['apt-cacher-ng']['backup']['schedule']['minute']
lineage = node['apt-cacher-ng']['backup']['lineage']

# Both schedule hour and minute should be set
unless schedule_hour && schedule_minute
  raise 'apt-cacher-ng/backup/schedule/hour and apt-cacher-ng/backup/schedule/minute inputs should be set'
end

# Adds or removes the crontab entry for backup schedule based on rs-mysql/schedule/enable
cron "backup_schedule_#{lineage}" do
  minute schedule_minute
  hour schedule_hour
  command "rs_run_recipe --policy 'apt-cacher-ng::backup' --name 'apt-cacher-ng::backup'"
  action :create
end
