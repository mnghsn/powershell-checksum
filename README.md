# PowerShell File Checksum Script Set

A PowerShell script set to compute and verify file checksum.

## Features

This script set uses `Get-FileHash` cmdlet to compute the hash value for the files, and outputs the result in GNU coreutils (`md5sum`, `sha1sum`, `sha256sum` and `sha512sum`) format.

## Requirements

- PowerShell 5.0 or PowerShell Core

## Installtion

The scripts are standalone and can run regardless of where the file is located on your machine.

## Usage

```powershell
# Compute the hash value for the files and output to the screen.
# $ sha256sum *.iso
Get-Checksum -Path *.iso -Algorithm SHA256

# Compute the hash value for the files and output to a file.
# $ sha256sum *.iso > SHA256SUMS.txt
Get-Checksum -Path *.iso -Algorithm SHA256 -OutFile SHA256SUMS.txt
```

```powershell
# Verify the hash value from a text file.
# $ sha256sum -c SHA256SUMS.txt
Test-Checksum -Path SHA256SUMS.txt

# Verify the hash value from all matched files.
Get-ChildItem -Path *SUMS.txt | Test-Checksum
```

## Disclaimer

The code within this repository comes with no guarantee. Use at your own risk.

## License

Licensed under the MIT License.
