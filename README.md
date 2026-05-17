# Rationale

The `gpg` program is horrible.  This project aims to wrap some key features
with functions and scripts with sensible names and legible documentation.

To start, I want to facilitate managing keys for checking email signatures,
especially email from OS developers and maintainers.


# Instructions


## Add a Script

Choose a name.  Use that name in place of `script`, as follows.

Copy `bin/template` to `bin/name`.  Follow the instructions in the comments.
Remove those comments from your script and add your own.


## Add a Library

Choose a name.  Use that name in place of `lib`, as follows.

Write a new file at `lib/lib.sh`.  The file should consist only of function
definitions.  Define corresponding variables in `conf/lib.sh`.  There must be a
configuration file with the same name as every library file, even if it is
empty.


# TO DO:

* Libraries should depend on one another.
* Each library should indicate when it has been loaded.
* Library loading code should refrain from double-loading libraries.
