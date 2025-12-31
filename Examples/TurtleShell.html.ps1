"<html>"
"<head>"
"</head>"
"<body>"
"<style>"    
".repl-input { grid-area: input; }"
".repl-go { grid-area: go; width: 50%; }"
"body { background-color: black; max-width: 100vw; height: 100vh; color: white; }"
".outputGrid {
    display: grid; 
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
    gap: 2.5em; 
    margin: 2.5em; 
    place-self: center;
    place-items: center;
}"

"output { display: block; }"
".repl-input-area {
    display: grid;
    text-align: center;
    grid-template-areas: 'input' 'go'; 
    place-content: center; 
    place-items: center;
    grid-template-rows: auto auto;
    grid-template-columns: 1fr;
}"
".repl-input { width: 100%; }"
"</style>"
"<div class='repl-input-area'>"
"<textarea class='repl-input' id='input' spellcheck='false'>"
'turtle rotate (randomangle) ("flower", "starflower" | Random) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'
"</textarea>"
"<button class='repl-go' id='go'>Go</button>"
"</div>"

"<output id='output'></output>"
"<ol id='output-item-list'>"    
"</ol>"

"<script type='module'>"
@"
function newShell(input, options = {}) {

    const outputItemList = document.getElementById('output-item-list')
    const newListDetails = document.createElement('details')
    newListDetails.setAttribute('open', '')
    const newListSummary = document.createElement('summary')
    newListSummary.innerText = outputItemList.childNodes.length
    
    const newListOutput = document.createElement('output') 
    const newListInput = document.createElement('textarea')
    newListInput.setAttribute('spellcheck','false')
    newListInput.classList.add('repl-input')
    
    const now = new Date()
    newListInput.id = 'input' + now.getTime()
    newListInput.value = input
    
    newListOutput.id = 'output' + now.getTime()        
    newListDetails.appendChild(newListSummary)
    newListDetails.appendChild(newListInput)

    const newGoButton = document.createElement('button') 
    newGoButton.innerText = 'go' 
    newGoButton.addEventListener('click', go)
    newListDetails.appendChild(newGoButton)
    newListDetails.appendChild(newListOutput)        
    if (outputItemList.firstChild) {
        outputItemList.insertBefore(newListDetails, outputItemList.firstChild)
    } else {
        outputItemList.appendChild(newListDetails)
    }
    
    newListDetails.animate({ scale: ['0%', '100%'] }, 84);        
    
    return newListInput.id
}
"@

"async function go(event) {
    let inputId = ''
    let inputScript = ''
    if (
        event?.target?.dataset?.input
    ) {
        const response = 
            await fetch(
                window.location.href,
                    {method: 'POST',body: event?.target?.dataset?.input}
            )
        const responseText = await response.text()
        
        if (event?.target?.dataset?.output) {
            for (const out in [
                ...document.querySelectorAll(event?.target?.dataset?.output)
            ]) {
                out.innerHTML = responseText;
                out.animate({ scale: ['0%', '100%'] }, 84);
            }
        } else {
            const out = document.createElement('output') 
            out.innerHTML = responseText;
            const mainOutput = document.getElementById('output')
            if (mainOutput?.firstChild) {            
                mainOutput.insertBefore(out, mainOutput.firstChild)
                out.animate({ scale: ['0%', '100%'] }, 84);
            } else if (mainOutput) {
                mainOutput.appendChild(out)
                out.animate({ scale: ['0%', '100%'] }, 84);
            }                        
        }            
        return
    }
    if (event?.target?.previousSibling?.value && 
        event?.target?.previousSibling?.id.match(/^input/)) {
        inputId = event?.target?.previousSibling?.id
        const outputId = inputId.replace(/^input/i, 'output')
    
    }
    
    if (! inputScript && inputId == 'input' || ! inputId) {
        const repl = document.getElementById('input')                
        inputId = newShell(repl.value)
        inputScript = repl.value                
    } else {
        const repl = document.getElementById(inputId)
        inputScript = repl?.value
    }
        
    if (! inputScript) { return }
      
    const outputId = inputId.replace(/^input/i, 'output')
    const out = document.getElementById(outputId)
    const response = await fetch(window.location.href,
        {method: 'POST',body: inputScript})                   
    out.innerHTML = await response.text()
    out.animate({ scale: ['0%', '100%'] }, 84);        
}"
"for (const goButton of [
    ...document.querySelectorAll('.reptile')
]) {
    goButton.addEventListener('click', go)
}"
"document.getElementById('go').addEventListener('click', go)"
"</script>"    
"<button class='reptile' id='star' data-input='turtle star 42 (4,5,6,7,8,9 | Get-Random) fill (randomcolor) stroke (randomcolor)'>Star</button>"
"</body>"
"</html>"