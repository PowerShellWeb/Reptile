#requires -Module Turtle, MarkX, oEmbed

Push-Location $PSScriptRoot

Reptile -Initialize {
    Import-Module Turtle, MarkX, OEmbed -Global
    $env:TURTLE_BOT = $true
    Set-Alias Random Get-Random
    function RandomColor { "#{0:x6}" -f (Get-Random -Max 0xffffff) }
    function RandomAngle {Get-Random -Min -360 -Max 360 }

    function ColorWheel { 
        "<style>"
        ".colorWheel {"
        $randomOffset = Get-Random -Min -360 -Max 360
        @(foreach ($n in 0..8) {
                "hsl($($randomOffset + ($n * 45)) 100% 50%)"
        }) -join ','
        "}"
        "</style>"
            
        "<div style='width:100%;height:100%;border-radius:50%;background:conic-gradient($(
            @(foreach ($n in 0..8) {
                "hsl($($randomOffset + ($n * 45)) 100% 50%)"
            }) -join ','
        ))'></div>"  
    }
    
    function say {
        $allInput = @($input) + @($args)
        foreach ($message in $allInput) {
            "<h1>$([Web.HttpUtility]::HtmlEncode($message))</h1>"
        }
    }
} -Repl (./TurtleShell.html.ps1) -SupportedCommand @(
    'Turtle', 'Get-Turtle'

    'MarkX', 'Markdown', 'Get-MarkX'

    'Get-OEmbed', 'oEmbed'

    'Get-Random', 'Random', 'RandomColor', 'RandomAngle'    

    'ColorWheel'

    'Say'
)

Pop-Location