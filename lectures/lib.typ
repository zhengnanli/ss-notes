// Adopted from: https://github.com/jskherman/jsk-lecnotes
// Shared with the companion Statistical Inference and Wireless Communication
// Systems notes, so that a reader moving between the three sees the same page
// furniture. The numerical helpers at the bottom are this course's own.

// Imports =============================================================

#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.10": codly-languages
#import "@preview/ctheorems:1.1.3": thmenv, thmrules
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/showybox:2.0.4": showybox
#import "@preview/tiptoe:0.4.0"
#import "@preview/whalogen:0.3.0": ce
#import "@preview/zap:0.5.0"

// Series palette =====================================================
// Categorical colors for the figures. Slot 1 is the document accent; the rest
// follow in a fixed order and are never cycled or reassigned by rank.
//
// This is the palette validated for the Wireless Communication Systems notes,
// carried over unchanged: worst adjacent separation under simulated
// deuteranopia is dE 10.0 against a target of 8, worst adjacent normal-vision
// separation is dE 17.4 against a floor of 15, and every slot clears 3:1
// contrast on white. Changing a slot means re-running that validation.
#let c-accent = rgb("#9E1B32") // slot 1, the document accent
#let c-blue = rgb("#2A6EBB") // slot 2
#let c-green = rgb("#1F6F45") // slot 3
#let c-orange = rgb("#C77C00") // slot 4
#let c-violet = rgb("#6B2E8F") // slot 5

// The fixed order, for figures that map a series list onto colors. This is also
// the diagram cycle installed in `template`, so the first curve in any diagram
// is the accent, the second is blue, and so on, with no per-figure setup.
#let series-colors = (c-accent, c-blue, c-green, c-orange, c-violet)

// Dash patterns, paired one-to-one with the palette and in the same order.
// A figure whose series differ only in color is unreadable on a monochrome
// printer and marginal for a colorblind reader, so every slot carries both.
// Use `series-stroke(i)` rather than picking a color by hand.
#let series-dash = (none, "dashed", "dotted", "dash-dotted", (6pt, 2pt, 1pt, 2pt))

#let series-stroke(i, thickness: 1.1pt) = (
  paint: series-colors.at(calc.rem(i, series-colors.len())),
  dash: series-dash.at(calc.rem(i, series-dash.len())),
  thickness: thickness,
)

// Ink for text and rules inside figures: annotations that label a curve take
// that curve's color, everything else takes one of these two. Period markers,
// axis guides, and the dashed lines that carry a tick label rather than data
// are `c-muted`, so they read as furniture and not as a sixth series.
#let c-ink = luma(20%) // axis annotations, reference lines
#let c-muted = luma(45%) // secondary marks, de-emphasized data

// Plotting Styles ====================================================

#let schoolbook-style = it => {
  let filter(value, distance) = value != 0 and distance >= 5pt
  let axis-args = (
    position: 0,
    filter: filter,
    format-ticks: none,
    tick-distance: 1000,
  )
  show: lq.set-tick(inset: 2pt, outset: 2pt, pad: 0em)
  show: lq.set-spine(tip: tiptoe.stealth, stroke: 0.5pt)
  show: lq.set-diagram(xaxis: axis-args, yaxis: axis-args)
  show: lq.set-grid(stroke: none)
  it
}

// Accessibility helpers ==============================================
// Wrap any block of visual content so the tagged PDF exposes alt text.
//
// With a caption the wrapper is a numbered figure, "Figure <topic>.<n>", using
// the numbering installed in `template`. With no caption it is visually
// invisible (no "Figure N", no counter bump) but the PDF structure tree still
// carries the alt string; that form is for a panel that is one cell of a larger
// figure, never for a figure in its own right.
// A schoolbook axis label is drawn *above* the diagram's layout box rather than
// inside it, so its ink escapes the figure and lands on whatever sits above. In
// running text the paragraph spacing hides that, but a figure at the top of a
// page, or at the top of a boxed environment that broke across a page, has its
// label sitting on the rule above it. A few points of headroom inside the
// figure give that ink somewhere to go.
#let _headroom(body) = pad(top: 5pt, body)

#let altfig(body, alt: "", caption: none) = if caption == none {
  figure(
    _headroom(body),
    alt: alt,
    caption: none,
    kind: image,
    supplement: none,
    numbering: none,
  )
} else {
  figure(_headroom(body), alt: alt, caption: caption, kind: image)
}

