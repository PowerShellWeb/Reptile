"<html>"
"<head>"
"</head>"
"<body>"
"<style>"    
".repl-input { grid-area: input; width: 100%; }"
".repl-go { grid-area: go; width: 50%; text-align: center; }"
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

"</style>"
"<div class='repl-input-area'>"
"<textarea class='repl-input' id='input' rows='3' spellcheck='false'>"
'turtle rotate (randomangle) (
    "flower", "starflower", "square", "circle", "rectangle" | random
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'
"</textarea>"
"<button class='repl-go' id='go'>Go</button>"
"</div>"
"<menu>"
"<button class='reptile' id='circle' data-input='turtle circle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Circle</button>"
"<button class='reptile' id='pie' data-input='turtle rotate (randomangle) pie 42 3 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Pie</button>"
"<button class='reptile' id='square' data-input='turtle rotate (randomangle) square 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Square</button>"
"<button class='reptile' id='rectangle' data-input='turtle rotate (randomangle) rectangle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Rectangle</button>"
"<button class='reptile' id='star' data-input='turtle rotate (randomangle) star 42 (5,6,7,8,9 | Get-Random) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Star</button>"
"<button class='reptile' id='flower' data-input='turtle rotate (randomangle) flower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Flower</button>"
"<button class='reptile' id='starflower' data-input='turtle rotate (randomangle) starflower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Starflower</button>"
"<details open><summary>Sectors</summary>"
@"
<button class='reptile' id='quadrants' data-input="turtle id quadrants rotate (randomangle) @(
    'CircleArc',42, 90, 'Rotate', 90 * 4
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Quadrants</button>

<button class='reptile' id='sextants' data-input="turtle id sextants rotate (randomangle) @(
    'CircleArc',42, 60, 'Rotate', 60 * 6
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Sextants</button>

<button class='reptile' id='octants' data-input="turtle id quadrants rotate (randomangle) @(
    'CircleArc',42, 45, 'Rotate', 45 * 8
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Octants</button>
"@
"</details>"
"</menu>"
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
    newListInput.setAttribute('rows','3')
    newListInput.classList.add('repl-input')
    
    
    const now = new Date()
    newListInput.id = 'input' + now.getTime()
    newListInput.value = input
    
    newListOutput.id = 'output' + now.getTime()        
    newListDetails.appendChild(newListSummary)
    newListDetails.appendChild(newListInput)

    const newGoButton = document.createElement('button') 
    newGoButton.innerText = 'go' 
    newGoButton.classList.add('repl-go')
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
        inputScript = event?.target?.dataset?.input
        inputId = newShell(inputScript)
        const outputId = inputId.replace(/^input/i, 'output')
        const out = document.getElementById(outputId)
        const response = await fetch(window.location.href,
            {method: 'POST',body: inputScript})
        out.innerHTML = await response.text()
        out.animate({ scale: ['0%', '100%'] }, 84);
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
"</body>"
"</html>"