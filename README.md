# jQuery Micro Utils

Tiny, CDN-friendly helpers to make jQuery traversal and ergonomics snappier — no widgets, just micro-utilities.

## Why?

jQuery is great, but sometimes you need:
- **First match per element** (not all matches or globally first)
- **Short-circuit traversal** (stop at first match, not collect all)
- **Predicate functions** (not just CSS selectors)
- **Modern conveniences** (tap, viewport detection)

This adds ~1KB of focused utilities without the bloat of jQuery UI or larger plugins.

## Install

```html
<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/AnswerDotAI/jquery-micro-utils@0.1.4/src/jquery-micro-utils.js"></script>
```

Or use npm/yarn:
```bash
npm install jquery-micro-utils
```

## API

### `.nextMatch(selectorOrFn)` / `.prevMatch(selectorOrFn)`

Find the **first** sibling that matches (not all). Accepts CSS selector or predicate function.

```js
// Find next sibling with 10+ characters (can't do this with jQuery's .next())
$('.item').nextMatch(el => el.textContent.length > 10);

// More efficient than .nextAll('.active').first() - stops at first match
$('.current').nextMatch('.active').addClass('highlight');

// Works backwards too
$('#item-5').prevMatch('.section-header').css('font-weight', 'bold');
```

**vs jQuery:** `.next()` only checks immediate sibling. `.nextAll()` gets ALL matches. `nextMatch()` finds FIRST match per element.

### `.findFirst(selector)`

Get the **first descendant** from each element (not all descendants).

```js
// Get first button from EACH card (not just the globally first)
$('.card').findFirst('button').prop('disabled', true);

// Faster than .find('img').first() when you only need one per container
$('.gallery-row').findFirst('img').addClass('hero');
```

**vs jQuery:** `.find()` returns ALL matches. `.find().first()` returns globally first. `findFirst()` returns first match FROM EACH element.

### `.containsText(str|RegExp)`

Filter elements by text content.

```js
// String contains
$('button').containsText('Save').addClass('primary');

// RegExp for complex matching
$('tr').containsText(/^(error|warning):/i).css('color', 'red');

// Find elements with specific price ranges
$('.price').containsText(/\$[5-9][0-9]\./).addClass('mid-range');
```

### `.inViewport(margin = 0)`

Filter to elements currently visible in viewport.

```js
// Lazy-load images as they come into view
$('img[data-src]').inViewport(200).each(function() {
  this.src = this.dataset.src;
  delete this.dataset.src;
});

// Animate elements when visible
$('.animate-me').inViewport().addClass('fade-in');

// Check what sections user can see
$('section').inViewport().tap(console.log);
```

### `.tap(fn)`

Debug or side-effect without breaking the chain.

```js
$('.item')
  .tap($els => console.log(`Processing ${$els.length} items`))
  .addClass('processed')
  .tap($els => analytics.track('items.processed', $els.length))
  .fadeIn();

// Quick debugging
$('.mystery').tap(console.log).remove();
```

### `$.as$(x)`

Safely convert anything to jQuery object.

```js
function process(element) {
  // Don't worry if element is DOM node, jQuery object, or selector string
  const $el = $.as$(element);
  $el.addClass('processed');
}

process(document.querySelector('.item'));  // DOM node - works
process($('.item'));                       // jQuery object - works
process('.item');                          // Selector string - works
```

## Real-World Examples

### Accordion behavior
```js
$('.accordion-header').on('click', function() {
  $(this)
    .nextMatch('.accordion-content')
    .slideToggle()
    .tap($content => console.log('Toggled:', $content));
});
```

### Progressive enhancement
```js
// Add "Read more" only to truncated content
$('.content').containsText('...').after('<button>Read more</button>');
```

### Performance monitoring
```js
// Track which sections users actually see
const viewed = new Set();
setInterval(() => {
  $('section[id]').inViewport().each(function() {
    if (!viewed.has(this.id)) {
      viewed.add(this.id);
      analytics.track('section.viewed', { id: this.id });
    }
  });
}, 1000);
```

## Development

```bash
npm install
npm run serve  # localhost:8080/examples/
```

## License

MIT © Answer.AI 2025

