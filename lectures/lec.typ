#import "lib.typ": *

#show: template.with(
  title: [Signals and Systems],
  short_title: "Signals & Systems",
  description: [],
  date: datetime(year: 2025, month: 08, day: 20),
  authors: (
    (
      name: "Zhengnan Li",
      link: "https://zhengnanli.gitlab.io",
    ),
  ),

  // lof: true,
  // lot: true,
  // lol: true,
  // landscape: true,
  // bibliography_file: "refs.bib",
  paper_size: "us-letter",
  cols: 1,
  // text_font: "New Computer Modern Math",
  text_font: "STIX Two Text",
  code_font: "Cascadia Mono",
  accent: "#9E1B32",
  h1-prefix: "Topic",
  colortab: true,
)

#show selector(<nonumber>): set heading(numbering: none)

// The topics run on rather than each starting a fresh page: a page break before
// every topic left a blank tail on the last page of each one, about five pages
// across the document. What announces a new topic instead is the extra air
// above a level-1 heading, set in `template`, together with the running header,
// which names the topic in force at the foot of the page. The one page break
// kept is the one after the table of contents.
#pagebreak()
#include "intro.typ"
#include "lti.typ"
#include "random_process.typ"
#include "fourier_series.typ"
#include "ct_fourier_transform.typ"
#include "dt_fourier_transform.typ"
#include "sampling.typ"
#include "laplace.typ"
#include "math.typ"
