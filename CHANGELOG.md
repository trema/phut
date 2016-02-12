# Changelog

## develop (unreleased)


## 0.7.7 (2/12/2016)
### New features
* Add Phut::VhostDaemon#reset_stats method.

## 0.7.6 (2/10/2016)
### Changes
* Drop the first line (NXST_FLOW...) of dump-flows output.


## 0.7.5 (12/17/2015)
### Bugs fixed
* [#33](https://github.com/trema/phut/pull/33): Fix dump_flows in OpenFlow 1.3.


## 0.7.4 (11/30/2015)
### Bugs fixed
* Fix NoMethodError.


## 0.7.3 (11/17/2015)
### Changes
* Pio 0.30.0.


## 0.7.2 (11/11/2015)
### Changes
* Pio 0.29.0.


## 0.7.1 (11/5/2015)
### Changes
* Pio 0.28.1.


## 0.7.0 (10/30/2015)
### New features
* [#32](https://github.com/trema/phut/pull/32): Add netns directive.


## 0.6.11 (9/29/2015)
### Changes
* [#30](https://github.com/trema/phut/issues/30): Support apt-installed rubies.


## 0.6.10 (9/16/2015)
### Changes
* Pio 0.27.0.


## 0.6.9 (9/9/2015)
### Changes
* Check the existance of pid, log and socket directory.


## 0.6.8 (9/9/2015)
### Changes
* Raises Phut::vSwitch::AlreadyRunning when phut failed to start vSwitch.


## 0.6.7 (9/9/2015)
### Bugs fixed
* [#27](https://github.com/trema/phut/issues/27): Change the option ordering of sysctl to work with CentOS 6.


## 0.6.6 (8/2/2015)
### Changes
* [#26](https://github.com/trema/phut/pull/26): Update pio and other gems.


## 0.6.5 (6/29/2015)
### Changes
* [#25](https://github.com/trema/phut/pull/25): Update pio and other gems.


## 0.6.4 (6/4/2015)
### Bugs fixed
* [#24](https://github.com/trema/phut/pull/24): vhost should not exit
  if the link to which the vhost is connected is disabled.


## 0.6.3 (6/4/2015)
### Bugs fixed
* [#23](https://github.com/trema/phut/pull/23): Fix vhost restart failure.


## 0.6.2 (6/3/2015)
### Bugs fixed
* Delete a vhost.*.ctl socket file after the vhost process is killed.


## 0.6.1 (6/1/2015)
### Bugs fixed
* Use the default port number (6653) if `port` attribute is not set.


## 0.6.0 (6/1/2015)
### Changes
* [#21](https://github.com/trema/phut/pull/21): Use IANA-assigned port number 6653.
* [#21](https://github.com/trema/phut/pull/21): Add `port` attribute to `vswitch` directive.


## 0.5.0 (4/22/2015)
### Misc
* Pio 0.20.0 (preliminary support of OpenFlow 1.3).


## 0.4.0 (3/19/2015)
### New features
* Add `phut show` command.

### Changes
* [#14](https://github.com/trema/phut/issues/14): Switch port number
  to which a virtual link is attached is implicitly determined by the
  ordering of `link` directives in DSL file.


## 0.3.1 (3/17/2015)
### Bugs fixed
* Set switch's dpid before connecting to a controller.


## 0.3.0 (3/17/2015)
### Changes
* [#20](https://github.com/trema/phut/pull/20): Use apt installed
  version of Open vSwitch.


## 0.2.4 (3/12/2015)
### Misc
* Pio 0.18.2.


## 0.2.3 (3/11/2015)
### New features
* Add `Pio::Configuration#[]`.


## 0.2.2 (3/9/2015)
### New features
* Add `mac` attribute to vhost.


## 0.2.0 (3/2/2015)
### New features
* [#19](https://github.com/trema/phut/pull/19): Add `bin/vhost`.


## 0.1.0 (2/23/2015)
### Misc
* The initial release version of phut.
