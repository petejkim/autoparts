# Autoparts
*A Package Manager for Nitrous.IO*

### Installation

Autoparts can be found in all Nitrous boxes within the directory `~/.parts/autoparts`,
and can be utilized with the `parts` command.

If it is not installed (or has been removed), run the following commands in the console:

```sh
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
exec $SHELL -l
```

### Requirements

* Some packages may require 512MB RAM or more.

### Usage

In this doc we will refer to installable packages as "parts". You can view all the parts
which Autoparts supports by running the following command:

    $ parts search

Autoparts will automatically update when a box is started, but if needed you can manually
update the repo if you are not seeing the latest updates:

    $ parts update

To install a part (or update an existing part), utilize the install command. For example, to
install PostgreSQL you will need to run the following command:

    $ parts install postgresql

Certain parts such as databases will need to be started in order to be utilized. Some box templates will
start a database upon boot, but if not you can start/stop it manually.

    $ parts start postgresql
    $ parts stop postgresql

For a full list of commands, run `parts help`.

### Developing on Nitrous.IO

Start hacking on this package manager on
[Nitrous.IO](https://www.nitrous.io/?utm_source=github.com&utm_campaign=Autoparts&utm_medium=hackonnitrous)
in seconds:

[![Hack nitrous-io/autoparts on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-l-v1-3cc067e71372f6045e1949af9d96095b.png)](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=nitrous-io%2Fautoparts&file_to_open=docs%2Fcontributing.md)

### Contributing

View [contributing.md](https://github.com/nitrous-io/autoparts/tree/master/docs/contributing.md) for full documentation.

### Additional Languages

[日本語](https://github.com/action-io/autoparts/blob/master/README.ja.md)

- - -
Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).