// Centered lilaq plot. Pass `alt:` and `caption:` to make it a numbered figure;
// pass neither to get a bare centered plot, which is what a panel inside a
// larger figure wants.
#let cdiagram(alt: none, caption: none, ..args) = {
  let default-args = (width: 8cm, height: 4cm)
  let merged-args = default-args + args.named()
  let body = align(center, lq.diagram(..merged-args, ..args.pos()))
  if alt == none and caption == none { body } else {
    altfig(alt: alt, caption: caption, body)
  }
}

// Wrap a block equation with alt text for tagged PDF.
// Usage: #eqalt("Sum from k=0 to N of x[k].", $ sum_(k=0)^N x[k] $)
#let eqalt(alt, body) = math.equation(block: true, alt: alt, body)

// An annotation placed inside a plot: one size down from the body text and in
// the figure ink, so it reads as part of the plot rather than as prose.
//
// The background is transparent. The companion notes knock a white box out
// behind such a label, because their plots carry a grid that would otherwise
// run through the letters. These plots do not: `schoolbook-style` switches the
// grid off, so the box has nothing to hide and instead punches a hole in
// whatever it sits on, which here means the shaded regions of the Laplace
// figures and the axis lines. Pass `background: white` at a call site that
// really does need to mask something.
#let plabel(body, fill: c-ink, size: 8pt, background: none) = box(
  fill: background,
  inset: if background == none { 0pt } else { (x: 2pt, y: 1pt) },
  text(size: size, fill: fill, body),
)

// Tick labels for a stacked column of `lq.diagram` panels. Only the bottom
// panel shows its x labels, but every panel must reserve the same horizontal
// space for them: the first and last labels overhang the plot frame, so a
// panel without them is narrower and `stack` centers it a couple of points off
// from the others. `hide` keeps the box and drops the ink.
#let shared-ticks(values, show-labels) = values.map(v => (
  v,
  if show-labels { [#v] } else { hide[#v] },
))

// Template ============================================================

