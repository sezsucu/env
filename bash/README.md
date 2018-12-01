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
* `localDate`: time and date in local time zone (except on WSL (Linux on Windows))
* `utcDate`: time and date in UTC time zone
* `localTime`: time in local time zone
* `download`: fetch a given url and download it
* `edel`: to remove emacs *~ files

### crypt.sh

#### To create a private key
```bash
crypt.sh create privateKey.pem
```

#### To extract the public key from the private key
```bash
crypt.sh public privateKey.pem > publicKey.txt
```

#### To encrypt a small size file using the private key
```bash
crypt.sh encrypt privateKey.pem < shortMesg.txt > shortMesg.enc.bin
```

#### To decrypt a small size encrypted file using the private key
```bash
crypt.sh decrypt privateKey.pem < shortMesg.enc.bin > shortMesg.dec.txt
```

#### To encrypt a small size file using the public key
```bash
crypt.sh encrypt publicKey.txt < shortMesg.txt > shortMesg.pub.enc.bin
# You can decrypt this file only with a privateKey
crypt.sh decrypt privateKey.pem < shortMesg.pub.enc.bin > shortMesg.dec.txt
```
You can't encrypt with a private key and decrypt with a public key using crypt.sh

#### Sign a data file with your private key
```bash
crypt.sh sign privateKey.pem < test.txt > signature.file
```

#### Verify a signature of data file with a public key
```bash
crypt.sh verify publicKey.txt signature.file < test.txt
```

#### Add a password to a private key file
```bash
crypt.sh add privateKey.pem > protectedPrivate.pem
```

#### Remove a password from a password protected private key file
```bash
crypt.sh remove protectedPrivate.pem > privateKey.pem
```

#### Generate a secret key
```bash
crypt.sh generate 32 > 32-byte.secretKey.txt
```

#### Encrypt a big message using a secret key
```bash
crypt.sh encrypt secretKey.txt < bigMesg.txt > enc.txt
```

#### Decrypt an encrypted message using a secret key
```bash
crypt.sh decrypt secretKey.txt < enc.txt > bigMesg.txt
```



