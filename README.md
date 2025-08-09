# jQuery Micro Utils

Tiny, CDN-friendly helpers to make jQuery traversal and ergonomics snappier — no widgets, just micro-utilities.

## Install

```html
<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/AnswerDotAI/jquery-micro-utils/src/jquery-micro-utils.js"></script>
```

UMD build works with `<script>`, AMD, or CommonJS.

## API

### `.nextMatch(selectorOrFn)`

**What:** First following sibling that matches. Short-circuits (faster than `.nextAll().first()`).

```js
const $bar = $('.foo').nextMatch('.bar');
if ($bar.exists) {
  $bar.addClass('hit');
}
```

### `.prevMatch(selectorOrFn)`

**What:** First previous sibling that matches (short-circuits).

```js
$('#item42').prevMatch('.active').tap($x => console.log($x[0]));
```

### `.findFirst(selector)`

**What:** First descendant under each root via `querySelector`.

```js
const $btn = $('.card').findFirst('button.primary');
```

### `.containsText(str|RegExp)`

**What:** Filter elements by `textContent` (string contains or RegExp test).

```js
const $matches = $('li').containsText(/done|complete/i);
```

### `.inViewport(margin = 0)`

**What:** Elements whose bounding rect intersects the viewport (±margin px).

```js
const $visible = $('.section').inViewport(100);
```

### `.tap(fn)`

**What:** Chain-tap for debugging/side-effects; returns the same jQuery set.

```js
$('.item').tap($it => console.log('count:', $it.length)).addClass('seen');
```

### `$.as$(x)`

**What:** Normalize DOM or jQuery input to a jQuery object.

```js
const $el = $.as$(maybeDomOrJq);
```

## Development

```bash
npm i
```

### Manual Demo

Open `examples/index.html` in any browser to try the utilities against a small fixture page (no build or server required). It loads jQuery 3.x from the CDN and the UMD source from `src/`.

Or run a tiny static server:

```bash
npm run serve
```

Then open `http://localhost:8080/examples/`.

## Files

- `src/jquery-micro-utils.js` – source (UMD)
- `examples/index.html` – manual browser demo

## Metadata

- `$.microUtils.version`: library version string.

## License

MIT, © Answer.AI 2025