#let template(
  // The title of the lecture notes
  title: "Lecture Notes Title",
  // The short_title is shown in the running header
  short_title: none, // string
  // The description of the lecture notes; is optional. Example:
  // description: [A template for lecture notes]
  description: none,
  // The date of the lecture notes; is optional. Example
  // datetime(year: 2020, month: 02, day: 02)
  date: none,
  // An array of authors. For each author you can specify a name, orcid, and affiliations.
  // affiliations should be content, e.g. "1", which is shown in superscript and should match the affiliations list.
  // Everything but the name is optional.
  authors: (
    // name: "",
    // link: ""
  ),
  // Enable/disable the list of figures, tables, and listings.
  lof: false,
  lot: false,
  lol: false,
  // The path to a bibliography file if you want to cite some external works.
  bibliography_file: none,
  // Citation style
  bibstyle: "apa",
  // The article's paper size. Also affects the margins.
  paper_size: "us-letter",
  // page orientation
  landscape: false,
  // The number of columns to be used in the page
  cols: 1,
  // The text and code font. Must be a valid font name.
  text_font: "Libertinus Serif",
  code_font: "DejaVu Sans Mono",
  // The color of the lecture notes' accent color. Must be a valid HEX color.
  accent: "#DC143C",
  h1-prefix: "Lecture",
  colortab: false,
  // Git version (manual override)
  git_version: none,
  // Auto fetch git info from sys.inputs
  auto_git: true,
  // Document language (BCP-47 tag); used for PDF/UA accessibility.
  lang: "en",
  // The lecture notes' content.
  body,
) = {
  // Necessary for ctheorems package
  show: thmrules

  // Every diagram draws its curves from the palette, in slot order, so that a
  // figure that adds a second curve gets the right color without touching the
  // call site. Dash patterns are not cycled here, since a stem plot or a set of
  // shifted copies of one signal must not pick up a dash it did not ask for;
  // reach for `series-stroke(i)` where a figure really carries several series.
  show: lq.set-diagram(cycle: series-colors)

  // Legends sit inside the plot area, so they must be opaque: lilaq's default
  // is transparent and the curves run straight through the entries. The thin
  // rule keeps the box from dissolving into the grid.
  show: lq.set-legend(
    fill: white,
    stroke: 0.4pt + luma(65%),
    radius: 1pt,
  )

  let accent_color = {
    if type(accent) == str {
      rgb(accent)
    } else if type(accent) == color {
      accent
    } else {
      rgb("#DC143C")
    }
  }

  // Fetch git version automatically if enabled
  let git_info = if auto_git and git_version == none {
    let hash = if "git-hash" in sys.inputs { sys.inputs.at("git-hash") } else {
      none
    }
    let date = if "git-date" in sys.inputs { sys.inputs.at("git-date") } else {
      none
    }

    if hash != none and date != none {
      hash + " (" + date + ")"
    } else if hash != none {
      hash
    } else if "git-version" in sys.inputs {
      sys.inputs.at("git-version")
    } else {
      none
    }
  } else {
    git_version
  }

  // Construct string title from title content
  let str_title = ""

  if type(title) == content and title.has("children") {
    for element in title.children {
      if element.has("text") {
        str_title = str_title + element.text + " "
      }
    }
  } else if type(title) == str {
    str_title = title
  }

  str_title = str_title.trim(" ")

  // Set document metadatra
  set document(title: str_title, author: authors.map(author => author.name))

  // Set the text and code font (lang drives PDF/UA tagging language)
  set text(font: text_font, size: 10pt, lang: lang)
  show raw: set text(size: 10pt)

  // Boxed environments break across pages, so a paragraph inside one can now
  // land on a page boundary. Price a single stranded line high enough that the
  // engine pulls a companion line along with it rather than leaving it alone at
  // the top or foot of a page.
  set text(costs: (orphan: 2000%, widow: 2000%, runt: 200%))

  // Make links blue and underlined. Disable for author list.
  show link: it => {
    let author_names = ()
    for author in authors {
      author_names.push(author.name)
    }

    if it.body.has("text") and it.body.text in author_names {
      it
    } else {
      underline(stroke: (dash: "densely-dotted"), offset: 2pt, text(
        fill: accent_color,
        it,
      ))
    }
  }

  // Configure the page.
  set page(
    paper: paper_size,
    columns: cols,
    flipped: landscape,
    numbering: "1",
    number-align: center,
    margin: (x: 1.5cm, y: 2cm),
    header: context {
      let elems = query(
        selector(heading.where(level: 1)).before(here()),
      )

      let head_title = text(fill: accent_color, {
        if short_title != none { short_title } else { str_title }
      })

      if elems.len() == 0 {
        align(right, "")
      } else {
        let current_heading = elems.last()

        let page_num = here().page()
        let headings_on_page = query(
          selector(heading.where(level: 1)),
        ).filter(h => h.location().page() == page_num)

        // Topics run on rather than starting a fresh page, so a page can carry
        // the end of one and the start of the next. The running head names the
        // topic in force at the *foot* of the page, which is the usual book
        // convention and the one a reader flipping backwards wants.
        if headings_on_page.len() > 0 {
          current_heading = headings_on_page.last()
        }
        if current_heading.numbering != none {
          let heading_number = counter(heading.where(level: 1))
            .at(current_heading.location())
            .first()
          (
            head_title
              + h(1fr)
              + emph(
                h1-prefix
                  + " "
                  + str(heading_number)
                  + ": "
                  + current_heading.body,
              )
          )
        } else {
          head_title + h(1fr) + emph(current_heading.body)
        }
        v(-6pt)
        line(length: 100%, stroke: (
          thickness: 1pt,
          paint: accent_color,
          dash: "solid",
        ))
      }
    },
    background: {
      if colortab {
        place(top + right, rect(
          fill: gradient.linear(angle: 45deg, white, accent_color),
          width: 100%,
          height: 1em,
        ))
      }

      if git_info != none {
        place(top + right, dx: -5pt, dy: 2pt)[
          #text(size: 7pt, fill: accent_color.lighten(10%), font: "DejaVu Sans Mono")[#git_info]
        ]
      }
    },
  )

  set text(10pt)

  // Equation numbering: (topic.eq), reset to 1 at every level-1 heading.
  set math.equation(numbering: (..nums) => {
    let h = counter(heading.where(level: 1)).get().first()
    let eq = nums.pos().first()
    numbering("(1.1)", h, eq)
  })

  // Figures, tables, and listings are numbered the same way, "Figure 4.2", so a
  // number read off the page says which topic it belongs to. Each kind counts
  // separately, and all of them restart with the topic.
  set figure(numbering: (..nums) => {
    let h = counter(heading.where(level: 1)).get().first()
    numbering("1.1", h, nums.pos().first())
  })

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  show math.equation: eq => {
    set block(spacing: 0.65em)
    eq
  }

  // Configure lists.
  set enum(indent: 0pt, body-indent: 6pt)
  set list(indent: 0pt, body-indent: 6pt)

  // The reference tables are long lists of one-line entries, so the default
  // 5pt of vertical cell padding adds up to a page of air across the document.
  // Horizontal padding is left alone; the columns need it to stay apart.
  set table(inset: (x: 5pt, y: 3.5pt))

  // Configure headings with subsection numbering up to level 3
  set heading(numbering: none) // Default: no numbering
  show heading.where(level: 1): set heading(numbering: (..nums) => (
    h1-prefix + " " + nums.pos().map(str).join(".") + ":"
  ))
  show heading.where(level: 2): set heading(numbering: "1.1")
  // show heading.where(level: 3): set heading(numbering: "1.1.1")
  // Level 4 and beyond will have no numbering

  show heading.where(body: [Contents]): set heading(numbering: none)
  show heading.where(body: [List of Figures]): set heading(numbering: none)
  show heading.where(body: [List of Tables]): set heading(numbering: none)
  show heading.where(body: [List of Listings]): set heading(numbering: none)
  show heading.where(body: [References]): set heading(numbering: none)

  // A heading is glued to whatever follows it, so it can never be left alone at
  // the foot of a page.
  show heading: set block(sticky: true)

  show heading: it => {
    it
    v(8pt, weak: true)
  }

  // A level-1 heading gets extra air above it, since it no longer has a page
  // break to announce it. `weak` so the space collapses at the top of a page.
  show heading.where(level: 1): it => {
    v(20pt, weak: true)
    it
  }

  // A level-1 heading is numbered "Topic 2:", so the default reference would
  // read "Section Topic 2:". Render cross-topic references as "Topic 2".
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading and el.level == 1 {
      let num = counter(heading.where(level: 1)).at(el.location()).first()
      link(el.location(), h1-prefix + " " + str(num))
    } else {
      it
    }
  }

  // Configure code blocks. codly's own block is breakable by default; what
  // stops a long listing from crossing a page is the `figure` wrapper, so that
  // is made breakable below.
  show: codly-init.with()
  codly(languages: codly-languages, breakable: true)

  show raw.where(block: false): it => box(
    fill: luma(236),
    inset: (x: 2pt),
    outset: (y: 3pt),
    radius: 1pt,
  )[#it]


  // Configure figures. Floats are deliberately off: the topics start on fresh
  // pages and the prose says "shown below" in about a dozen places, so a figure
  // that drifted to the top of the page would contradict the sentence that
  // introduces it. Turning floats on means rewriting those sentences first.
  // set figure(placement: auto)
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)

  // A caption is set a little smaller than the body, so that a figure and the
  // paragraph that discusses it are not competing for the reader's eye.
  show figure.caption: set text(size: 0.92em)

  // Figures sit closer to the text than Typst's default, and the caption closer
  // to the plot it belongs to. Most of the figures here are schoolbook-style
  // plots whose axes already carry a wide margin of their own, so the default
  // spacing reads as a hole in the page rather than as separation.
  show figure: set block(spacing: 1em)
  set figure(gap: 0.5em)

  // Listings: caption on top, so the file name is read before the code rather
  // than pages later, and the enclosing block breakable so a script longer than
  // a page continues onto the next instead of overflowing.
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set block(breakable: true)
  show figure.where(
    kind: raw,
  ): it => {
    v(0.5em)
    it
    v(0.5em)
  }

  // Create color tab at the upper right corner
  // Display the paper's title and description.
  align(center, [
    #set text(18pt, weight: "bold")
    #title
  ])
  if description != none {
    align(center, box(width: 90%)[
      #set text(size: 12pt, style: "italic")
      #description
    ])
  }
  v(0pt, weak: true)

  // Authors and affiliations
  align(center)[
    #if authors.len() > 0 {
      box(inset: (y: 10pt), {
        authors
          .map(author => {
            text(11pt, weight: "semibold")[
              #if "link" in author {
                [#link(author.link)[#author.name]]
              } else { author.name }]
          })
          .join(", ", last: {
            if authors.len() > 2 {
              ", and"
            } else {
              " and"
            }
          })
      })
    }
  ]
  v(6pt, weak: true)

  // Display the lecture notes' last updated date.
  if date != none {
    align(center, table(
      columns: (auto, auto),
      stroke: none,
      gutter: 0pt,
      align: (right, left),
      [#text(size: 11pt, "Published:")],
      [#text(
          size: 11pt,
          fill: accent_color,
          weight: "semibold",
          date.display(
            "[month repr:long] [day padding:zero], [year repr:full]",
          ),
        )
      ],

      text(size: 11pt, "Last updated:"),
      text(
        size: 11pt,
        fill: accent_color,
        weight: "semibold",
        datetime
          .today()
          .display("[month repr:long] [day padding:zero], [year repr:full]"),
      ),
    ))
  } else {
    align(
      center,
      text(size: 11pt)[Last updated:#h(5pt)]
        + text(
          size: 11pt,
          fill: accent_color,
          weight: "semibold",
          datetime
            .today()
            .display(
              "[month repr:long] [day padding:zero], [year repr:full]",
            ),
        ),
    )
  }
  v(18pt, weak: true)

  // pagebreak()

  show outline.entry: it => {
    text(fill: accent_color, it)
  }

  // Display the lecture notes' table of contents.
  heading(level: 1, outlined: false)[Contents]
  outline(indent: auto, title: none, depth: 2)

  if lof or lot or lol {
    show heading.where(level: 1): set text(size: 0.9em)
    if lof {
      v(4pt)
      heading(level: 1)[List of Figures]
      outline(
        indent: auto,
        title: none,
        target: figure.where(kind: image),
      )
    }

    if lot {
      v(4pt)
      heading(level: 1)[List of Tables]
      outline(
        indent: auto,
        title: none,
        target: figure.where(kind: table),
      )
    }

    if lol {
      v(4pt)
      heading(level: 1)[List of Listings]
      outline(
        indent: auto,
        title: none,
        target: figure.where(kind: raw),
      )
    }

    align(center)[#v(1em) * \* #sym.space.quad \* #sym.space.quad \* *]
  }

  v(2em, weak: true)

  // pagebreak()

  // Set paragraph to be justified and set linebreaks
  set par(justify: true, linebreaks: "optimized", leading: 0.8em)

  // Display the lecture notes' content.
  body

  v(24pt, weak: true)

  // Display bibliography.
  if bibliography_file != none {
    align(
      center,
    )[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]
    bibliography(bibliography_file, title: [References], style: bibstyle)
  }
}

// Functions ===========================================================

// Code listings ======================================================
// The MATLAB reference scripts under matlab/ can be embedded in the notes, but
// are suppressed by default: they add a great many pages and the scripts are
// better read in an editor than on paper. Flip this to `true` in lec.typ to
// print them all, or pass `force: true` to one call site to print just that one.
//
// A printed listing is breakable (see the figure show rules in `template`), so a
// script longer than a page continues onto the next.
#let show-listings = state("show-listings", false)

// Embed one script. `path` is relative to lec/, since that is where this file
// lives and therefore what `read` resolves against.
#let listing(path, lang: "matlab", caption: auto, force: false) = context {
  if force or show-listings.get() {
    figure(
      raw(read(path), lang: lang, block: true),
      caption: if caption == auto { raw(path) } else { caption },
      kind: raw,
      supplement: [Listing],
    )
  }
}

