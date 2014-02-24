# Contributing to Autoparts

### Getting Started

Before building a new part ensure you have updated the repo. Run `parts update` within your Nitrous box in order to do this.

### Package Guidelines

Autoparts packages are located in `lib/autoparts/packages`. Please follow the [Ruby Styleguide](https://github.com/styleguide/ruby) when building a part.

In order to create a new package you will need to provide the following information when creating a pull request:

* Package Name
* Version
* Description
* Source URL (official release source which package will always be located at)
* Filetype (the extension of the file)
* SHA-1 hash (hash should be available on same page as package. If not you can [generate](http://hash.online-convert.com/sha1-generator) a SHA-1 hash with the source file)
* Dependencies (if any)
* Compile / Installation commands
* (Optional) Start/Stop commands. This is needed only if building a part for a database or another tool that runs as a service.

There are a few requirements if the part requires additional configurations:

* Post-installation setup tasks (e.g. creating conf file, generating empty database file) should be done in `post_install` method.
* Configuration files should be placed in `Path.etc` (e.g. `~/.parts/etc`) or `Path.etc + name` (e.g. `~/.parts/etc/postgresql`).
* Data files (e.g. database files) should be placed in `Path.var + name` (e.g. `~/.parts/var/postgresql`).
* Log files should be placed in `Path.var + 'log' + "#{name}.log"` (e.g. `~/.parts/var/log/postgresql.log`).

### Building a New Part

Take a look at [docs/example-part.rb](https://github.com/nitrous-io/autoparts/tree/master/docs/example-part.rb) for details on how a package is built.

Once you have finished building a part, create a pull request with a [descriptive commit message](http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message). We will quickly review the part to be merged.