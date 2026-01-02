<#
.SYNOPSIS
    A Caculating Reptile
.DESCRIPTION
    A simple calculator in Reptile.
    
    PowerShell Data blocks act as a simple calculator.
.NOTES
    This explicitly supports no commands and has no initialization script, so it will not use any default values.
    
    This is about as barebones as you can get.
#>
Reptile -SupportedCommand @() -Initialize {} -Shell @"
<html><head><title>Calculating Reptile</title></head>
<body>
<form action='/' method='post'>
    <input class='repl-input' id='repl' name='input'></input>
    <input type='submit' value='go'></input>
</form>
</body>
</html>
"@