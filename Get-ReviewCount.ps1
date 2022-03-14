Write-Host "Review Count:" (.\Get-ReviewList.ps1 | Where-Object { $_.ratings } | Measure-Object ).Count
