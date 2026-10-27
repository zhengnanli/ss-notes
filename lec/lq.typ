// Lilaq, with headroom over the y axis ================================
//
// The schoolbook style puts an arrow tip on the end of each spine, and an
// arrow whose point sits level with the tallest thing in the plot reads as
// a bar, not as an axis: see the growing exponential in Topic 1, whose
// curve used to run past the tip of the very axis it was drawn against.
//
// The tip is drawn at the upper y limit, so the only way to lift it clear
// of the data is to lift that limit. A figure that leaves `ylim` at `auto`
// gets this from lilaq's own `margin` (raised on the top side in
// `schoolbook-style`); a figure that states `ylim` explicitly is "tight"
// as far as lilaq is concerned and no margin is applied to it, which is
// most of the figures in these notes. So `diagram` below re-exports
// lilaq's with the upper y limit lifted by a fixed fraction of the range.
//
// This module re-exports the whole of lilaq and overrides that one name,
// which is why `lib.typ` imports it *as* `lq`: every existing
// `lq.diagram(...)`, `lq.plot(...)`, `lq.theme.schoolbook` call site keeps
// working untouched and picks the headroom up for free.
//
// Pass `headroom: 0%` at a call site that must keep its stated limits
// exactly, e.g. one whose y limits are quoted in the surrounding prose.

#import "@preview/lilaq:0.6.0": *
#import "@preview/lilaq:0.6.0" as _lq

// Fraction of the y range added above the data. Kept in step with the top
// `margin` set in `schoolbook-style`, so an explicit-limit figure and an
// automatic-limit one leave the same amount of air under the arrow.
#let y-headroom = 12%

#let lift-ylim(lim, headroom: y-headroom) = {
  if type(lim) != array or lim.len() != 2 { return lim }
  let (lo, hi) = lim
  // `auto` on either end means lilaq computes that end and applies its own
  // margin to it; leave those alone.
  if type(lo) not in (int, float) or type(hi) not in (int, float) { return lim }
  (lo, hi + (hi - lo) * headroom / 100%)
}

#let diagram(headroom: y-headroom, ..args) = {
  let named = args.named()
  if "ylim" in named {
    named.ylim = lift-ylim(named.ylim, headroom: headroom)
  }
  _lq.diagram(..args.pos(), ..named)
}
