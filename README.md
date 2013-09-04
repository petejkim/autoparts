Autoparts - A Package Manager for Nitrous.IO
============================================

#### EXPERIMENTAL - WORK IN PROGRESS

Once Autoparts is stable and throughly tested, it will come preinstalled
on all Nitrous.IO boxes. If you want to help test Autoparts, follow the
instructions below:

### Requirements

* A **"bran"** box. Some packages may not work correctly in **"arya"**
  boxes. All new boxes created should now be **"bran"** boxes.
* Some packages may require 512MB RAM or more.

### Automatic Installtion

Enter the following into your boxes' terminal:

```sh
ruby -e "$(curl -fsSL https://raw.github.com/action-io/autoparts/master/setup.rb)"
```

### Manual Installation

1. Check out Autoparts into `~/.parts/autoparts`

   ```sh
   $ git clone https://github.com/action-io/autoparts.git ~/.parts/autoparts
   ```

2. Add `~/.parts/autoparts/bin` to your `$PATH` for access to the
   `parts` command-line utility.

    **bash:**
    ```sh
    $ echo 'export PATH="$HOME/.parts/autoparts/bin:$PATH"' >> ~/.bash_profile
    ```

    **zsh:**
    ```sh
    $ echo 'export PATH="$HOME/.parts/autoparts/bin:$PATH"' >> ~/.zshrc
    ```

3. Add `parts init` to your shell to load environment variables required
   by Autoparts.

    **bash:**
    ```sh
    $ echo 'eval "$(parts init -)"' >> ~/.bash_profile
    ```

    **zsh:**
    ```sh
    $ echo 'eval "$(parts init -)"' >> ~/.zshrc
    ```

4. Restart your shell to load changes.
    You can now begin using Autoparts.

    ```sh
    $ exec $SHELL -l
    ```

### Usage

See `parts help`.

- - -
Copyright (c) 2013 Irrational Industries Inc.
This software is licensed under the BSD 2-Clause license.
