[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]    
    [ValidateScript( { Test-Path $_ })]
    [string[]]$Path
)

Begin {
    $rootPath = "c:\Users\$env:USERNAME\OneDrive\Pictures\Soda\Processed"
    Write-Verbose "Root: $rootPath"
    $copyright = 'Copyright {0} Nathan Stohlmann, All Rights Reserved' -f ( Get-Date ).Year
    Write-Verbose "Copyright: $copyright"
    $watermark = Join-Path -Path $PSScriptRoot -ChildPath "static" -AdditionalChildPath "logos", "watermark.png"
    Write-Verbose "Watermark File: $watermark"
}

Process {
    foreach ( $file in $Path ) {
        Write-Verbose "Processing file: $file"
        $fileName = Split-Path -Path $file -Leaf
        $destImg = Join-Path -Path $rootPath -ChildPath $fileName
        Write-Verbose "Full Output: $destImg"
        $thumbImg = Join-Path -Path $rootPath -ChildPath thumbs -AdditionalChildPath $fileName
        Write-Verbose "Thumbnail: $thumbImg"

        # Copy source file and embed watermark
        magick.exe $file `( $watermark -resize 20 `) -gravity center -composite $destImg

        # Strip EXIF and add copyright
        exiftool.exe -all= -copyright="$copyright" $destImg

        # Remove exiftool backups
        Remove-Item -Path $rootPath\*.jpg_original -Force

        # Generate thumbnail
        magick.exe $destImg -resize 210x $thumbImg
    }
}