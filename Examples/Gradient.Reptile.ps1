<#
.SYNOPSIS
    Gradient Reptile
.DESCRIPTION
    A simple Reptile that makes gradients.
.NOTES
    This imports a single module and exposes a pair of commands
#>
Reptile -SupportedCommand @(
    'Gradient','Get-Gradient'
) -Initialize {
    Import-Module Gradient  
} -Shell @"
<html><head><title>Gradient Reptile</title></head>
<body>
<form action='/' method='post'>
    <input type='color' name='color1' value='#4488ff' />
    <input type='color' name='color2' value='#224488' />
    <select name='gradientType'>
        <option selected>radial</option>
        <option>linear</option>
        <option>conic</option>
    </select>
    <input type='hidden' name='input' value="$(
        [Web.HttpUtility]::HtmlAttributeEncode(@'
"<div style='width:100%;height:100%;background:$(gradient $gradientType $color1 $color2)'></div>"
'@))"</input>
    <input type='submit' value='go'></input>
</form>
</body>
</html>
"@