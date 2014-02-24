# Autoparts
*A Package Manager for Nitrous.IO*

### Installation

Autoparts can be found in all Nitrous boxes within the directory `~/.parts/Autoparts`, 
and can be utilized with the `parts` command.

If it is not installed (or has been removed), run the following commands into the console:

```sh
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
exec $SHELL -l
```

### Requirements

* Some packages may require 512MB RAM or more.
### Getting Started

### Usage

In this doc we will refer to installable packages as "parts". You can view all the parts 
which Autoparts supports by running the following command:

    $ parts search

Autoparts will automatically update upon boot, but if needed you can manually update the repo 
if you are not seeing the latest updates:

    $ parts update

To install a part (or update an existing part), utilize the install command. For example, to 
install PostgresQL you will need to run the following command:

    $ parts install postgresql

Certain parts such as databases will need to be started in order to utilize. Some box templates will 
start a database upon boot, but if not you can start/stop it manually.

    $ parts start postgresql 
    $ parts stop postgresql

For a full list of commands, run `parts help`.

### Contributing

View [contributing.md](https://github.com/nitrous-io/autoparts/tree/master/docs/contributing.md) for documentation on this.

### Additional Languages

[日本語](https://github.com/action-io/autoparts/blob/master/README.ja.md)

- - -
Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).
