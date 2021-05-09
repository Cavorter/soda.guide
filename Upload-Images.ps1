[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string[]]$Name,

    [ValidateScript( { Test-Path -Path $_ })]
    [string]$RootPath = "C:\Users\$env:USERNAME\OneDrive\Pictures\soda\processed"
)

Begin {
    $ErrorActionPreference = "Stop"

    $context = ( Get-AzStorageAccount -ResourceGroupName soda-guide -Name sodaguideimg ).Context
    $fileName = "$Name.jpg"
    $imgName = Join-Path -Path $RootPath -ChildPath $fileName
    $tmbName = Join-Path -Path $RootPath -ChildPath thumbs -AdditionalChildPath $fileName
}

Process {
    foreach ( $item in @( $imgName , $tmbName ) ) {
        Write-Verbose "Processing file $item..."

        if ( Test-Path -Path $item ) {
            $blobName = "review" + ( $item.Replace( $RootPath , '' ).Replace('\', '/').Replace( ' ', '-' ).Replace('_', '-').Tolower() )
            Set-AzStorageBlobContent -Context $context -File $item -Container "content" -Blob $blobName -Force
        }
        else {
            throw "Unable to locate $item!"
        }
    }
}