// Configure blockquotes.
#let blockquote(cite: none, body) = [
  #set text(size: 0.97em)
  #pad(left: 1.5em)[
    #block(
      breakable: true,
      width: 100%,
      fill: gray.lighten(90%),
      radius: (left: 0pt, right: 5pt),
      stroke: (left: 5pt + gray, rest: 1pt + silver),
      inset: 1em,
    )[#body]
  ]
]


// Configure horizontal ruler
#let horizontalrule = {
  v(1em)
  line(start: (37%, 0%), end: (63%, 0%), stroke: stroke((
    thickness: 0.5pt,
    dash: "solid",
  )))
  v(1em)
}

// Configure alternative horizontal ruler
#let sectionline = align(
  center,
)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]

// Attempt to add \boxed{} command from LaTeX
#let dboxed(content) = {
  box(
    stroke: 0.5pt + black,
    outset: (x: 1pt, y: 8pt),
    inset: (x: 2pt, y: 1pt),
    baseline: 6pt,
    $display(#content)$,
  )
}

#let iboxed(content) = {
  box(
    stroke: 0.5pt + black,
    outset: (x: 1pt, y: 3pt),
    inset: (x: 2pt, y: 1pt),
    baseline: 1pt,
    $#content$,
  )
}

// Nice boxes using showybox and ctheorems packages =================

