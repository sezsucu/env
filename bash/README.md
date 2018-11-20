# env
A customized bash framework for a productive use of bash.

## Internals
`~/env/` directory contains where this project resides. In order to use it
you need to include the following in your `~/.profile` or `~/.bashrc` files:

```bash
. ~/env/bash/start.sh
```

**You can rename `~/env` to any directory you want**. The following are the environment
variables defined from the start script:

* **`ENV_HOME_DIR`**: where this project resides
* **`ENV_DATA_DIR`**: always defined as `~/.envData`
* **`ENV_ARCH`**: either `32` or `64` depending on the architecture of the CPU
* **`ENV_PLATFORM`**: either `Mac` or `Linux`

**When passing parameters to library functions make sure that you quote them**. For example
```bash
findFiles `*~`
```
If you pass it without quote, bash will expand *~ and pass the matching files to the function, not the
'*~'.

## Customizations
Consider looking at the files below for customizations.
```
$ENV_HOME_DIR/bash/support/aliasesForLinux.sh
$ENV_HOME_DIR/bash/support/aliasesForMac.sh
$ENV_HOME_DIR/bash/aliases.sh
$ENV_HOME_DIR/bash/settings.sh
```

### Local time zone
By default, `start.sh` will attempt to figure out the local time zone, but if it fails
it will use the `LOCAL_TIME_ZONE` located in `settings.sh`. By default this value is `Etc/UTC`.
This value is being used in various locations for display purposes. By default, we set `TZ` to
`Etc/UTC` and prefer to work with UTC mostly. We use the local time zone in certain locations,
such as the bash prompt. `LOCAL_TIME_ZONE` is also used in certain functions due to limitations
of platforms. 

## Important commands

###


