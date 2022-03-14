[CmdletBinding()]
Param()

$outputFolder = Join-Path -Path $PSScriptRoot -ChildPath "content" -AdditionalChildPath "review"
if (-not( Test-Path -Path $outputFolder )) {
    New-Item -ItemType Directory -Path $outputFolder -Force
}

$seperator = "---"
$imageRoot = "https://sodaguideimg.blob.core.windows.net/content"

$removeChars = @( "'" , '!' , '&' , ',' , '.' , '%' )
$replaceChars = @( ' ' , '_' , '--' , '\' , '/' )

$ratingsSheet = Import-Excel -Path 'C:\Users\NathanStohlmann\OneDrive\Documents\Soda Ratings.xlsx' -WorksheetName Ratings | Sort-Object -Property Date | Where-Object { $_.Date -gt ( Get-Date "12/31/2014" )}

foreach ( $item in $ratingsSheet ) {
    $name = $item.Brand , $item.Flavor -join ' '
    Write-Verbose $name
    $shortName = $name.ToLower()
    foreach ( $char in $removeChars ) {
        $shortName = $shortName.Replace( $char , '' )
    }
    foreach ( $char in $replaceChars ) {
        $shortName = $shortName.Replace( $char , '-' )
    }
    Write-Verbose $shortName

    $fileName = Join-Path -Path $outputFolder -ChildPath "$shortName.md"
    
    $post = @( $seperator )
    $post += 'title: "{0}"' -f $name
    $post += 'date: {0}-{1:d2}-{2:d2}' -f $item.Date.Year,$item.Date.Month,$item.Date.Day
    $post += 'featured: false'
    $post += 'draft: true'
    $post += 'thumbnail: "{1}/review/thumbs/{0}.jpg"' -f $shortName,$imageRoot
    $post += "categories:"
    $post += "- soda"
    $post += "- water"
    $post += "- kombucha"
    $post += "- other"
    $post += "ratings:"

    switch ( $item.Rating ) {
        0 { $rating = "- Pass"}
        1 { $rating = "- Ok" }
        2 { $rating = "- Recommended" }
    }
    $post += $rating

    $post += "tags:"

    switch ( $item.Sweetness ) {
        0 { $tag = "- Not Sweet" }
        1 { $tag = "- Slightly Sweet" }
        2 { $tag = "- Medium Sweet" }
        3 { $tag = "- Quite Sweet" }
        4 { $tag = "- Very Sweet" }
        5 { $tag = "- SUGARBOMB" }
    }
    $post += $tag

    $post += "brands:"
    $post += "- {0}" -f $item.Brand
    $post += $seperator
    $post += ""
    $post += $item.Comment
    $post += ""
    $post += '[Originally posted to Twitter.]({0})' -f $item.Twitter
    $post += ""
    $post += '{{{{< figure src="{0}/review/{1}.jpg" >}}}}' -f $imageRoot,$shortName
    $post += ""

    $post | Out-File -FilePath $fileName -Force
}
