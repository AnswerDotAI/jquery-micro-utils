/* This file mirrors the plugin in the main canvas. Keep this copy under src/ for packaging. */

/*!
 * jQuery Micro Utils v0.1.1
 * Small, CDN-friendly helpers for efficient traversal & ergonomics.
 * (c) 2025 — MIT License
 */
(function (factory) {
  if (typeof define === 'function' && define.amd) {
    define(['jquery'], factory);
  } else if (typeof module === 'object' && module.exports) {
    module.exports = factory(require('jquery'));
  } else {
    factory(jQuery);
  }
}(function ($) {
  'use strict';

  if (!$ || !$.fn) {
    throw new Error('jquery-micro-utils requires jQuery to be loaded first.');
  }

  function toPredicate(test) {
    if (typeof test === 'function') return /** @type {(el: Element) => boolean} */(test);
    if (typeof test === 'string' && test.trim()) {
      return function (el) { return el.matches(test); };
    }
    return function () { return true; };
  }

  function firstSibling(start, dir, pred) {
    let el = start;
    while (el && (el = /** @type {Element|null} */(el[dir]))) {
      if (pred(el)) return el;
    }
    return null;
  }

  function toUniqueSet(nodes) {
    const arr = [];
    for (let i = 0; i < nodes.length; i++) {
      const n = nodes[i];
      if (n) arr.push(n);
    }
    return $( $.uniqueSort(arr) );
  }

  $.fn.nextMatch = function (selectorOrFn) {
    const pred = toPredicate(selectorOrFn);
    const out = new Array(this.length);
    for (let i = 0; i < this.length; i++) {
      const el = this[i];
      out[i] = el ? firstSibling(el, 'nextElementSibling', pred) : null;
    }
    return toUniqueSet(out);
  };

  $.fn.prevMatch = function (selectorOrFn) {
    const pred = toPredicate(selectorOrFn);
    const out = new Array(this.length);
    for (let i = 0; i < this.length; i++) {
      const el = this[i];
      out[i] = el ? firstSibling(el, 'previousElementSibling', pred) : null;
    }
    return toUniqueSet(out);
  };

  $.fn.findFirst = function (selector) {
    if (typeof selector !== 'string' || !selector.trim()) return this.pushStack([]);
    const out = new Array(this.length);
    for (let i = 0; i < this.length; i++) {
      const el = this[i];
      out[i] = el && el.querySelector ? el.querySelector(selector) : null;
    }
    return toUniqueSet(out);
  };

  $.fn.containsText = function (query) {
    if (query == null) return this.pushStack([]);
    const isRegex = query instanceof RegExp;
    return this.filter(function () {
      const t = (this.textContent || '').trim();
      return isRegex ? /** @type {RegExp} */(query).test(t) : t.includes(String(query));
    });
  };

  $.fn.tap = function (fn) {
    if (typeof fn === 'function') fn(this);
    return this;
  };

  $.fn.inViewport = function (margin) {
    const m = Number.isFinite(margin) ? Number(margin) : 0;
    return this.filter(function () {
      if (!(this instanceof Element)) return false;
      const rect = this.getBoundingClientRect();
      const vpH = window.innerHeight || document.documentElement.clientHeight;
      const vpW = window.innerWidth || document.documentElement.clientWidth;
      return (
        rect.bottom >= -m &&
        rect.right  >= -m &&
        rect.top    <= vpH + m &&
        rect.left   <= vpW + m
      );
    });
  };

  try {
    Object.defineProperty($.fn, 'exists', {
      configurable: true,
      get: function () { return this.length > 0; }
    });
  } catch (_) {}

  $.as$ = function (x) { return x && x.jquery ? x : $(x); };

  $.microUtils = { version: '0.1.1' };

}));
