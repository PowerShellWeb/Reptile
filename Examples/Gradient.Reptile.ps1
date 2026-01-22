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
    <input type='color' id='color1' name='color1' value='#4488ff' />
    <label for='color1'>Color 1</label>
    <input type='color' id='color2' name='color2' value='#224488' />
    <label for='color2'>Color 2</label>
    <select id='gradientType' name='gradientType'>
        <option selected>radial</option>
        <option>linear</option>
        <option>conic</option>
    </select>
    <label for='gradientType'>Gradient Type</label>
    <input type='hidden' name='command' value="$(
        [Web.HttpUtility]::HtmlAttributeEncode(@'
"<div style='width:100%;height:100%;background:$(gradient $gradientType $color1 $color2)'></div>"
'@))"</input>
    <input type='submit' value='go'></input>
</form>
</body>
</html>
"@