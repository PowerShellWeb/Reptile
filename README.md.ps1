$help = Get-Help Reptile 

"# $($help.SYNOPSIS)"

"### $($help.Description.text -join [Environment]::NewLine)"

$help.alertset.alert.text -join [Environment]::NewLine