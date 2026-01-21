<#
.SYNOPSIS
    A Sleepy Reptile
.DESCRIPTION
    A Sleepy Reptile.
    
    A simple sleepy reptile that demonstrates asynchronous output
.NOTES
    This exposes a single command `SayWhen`.

    `SayWhen` will say a message after a short sleep
#>
Reptile -SupportedCommand @('SayWhen') -Initialize {
    function SayWhen(
        [string]$Message = "when", 
        [ValidateRange('00:00:00', '00:00:15')]
        [Timespan]$time = '00:00:01'
    ) {
        Start-Sleep -Milliseconds $time.TotalMilliseconds
        "<h3>$([Web.HttpUtility]::HtmlEncode($message))</h3>"
    }
} -Shell (
@"
<form action='/' method='post'>    
    <label for='sayWhen'>Say When</label>
    <textarea id='sayWhen' name='command'>
        sayWhen 1;sayWhen 2;sayWhen 3
    </textarea>
    <input type='submit' value='go'></input>
</form>
"@
)

