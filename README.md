Box Parts - A Simple Package Manager
====================================

Box Parts is a simple package manager. It provides a simple command line for installing a selection of curated binaries. This means installing a package is extremely fast.

Box Parts is used by [Codio](https://codio.com) to provide user-installed binary packages for every Codio project.


### Installation

Every Codio Box comes pre-installed with Box Parts. Just open up the terminal and access it via the `parts` command.


### Usage

See `parts help`.


### Package Guidelines

* Post-installation setup tasks (e.g. creating conf file, generating
  empty database file) should be done in `post_install` method.
* Configuration files should be placed in `Path.etc` (e.g. `~/.parts/etc`) or
  `Path.etc + name` (e.g. `~/.parts/etc/postgresql`).
* Data files (e.g. database files) should be placed in `Path.var + name`
  (e.g. `~/.parts/var/postgresql`).
* Log files should be placed in `Path.var + 'log' + "#{name}.log"` (e.g.
  `~/.parts/var/log/postgresql.log`).

- - -
Copyright (c) 2013-2014 Application Craft Ltd. http://codio.com
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/codio/boxparts/master/LICENSE).

Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).
