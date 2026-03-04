Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'


$PrivatePath = Join-Path $PSScriptRoot "Private"
$PublicPath = Join-Path $PSScriptRoot "Public"


# Load the private functions
if (Test-Path $PrivatePath) {
    Get-ChildItem -Path $PrivatePath -Filter *.ps1 -File | ForEach-Object {
        . $_.FullName
    }
}

# Load the public functions
if (Test-Path $PublicPath) {
    Get-ChildItem -Path $PublicPath -Filter *.ps1 -File | ForEach-Object {
        . $_.FullName
    }
}

# Export all functions found in Public folder
Export-ModuleMember -Function (
    Get-ChildItem $PublicPath -Filter *.ps1 | ForEach-Object { $_.BaseName }
)
