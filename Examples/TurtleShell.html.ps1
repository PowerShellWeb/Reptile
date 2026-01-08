param(
[string]
$Lucky = @'
turtle lucky
'@,

[PSObject[]]
$Examples = @(

"<details name='examples'>"
"<summary>Examples</summary>"
"<button class='reptile' id='circle' command='turtle circle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Circle</button>"
"<button class='reptile' id='pie' command='turtle rotate (randomangle) pie 42 3 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Pie</button>"
"<button class='reptile' id='square' command='turtle rotate (randomangle) square 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Square</button>"
"<button class='reptile' id='rectangle' command='turtle rotate (randomangle) rectangle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Rectangle</button>"
"<button class='reptile' id='star' command='turtle rotate (randomangle) star 42 (5,6,7,8,9 | Get-Random) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Star</button>"
"<button class='reptile' id='flower' command='turtle rotate (randomangle) flower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Flower</button>"
"<button class='reptile' id='starflower' command='turtle rotate (randomangle) starflower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Starflower</button>"
"<blockquote>"
"<details open><summary>Sectors</summary>"

@"
<button class='reptile' id='quadrants' command="turtle id quadrants rotate (randomangle) @(
    'CircleArc',42, 90, 'Rotate', 90 * 4
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Quadrants</button>

<button class='reptile' id='antiquadrants' command="turtle id antiquadrants rotate (randomangle) @(
    'CircleArc',42, -90, 'Rotate', 90 * 4
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antiquadrants</button>

<button class='reptile' id='sextants' command="turtle id sextants rotate (randomangle) @(
    'CircleArc',42, 60, 'Rotate', 60 * 6
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Sextants</button>

<button class='reptile' id='antisextants' command="turtle id antisextants rotate (randomangle) @(
    'CircleArc',42, -60, 'Rotate', 60 * 6
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antisextants</button>

<button class='reptile' id='octants' command="turtle id quadrants rotate (randomangle) @(
    'CircleArc',42, 45, 'Rotate', 45 * 8
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Octants</button>

<button class='reptile' id='antioctants' command="turtle id antioctants rotate (randomangle) @(
    'CircleArc',42, -45, 'Rotate', 45 * 8
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antioctants</button>
"@

"</details>"

"</blockquote>"

"<blockquote>"

"<details open><summary>Pies</summary>"

@"
<button class='reptile' id='pie3' command="
turtle id rotate (randomangle) pie 42 3 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">3 slices</button>

<button class='reptile' id='pie4' command="
turtle id rotate (randomangle) pie 42 4 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">4 slices</button>

<button class='reptile' id='pie5' command="
turtle id rotate (randomangle) pie 42 5 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">5 slices</button>

<button class='reptile' id='pie6' command="
turtle id rotate (randomangle) pie 42 6 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">6 slices</button>

<button class='reptile' id='pie7' command="
turtle id rotate (randomangle) pie 42 7 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">7 slices</button>

<button class='reptile' id='pie8' command="
turtle id rotate (randomangle) pie 42 8 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">8 slices</button>

"@

"</details>"

"</blockquote>"

)

)


"<html>"
"<head>"
"</head>"
"<body>"
"<style>"
".repl-command { grid-area: command; width: 100%; }"
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
"table { width: 100%; border: 1px solid; }"
"th, td { border: 1px solid;}"

"output { display: block; }"
".repl-command-grid {
    display: grid;
    text-align: center;
    grid-template-areas: 'command' 'go'; 
    place-content: center; 
    place-items: center;
    grid-template-rows: auto auto;
    grid-template-columns: 1fr;
    gap: 0.5rem;
    padding: 0.5rem;
}"

"button, summary { font-size: 1.25rem; padding: 0.25rem; }"

"</style>"
"<div class='repl-command-grid'>"
"<textarea class='repl-command' id='command' autocomplete='repl-command' rows='3' spellcheck='false'>"
$Lucky
"</textarea>"
"<button class='repl-go' id='go'>Go Turtle!</button>"
"</div>"
"<menu>"
"<menu>"

@"
<button class='reptile' id='feelinglucky' command="$([Web.HttpUtility]::HtmlAttributeEncode($Lucky))">Lucky</button>
"@
"</menu>"
"<menu>"
$Examples
"</menu>"
"</details>"
"<output id='output'></output>"
"<ol id='output-item-list'>"    
"</ol>"

