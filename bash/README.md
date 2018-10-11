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
* **`envHasPython`**: either `1` or `0`
* **`envHasJava`**: either `1` or `0`

**When passing parameters to library functions make sure that you quote them**. For example
```bash
findFiles `*~`
```
If you pass it without quote, bash script will first expand *~ and pass that to the function, not the
'*~'.

## Customizations
Consider looking at the files below for customizations.
```
$ENV_HOME_DIR/bash/linux/aliasesForLinux.sh
$ENV_HOME_DIR/bash/mac/aliasesForMac.sh
$ENV_HOME_DIR/bash/aliases.sh
```


