# Nathan's Soda Guide

Source for [Nathan's Soda Guide](https://soda.guide)

Based on [HUGO](https://gohugo.io) using the [Clarity](https://themes.gohugo.io/hugo-clarity/) theme.

## Creating a new review
I have finally automated uploading images to the storage host now that I've moved to Cloudflare Images from Azure Storage Account. Previously I could always upload easily via script from my home system but on my work system it was more difficult because I was always logged into my work account and switching accounts is enough of a PITA it was easier to upload through the portal.

### Prep
Before using New-Review.ps1 add the following files to the root of the project:

#### local.settings.json
```json
{
    "imagePath": "X:\\Some\\Path\\To\\Pictures\\Folder"
}
```

#### cfParams.xml
```powershell
# Copy Cloudflare Images Account ID from dashboard
$cfAccount = Get-Clipboard

# Create new Cloudflare API token scoped to Edit on Cloudflare Images
$cftoken = Get-Clipboard | Convertto-SecureString -AsPlainText -Force

# Persist the information to disk in a relatively secure fashion
@{ AccountId = $cfAccount; Token = $cfToken } | Export-Clixml -Path .\cfParams.xml
```
### Execution

```powershell
New-Review -Name new-soda
```