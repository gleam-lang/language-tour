/* # Code switcher 
 *
 * ## Minimal layout
 *
 *  <div id="example" style="height: 1rem"
 *    class="code-switcher code-switcher-toggle-in">
 *    <pre>
 *      <span>my</span><span data-switcher-id="example">example</span>
 *    </pre>
 *    <pre>
 *      <span>your</span><span data-switcher-id="example">example</span>
 *    </pre>
 *  </div>
 *
 *  <script src="/js/code-switcher.js" type="module">
 *  <link rel="stylesheet" href="/css/code-switcher.css">
 *
 * * * *
 *
 * ## Notes
 *
 * There may be other elements within the <div>.
 *
 * Each `data-switcher-id` needs to be unique within the <pre> 
 *  AND present in both <pre>'s.
 *
 * Every bit of text within the <pre> needs to be inside a <span>.
 *  Either with or without an id.
 *
 * Toggling between the two states is done using `toggleCode(<element-id>)`.
 *  For the above example that would be `toggleCode("example")`
 *
 * The height of the <div> has to be set manually, unfortunately.
 *  At least I've not found a way to do it dynamically.
 *
 * * * *
 *
 * ## How does this work
 *
 * On startup code-switcher.js calculates the transform needed to move
 *  the elements with matching `data-switcher-id`'s to the position of their counterpart.
 *  The transforms get stored in a <style> element in the page's <head>.
 *
 * ## Animation flow
 *
 * 1. Hide 'matched'(a) & Start fading out the rest(a)
 * 2. Begin translating 'matched'(b) to x0y0
 * 3. End fading out(a)
 * 4. Begin fade in(b)
 * 5. End translating(b) 
 * 6. End fade in(b)
 *
 * (a) and (b) refer to either of the 2 <pre>. Which is which depends on direction.
 * */


/*
 * Calculate the px needed to move elements with matching `data-switcher-id`'s to their respective counterpart.
 *
 * **They have to adhere to the structure described at the top of this file.**
 *
 */
function initBlocks() {
    const targets = document.getElementsByClassName("code-switcher")

    var styleHtml = ".code-switcher {"

    for (const target of targets) {
        const children = target.getElementsByTagName("pre")

        if (children.length != 2) {
            console.log("Invalid child count " + children.length);
            return;
        }

        // get only the spans that have a `data-switcher-id` attribute
        const spans1 = spansWithData(children[0]);
        const spans2 = spansWithData(children[1]);

        for (const spanId in spans1) {
            const first = spans1[spanId]
            const second = spans2[spanId]

            if (second == undefined) {
                throw new Error("Differing contents. " + spanId + " not found in second element.")
            }

            // top offset for both
            const firstTop = first.getBoundingClientRect().top;
            const secondTop = second.getBoundingClientRect().top;

            // left offset for both
            const firstLeft = first.getBoundingClientRect().left;
            const secondLeft = second.getBoundingClientRect().left;

            const firstX = secondLeft - firstLeft
            const firstY = secondTop - firstTop
            
            const secondX = firstLeft - secondLeft
            const secondY = firstTop - secondTop 

            first.classList.add("first-" + spanId)
            styleHtml += "\n.first-" + spanId + " {" +
            "transform: translate(" + firstX + "px, " + firstY + "px);" +
            "}"

            second.classList.add("second-" + spanId)
            styleHtml += "\n.second-" + spanId + " {" +
            "transform: translate(" + secondX + "px, " + secondY + "px);" +
            "}"
        }

        window.setInterval(() => {toggleCode(target.id)}, 2000)
    }

    var style = document.createElement("style")
    style.type = "text/css"
    style.innerHTML = styleHtml + "\n}" 
    
    document.head.appendChild(style)
}

// Get the <span>s that have a 'data-switcher-id' attribute
function spansWithData(item) {
    var acc = []

    const spans = item.querySelectorAll('span[data-switcher-id]')

    for (const span of spans) {
        acc[span.dataset.switcherId] = span;
    }

    return acc;
}

/* Toggle a code-switcher <div> with a given id between `toggle-in` and `toggle-out`
 * */
function toggleCode(targetId) {
    const target = document.getElementById(targetId)

    const incoming = target.classList.toggle("code-switcher-toggle-in")
    target.classList.toggle("code-switcher-toggle-out", !incoming)
}

initBlocks()
