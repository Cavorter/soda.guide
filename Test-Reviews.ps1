BeforeDiscovery {
    $reviewDir = Join-Path -Path $PSScriptRoot -ChildPath content -AdditionalChildPath review
    $reviewFiles = Get-ChildItem -Path $reviewDir\*.md

    # $reviewFiles = $reviewFiles[0..4]
}

Describe "Review - <_>" -ForEach $reviewFiles {
    BeforeDiscovery {
        $seperator = '---'
        $notYaml = ( $_ | Get-Content | Out-String ).Substring(0, 3) -ne $seperator

        $requiredFields = @(
            "title"
            "date"
            "categories"
            "tags"
            "brands"
        )
    }

    BeforeAll {
        $content = $_ | Get-Content | Out-String

        $seperator = '---'
        $parts = $content -split $seperator
        $frontMatter = $parts[1] | ConvertFrom-Yaml -ErrorAction SilentlyContinue
        $review = $parts[2]
    }

    It "Has required field <_>" -TestCases $requiredFields -Skip:( $notYaml ) {
        $frontMatter."$_" | Should -Not -BeNullOrEmpty
    }

    It "Has only one or zero ratings" -Skip:( $notYaml ) {
        if ( $frontMatter.ratings ) {
            $frontMatter.ratings.Count | Should -Be 1
        }
    }

    It "Has only one category" -Skip:( $notYaml ) {
        $frontMatter.categories.Count | Should -Be 1
    }

    It "Has up to one sweetness tag" -Skip:( $notYaml ) {
        $frontMatter.tags.Where({ $_ -like "* Sweet" }).Count | Should -BeLessThan 2
    }

    It "Has the twitter tag if the body has a tweet shortcode" -Pending {
        $shortcodeMatch = '{{< tweet .*? >}}'
        $linkMatch = '\[Originally posted to Twitter.\]'
        if ( $review -match $shortcodeMatch -or $review -match $linkMatch ) {
            $frontMatter.tags | Should -Contain "Twitter"
        }
    }
}