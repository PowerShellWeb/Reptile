<#
.SYNOPSIS
    Days Until Reptile 
.DESCRIPTION
    A simple single command form.  Show the number of days until a date.    
.NOTES
    This demonstrates how we can build really self-service forms.
#>
Reptile  -Initialize {
    # We can declare a small function in initialize
    function DaysUntil([Parameter(Mandatory)][DateTime]$Date) {
        "<h1>$(($date - [DateTime]::Now).TotalDays) days until $($date)</h1>"
    }
} -SupportedCommand @(
    # We also need to add it to the list of supported commands.
    'DaysUntil'
) -Shell @(
    # Our shell is just a form with two inputs:    
    "<form action='/' method='post'>"
    # A date selector
    "<input type='date' id='date' name='date' value='$([Datetime]::Now.Year)-12-25' />"
    # (with a label)
    "<label for='date'>Choose a Date</label>"
    # and a hidden input containing our script.
    "<input type='hidden' name='input' value='$(
        [Web.HttpUtility]::HtmlAttributeEncode('daysuntil $Date')
    )'></input>"
    "<input type='submit' value='go'></input>"
    "</form>"
)