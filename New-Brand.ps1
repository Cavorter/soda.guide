[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Name
)

$localSettingsPath = Join-Path -Path $PSScriptRoot -ChildPath local.settings.json

Set-Location -Path $PSScriptRoot

# Get Hugo version
$versionRaw = (hugo version).Split(' ')[1]
$versionObj = [version]$versionRaw.Substring(1,$versionRaw.length-1).Split('-').Split('+')[0]
$contentIndex = $versionObj -lt "0.92.0" ? 0 : 1

$result = &hugo new "brands/$($Name)/_index.md"
if ( $LASTEXITCODE -eq 0 ) {
    $rawFile = $result.Split(' ')[$contentIndex]
    Write-Verbose "Raw File: $rawFile"

    $brandFile = $versionObj -lt "0.92.0" ? $rawFile : $rawFile.Replace('"', '').Replace('\\', '\')
    Write-Verbose "Brand File: $brandFile"

    &code $brandFile
}