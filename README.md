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

# Attributes

- `node[apt-cacher-ng][cache][cache_dir]` - The local directory to use to store cache data
- `node[apt-cacher-ng][cache][port]` - The port that apt-cacher-ng listens on.  Default: 3142
- `node[apt-cacher-ng][cache][server]` - The hostname/ip of the apt-cacher-ng server

# Recipes

## `apt-cacher-ng::default`

Installs and configures the apt-cache-ng package to be a cache server and configures apt to proxy through the apt-cacher-ng cache.
This recipe should be placed at the top of the runlist to avoid issues where apt-update gets run before the proxy is configured.

## `apt-cacher-ng::cache_client`

Configures apt to proxy through the apt-cacher-ng cache. This recipe must be placed at the top of the runlist to avoid issues where
apt-update gets run before the proxy is configured.