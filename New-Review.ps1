#requires -modules cf.images

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    [switch]$NoImage
)

# $ErrorActionPreference = "Stop"

$localSettingsPath = Join-Path -Path $PSScriptRoot -ChildPath local.settings.json
$localSettings = Get-Content -Path $localSettingsPath | ConvertFrom-Json -AsHashtable

Set-Location -Path $PSScriptRoot

# Image
if ( -not $NoImage ) {
    # Find the image file
    $imagePath = Join-Path -Path $localSettings.imagePath -ChildPath ( $Name + ".jpg" )
    if ( Test-Path -Path $imagePath ) {
        $imageFile = Get-Item -Path $imagePath
        $paramPath = Join-Path -Path $PSScriptRoot -ChildPath cfParams.xml
        $cfParams = Import-Clixml -Path $paramPath

        $imageList = Get-ImageList @cfParams
        if ( $imageList.filename -contains $imageFile.Name ) {
            Write-Host "Image is already uploaded!"
            $imageInfo = $imageList | Where-Object { $_.filename -eq $imageFile.Name }
        } else {
            Write-Host "Publishing image $imageFile..."
            $imageInfo = ( Publish-Image @cfParams -FilePath $imageFile ).result
        }
    }
    else {
        throw "Unable to locate image! ($imagePath)"
    }
}

# Get Hugo version
$versionRaw = (hugo version).Split(' ')[1]
$versionObj = [version]$versionRaw.Substring(1,$versionRaw.length-1).Split('-').Split('+')[0]
$contentIndex = $versionObj -lt "0.92.0" ? 0 : 1

$rawFile = ( &hugo new "review/$($Name).md" ).Split(' ')[$contentIndex]
Write-Verbose "Raw File: $rawFile"

$reviewFile = $versionObj -lt "0.92.0" ? $rawFile : $rawFile.Replace('"','').Replace('\\','\')
Write-Verbose "Review File: $reviewFile"

if ( $imageInfo ) {
    Write-Host "Updating image url with id: $($imageInfo.id)"
    ( Get-Content -Path $reviewFile | Out-String ) -replace 'image-id-here' , $imageInfo.id | Set-Content -Path $reviewFile
}
&code $reviewFile
