## Reptile        
### Read Evaluate Print Terminal Input Loop Editor - A Scaley Simple PowerShell Data REPL

Command Lines can be scary.

Websites feel much safer.

Reptile gives you simple, scalable and safe web terminals.

### Installing and Importing

We can install Reptile from the PowerShell Gallery:

~~~PowerShell
Install-Module Reptile
~~~

Once installed, we can import it with:

~~~PowerShell
Import-Module Reptile -PassThru
~~~

We can also clone the repository and import it from any directory:

~~~PowerShell
git clone https://github.com/PowerShellWeb/Reptile
cd ./Reptile
Import-Module ./ -PassThru
~~~

### Getting Started

Once installed, we just run reptile:

~~~PowerShell
reptile
~~~

This will start a simple terminal with no commands enabled.

You can still 'run' a few things.

`2+2` will equal `4`.  "a" + "b" + "c" will be `abc`.

Feel free to play around.

Reptile runs in Restricted Language mode, and it's pretty restrictive.

## Simple, Scalable, Safe

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

### Reptile Roadmap

Reptile will Evolve.

Reptile is a new project, and will grow and change with time.
Implementation is subject to change.

The next items on the Reptile Roadmap are:

* Additional Protocol Support 
  * JsonRPC
  * MCP
  * XRPC
* New Examples
* Better Variable Input
* More Turtles (and other useful interactive tools)
