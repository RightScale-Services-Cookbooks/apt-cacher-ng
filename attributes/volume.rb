#
# Cookbook Name:: rsc_apt-cacher-ng
# Attribute:: volume
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

# The hour for the backup schedule
default['apt-cacher-ng']['schedule']['hour'] = nil

# The minute for the backup schedule
default['apt-cacher-ng']['schedule']['minute'] = nil

# The mount point where the device will be mounted
default['apt-cacher-ng']['device']['mount_point'] = '/mnt/storage'

# Nickname for the device
default['apt-cacher-ng']['device']['nickname'] = 'data_storage'

# Size of the volume to be created
default['apt-cacher-ng']['device']['volume_size'] = 10

# I/O Operations Per Second value
default['apt-cacher-ng']['device']['iops'] = nil

# Volume type
default['apt-cacher-ng']['device']['volume_type'] = nil

# Controller type
default['apt-cacher-ng']['device']['controller_type'] = nil

# The filesystem to be used on the device
default['apt-cacher-ng']['device']['filesystem'] = 'ext4'

# Amount of time (in seconds) to wait for a volume to detach at decommission
default['apt-cacher-ng']['device']['detach_timeout'] = 300

# Whether to destroy volume(s) on decommission
default['apt-cacher-ng']['device']['destroy_on_decommission'] = false

# The additional options/flags to use for the `mkfs` command. If the whole device is formatted, the force (-F) flag
# can be used (on ext4 filesystem) to force the operation. This flag may vary based on the filesystem type.
default['apt-cacher-ng']['device']['mkfs_options'] = '-F'

# Backup lineage
default['apt-cacher-ng']['backup']['lineage'] = nil

# Restore lineage
default['apt-cacher-ng']['restore']['lineage'] = nil

# The timestamp to restore backup from a backup taken on or before the timestamp in the same lineage
default['apt-cacher-ng']['restore']['timestamp'] = nil

# Maximum backups to keep
default['apt-cacher-ng']['backup']['keep']['keep_last'] = 60

# Daily backups to keep
default['apt-cacher-ng']['backup']['keep']['dailies'] = 14

# Weekly backups to keep (Keep weekly backups for 1.5 months)
default['apt-cacher-ng']['backup']['keep']['weeklies'] = 6

# Monthly backups to keep
default['apt-cacher-ng']['backup']['keep']['monthlies'] = 12

# Yearly backups to keep
default['apt-cacher-ng']['backup']['keep']['yearlies'] = 2
