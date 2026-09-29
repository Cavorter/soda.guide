[CmdletBinding()]
param()

$localSettingsPath = Join-Path -Path $PSScriptRoot -ChildPath "local.settings.json"
Write-Verbose "Reading settings from $localSettingsPath..."
$result = Get-Content -Path $localSettingsPath | ConvertFrom-Json -AsHashtable

Write-Output $result
