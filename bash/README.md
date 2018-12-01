# env
A customized bash framework for a productive use of bash.

## Internals
`~/env/` directory contains where this project resides. In order to use it
you need to include the following in your `~/.profile` or `~/.bashrc` files:

```bash
. ~/env/bash/start.sh
```

**You can rename `~/env` to any directory you want**. 

**When passing parameters to library functions make sure that you quote them**. For example
```bash
findFiles `*~`
```
If you pass it without quote, bash will expand *~ and pass the matching files to the function, not the
'*~'.

### Environment variables

* **`ENV_HOME_DIR`**: where this project resides
* **`ENV_DATA_DIR`**: always defined as `~/.envData`
* **`ENV_ARCH`**: either `32` or `64` depending on the architecture of the CPU
* **`ENV_PLATFORM`**: `Mac` or `Linux` or `Cygwin`

### Data directories and files
* `~/.envData/bash`: history file and bashVars.sh file location
* `~/.envData/emacs/backup`: emacs backup files location

### Customizations
Consider looking at the files below for customizations.
```
$ENV_HOME_DIR/bash/aliases.sh
$ENV_HOME_DIR/bash/settings.sh
```

### Local time zone
By default, `settings.sh` will attempt to figure out the local time zone, but if it fails
it will use the default value of `LOCAL_TIME_ZONE` which is `Etc/UTC`.
This value is being used in various locations for display purposes. By default, we set `TZ` to
`Etc/UTC` and prefer to work with UTC mostly. We use the local time zone in certain locations,
such as the bash prompt. `LOCAL_TIME_ZONE` is also used in certain functions due to limitations
of platforms. 

## Important commands

### Aliases

* `lsl`: detailed list of files
* `lsa`: non-detailed list of files
* `sane`: use it when your screen is messed up, can't see what you type
* `largeFiles`: lists the top 15 largest files
* `resetShell`: reread the start.sh, so changes are reflected
* `..`: go one directory up
* `dus`: how much current directory occupies in size
* `duh`: this directory and its direct subdirectories reported
* `paths`: show PATH environment variable as a list of paths
* `localDate`: time and date in local time zone (except on Cygwin and WSL (Linux on Windows))
* `utcDate`: time and date in UTC time zone
* `localTime`: time in local time zone
* `download`: fetch a given url and download it