#let boxnumbering = "1.1"
#let boxcounting = "heading"

// Factory: produce a thmenv-backed showybox environment. `title-light`
// controls how much the title bar is lightened (hypothesis uses 10%
// for a more saturated header; everything else uses 30%).
#let _thmbox(envname, label, color, title-light: 30%) = thmenv(
  envname,
  boxcounting,
  1,
  (name, number, body, ..args) => {
    // Glue the title bar to the start of the body. showybox renders the title
    // as its own block, so a breakable box is free to split straight after it
    // and leave a coloured header stranded alone at the foot of a page. The
    // title block is the only one filled with the title colour, which is what
    // makes it targetable from out here.
    show block.where(fill: color.lighten(title-light)): set block(sticky: true)
    showybox(
    // Breakable, so a box that does not fit continues onto the next page
    // instead of jumping to it whole and leaving most of the current page
    // blank. Pass `breakable: false` at a call site for a box that has to stay
    // in one piece.
    breakable: true,
    // The environment name and number are furniture: a reader who is already
    // looking at the box knows it is an example. Setting them at partial
    // opacity keeps them legible for a cross-reference without competing with
    // the title, which is the part that says what the box is about.
    title: [
      *#name* #h(1fr) #text(fill: white.transparentize(45%))[#label #number]
    ],
    frame: (
      border-color: color,
      title-color: color.lighten(title-light),
      // No wash behind the body. The border and the title bar already say where
      // the box starts and stops, and a tint underneath a page of equations
      // mostly costs contrast. The title bar keeps its fill because the title
      // is set in white and would otherwise vanish.
      body-color: white,
      footer-color: white,
    ),
    ..args.named(),
    body,
    )
  },
).with(numbering: boxnumbering)

