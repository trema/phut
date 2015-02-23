phut
====

[![Build Status](http://img.shields.io/travis/trema/phut/develop.svg?style=flat)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/trema/phut.svg?style=flat)][codeclimate]
[![Coverage Status](http://img.shields.io/codeclimate/coverage/github/trema/phut.svg?style=flat)][coveralls]
[![Dependency Status](http://img.shields.io/gemnasium/trema/phut.svg?style=flat)][gemnasium]
[![Gitter chat](http://img.shields.io/badge/GITTER-phut-blue.svg?style=flat)][gitter]

Virtual network in seconds

[travis]: http://travis-ci.org/trema/phut
[codeclimate]: https://codeclimate.com/github/trema/phut
[coveralls]: https://coveralls.io/r/trema/phut
[gemnasium]: https://gemnasium.com/trema/phut
[gitter]: https://gitter.im/trema/phut


Install
-------

```
$ git clone https://github.com/trema/phut.git
$ cd phut
$ bundle install
```


Play
----

With Phut network DSL, you can describe the network topology in which
your OpenFlow controller is executed.

```ruby
# phut.conf
# One virtual switch + two virtual hosts.
vswitch { dpid 0xabc }
vhost 'host1'
vhost 'host2'
link '0xabc', 'host1'
link '0xabc', 'host2'
```

Then you can pass the network configuration to `phut run`.

```
$ bundle exec phut run phut.conf
```
