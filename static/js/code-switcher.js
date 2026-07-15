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
 * Toggling between the two states is done using `toggle_code(<element-id>)`.
 *  For the above example that would be `toggle_code(example)`
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
function init_blocks() {
    const targets = document.getElementsByClassName("code-switcher")

    const inner = Array.from(targets).reduce((style_html, target) => {
        const children = target.getElementsByTagName("pre")

        if(children.length != 2){
            console.log("Invalid child count " + children.length);
            return;
        }

        const pre1 = valid_pre(children[0]);
        const pre2 = valid_pre(children[1]);

        // get only the spans that have a `data-switcher-id` attribute
        const spans1 = spans_with_data(pre1);
        const spans2 = spans_with_data(pre2);

        for(let span_id in spans1) {
            const first = spans1[span_id]
            const second = spans2[span_id]

            if(second == undefined) {
                console.log("Differing pre contents. " + span_id + " not found in second element.")
                return;
            }

            // top offset for both
            const first_top = first.getBoundingClientRect().top;
            const second_top = second.getBoundingClientRect().top;

            // left offset for both
            const first_left = first.getBoundingClientRect().left;
            const second_left = second.getBoundingClientRect().left;

            var first_x = second_left - first_left
            var first_y = second_top - first_top
            
            var second_x = first_left - second_left
            var second_y = first_top - second_top 


            first.classList.add("first-" + span_id)
            style_html += "\n.first-" + span_id + " {" +
            "transform: translate(" + first_x + "px, " + first_y + "px);" +
            "}"

            second.classList.add("second-" + span_id)
            style_html += "\n.second-" + span_id + " {" +
            "transform: translate(" + second_x + "px, " + second_y + "px);" +
            "}"

        }

        window.setInterval(() => {toggle_code(target.id)}, 2000)

        return style_html
    }, ".code-switcher {" )


    var style = document.createElement("style")
    style.type = "text/css"
    style.innerHTML = inner + "\n}" 
    
    document.getElementsByTagName("head")[0].appendChild(style)
}

/* Toggle a code-switcher <div> with a given id between `toggle-in` and `toggle-out`
 * */
export function toggle_code(target_id) {
    const target = document.getElementById(target_id)

    if(target.className == "code-switcher" || target.className == "code-switcher code-switcher-toggle-out") {
        target.className = "code-switcher code-switcher-toggle-in"
    } else {
        target.className = "code-switcher code-switcher-toggle-out"
    }
}

// Get the <span>s that have a 'data-switcher-id' attribute
function spans_with_data(item) {
    return Array.from(item.children).filter((span) => {
        if(span.tagName != "SPAN")
            return false;

        if(span.attributes["data-switcher-id"] == undefined)
            return false;

        return true;
    }).reduce((acc, span) => {
        acc[span.attributes["data-switcher-id"].value] = span;
        return acc;
    }, {})
}

// Check that the child is a <pre>
function valid_pre(child) {
    if(child.tagName != "PRE") {
        console.log("Invalid child " + child.tagName + " expected <pre>")
        return undefined;
    }

    return child;
}

// Init the codeblocks once the page is loaded 
addEventListener("load", () => {
    init_blocks()
})

// make toggle_code available
window.toggle_code = toggle_code;
