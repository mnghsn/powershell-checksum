#Requires -Version 5.0

<#
.SYNOPSIS
    Computes the hash value for the files by using a specified hash algorithm.

.DESCRIPTION
    This PowerShell script computes the hash value for the files by using a
    specified hash algorithm and outputs the checksum like GNU coreutils.

.PARAMETER Path
    Specifies the path to one or more files as an array.

.PARAMETER Algorithm
    Specifies the cryptographic hash function to use for computing the hash
    value of the contents of the specified file.

.PARAMETER Format
    Specifies the checksum format which the script outputs.

.PARAMETER OutFile
    Specifies the path to the output file.
#>

################################################################################
# Parameters
################################################################################

[CmdletBinding()]

param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path -Path $_ })]
    [Alias('FullName')]
    [String[]]
    $Path,

    [Parameter()]
    [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
    [String]
    $Algorithm = 'SHA256',

    [Parameter()]
    [ValidateSet('Binary', 'Text', 'Tag')]
    [String]
    $Format = 'Binary',

    [Parameter()]
    [ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]
    [String]
    $OutFile
)

################################################################################
# Execution
################################################################################

begin {
    $Algorithm = $Algorithm.ToUpper()

    switch ($Format) {
        'Binary' { $outputFormat = '{0} *{1}' }
        'Text'   { $outputFormat = '{0}  {1}' }
        'Tag'    { $outputFormat = '{2} ({1}) = {0}' }
    }

    if ($OutFile -and (Test-Path -LiteralPath $OutFile -PathType Leaf)) {
        Clear-Content -LiteralPath $OutFile
    }
}

process {
    Get-Item -Path $Path | Where-Object { Test-Path -Path $_ -PathType Leaf } | ForEach-Object {
        $hash = (Get-FileHash -LiteralPath $_ -Algorithm $Algorithm).Hash.ToLower()
        $name = if ($_.DirectoryName -eq (Get-Location).Path) { $_.Name } else { $_.FullName }

        $output = $outputFormat -f $hash, $name, $Algorithm

        if ($OutFile) {
            if ($PSVersionTable.PSVersion.Major -gt 5) {
                $output | Add-Content -LiteralPath $OutFile -Encoding utf8NoBOM
            } else {
                $output = $output | Out-String | ForEach-Object { [System.Text.Encoding]::UTF8.GetBytes($_) }
                $output | Add-Content -LiteralPath $OutFile -Encoding Byte
            }
        } else {
            $output | Write-Output
        }
    }
}
