name 'apt-cacher-ng'
maintainer 'RightScale, Inc.'
maintainer_email 'premium@rightscale.com'
license 'Apache 2.0'
description 'Installs/Configures apt-cacher-ng'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

depends 'apt'
depends 'marker', '~> 1.0.1'
#depends 'rightscale_tag', '~> 1.0.5'

recipe 'apt-cacher-ng::default', 'Initial apt-cacher-ng'
#recipe 'apt-cacher-ng::volume', 'Creates or restores a volume and attaches it to the server.'
#recipe 'apt-cacher-ng::collectd', 'Setup apt-cacher-ng monitoring'
#recipe 'apt-cacher-ng::tags', 'Setup instance tagging'
#recipe 'apt-cacher-ng::cache_sync', 'Sync cache with the primary cache server'
#recipe 'apt-cacher-ng::enable_scheduled_sync', 'Enable cron job to sync cache data with primary cache server'
#recipe 'apt-cacher-ng::disable_scheduled_sync', 'Disable cron job to sync cache data with primary cache server'
#recipe 'apt-cacher-ng::backup', 'Take a snapshot of the cache volume'
#recipe 'apt-cacher-ng::enable_scheduled_backup', 'Enable cron job to snapshot cache data'
#recipe 'apt-cacher-ng::disable_scheduled_backup', 'Disable cron job to snapshot cache data'
recipe 'apt-cacher-ng::cache_client', 'Configure instance to use apt cache server'
#recipe 'apt-cacher-ng::decommission', 'Cleanup resources on termination'

attribute "apt-cacher-ng/cache/port",
          :display_name => "apt-cacher-ng Port",
          :description => "The port that apt-cacher-ng listens on.  Default: 3142",
          :default => "3142",
          :required => "recommended",
          :recipes => [
            'apt-cacher-ng::default',
            'apt-cacher-ng::cache_client',
            ]

attribute "apt-cacher-ng/cache/server",
          :display_name => "Cache Server",
          :description => "The hostname/ip of the apt-cacher-ng server",
          :required => "required",
          :recipes => [
            'apt-cacher-ng::cache_client',
            'apt-cacher-ng::cache_sync',
          ]

attribute "apt-cacher-ng/cache/cache_dir",
          :display_name => "Cache Directory",
          :description => "The local directory to use to store cache data",
          :default => "/var/cache/apt-cacher-ng/",
          :required => "recommended",
          :recipes => [
            'apt-cacher-ng::volume',
            'apt-cacher-ng::default',
          ]

attribute "apt-cacher-ng/sync/interval",
          :display_name => "Sync Interval",
          :description => "The interval in seconds to sync cache data from the primary cache server.",
          :default => "600",
          :required => "recommended",
          :recipes => [
            'apt-cacher-ng::enable_scheduled_sync',
          ]

attribute "apt-cacher-ng/sync/ssh_key",
          :display_name => "Shared SSH Key",
          :description => 'SSH key used to sync cache data from the primary cache server. Both the primary server' +
                          ' and all secondary servers must have this key to sync cache data propertly.',
          :required => "optional",
          :recipes => [
            'apt-cacher-ng::default'
          ]

attribute "apt-cacher-ng/volume/nickname",
          :display_name => "Volume Nickname",
          :description => 'Nickname for the volume. apt-cacher-ng::volume uses this for the filesystem label, which is' +
                          ' restricted to 12 characters. If longer that 12 characters, the filesystem label will be set' +
                          ' to the first 12 characters. Example: apt_cache',
          :default => 'apt_cache',
          :required => "recommended",
          :recipes => ['apt-cacher-ng::volume']

attribute "apt-cacher-ng/volume/size",
          :display_name => "Volume Size",
          :description => 'Size of the volume or logical volume to create (in GB). This disk must be large enough to hold all' +
                          ' software packages expected to be cached. As an example, to cache an entire Ubuntu distribution' +
                          ' for a single arch type, you will need approximately 15GB of disk space.',
          :default => "15",
          :required => "recommended",
          :recipes => ['apt-cacher-ng::volume']

attribute "apt-cacher-ng/volume/destroy_on_decommission",
          :display_name => "Destroy on Decommission",
          :description => "If set to true, the volumes will be destroyed on decommission.",
          :default => "true",
          :required => "recommended",
          :recipes => ['apt-cacher-ng::decommission']

attribute "apt-cacher-ng/backup/lineage",
          :display_name => 'Backup Lineage',
          :description => 'The prefix that will be used to name/locate the backup of the apt-cache-ng server.',
          :required => 'required',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/backup/schedule/enable",
          :display_name => 'Backup Schedule Enable',
          :description => 'Enable or disable periodic backup schedule',
          :default => 'false',
          :choice => ['true', 'false'],
          :required => 'recommended',
          :recipes => ['apt-cacher-ng::enable_scheduled_backup']

attribute "apt-cacher-ng/backup/schedule/hour",
          :display_name => "Backup Schedule Hour",
          :description => "The hour to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking" +
                          ' backups every hour. Example: 23',
          :required => 'required',
          :recipes => ['apt-cacher-ng::enable_scheduled_backup']

attribute "apt-cacher-ng/backup/schedule/minute",
          :display_name => "Backup Schedule Minute",
          :description => "The minute to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking" +
                          ' backups every hour. Example: 30',
          :required => 'required',
          :recipes => ['apt-cacher-ng::enable_scheduled_backup']
          
attribute "apt-cacher-ng/backup/keep/dailies",
          :display_name => "Backup Keep Dailies",
          :description => "Number of daily backups to keep. Example: 14",
          :default => '14',
          :required => 'optional',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/backup/keep/keep_last",
          :display_name => "Backup Keep Last Snapshots",
          :description => "Number of snapshots to keep. Example: 60",
          :default => '60',
          :required => 'optional',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/backup/keep/monthlies",
          :display_name => 'Backup Keep Monthlies',
          :description => 'Number of monthly backups to keep. Example: 12',
          :default => '12',
          :required => 'optional',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/backup/keep/weeklies",
          :display_name => 'Backup Keep Weeklies',
          :description => 'Number of weekly backups to keep. Example: 6',
          :default => '6',
          :required => 'optional',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/backup/keep/yearlies",
          :display_name => "Backup Keep Yearlies",
          :description => 'Number of yearly backups to keep Example: 2',
          :default => '2',
          :required => 'optional',
          :recipes => ['apt-cacher-ng::backup']

attribute "apt-cacher-ng/restore/lineage",
          :display_name => 'Restore Lineage',
          :description => 'The lineage name to restore backups from. Example: production',
          :required => 'recommended',
          :recipes => ['apt-cacher-ng::volume']

attribute "apt-cacher-ng/restore/timestamp",
          :display_name => 'Restore Timestamp',
          :description => 'The timestamp (in seconds since UNIX epoch) to select a backup to restore from.' +
                          ' The backup selected will have been created on or before this timestamp. Example 1391473172',
          :required => 'recommended',
          :recipes => ['apt-cacher-ng::volume']



