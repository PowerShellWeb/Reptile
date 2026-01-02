function Get-Reptile
{
    <#
    .SYNOPSIS
        Gets Reptiles
    .DESCRIPTION
        Gets Reptiles - Read Evaluate Print Terminal Input Loop Editor
    .NOTES
        ## Reptile        
        ### Read Evaluate Print Terminal Input Loop Editor - A Scaley Simple PowerShell Data REPL

        Command Lines can be scary.

        Websites feel much safer.

        Reptile gives you simple, scalable and safe web terminals.

        ### Simple

        Reptile run PowerShell in a [data block](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes?wt.mc_id=MVP_321542)

        This only allows whatever commands you choose, and does not allow loops, strong types, or methods.

        All a reptile really does is take input, create a data block, and call PowerShell.        

        ### Scalable

        Reptile is built with a [HttpListener](https://learn.microsoft.com/en-us/dotnet/api/system.net.httplistener?wt.mc_id=MVP_321542)
        and [PowerShell Thread Jobs](https://learn.microsoft.com/en-us/powershell/module/threadjob/start-threadjob?wt.mc_id=MVP_321542).

        This makes Reptile simple to scale:  Just launch more than one job.

        ### Safe

        Data statements are a constrained form of PowerShell that primarily process data.

        Data statements can also run any number of -SupportedCommands.

        Data statements cannot access most variables, use methods, reference most types, or loop.

        This makes them fairly ideal for a mostly safe REPL loop.

        If a command is not supported, it will not be run.

        This means that as long as no supported command allow arbitrary code injection, you are safe.

        However, if you ran `reptile -supportedCommand python`,
        then that would be a much more dangerous reptile to deal with.

        Which is why there are some additional safety measures.

        #### Additional Safety Measures

        ##### Local Loopback Port

        By default, reptile will run on a random local loopback port.

        This has three security benefits:

        1. It does not require elevation to administrator
        2. It does not open an external port
        3. It is less predictable
        
        If you are running reptile locally as intended, you control which scripts you run, and they can run as you.

        If you choose to allow a live reptile instance, you are as safe as the commands the reptile supports.

        ##### AST Inspection

        Scripts that are not parsable as a data block will never be run.

        Additionally, if someone succeeds in the miracle of escaping syntax, 
        and the AST is not a single data statement, it will not run.        
        
        ##### Background Execution

        All data blocks will be evaluated in a background job.

        This is a trade off of performance for security.  
        
        Responses will take longer than they would inline, 
        but any potential data corruption is quite literally limited in scope.

        The background jobs cannot access the main server thread, 
        and so have a much more difficult time escalating any potential jailbreaks.

        Additionally, because the responses are run in background _thread_ jobs, 
        it limits the overall impact of each request, and thus service is harder to deny.
    .EXAMPLE
        ./DataReplServer.ps1
    .LINK
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes
    #>
    [Alias('Reptile','REPL','WebRepl')]
    param(
    # The rootUrl of the server.  By default, a random loopback address.
    [string]$RootUrl=
        "http://127.0.0.1:$(Get-Random -Minimum 4200 -Maximum 42000)/",

    # The list of supported commands
    [Alias('SupportedCommands')]
    [string[]]
    $SupportedCommand = @(),

    # The Reptile's Shell    
    # This object will be rendered on GET requests.
    # It should be HTML.
    [PSObject]
    [Alias('Repl', 'WebRepl', 'Scales','Scale', 'Skin')]
    $Shell = @(
        if (Test-Path "./repl.html") {
            Get-Content ./repl.html
        } else {
            "<html><head><title>Reptile</title>"
            "<style>"
                "body {"
                    @(
                        "max-width: 100vw"
                        "height: 100vh"
                        "background-color: black"
                        "color: white;"
                    ) -join '; '
                "}"
                ".repl-input-area {"
                    @(
                        "display: grid"
                        "place-items: center"
                        "place-content: center"
                        "grid-template-areas: 'input' 'go' 'output'"
                        "grid-template-rows: auto auto auto"
                        "grid-template-columns: 1fr"
                    ) -join '; '
                "}"
                ".repl-input { grid-area: input; width: 100%; }"
                ".repl-go { grid-area: go; width: 50%;}"
                ".repl-output { grid-area: output; width: 100%; }"
            "</style>"
            "</head>"
            "<body>"
            "<form action='/' method='post'>"
                "<input class='repl-input' id='repl' name='input'></input>"
                "<input type='submit' value='go'></input>"
            "</form>"                                    
            "</body>"
            "</html>"
        }
    ) -join [Environment]::NewLine,

    # The script used to initialize the reptile.
    [ScriptBlock]
    $Initialize = {},

    # The number of nodes to run.
    [uint32]
    $NodeCount = 1
    )

    if ($SupportedCommand -match '^(?>Invoke-Expression|iex)$') {
        Write-Error "No.  Invoke-Expression is unsafe.  We will not support this."
        return
    }    

    # Create a listener
    $httpListener = [Net.HttpListener]::new()
    $httpListener.Prefixes.Add($RootUrl)
    # and write a warning so that the user knows (and can click it open)
    Write-Warning "Listening on $RootUrl $($httpListener.Start())"

    # Make our IO object by packing our job input into a dictionary.
    $io = [Ordered]@{
        HttpListener = $httpListener
        SupportedCommand  = $SupportedCommand
        Shell = $Shell
        Initialize = $Initialize
    }    
    # Every item in this dictionary becomes a variable in our job.
    
    # We will add IO to the return objects.

    # If we want things to be "hot-swappable", we can reference $IO

    # For example, we want to reply in a background job:
    $ReplyDefinition = {        
        param([ScriptBlock]$dataBlock, $reply)
        # We want to double check the data statement is the only thing
        if (-not (
            ($dataBlock.Ast.EndBlock.Statements.Count -eq 1) -and 
            ($dataBlock.Ast.EndBlock.Statements[0] -is 
                [Management.Automation.Language.DataStatementAst])
        )) {                    
            $reply.Close()
            return
        }
        
        # Then we want to try running the data block
        try {            
            $result = $(& $dataBlock *>&1)            
            # And respond with the outer XML
            if ($result.OuterXml) {
                $reply.Close($OutputEncoding.GetBytes($result.OuterXml),  $false)
            } else {
                # or the stringification of the result.                
                $reply.Close($OutputEncoding.GetBytes("$result"),  $false)
            }            
        } catch {
            # If anything went wrong, though it feels wrong, we want to respond with 200
            $reply.StatusCode = 200
            # so that the error is clear to an interactive user.            
            $reply.Close($OutputEncoding.GetBytes("$($_)"), $false)
        }
    }
    $IO.ReplyDefinition = $ReplyDefinition

    $ServerDefinition = {
        param([Collections.IDictionary]$io)
        
        # First, let's unpack.
        $psvariable = $ExecutionContext.SessionState.PSVariable
        foreach ($key in @($io.Keys)) { 
            if ($io[$key] -is [PSVariable]) { $psvariable.set($io[$key]) }
            else { $psvariable.set($key, $io[$key]) }
        }

        filter errorOut {
            $err = $_
            if ($err -isnot [Management.Automation.ErrorRecord]) {
                return       
            }
            # Attempt to find the best error message
            $bestMessage =
                if ($err.Exception.InnerException.Message) {
                    $err.Exception.InnerException.Message
                } elseif ($err.Exception.Message) {
                    $err.Exception.Message
                } else {
                    "$err"
                }

            # write out our error
            $err | Out-Host
            $err | Write-Error
            # and, ironically, say things are OK
            $reply.StatusCode = 200
            # So we can show the user the error.            
            $reply.Close($OutputEncoding.GetBytes("$bestMessage"), $false)                                        
        }

        filter replaceVariable {
            param([string]$variableName, [string]$replacement)
            
            # Very permissive variable pattern:
            # variables can begin with:
            $prefixes = @(
                ':' # colons (logo style)
                '-{2}' # two dashes (css style)                
                '\$' # dollar signs (PowerShell style)
            )
            $variablePattern = "(?>$($prefixes -join '|'))" + ([Regex]::Escape($variableName))
            
            $in = $_
            $in -replace $variablePattern, "'$($replacement -replace "'","''")'"
        }

        
        # Then listen for the next request
        :nextRequest while ($httpListener.IsListening) {
            $getContext = $httpListener.GetContextAsync()
            # (wait for short prime intervals, so we can cancel if we need to).
            while (-not $getContext.Wait(17)) { }
            $request, $reply =
                $getContext.Result.Request, $getContext.Result.Response
            
            # Switch what we do next based off of the HTTP Method.
            switch ($request.httpMethod) {
                get {
                    # If it's get, return the REPL
                    $reply.ContentType = 'text/html'                
                    $replBytes = $OutputEncoding.GetBytes("$($io.Shell)")
                    $reply.Close($replBytes, $false)
                }
                head {
                    # If it's head, return 0 for content length and close out.
                    $reply.ContentLength = 0; $reply.Close()
                }            
                default {
                    # Any other verb we'll try to evaluate the body.
                    # Of course, if there is no body
                    if (-not $request.InputStream) {                        
                        Write-Host "No input" -ForegroundColor Yellow
                        $reply.ContentLength = 0
                        $reply.Close() # close out
                        continue nextRequest # and continue to the next request.
                    }
                    
                    # Read our body
                    $streamReader = [IO.StreamReader]::new($request.InputStream, $request.ContentEncoding)
                    $inputString = $streamReader.ReadToEnd()
                    $streamReader.Close()
                    $streamReader.Dispose()

                    # If we cannot parse the body, we'll pass it as a command.


                    $inputParsed = $null
                    $inputCopy = [Ordered]@{}
                    # If the content type resembled json
                    if ($request.ContentType -match '.+?/.{0,}json') {
                        # try to parse it
                        $inputParsed = 
                            try { $inputString | ConvertFrom-Json -AsHashtable}
                            catch {
                                # and error out if that did not work.
                                $_ | errorOut
                                continue nextRequest
                            }

                        # JSON rpc sends a method and parameters
                        if ($inputParsed.jsonrpc -and 
                            $inputParsed.method
                        ) {
                            $jsonRpcParsed = $inputParsed
                            $inputCopy.input = $jsonRpcParsed.method
                            
                            
                            foreach ($key in $jsonRpcParsed.parameters.keys) {
                                $inputCopy[$key] = $jsonRpcParsed.parameters[$key]
                            }
                        }
                    }

                    # If the content type looks like form data
                    if ($request.ContentType -eq 'application/x-www-form-urlencoded') {
                        
                        # try to parse it                    
                        try { $inputParsed = [Web.HttpUtility]::ParseQueryString($inputString) }
                        catch {
                            # and error out if that did not work.
                            $_ | errorOut
                            continue nextRequest
                        }
                                                                        
                        foreach ($key in $inputParsed.Keys) {
                            $inputCopy[$key] = $inputParsed[$key]
                            Write-Host "$key - $($inputCopy[$key])"
                        }
                        $reply.ContentType = 'text/html'
                    }

                    # If we have parsed the input, 
                    # then it's fairly simple to support variables.

                    # (data blocks don't variables, but they guard against injection enough to replace text)
                    
                    if ($inputCopy.Count) {
                        if (-not $inputCopy['Input']) {
                            $err = 
                                Write-Error "No Input" -TargetObject $request *>&1
                            $err | errorOut
                            continue nextRequest
                        }
                        $inputString = $inputCopy['Input']
                        foreach ($key in $inputCopy.Keys) {
                            $inputString = $inputString | replaceVariable $key $inputCopy[$key]
                        }
                    }                    

                    # and then write what was attempted and when.
                    @(
                        "$($request.RemoteAddr) $($request.httpMethod) $($request.Url) @ $([datetime]::Now)"
                    ) | Write-Host -ForegroundColor Cyan

                    # Now we try to make it into a data block
                    $dataBlock =
                        try {
                            # First we construct a script block.
                            # If this fails, the code is invalid.
                            $inputScriptBlock = 
                                [ScriptBlock]::Create($inputString)

                            # data blocks give us an inline restricted language mode
                            [ScriptBlock]::Create("data $(
                                if ($SupportedCommand) { "-supportedCommand '$(
                                    # and we can support a limited set of commands.
                                    $SupportedCommand -replace "'","''" -join "','"
                                )'"}
                            ) {" + 
                                [Environment]::NewLine + 
                                $inputScriptBlock + 
                                [Environment]::NewLine + 
                            "}")
                        } catch {
                            # If we could not make this a data block
                            $_ | errorOut
                            continue nextRequest
                        }

                    # This last bit of healthy paranoia is done twice.
                    # It may not even be possible, but, if, somehow someone managed to inject a _second_
                    # command, or, magically make it not a data block, 
                    if (
                        ($dataBlock.Ast.EndBlock.Statements.Count -ne 1) -or 
                        ($dataBlock.Ast.EndBlock.Statements[0] -isnot 
                            [Management.Automation.Language.DataStatementAst])
                    ) {
                        # we want to write an error.
                        $err = 
                            Write-Error "Unbalanced Injection Attempted @ $([datetime]::Now)" -Category SecurityError -TargetObject $request *>&1
                        $err | errorOut
                        continue nextRequest
                    }
                    
                    # Now we can launch an inner thread job to run the script and reply.
                    $replyJobParameters = @{
                        ScriptBlock=$ReplyDefinition
                        ThrottleLimit=1kb
                        ArgumentList=$dataBlock, $reply
                        InitializationScript=$Initialize
                    }
                    # Doing this makes the server more resilient, but will be slower than directly handling each request.
                    Start-ThreadJob @replyJobParameters
                }
            }
        }            
    
    }

    $JobParameters = @{
        ScriptBlock = $ServerDefinition
        InitializationScript = $Initialize
        ThrottleLimit = 256
        ArgumentList = $io
        Name = $RootUrl
    }

    foreach ($nodeNumber in 1..$NodeCount) {
        # Our server is a thread job
        Start-ThreadJob @JobParameters| # Output our job,
            Add-Member -NotePropertyMembers @{ # but attach a few properties first:
                HttpListener=$httpListener # * The listener (so we can stop it)
                IO=$IO # * The IO (so we can change it)
                Url="$RootUrl" # The URL (so we can easily access it).
            } -Force -PassThru # Pass all of that thru and return it to you.
    }
}
