/*!
 * jQuery Micro Utils v0.1.2
 * Small, CDN-friendly helpers for efficient traversal & ergonomics.
 * (c) 2025 Answer.AI — MIT License
 */
(function (factory) {
  if (typeof define === 'function' && define.amd) { define(['jquery'], factory);
  } else if (typeof module === 'object' && module.exports) { module.exports = factory(require('jquery'));
  } else { factory(jQuery); }
}(function ($) {
  'use strict';

  if (!$?.fn) throw new Error('jquery-micro-utils requires jQuery to be loaded first.');

  function toPred(test) {
    if (typeof test === 'function') return test;
    if (typeof test === 'string' && test.trim()) { return el => el.matches(test); }
    return () => true;
  }

  function toUnq(nodes) { return $($.uniqueSort($.makeArray(nodes).filter(Boolean))); }

  function firstSibling(el, dir, pred) {
    while (el = el[dir]) { if (pred(el)) return el; }
  }

  function siblingMatch(set, dir, test) { return toUnq(set.map((_, el) => firstSibling(el, dir, toPred(test)))); }

  $.fn.nextMatch = function (selectorOrFn) { return siblingMatch(this, 'nextElementSibling', selectorOrFn); };
  $.fn.prevMatch = function (selectorOrFn) { return siblingMatch(this, 'previousElementSibling', selectorOrFn); };

  $.fn.findFirst = function(selector) {
    if (!selector?.trim()) return this.pushStack([]);
    return toUnq(this.map((_, el) => el.querySelector?.(selector)));
  };

  $.fn.containsText = function (query) {
    if (query == null) return this.pushStack([]);
    var isRegex = query instanceof RegExp;
    return this.filter(function () {
      var t = (this.textContent || '').trim();
      return isRegex ? query.test(t) : t.includes(String(query));
    });
  };

  $.fn.tap = function (fn) {
    fn?.(this);
    return this;
  };

  $.fn.inViewport = function (margin = 0) {
    var m = Number(margin) || 0;
    return this.filter(function () {
      if (!(this instanceof Element)) return false;
      var rect = this.getBoundingClientRect();
      return rect.bottom >= -m && 
             rect.right >= -m && 
             rect.top <= window.innerHeight + m && 
             rect.left <= window.innerWidth + m;
    });
  };

  $.as$ = x => x?.jquery ? x : $(x);
  $.microUtils = { version: '0.1.2' };

}));