#let definition  = _thmbox("Definition",  "Definition",  olive)
#let example     = _thmbox("example",     "Example",     orange)
#let note        = _thmbox("note",        "Note",        blue)
#let attention   = _thmbox("attention",   "Attention",   rgb("#DC143C"))
#let quote       = _thmbox("quote",       "Quote",       black)
#let theorem     = _thmbox("theorem",     "Theorem",     navy)
#let proposition = _thmbox("Proposition", "Proposition", maroon)
#let hypothesis  = _thmbox("hypothesis",  "Hypothesis",  orange, title-light: 10%)

// An aside: a piece of background needed for the next step but not part of the
// main thread. The violet palette slot, so it reads as a print tone rather than
// as Typst's built-in `purple`, which lightens to a hot magenta.
#let sidenote    = _thmbox("sidenote",    "Detour",      c-violet)

// Notation helpers ====================================================
// The transform-pair relations. Written out in full, a Fourier series pair is
// `limits(arrow.l.r)^(cal("FS"))`, which appears often enough that spelling it
// out obscures the equations, and which was written three different ways across
// the topic files before these were factored out.
#let fspair = $limits(arrow.l.r)^(cal("F S"))$
#let ftpair = $limits(arrow.l.r)^(cal("F"))$
#let lpair = $limits(arrow.l.r)^(cal("L"))$

// Numerical helpers ===================================================
// These exist so that the figures can be computed from the same formulas that
// appear in the text, rather than from data pasted in from elsewhere.

// The two conventions the notes use side by side, with the removable
// singularity at the origin filled in. A hand-rolled `sin(pi x) / (pi x)` in a
// topic file divides by zero the moment a sample grid happens to land on it.
#let sinc(x) = if calc.abs(x) < 1e-9 { 1.0 } else {
  calc.sin(calc.pi * x) / (calc.pi * x)
}

#let sa(x) = if calc.abs(x) < 1e-9 { 1.0 } else { calc.sin(x) / x }

// Fourier series coefficients of the periodic square wave, in both the
// continuous-time and the discrete-time form. The figures that show a partial
// sum converging must evaluate the same expression the text derives, so both
// live here rather than being re-typed at each call site.
//
// CT: one period is 1 for |t| < T1 and 0 out to |t| = T / 2, so
//   a_k = sin(k omega_0 T1) / (k pi),  a_0 = 2 T1 / T.
#let ct-square-ak(k, period: 1.0, half-width: 0.3) = {
  if k == 0 { 2 * half-width / period } else {
    calc.sin(2 * calc.pi * k * half-width / period) / (k * calc.pi)
  }
}

// DT: one period is 1 for |n| <= N1 out of N samples, so
//   a_k = sin(2 pi k (N1 + 1/2) / N) / (N sin(pi k / N)),
// which is (2 N1 + 1) / N at k = 0 and at every multiple of N, where the
// quotient is 0/0.
#let dt-square-ak(k, N: 9, N1: 2) = {
  if calc.rem(k, N) == 0 { (2 * N1 + 1) / N } else {
    (
      calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
        / (N * calc.sin(calc.pi * k / N))
    )
  }
}
