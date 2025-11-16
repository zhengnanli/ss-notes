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

#pagebreak()
#include "intro.typ"
#pagebreak()
#include "lti.typ"
#pagebreak()
#include "random_process.typ"
#pagebreak()
#include "fourier_series.typ"
#pagebreak()
#include "ct_fourier_transform.typ"
#pagebreak()
#include "dt_fourier_transform.typ"
#pagebreak()
#include "sampling.typ"
#pagebreak()
#include "laplace.typ"
#pagebreak()
#include "math.typ"
