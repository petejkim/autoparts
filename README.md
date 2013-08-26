Autoparts - A Package Manager for Nitrous.IO
============================================

## EXPERIMENTAL - WORK IN PROGRESS

### Installation

1. Check out Autoparts into `~/.parts/autoparts`

   ```sh
   $ git clone https://github.com/petejkim/autoparts.git ~/.parts/autoparts
   ```

2. Run `bundle install` in `~/.parts/autoparts`

    ```sh
    $ cd ~/.parts/autoparts
    .parts/autoparts $ bundle install
    ```

3. Add `~/.parts/autoparts/bin` to your `$PATH` for access to the
   `parts` command-line utility.

    **bash:**
    ```sh
    $ echo 'export PATH="$HOME/.parts/autoparts/bin:$PATH"' >> ~/.bashrc
    ```

    **zsh:**
    ```sh
    $ echo 'export PATH="$HOME/.parts/autoparts/bin:$PATH"' >> ~/.zshrc
    ```

4. Add `parts init` to your shell to load environment variables required
   by Autoparts.

    **bash:**
    ```sh
    $ echo 'eval "$(parts init -)"' >> ~/.bashrc
    ```

    **zsh:**
    ```sh
    $ echo 'eval "$(parts init -)"' >> ~/.zshrc
    ```

5. Restart your shell to load changes.
    You can now begin using Autoparts.

    ```sh
    $ exec $SHELL -l
    ```

### TODO

* Install Script
* Dependency Tracking
* Delete package directory if installation fails
* don't move download if sha1 verification fails
* archiving / binary install should only work when autoparts is
  installed in /home/action/.parts/autoparts

Copyright (c) 2013 Irrational Industries Inc.
This software is licensed under the BSD 2-Clause license.
