Autoparts - A Package Manager for Nitrous.IO
============================================

[日本語](https://github.com/action-io/autoparts/blob/master/README.ja.md)

### Requirements

* A **"bran"** box. Some packages may not work correctly in **"arya"**
  boxes. All new boxes created should now be **"bran"** boxes.

  ![Bran
  box](https://raw.github.com/action-io/action-assets/a7d29cbd686f2269ac930c01a8928accd19a0b89/support/screenshots/bran-box.png)

* Some packages may require 512MB RAM or more.

### Installation

Enter the following into your boxes' terminal:

```sh
ruby -e "$(curl -fsSL https://raw.github.com/action-io/autoparts/master/setup.rb)"
exec $SHELL -l
```

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
Copyright (c) 2013 Irrational Industries Inc.
This software is licensed under the BSD 2-Clause license.
