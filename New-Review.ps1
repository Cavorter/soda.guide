#requires -modules cf.images

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    [switch]$NoImage
)

$ErrorActionPreference = "Stop"

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

$reviewFile = ( &hugo new "review/$($Name).md" ).Split(' ')[0]

if ( $imageInfo ) {
    Write-Host "Updating image url with id: $($imageInfo.id)"
    ( Get-Content -Path $reviewFile -Raw ) -replace 'image-id-here' , $imageInfo.id | Set-Content -Path $reviewFile
}
&code $reviewFile