"<script type='module'>"
@"
function newShell(input, options = {}) {
    const now = new Date()

    const outputItemList = document.getElementById('output-item-list')

    const newListDetails = document.createElement('details')
    newListDetails.setAttribute('open', '')

    const newListSummary = document.createElement('summary')
    
    newListSummary.innerText = outputItemList.childNodes.length
    newListDetails.appendChild(newListSummary)
    const newListGrid = document.createElement('div') 
    newListGrid.classList.add('repl-command-grid')
    newListDetails.appendChild(newListGrid)
    
    const newListInput = document.createElement('textarea')
    const inputLines = input.split(/(\r\n|\n|\r)/)
    
    newListInput.setAttribute('spellcheck','false')
    newListInput.setAttribute('autocomplete','repl-command')    
    newListInput.setAttribute('rows',inputLines.length - 1)
    newListInput.setAttribute('disabled', 'true')
    newListInput.classList.add('repl-command')    
    newListInput.id = 'command' + now.getTime()
    newListInput.value = input
    newListGrid.appendChild(newListInput)

    const newListOutput = document.createElement('output')
    newListOutput.id = newListInput.id.replace(/^command/i, 'output')
    
    const newGoButton = document.createElement('button')    
    newGoButton.id = newListInput.id.replace(/^command/i, 'go')
    newGoButton.innerText = 'Go Turtle' 
    newGoButton.classList.add('repl-go')
    newGoButton.addEventListener('click', go)
    newGoButton.setAttribute('disabled', 'true')
    newListGrid.appendChild(newGoButton)                    
    newListDetails.appendChild(newListOutput)
    
    if (outputItemList.firstChild) {
        outputItemList.insertBefore(newListDetails, outputItemList.firstChild)
    } else {
        outputItemList.appendChild(newListDetails)
    }
    
    newListDetails.animate({ scale: ['0%', '100%'] }, 67);
    
    return newListInput.id
}
"@

"async function go(event) {
    let inputId = ''
    let inputScript = ''
    
    if (event?.target?.animate) {
        event.target.animate({ scale: ['100%', '105%','100%'] }, 67);
    }
    
    if (
        event?.target?.getAttribute && 
        event?.target?.getAttribute('command')
    ) {
        inputScript = event.target.getAttribute('command')
        
        inputId = newShell(inputScript)

        const outputId = inputId.replace(/^command/i, 'output')

        const out = document.getElementById(outputId)
        
        const response = await fetch(window.location.href,
            {method: 'POST',body: inputScript})

        out.innerHTML = await response.text()

        out.animate({ scale: ['0%', '100%'] }, 67);

        out.scrollIntoView()

        const inputElement = document.getElementById(inputId)
        if (inputElement) {
            inputElement.removeAttribute('disabled')
        }
        const goElement = document.getElementById(
            inputId.replace(/^command/i, 'go')
        )
        if (goElement) {
            goElement.removeAttribute('disabled')
        }
        return
    }
    if (event?.target?.previousSibling?.value && 
        event?.target?.previousSibling?.id.match(/^command/i)) {
        inputId = event?.target?.previousSibling?.id
        const outputId = inputId.replace(/^command/i, 'output')    
    }
    
    if (! inputScript && inputId == 'command' || ! inputId) {
        const repl = document.getElementById('command')
        repl.animate({ scale: ['100%', '105%','100%'] }, 67);
        inputId = newShell(repl.value)
        inputScript = repl.value                
    } else {
        const repl = document.getElementById(inputId)
        repl.setAttribute('disabled', 'true')
        inputScript = repl?.value
    }
        
    if (! inputScript) { return }
      
    const outputId = inputId.replace(/^command/i, 'output')
    const out = document.getElementById(outputId)
    const goElement = document.getElementById(
        inputId.replace(/^command/i, 'go')
    )
    if (goElement) {    
        goElement.setAttribute('disabled', 'true')
        
    }
    const inputElement = document.getElementById(inputId)    
    if (inputElement) {
        inputElement.animate({ scale: ['100%', '105%','100%'] }, 67);
    }    
    const response = await fetch(window.location.href,
        {method: 'POST',body: inputScript})                   
    out.innerHTML = await response.text()
    out.animate({ scale: ['0%', '100%'] }, 67);

    
    if (inputElement) {
        inputElement.removeAttribute('disabled')
        inputElement.animate({ scale: ['100%', '105%','100%'] }, 67);
    }    
    if (goElement) {
        goElement.removeAttribute('disabled')
    }    
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