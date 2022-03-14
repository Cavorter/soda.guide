[CmdletBinding()]
Param()

$seperator = '---'
$reviewDir = Join-Path -Path $PSScriptRoot -ChildPath content -AdditionalChildPath review
$reviewFiles = Get-ChildItem -Path $reviewDir\*.md

foreach ( $review in $reviewFiles ) {
    Write-Verbose "Processing $review..."
    $content = $review | Get-Content | Out-String
    if ( $content.Substring(0,3) -eq $seperator ) {
        Write-Verbose "...Has YAML header..."
        ( $content -split $seperator )[1] | ConvertFrom-Yaml | Write-Output
    } else {
        Write-Warning "Unknown header! ($review)"
    }
}
