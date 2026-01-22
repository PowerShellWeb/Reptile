## Reptile Security

Reptile is designed to be *mostly* safe.

By default, without exposing commands, Reptile should be completely safe.

By exposing any commands, Reptiles are (almost) as dangerous as the commands they can run.

Please use locally, with commands you have threat modelled.

If you find a security concern about Reptile, please open an issue.

If you want to read more about how Reptile works and keeps things mostly safe, read below:

### Reptile Safety

Reptile runs in data statements for safety.

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
