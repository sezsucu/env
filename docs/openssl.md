## Goals of Cryptography
* Confidentiality (secrecy): You can't understand or see what the data is
* Integrity (anti-tampering): The data can not be modified in mid-way, you receive the original data and nothing else
* Authentication
* Non-repudiation: The message comes from the person who claims to be that person

## Attacks
* Snooping (passive easvesdropping): watchin network traffic
* Tampering: changes data in transit
* Spoofing: forges network data, appearing to come from a different address
* Hijacking: Once a real user is authenticated, the connection is hijacked
* Capture-replay: Attacker records and replays network transactions for malicious purposes

## Algorithms
* Symmetric key encryption: using a single key
** 3DES is the most conservative one, but AES is going to replace it, RC4 is also widely used
** 80-bit keys are recommended, but 64-bit keys may be good for now
** AES supports 128-bit and higher, whereas 3DES has 112 bits of effective security

## Examples

* Create digest
```bash
openssl sha1 file.input
# same as above
openssl dgst -sha1 file.txt

openssl sha1 -out digest.txt file.txt
# same as above
openssl dgst -sha1 -out digest.out file.txt
```

* Create sha1 digest and sign it with a key
```bash
openssl dgst -dss1 -sign privateKey.pem -out signedHash.bin file.txt
# verify the signedHash.bin using the privateKey file
openssl dgst -dss1 -prverify privateKey.pem -signature signedHash.bin file.txt
# extract the public key first
openssl rsa -in privateKey.pem -pubout -out public.key
# using the public key
openssl dgst -dss1 -verify public.key -signature dsasign.bin file.txt

# for sha1
openssl sha1 -sign privateKey.pem -out signedHash.bin file.txt
openssl rsa -in privateKey.pem -pubout -out public.key
openssl sha1 -verify public.key -signature signedHash.bin file.txt
```

### security.sh

* To encrypt any size file
```bash
# it will ask a new password for you to enter
crypt.sh enc < input.file > output.file
```

* To decrypt an encrypted file
```bash
# it will ask the password you used to encrypt the output.file
crypt.sh dec < output.file > input.file
```

* To generate a 32-byte key to be used for encryption
```bash
crypt.sh gen 32 > key.txt
```

* To create a private/public key pair (4096-bit)
```bash
crypt.sh create mykey.pem
```

* To extract the public key from a private key
```bash
crypt.sh public mykey.pem > public.key
```

* To protect a private key with a password
```bash
crypt.sh add mykey.pem > password.protecte.mykey.pem
```

* To remove a password from a password protected private key
```bash
crypt.sh remove password.protecte.mykey.pem > mykey.pem
```

* To sign data with your private key
```bash
crypt.sh sign mykey.pem < input.file > signature.file
```

* To verify a signature file with your public key
```bash
crypt.sh verify public.key signature.file < input.file
```




