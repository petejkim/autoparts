Autoparts - A Package Manager for Nitrous.IO
============================================

#### EXPERIMENTAL - WORK IN PROGRESS

Once Autoparts is stable and throughly tested, it will come preinstalled
on all Nitrous.IO boxes. If you want to help test Autoparts, follow the
instructions below:

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

- - -
Copyright (c) 2013 Irrational Industries Inc.
This software is licensed under the BSD 2-Clause license.
