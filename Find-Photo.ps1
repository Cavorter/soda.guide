[CmdletBinding()]
Param(
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path,

    [switch]$Exact
)

$postFile = Get-ChildItem -Path $Path
$postShortName = $postFile.BaseName
Write-Verbose "Short Name: $postShortName"
$postContent = Get-Content -Path $postFile.FullName

$photoDir = Join-Path -Path $env:OneDriveConsumer -ChildPath Pictures -AdditionalChildPath Soda
Write-Verbose "Photo Dir: $photoDir"

$exactMatch = Get-ChildItem -Path "$photoDir\$postShortName.*"
if ( $exactMatch ) {
    $exactMatch | Write-Output
} else  {
    if ( -Not $Exact ) {
        Write-Host "Punting..."
    }
}