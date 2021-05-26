$reviewList = Get-ChildItem -Path $PSScriptRoot\content\review\*.md

foreach ( $item in $reviewList ) {
    $match = &$PSScriptRoot\Find-Photo.ps1 -Path $item.FullName -Exact
    if ( $match ) {
        $processPath = Join-Path -Path $match.Directory.FullName -ChildPath Processed -AdditionalChildPath $match.Name
        if ( -not ( Test-Path -Path $processPath )) {
            &$PSScriptRoot\Process-Image.ps1 -Path $match
        }
    }
}