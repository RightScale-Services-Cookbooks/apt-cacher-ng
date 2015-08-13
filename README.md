# apt-cacher-ng

[![Release](https://img.shields.io/github/release/RightScale-Services-Cookbooks/rsc_apt-cacher-ng.svg?style=flat)][release]
[![Build Status](https://travis-ci.org/RightScale-Services-Cookbooks/rsc_apt-cacher-ng.svg?style=flat)][travis]
[travis]: https://travis-ci.org/RightScale-Services-Cookbooks/rsc_apt-cacher-ng
[release]: https://github.com/RightScale-Services-Cookbooks/rsc_apt-cacher-ng/releases/latest

Provides recipes for managing an Apt Cacher NG server with RightScale.

Github Repository: [https://github.com/RightScale-Services-Cookbooks/rsc_apt-cacher-ng](https://github.com/RightScale-Services-Cookbooks/rsc_apt-cacher-ng)

# Requirements
* Requires Chef 11 or higher
* Requires Ruby 1.9 of higher
* Platform
  * Ubuntu 12.04
  * Ubuntu 14.04  
* Cookbooks
  * [marker](http://community.opscode.com/cookbooks/marker)
  * [apt](https://communicty.opscode.com/cookbooks/apt)
  * [rightscale_tag](http://community.opscode.com/cookbooks/rightscale_tag)

See the `Bersfile` and `metadata.rb` for up to date dependency information.

# Usage

## Create an apt-cacher-ng server

To setup an apt-cacher-ng server, place the `apt-cacher-ng::default` recipe at the front of the runlist with the following attribute set:

- `node[apt-cacher-ng][cache][cache_dir]` - The local directory to use to store cache data
- `node[apt-cacher-ng][cache][port]` - The port that apt-cacher-ng listens on.  Default: 3142

## Configure an apt-cacher-ng client

To setup an apt-cacher-ng client, place the `apt-cacher-ng::cache_client` recipe at the front of the runlist with the following attribute set:

- `node[apt-cacher-ng][cache][port]` - The port that apt-cacher-ng listens on.  Default: 3142
- `node[apt-cacher-ng][cache][server]` - The hostname/ip of the apt-cacher-ng server

## Create or restore an EBS volume for the apt-cacher-ng server

To create an EBS volume to the apt-cache-ng server, place the `apt-cacher-ng::volume` recipe above the `apt-cache-ng::default` recipe in the runlist, with the following attribute set:

- `node[apt-cacher-ng][device][nickname]` - Nickname for the volume. apt-cacher-ng::volume uses this for the filesystem label, which is restricted to 12 characters. If longer that 12 characters, the filesystem label will be set to the first 12 characters. Example: apt_cache
- `node[apt-cacher-ng][device][volume_size]` - Size of the volume or logical volume to create (in GB). This disk must be large enough to hold all software packages expected to be cached. As an example, to cache an entire Ubuntu distribution for a single arch type, you will need approximately 15GB of disk space.
- `node[apt-cacher-ng][device][mount_point]` - The mount point to mount the device on. Example: /mnt/storage. 
- `node[apt-cacher-ng][backup][lineage]` - The prefix that will be used to name/locate the backup of the apt-cache-ng server.

To restore a volume to the apt-cache-ng server, place the `apt-cacher-ng::volume` recipe above the `apt-cache-ng::default` recipe in the runlist, with the same attributres used to create the volume in addition to the following attribute set:

- `node[apt-cache-ng][restore][lineage]` - The lineage name to restore backups from. Should match the backup lineage that the backup was taking from.
- `node[apt-cache-ng][restore][timestamp]` - The timestamp (in seconds since UNIX epoch) to select a backup to restore from.
- - The backup selected will have been created on or before this timestamp. Example 1391473172

### Destroy volume on decommission

To destroy the volume on decommission, place the `apt-cacher-ng::decommission` recipe to the decommission runlist, with the following attribute set:

- node[apt-cache-ng][device][destroy_on_decommission]` - If set to true, the volumes will be destroyed on decommission.

## Backup an apt-cacher-ng server

To backup an apt-cacher-ng server, run the `apt-cacher-ng::backup` recipe with the following attribute set:

- `node[apt-cacher-ng][backup][lineage]` - The prefix that will be used to name/locate the backup of the apt-cache-ng server.
- `node[apt-cacher-ng][backup][keep][dailies]` - Number of daily backups to keep. Example: 14
- `node[apt-cacher-ng][backup][keep][keep_last]` - Number of backups to keep. Example: 60
- `node[apt-cacher-ng][backup][keep][monthlies]` - Number of monthly backups to keep. Example: 12
- `node[apt-cacher-ng][backup][keep][weeklies]` - Number of weekly backups to keep. Example: 6
- `node[apt-cacher-ng][backup][keep][yearly]` - Number of yearly backups to keep. Example: 2

### Enable backups

To enable scheduled backups, run the `apt-cacher-ng::enable_scheduled_backups` recipe with the following attribute set:

- node[apt-cache-ng][backup][schedule][minute]` - The minute to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking backups every minute. Example 30
- node[apt-cache-ng][backup][schedule][hour]` - The hour to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking backups every hour. Example: 23

### Disable backups

To disable scheduled backups, run the `apt-cacher-ng::disable_scheduled_backups` recipe.

# Attributes

- `node[apt-cacher-ng][cache][cache_dir]` - The local directory to use to store cache data
- `node[apt-cacher-ng][cache][port]` - The port that apt-cacher-ng listens on.  Default: 3142
- `node[apt-cacher-ng][cache][server]` - The hostname/ip of the apt-cacher-ng server
- `node[apt-cacher-ng][sync][interval]` - NOT IMPLEMENTED
- `node[apt-cacher-ng][sync][ssh_key]` - NOT IMPLEMENTED
- `node[apt-cacher-ng][device][nickname]` - Nickname for the volume. apt-cacher-ng::volume uses this for the filesystem label, which is  restricted to 12 characters. If longer that 12 characters, the filesystem label will be set to the first 12 characters. Example: apt_cache
- `node[apt-cacher-ng][device][volume_size]` - Size of the volume or logical volume to create (in GB). This disk must be large enough to hold all software packages expected to be cached. As an example, to cache an entire Ubuntu distribution for a single arch type, you will need approximately 15GB of disk space.
- `node[apt-cacher-ng][device][destroy_on_decommission]` - If set to true, the volumes will be destroyed on decommission.
- `node[apt-cacher-ng][device][mount_point]` - The mount point to mount the device on. Example: /mnt/storage
- `node[apt-cacher-ng][backup][lineage]` - The prefix that will be used to name/locate the backup of the apt-cache-ng server.
- `node[apt-cacher-ng][backup][schedule][hour]` - The hour to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking backups every hour. Example: 23
- `node[apt-cacher-ng][backup][schedule][minute]` - The minute to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking backups every minute. Example: 30
- `node[apt-cacher-ng][backup][keep][dailies]` - Number of daily backups to keep. Example: 14
- `node[apt-cacher-ng][backup][keep][keep_last]` - Number of backups to keep. Example: 14
- `node[apt-cacher-ng][backup][keep][monthlies]` - Number of monthly backups to keep. Example: 14
- `node[apt-cacher-ng][backup][keep][weeklies]` - Number of weekly backups to keep. Example: 14
- `node[apt-cacher-ng][backup][keep][yearlies]` - Number of yearly backups to keep. Example: 14
- `node[apt-cacher-ng][restore][lineage]` - The lineage name to restore backups from. Example: production
- `node[apt-cacher-ng][restore][timestamp]` - The timestamp (in seconds since UNIX epoch) to select a backup to restore from. The backup selected will have been created on or before this timestamp. Example 1391473172

# Recipes

## `apt-cacher-ng::default`

Installs and configures the apt-cache-ng package to be a cache server and configures apt to proxy through the apt-cacher-ng cache.
This recipe should be placed at the top of the runlist to avoid issues where apt-update gets run before the proxy is configured.

## `apt-cacher-ng::cache_client`

Configures apt to proxy through the apt-cacher-ng cache. This recipe must be placed at the top of the runlist to avoid issues where
apt-update gets run before the proxy is configured.

## `apt-cacher-ng::volume`

Creates or restores a volume and attaches it to the server.

## `apt-cacher-ng::backup`

Take a snapshot of the cache volume

## `apt-cacher-ng::enable_scheduled_backups`

Enable cron job to snapshot cache data

## `apt-cacher-ng::disable_scheduled_backups`

Disable cron job to snapshot cache data

## `apt-cacher-ng::decommission`

Cleanup resources on termination
