#import "lib.typ": *

= The z-Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

// z-plane helpers =====================================================
// A pole-zero plot in the z-plane: the unit circle dashed, the ROC shaded as
// a disc, a ring, or the exterior of a circle, poles as crosses and zeros as
// circles, drawn the same way as the s-plane plots in the Laplace topic.
// `roc: (r-in, r-out)` shades r-in < |z| < r-out; `r-out: none` means the ROC
// runs out to infinity. The plot is square with equal limits on both axes, so
// that circles come out round.
// Tick (value, label) pairs from bare values.
#let lbl(vals) = vals.map(v => (v, $#v$))
#let roc-fill = c-blue.lighten(72%)
#let pz-mark(sym) = mark => place(center + horizon, text(mark.fill)[#sym])
#let zplane(
  poles: (),
  zeros: (),
  roc: none,
  lim: 1.6,
  ticks: (-1, 1),
  size: 4.2cm,
  ..extra,
) = {
  let shapes = ()
  if roc != none {
    let (r-in, r-out) = roc
    if r-out == none {
      shapes.push(lq.rect(
        -2 * lim,
        -2 * lim,
        width: 4 * lim,
        height: 4 * lim,
        fill: roc-fill,
        stroke: none,
      ))
    } else {
      shapes.push(lq.ellipse(
        0,
        0,
        width: 2 * r-out,
        height: 2 * r-out,
        align: center + horizon,
        fill: roc-fill,
        stroke: none,
      ))
    }
    if r-in > 0 {
      shapes.push(lq.ellipse(
        0,
        0,
        width: 2 * r-in,
        height: 2 * r-in,
        align: center + horizon,
        fill: white,
        stroke: none,
      ))
    }
  }
  let marks = ()
  if zeros.len() > 0 {
    marks.push(lq.scatter(
      zeros.map(p => p.at(0)),
      zeros.map(p => p.at(1)),
      mark: pz-mark($circle$),
    ))
  }
  if poles.len() > 0 {
    marks.push(lq.scatter(
      poles.map(p => p.at(0)),
      poles.map(p => p.at(1)),
      mark: pz-mark($times$),
    ))
  }
  lq.diagram(
    xlabel: $Re$,
    ylabel: $Im$,
    width: size,
    height: size,
    headroom: 0%,
    xlim: (-lim, lim),
    ylim: (-lim, lim),
    // Ticks given as (value, label) pairs: the schoolbook style prints no
    // labels for bare numeric ticks.
    xaxis: (ticks: lbl(ticks), subticks: none),
    yaxis: (ticks: lbl(ticks), subticks: none),
    ..shapes,
    lq.ellipse(
      0,
      0,
      width: 2,
      height: 2,
      align: center + horizon,
      fill: none,
      stroke: (paint: c-muted, dash: "dashed", thickness: 0.6pt),
    ),
    ..marks,
    ..extra.pos(),
  )
}

// One panel of a multi-panel figure: captioned "(a)", "(b)", ... but not a
// numbered figure of its own.
#let panel(body, cap) = figure(
  body,
  caption: cap,
  supplement: none,
  numbering: none,
)

// Distance from e^(j w) to the point r e^(j theta), the length of the vector
// used in the geometric evaluation of a frequency response.
#let vec-len(w, r, theta) = calc.sqrt(1 - 2 * r * calc.cos(w - theta) + r * r)

In the topic on Fourier series, we saw that the response of a discrete-time LTI system with impulse response $h[n]$ to a complex exponential input $z^n$ is
$
  y[n] = H(z) z^n
$
where
$
  H(z) = sum_(k = -infinity)^infinity h[k] z^(-k)
$
For $|z| = 1$, that is $z = e^(j omega)$, this sum is the discrete-time Fourier transform of $h[n]$. For general complex $z$, it is the _z-transform_. The z-transform does for discrete-time signals and systems what the Laplace transform does for continuous-time ones: it handles signals whose DTFT does not exist, such as growing exponentials, and it turns difference equations into algebra.

#definition("The z-Transform")[
  The z-transform of a discrete-time signal $x[n]$ is defined as
  #eqalt(
    "Capital X of z equals the sum over all integers n of x of n times z to the minus n.",
    $
      X(z) = sum_(n = -infinity)^infinity x[n] z^(-n)
    $,
  ) <ztransform>
  where $z$ is a complex variable. We denote the transform in operator form as $cal(Z){x[n]}$, and the transform relationship as $x[n] #zpair X(z)$. Writing $z$ in polar form, $z = r e^(j omega)$,
  $
    X(r e^(j omega)) = sum_(n = -infinity)^infinity (x[n] r^(-n)) e^(-j omega n) = cal(F){x[n] r^(-n)}
  $
  so the z-transform is the DTFT of $x[n]$ weighted by the real exponential $r^(-n)$. In particular, on the unit circle $r = 1$,
  $
    X(z)lr(|, size: #100%)_(z = e^(j omega)) = X(e^(j omega)) = cal(F){x[n]}
  $
]

The unit circle $|z| = 1$ plays the role in the z-plane that the $j omega$-axis plays in the s-plane. As with the Laplace transform, the sum in @ztransform converges only for some values of $z$, and this set is called the _region of convergence_ (ROC). A z-transform is specified by its algebraic expression *and* its ROC.

#example("z-Transform and Fourier Transform")[
  Let $x[n] = a^n u[n]$. Then
  $
    X(z) = sum_(n = -infinity)^infinity a^n u[n] z^(-n) = sum_(n = 0)^infinity (a z^(-1))^n
  $
  This geometric series converges if and only if $|a z^(-1)| < 1$, that is, $|z| > |a|$. Its sum follows from a short trick: if $S = 1 + q + q^2 + dots.c$ with $|q| < 1$, then $q S = S - 1$, so $S = 1 \/ (1 - q)$. Hence
  $
    a^n u[n] #zpair 1 / (1 - a z^(-1)) = z / (z - a), quad |z| > |a|
  $
  $X(z)$ has a zero at $z = 0$ and a pole at $z = a$, and the ROC is the exterior of the circle through the pole. If $|a| < 1$, the ROC contains the unit circle and the DTFT exists, in agreement with the topic on the DTFT. For $a = 1$, $x[n]$ is the unit step and $u[n] #zpair 1 \/ (1 - z^(-1))$, $|z| > 1$.

  Now let $x[n] = -a^n u[-n - 1]$, which is nonzero only for $n <= -1$. Then
  $
    X(z) = -sum_(n = -infinity)^(-1) a^n z^(-n) = -sum_(m = 1)^infinity (a^(-1) z)^m = 1 - sum_(m = 0)^infinity (a^(-1) z)^m
  $
  which converges if $|a^(-1) z| < 1$, that is, $|z| < |a|$. Then
  $
    X(z) = 1 - 1 / (1 - a^(-1) z) = (-a^(-1) z) / (1 - a^(-1) z) = z / (z - a)
  $
  or
  $
    -a^n u[-n - 1] #zpair 1 / (1 - a z^(-1)) = z / (z - a), quad |z| < |a|
  $
  The two signals have *the same* algebraic expression. Only the ROC, shown in @fig-z-roc1, tells them apart.
] <ex-z-fourier>

#altfig(
  placement: auto,
  alt: "Two pole-zero plots in the z-plane for X of z equals z over z minus a with a equal to 0.8. Both show a zero at the origin, a pole at z equals 0.8, and the unit circle dashed. Panel (a) shades the exterior of the circle of radius 0.8, the ROC of the right-sided signal a to the n u of n. Panel (b) shades the disc of radius 0.8, the ROC of the left-sided signal minus a to the n u of minus n minus one.",
  caption: [
    One expression, $X(z) = z \/ (z - a)$ with $a = 0.8$, and two ROCs:
    $|z| > a$ for the right-sided $a^n u[n]$ (a) and $|z| < a$ for the
    left-sided $-a^n u[-n-1]$ (b). The dashed curve is the unit circle.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1em,
      panel(
        zplane(
          poles: ((0.8, 0),),
          zeros: ((0, 0),),
          roc: (0.8, none),
          lq.place(0.8, 0.12, align: center + bottom, plabel[$a$]),
        ),
        [(a) $|z| > a$],
      ),
      panel(
        zplane(
          poles: ((0.8, 0),),
          zeros: ((0, 0),),
          roc: (0, 0.8),
          lq.place(0.8, 0.12, align: center + bottom, plabel[$a$]),
        ),
        [(b) $|z| < a$],
      ),
    )
  ],
) <fig-z-roc1>

#example("Examples of z-Transforms")[
  Consider the sum of two right-sided exponentials,
  $
    x[n] = 7 (1/3)^n u[n] - 6 (1/2)^n u[n]
  $
  From @ex-z-fourier,
  $
    7 (1/3)^n u[n] & #zpair 7 / (1 - 1/3 z^(-1)), & |z| > 1/3 \
    6 (1/2)^n u[n] & #zpair 6 / (1 - 1/2 z^(-1)), & |z| > 1/2
  $
  Both sums converge where both ROCs overlap, $|z| > 1/2$, so
  $
    X(z) = 7 / (1 - 1/3 z^(-1)) - 6 / (1 - 1/2 z^(-1)) = (1 - 3/2 z^(-1)) / ((1 - 1/3 z^(-1))(1 - 1/2 z^(-1))) = (z (z - 3/2)) / ((z - 1/3)(z - 1/2)), quad |z| > 1/2
  $
  The zeros are at $z = 0$ and $z = 3/2$, the poles at $z = 1/3$ and $z = 1/2$. Writing $X(z)$ in positive powers of $z$, as in the last form, is the easiest way to read off the poles and zeros. The ROC, the exterior of the circle through the outermost pole, contains the unit circle, so $x[n]$ also has a DTFT. @fig-z-roc2 shows the pole-zero plot.

  #altfig(
    alt: "Pole-zero plot in the z-plane with zeros at the origin and at z equals 1.5, poles at z equals one third and one half, the unit circle dashed, and the exterior of the circle of radius one half shaded as the region of convergence.",
    caption: [
      Pole-zero plot of $X(z)$. The ROC $|z| > 1/2$ lies outside the outermost
      pole and contains the unit circle.
    ],
    align(center)[
      #zplane(
        poles: ((1 / 3, 0), (0.5, 0)),
        zeros: ((0, 0), (1.5, 0)),
        roc: (0.5, none),
        lim: 2,
        lq.place(1.5, 0.15, align: center + bottom, plabel[$3/2$]),
      )
    ],
  ) <fig-z-roc2>
]

== The Region of Convergence for the z-Transform <sec-z-roc>

The ROC has a small number of properties, and together they pin it down from the pole-zero plot and a little knowledge of the signal.

+ *The ROC is a ring in the z-plane centered at the origin.* By the definition, $X(r e^(j omega))$ converges when $x[n] r^(-n)$ is absolutely summable, and that depends only on $r = |z|$, not on the angle of $z$.
+ *The ROC contains no poles.* At a pole, $X(z)$ is infinite, so the sum cannot converge there.
+ *If $x[n]$ has finite duration, the ROC is the entire z-plane, except possibly $z = 0$ and/or $z = infinity$.* A finite sum of terms $x[n] z^(-n)$ is finite unless one of them blows up. Terms with $n > 0$ blow up at $z = 0$, and terms with $n < 0$ blow up at $z = infinity$. For example,
  $
    delta[n] #zpair 1 "(all" z")", quad delta[n - 1] #zpair z^(-1) "(" z != 0")", quad delta[n + 1] #zpair z "(" z != infinity")"
  $
+ *If $x[n]$ is right-sided and the circle $|z| = r_0$ is in the ROC, then all finite $|z| > r_0$ are in the ROC.* For $|z| > r_0$, each term $x[n] z^(-n)$ with $n > 0$ is smaller in magnitude than at $r_0$. In addition, a right-sided signal is causal exactly when the ROC also includes $z = infinity$.
+ *If $x[n]$ is left-sided and the circle $|z| = r_0$ is in the ROC, then all $0 < |z| < r_0$ are in the ROC.*
+ *If $x[n]$ is two-sided and the circle $|z| = r_0$ is in the ROC, then the ROC is a ring that contains $|z| = r_0$.* The right-sided part converges outside some circle and the left-sided part inside another, and the ROC is the overlap.
+ *If $X(z)$ is rational, the ROC is bounded by poles or extends to $0$ or $infinity$.* For a right-sided signal it is the exterior of the circle through the outermost pole, and for a left-sided signal the interior of the circle through the innermost nonzero pole.
+ *The DTFT of $x[n]$ exists if and only if the ROC contains the unit circle.* On the unit circle, convergence of the sum in @ztransform is absolute summability of $x[n]$.

#example("A Two-Sided Signal")[
  Let $x[n] = b^(|n|)$ with $b > 0$. Split it into a right-sided and a left-sided part,
  $
    x[n] = b^n u[n] + b^(-n) u[-n - 1]
  $
  From @ex-z-fourier, with $a = b$ and $a = 1 \/ b$ respectively,
  $
    b^n u[n] & #zpair 1 / (1 - b z^(-1)), & |z| > b \
    b^(-n) u[-n - 1] & #zpair -1 / (1 - b^(-1) z^(-1)), & |z| < 1 / b
  $
  If $b < 1$, the two ROCs overlap in the ring $b < |z| < 1 \/ b$ and
  $
    X(z) = 1 / (1 - b z^(-1)) - 1 / (1 - b^(-1) z^(-1)) = (b^2 - 1) / b dot.c z / ((z - b)(z - 1 \/ b)), quad b < |z| < 1 / b
  $
  If $b >= 1$, the two ROCs do not overlap, and $x[n]$ has no z-transform at all, even though each of its two parts has one. @fig-z-roc3 shows the case $b = 1/2$. The ring contains the unit circle, consistent with $b^(|n|)$ being absolutely summable.

  #altfig(
    alt: "Pole-zero plot in the z-plane with a zero at the origin, poles at z equals one half and z equals two, the unit circle dashed, and the ring between radius one half and radius two shaded as the region of convergence.",
    caption: [
      $x[n] = (1/2)^(|n|)$: poles at $1/2$ and $2$, and the ROC is the ring
      $1/2 < |z| < 2$ between them, which contains the unit circle.
    ],
    align(center)[
      #zplane(
        poles: ((0.5, 0), (2, 0)),
        zeros: ((0, 0),),
        roc: (0.5, 2),
        lim: 2.5,
        ticks: (-2, -1, 1, 2),
      )
    ],
  ) <fig-z-roc3>
]

== The Inverse z-Transform

#note("(optional) The Inversion Integral")[
  As in the inverse Laplace transform, the DTFT interpretation of the z-transform gives an inversion formula. For a fixed $r$ with $|z| = r$ in the ROC, $X(r e^(j omega)) = cal(F){x[n] r^(-n)}$, so by the inverse DTFT
  $
    x[n] r^(-n) = 1 / (2 pi) integral_(2 pi) X(r e^(j omega)) e^(j omega n) "d"omega quad => quad x[n] = 1 / (2 pi) integral_(2 pi) X(r e^(j omega)) (r e^(j omega))^n "d"omega
  $
  Changing the variable of integration to $z = r e^(j omega)$, with $"d"z = j z "d"omega$, turns the integral over one period of $omega$ into a counterclockwise trip around the circle $|z| = r$:
  $
    x[n] = 1 / (2 pi j) integral.cont X(z) z^(n - 1) "d"z
  $
  The integral can be evaluated with the residue theorem from complex analysis. For the rational transforms in this course, the two methods below are all we need.
]

=== Partial-Fraction Expansion

For a rational $X(z)$ with distinct poles $a_1, dots.c, a_m$, write it as a sum of first-order terms in $z^(-1)$,
$
  X(z) = sum_(i = 1)^m A_i / (1 - a_i z^(-1))
$
plus, if the numerator order in $z^(-1)$ is not lower than the denominator order, a polynomial in $z^(-1)$ found by long division. Each first-order term inverts by @ex-z-fourier, and the ROC decides which way:
$
  A_i / (1 - a_i z^(-1)) quad <-- quad cases(
    A_i a_i^n u[n] & "if the ROC is outside the pole," |z| > |a_i|,
    -A_i a_i^n u[-n - 1] & "if the ROC is inside the pole," |z| < |a_i|
  )
$

#example("Inverse z-Transform: Partial Fractions")[
  Let
  $
    X(z) = (3 - 5/6 z^(-1)) / ((1 - 1/4 z^(-1))(1 - 1/3 z^(-1)))
  $
  The partial-fraction expansion is
  $
    X(z) = 1 / (1 - 1/4 z^(-1)) + 2 / (1 - 1/3 z^(-1))
  $
  The poles are at $1/4$ and $1/3$, so there are three possible ROCs, and three different signals with this $X(z)$.

  - $|z| > 1/3$: the ROC is outside both poles, and both terms are right-sided:
    $
      x[n] = (1/4)^n u[n] + 2 (1/3)^n u[n]
    $
  - $1/4 < |z| < 1/3$: the ROC is outside the pole at $1/4$ and inside the pole at $1/3$:
    $
      x[n] = (1/4)^n u[n] - 2 (1/3)^n u[-n - 1]
    $
  - $|z| < 1/4$: the ROC is inside both poles, and both terms are left-sided:
    $
      x[n] = -(1/4)^n u[-n - 1] - 2 (1/3)^n u[-n - 1]
    $

  This mirrors the Laplace example with $1 \/ ((s + 1)(s + 2))$ and its three ROCs.
]

=== Power-Series Expansion

By @ztransform, $x[n]$ is the coefficient of $z^(-n)$ when $X(z)$ is written as a power series. For a finite-duration signal, the power series can be read off directly. For example, if
$
  X(z) = 4 z^2 + 2 + 3 z^(-1), quad 0 < |z| < infinity
$
then $x[n] = 4 delta[n + 2] + 2 delta[n] + 3 delta[n - 1]$.

For a rational $X(z)$, long division produces the power series, one term at a time. The ROC tells us which way to divide.

#example("Inverse z-Transform: Long Division")[
  Let $X(z) = 1 \/ (1 - a z^(-1))$.

  If $|z| > |a|$, the signal is right-sided, and we divide so as to get decreasing powers of $z$, that is, a series in $z^(-1)$:
  $
    1 / (1 - a z^(-1)) = 1 + a z^(-1) + a^2 z^(-2) + dots.c quad => quad x[n] = a^n u[n]
  $
  If $|z| < |a|$, the signal is left-sided, and we divide so as to get a series in positive powers of $z$. Write the denominator as $-a z^(-1) + 1$ and divide:
  $
    1 / (-a z^(-1) + 1) = -a^(-1) z - a^(-2) z^2 - a^(-3) z^3 - dots.c quad => quad x[n] = -a^n u[-n - 1]
  $
  Long division is convenient for the first few samples of a signal. It rarely gives a closed form, which is what the partial-fraction method is for.

  Power series also handle transforms that are not rational. Let $X(z) = log(1 + a z^(-1))$ with $|z| > |a|$. Using the Taylor series $log(1 + v) = sum_(n = 1)^infinity (-1)^(n + 1) v^n \/ n$ for $|v| < 1$,
  $
    X(z) = sum_(n = 1)^infinity (-1)^(n + 1) a^n / n z^(-n) quad => quad x[n] = (-1)^(n + 1) a^n / n u[n - 1]
  $
]

== (optional) Geometric Evaluation of the Fourier Transform from the Pole-Zero Plot

A rational transform factors as
$
  X(z) = K (product_k (z - c_k)) / (product_k (z - d_k))
$
with zeros $c_k$ and poles $d_k$. On the unit circle, each factor $e^(j omega) - c_k$ is the vector from the zero $c_k$ to the point $e^(j omega)$, and similarly for the poles. Hence
$
  |X(e^(j omega))| = |K| (product_k |e^(j omega) - c_k|) / (product_k |e^(j omega) - d_k|), quad angle X(e^(j omega)) = angle K + sum_k angle(e^(j omega) - c_k) - sum_k angle(e^(j omega) - d_k)
$
As $omega$ goes from $0$ to $pi$, the point $e^(j omega)$ walks along the upper half of the unit circle. The magnitude is large when the point passes close to a pole and small when it passes close to a zero. A zero *on* the unit circle forces $|X(e^(j omega))| = 0$ at that frequency.

#example("A First-Order System")[
  Let $H(z) = 1 \/ (1 - a z^(-1)) = z \/ (z - a)$ with $0 < a < 1$. The zero is at the origin, so its vector always has length $1$, and
  $
    |H(e^(j omega))| = 1 / (|e^(j omega) - a|) = 1 / sqrt(1 - 2 a cos omega + a^2)
  $
  At $omega = 0$, the point $e^(j omega) = 1$ is closest to the pole and $|H| = 1 \/ (1 - a)$. At $omega = pi$, it is farthest away and $|H| = 1 \/ (1 + a)$. The system is a low-pass filter, and the closer $a$ is to $1$, the sharper the peak. With $-1 < a < 0$, the pole sits on the negative real axis and the system is high-pass. @fig-z-geom shows the vectors and the resulting magnitude for $a = 0.6$.
]

#[
#let a = 0.6
#let w0 = 1.1
#let ws = lq.linspace(0, calc.pi, num: 200)
#altfig(
  placement: auto,
  alt: "Left: z-plane with the unit circle, a zero at the origin and a pole at z equals 0.6. A point on the unit circle at angle omega equal to about 1.1 radians is joined by an arrow from the zero (of length one) and an arrow from the pole. Right: the magnitude of H of e to the j omega for omega from 0 to pi, falling from 2.5 at omega equals 0 to 0.625 at omega equals pi.",
  caption: [
    Geometric evaluation for $H(z) = z \/ (z - 0.6)$. The magnitude response is
    the reciprocal of the length of the vector from the pole to $e^(j omega)$
    (left), which is shortest at $omega = 0$, so the response peaks there
    (right).
  ],
  align(center)[
    #grid(
      columns: (1fr, 1.4fr),
      column-gutter: 1em,
      align: horizon,
      zplane(
        poles: ((a, 0),),
        zeros: ((0, 0),),
        lim: 1.4,
        lq.line(
          (0, 0),
          (calc.cos(w0), calc.sin(w0)),
          stroke: c-green,
          tip: tiptoe.stealth,
        ),
        lq.line(
          (a, 0),
          (calc.cos(w0), calc.sin(w0)),
          stroke: c-accent,
          tip: tiptoe.stealth,
        ),
        lq.place(
          calc.cos(w0) + 0.05,
          calc.sin(w0) + 0.15,
          align: left,
          plabel[$e^(j omega)$],
        ),
      ),
      lq.diagram(
        width: 6cm,
        height: 4cm,
        xlabel: $omega$,
        ylabel: $|H(e^(j omega))|$,
        xlim: (0, 3.4),
        ylim: (0, 2.8),
        xaxis: (
          ticks: ((0, $0$), (calc.pi / 2, $pi/2$), (calc.pi, $pi$)),
          subticks: none,
        ),
        yaxis: (ticks: lbl((1, 2)), subticks: none),
        lq.plot(ws, ws.map(w => 1 / vec-len(w, a, 0)), mark: none),
      ),
    )
  ],
) <fig-z-geom>
]

#example("Zeros of the Moving-Average Filter")[
  The $M$-point moving average $y[n] = 1/M sum_(k = 0)^(M - 1) x[n - k]$ has
  $
    H(z) = 1 / M sum_(k = 0)^(M - 1) z^(-k) = 1 / M (1 - z^(-M)) / (1 - z^(-1)) = 1 / M (z^M - 1) / (z^(M - 1) (z - 1))
  $
  The numerator $z^M - 1$ vanishes at the $M$th roots of unity $e^(j 2 pi k \/ M)$, $k = 0, dots.c, M - 1$. The root at $z = 1$ cancels the factor $z - 1$ in the denominator, which leaves $M - 1$ zeros evenly spaced on the unit circle and $M - 1$ poles at the origin. Like every FIR filter, the moving average has all its poles at $z = 0$ and is therefore always stable.

  Each zero on the unit circle produces a null in the magnitude response, at $omega = 2 pi k \/ M$, $k = 1, dots.c, M - 1$. Between the nulls, the response rises into the side lobes of
  $
    |H(e^(j omega))| = lr(|(sin(M omega \/ 2)) / (M sin(omega \/ 2))|)
  $
  @fig-z-ma shows the case $M = 8$.

  #let M = 8
  #let ws = lq.linspace(0.0001, calc.pi, num: 400)
  #altfig(
    alt: "Left: z-plane for the 8-point moving-average filter, with seven zeros evenly spaced on the unit circle at angles that are multiples of pi over 4, excluding angle zero, and a pole of order seven at the origin. Right: the magnitude response from omega equals 0 to pi, equal to one at omega equals 0 and touching zero at omega equals pi over 4, pi over 2, 3 pi over 4 and pi.",
    caption: [
      The 8-point moving average: seven zeros on the unit circle and seven
      poles at the origin (left). The magnitude response is zero wherever
      $e^(j omega)$ passes through a zero (right).
    ],
    align(center)[
      #grid(
        columns: (1fr, 1.4fr),
        column-gutter: 1em,
        align: horizon,
        zplane(
          poles: ((0, 0),),
          zeros: range(1, M).map(k => (
            calc.cos(2 * calc.pi * k / M),
            calc.sin(2 * calc.pi * k / M),
          )),
          lim: 1.4,
          lq.place(0.18, 0.28, align: left, plabel[$7$]),
        ),
        lq.diagram(
          width: 6cm,
          height: 4cm,
          xlabel: $omega$,
          ylabel: $|H(e^(j omega))|$,
          xlim: (0, 3.4),
          ylim: (0, 1.1),
          xaxis: (
            ticks: (
              (0, $0$),
              (calc.pi / 4, $pi/4$),
              (calc.pi / 2, $pi/2$),
              (3 * calc.pi / 4, $(3pi)/4$),
              (calc.pi, $pi$),
            ),
            subticks: none,
          ),
          yaxis: (ticks: lbl((0.5, 1)), subticks: none),
          lq.plot(
            ws,
            ws.map(w => calc.abs(calc.sin(M * w / 2) / (M * calc.sin(w / 2)))),
            mark: none,
          ),
        ),
      )
    ],
  ) <fig-z-ma>
]

== Properties of the z-Transform <sec-z-properties>

The properties of the z-transform parallel those of the DTFT and the Laplace transform, each with a statement about the ROC. Throughout, let
$
  x[n] #zpair X(z), quad z in R, quad quad x_1 [n] #zpair X_1 (z), quad z in R_1, quad quad x_2 [n] #zpair X_2 (z), quad z in R_2
$

- Linearity:
$
  a x_1 [n] + b x_2 [n] #zpair a X_1 (z) + b X_2 (z), quad "ROC contains" R_1 inter R_2
$
As with the Laplace transform, the ROC can be larger if poles cancel.
#block(sticky: true)[- Time Shifting:]
$
  x[n - n_0] #zpair z^(-n_0) X(z), quad "ROC" = R "except possibly the addition or removal of" z = 0 "or" z = infinity
$
_Proof._ Substitute $m = n - n_0$:
$
  sum_(n = -infinity)^infinity x[n - n_0] z^(-n) = sum_(m = -infinity)^infinity x[m] z^(-(m + n_0)) = z^(-n_0) X(z)
$
The factor $z^(-n_0)$ is finite for all $z$ except $z = 0$ (if $n_0 > 0$) or $z = infinity$ (if $n_0 < 0$). #qed

In particular, $z^(-1)$ is the transform of a unit delay, which is why the delay element in a block diagram is often labeled $z^(-1)$.
#block(sticky: true)[- Scaling in the z-Domain:]
$
  z_0^n x[n] #zpair X(z / z_0), quad "ROC" = |z_0| R
$
_Proof._ $sum_n z_0^n x[n] z^(-n) = sum_n x[n] (z \/ z_0)^(-n) = X(z \/ z_0)$, which converges when $z \/ z_0 in R$. #qed

Every pole and zero moves from $p$ to $z_0 p$. For $z_0 = e^(j omega_0)$, the pole-zero plot rotates by $omega_0$, which is the frequency-shifting property of the DTFT.
- Time Reversal:
$
  x[-n] #zpair X(1 / z), quad "ROC" = 1 / R
$
A pole at $p$ moves to $1 \/ p$, and a ring $r_1 < |z| < r_2$ becomes $1 \/ r_2 < |z| < 1 \/ r_1$.
- Time Expansion: with $x_((k))[n] = x[n \/ k]$ when $n$ is a multiple of $k$ and $0$ otherwise,
$
  x_((k))[n] #zpair X(z^k), quad "ROC" = R^(1 \/ k)
$
- Conjugation:
$
  x^*[n] #zpair X^*(z^*), quad "ROC" = R
$
If $x[n]$ is real, $X(z) = X^*(z^*)$, so complex poles and zeros come in conjugate pairs.
#block(sticky: true)[- Convolution:]
$
  x_1 [n] star x_2 [n] #zpair X_1 (z) X_2 (z), quad "ROC contains" R_1 inter R_2
$
_Proof._ Exchange the order of summation and use time shifting:
$
  sum_(n = -infinity)^infinity (sum_(k = -infinity)^infinity x_1 [k] x_2 [n - k]) z^(-n) = sum_(k = -infinity)^infinity x_1 [k] (sum_(n = -infinity)^infinity x_2 [n - k] z^(-n)) = sum_(k = -infinity)^infinity x_1 [k] z^(-k) X_2 (z) = X_1 (z) X_2 (z)
$
#qed

This is the property behind the system function: for an LTI system, $Y(z) = H(z) X(z)$. It is also why multiplying two polynomials in $z^(-1)$ convolves their coefficient sequences, as in the polynomial example in the topic on LTI systems.
- First Difference:
$
  x[n] - x[n - 1] #zpair (1 - z^(-1)) X(z), quad "ROC contains" R inter {|z| > 0}
$
#block(sticky: true)[- Accumulation:]
$
  sum_(k = -infinity)^n x[k] #zpair 1 / (1 - z^(-1)) X(z) = z / (z - 1) X(z), quad "ROC contains" R inter {|z| > 1}
$
_Proof._ The running sum is $x[n] star u[n]$, and $u[n] #zpair 1 \/ (1 - z^(-1))$ with ROC $|z| > 1$, and the convolution property gives the result. #qed

Unlike the DTFT version, there is no impulse term to carry around: the pole at $z = 1$ simply sits on the boundary of the ROC.
#block(sticky: true)[- Differentiation in the z-Domain:]
$
  n x[n] #zpair -z ("d"X(z)) / ("d"z), quad "ROC" = R
$
_Proof._ Differentiate @ztransform term by term: $("d"X(z)) \/ ("d"z) = sum_n (-n) x[n] z^(-n - 1)$, and multiply by $-z$. #qed

Applied to $a^n u[n]$,
$
  n a^n u[n] #zpair -z "d" / ("d"z) (1 / (1 - a z^(-1))) = (a z^(-1)) / (1 - a z^(-1))^2, quad |z| > |a|
$
#block(sticky: true)[- The Initial-Value Theorem:]
If $x[n] = 0$ for $n < 0$, then
$
  x[0] = lim_(z -> infinity) X(z)
$
_Proof._ $X(z) = x[0] + x[1] z^(-1) + x[2] z^(-2) + dots.c$, and every term but the first vanishes as $z -> infinity$. #qed

A consequence: if $x[n]$ is causal and $X(z)$ is rational, then $X(z)$ is finite at $z = infinity$, so the numerator of $X(z)$, written in positive powers of $z$, cannot have a higher degree than the denominator.

== Tables of z-Transform Properties and Basic z-Transform Pairs

#note("z-Transform Properties")[
  #table(
    columns: 4,
    align: center + horizon,
    stroke: 0.5pt,
    table.header([*Property*], [*Signal*], [*z-Transform*], [*ROC*]),

    [], [$x[n]$ \ $x_1 [n]$ \ $x_2 [n]$], [$X(z)$ \ $X_1 (z)$ \ $X_2 (z)$], [$R$ \ $R_1$ \ $R_2$],

    [Linearity], [$a x_1 [n] + b x_2 [n]$], [$a X_1 (z) + b X_2 (z)$], [At least $R_1 inter R_2$],

    [Time Shifting],
    [$x[n - n_0]$],
    [$z^(-n_0) X(z)$],
    [$R$, except possibly adding or removing $0$ or $infinity$],

    [Scaling in the z-Domain], [$z_0^n x[n]$], [$X(z / z_0)$], [$|z_0| R$],

    [Frequency Shifting], [$e^(j omega_0 n) x[n]$], [$X(e^(-j omega_0) z)$], [$R$],

    [Time Reversal], [$x[-n]$], [$X(1 / z)$], [$1 / R$],

    [Time Expansion],
    [$x[n \/ k]$ if $n = k ell$, $ell in ZZ$, else 0],
    [$X(z^k)$],
    [$R^(1 \/ k)$],

    [Conjugation], [$x^*[n]$], [$X^*(z^*)$], [$R$],

    [Convolution], [$x_1 [n] star x_2 [n]$], [$X_1 (z) X_2 (z)$], [At least $R_1 inter R_2$],

    [First Difference], [$x[n] - x[n - 1]$], [$(1 - z^(-1)) X(z)$], [At least $R inter {|z| > 0}$],

    [Accumulation],
    [$sum_(k = -infinity)^n x[k]$],
    [$1 / (1 - z^(-1)) X(z)$],
    [At least $R inter {|z| > 1}$],

    [Differentiation in $z$], [$n x[n]$], [$-z ("d"X(z)) / ("d"z)$], [$R$],
  )

  *Initial-Value Theorem.* If $x[n] = 0$ for $n < 0$, then $x[0] = lim_(z -> infinity) X(z)$.
]

#note("z-Transform Pairs")[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: 0.5pt,
    table.header([*Signal*], [*z-Transform*], [*ROC*]),

    [$delta[n]$], [$1$], [All $z$],

    [$u[n]$], [$1 / (1 - z^(-1))$], [$|z| > 1$],

    [$-u[-n - 1]$], [$1 / (1 - z^(-1))$], [$|z| < 1$],

    [$delta[n - m]$],
    [$z^(-m)$],
    [All $z$, except $0$ (if $m > 0$) or $infinity$ (if $m < 0$)],

    [$a^n u[n]$], [$1 / (1 - a z^(-1))$], [$|z| > |a|$],

    [$-a^n u[-n - 1]$], [$1 / (1 - a z^(-1))$], [$|z| < |a|$],

    [$n a^n u[n]$], [$(a z^(-1)) / (1 - a z^(-1))^2$], [$|z| > |a|$],

    [$-n a^n u[-n - 1]$], [$(a z^(-1)) / (1 - a z^(-1))^2$], [$|z| < |a|$],

    [$b^(|n|)$, $0 < b < 1$],
    [$1 / (1 - b z^(-1)) - 1 / (1 - b^(-1) z^(-1))$],
    [$b < |z| < 1 / b$],

    [$cos(omega_0 n) u[n]$],
    [$(1 - cos(omega_0) z^(-1)) / (1 - 2 cos(omega_0) z^(-1) + z^(-2))$],
    [$|z| > 1$],

    [$sin(omega_0 n) u[n]$],
    [$(sin(omega_0) z^(-1)) / (1 - 2 cos(omega_0) z^(-1) + z^(-2))$],
    [$|z| > 1$],

    [$r^n cos(omega_0 n) u[n]$],
    [$(1 - r cos(omega_0) z^(-1)) / (1 - 2 r cos(omega_0) z^(-1) + r^2 z^(-2))$],
    [$|z| > r$],

    [$r^n sin(omega_0 n) u[n]$],
    [$(r sin(omega_0) z^(-1)) / (1 - 2 r cos(omega_0) z^(-1) + r^2 z^(-2))$],
    [$|z| > r$],
  )
]

== Analysis and Characterization of LTI Systems Using the z-Transform <sec-z-lti>

By the convolution property, the output of an LTI system satisfies $Y(z) = H(z) X(z)$, where the _system function_ $H(z)$ is the z-transform of the impulse response. Many properties of the system can be read from the poles of $H(z)$ and its ROC.

=== Causality

A causal LTI system has $h[n] = 0$ for $n < 0$, so $h[n]$ is right-sided and, by @sec-z-roc, the ROC of $H(z)$ is the exterior of a circle *including* $z = infinity$. For a rational $H(z)$, this means two things:
+ the ROC is outside the outermost pole, and
+ written in positive powers of $z$, the numerator of $H(z)$ has degree no greater than the denominator. Otherwise $H(z)$ has a pole at $z = infinity$.

For example, $H(z) = (z^3 - 2 z^2 + z) \/ (z^2 + 1/4 z + 1/8)$ cannot be the system function of a causal system, whatever its ROC: the numerator has degree $3$ and the denominator degree $2$. Dividing out, $H(z) = z + dots.c$, and the term $z$ is a one-sample time advance.

=== Stability

An LTI system is stable if and only if $h[n]$ is absolutely summable, which by the last ROC property is the same as: *the ROC of $H(z)$ contains the unit circle*. Combining this with causality gives the result that is used most in practice.

#theorem("Causal and Stable Systems")[
  A rational system function $H(z)$ has an interpretation as a causal and stable system if and only if all of its poles lie strictly inside the unit circle, $|p| < 1$, and it has no pole at $z = infinity$.
]

Causality is not always required. A filter that runs on a recorded signal can look at "future" samples freely. Dropping causality gives a weaker condition.

#theorem("Stable Systems")[
  A rational system function $H(z)$ has an interpretation as a stable, but not necessarily causal, system if and only if it has no poles on the unit circle.
]

The theorems answer a question that the difference equation alone cannot. Consider
$
  y[n] = a y[n - 1] + x[n] quad <=> quad H(z) = 1 / (1 - a z^(-1)) = z / (z - a)
$
Run forward in time, the recursion gives the causal impulse response $h[n] = a^n u[n]$, which is stable only if $|a| < 1$. But the same equation can be rearranged as $y[n - 1] = a^(-1) y[n] - a^(-1) x[n]$ and run *backward* in time, which gives the anticausal impulse response $h[n] = -a^n u[-n - 1]$, stable only if $|a| > 1$. These are exactly the two ROCs of $z \/ (z - a)$. For a pole outside the unit circle, the stable interpretation exists but is anticausal.

#note("(optional) Proofs of the Two Theorems")[
  We prove the theorems for a rational $H(z)$ with distinct finite poles $p_1, dots.c, p_R$, which covers systems described by difference equations.

  _Causal and stable._ If $H(z)$ has no pole at infinity, its partial-fraction expansion has the form
  $
    H(z) = c_0 + sum_(k = 1)^R beta_k z / (z - p_k)
  $
  and the causal interpretation is
  $
    h[n] = c_0 delta[n] + sum_(k = 1)^R beta_k p_k^n u[n]
  $
  If every $|p_k| < 1$, each term is a decaying geometric sequence and $sum_n |h[n]| <= |c_0| + sum_k |beta_k| \/ (1 - |p_k|) < infinity$. If some $|p_k| >= 1$, the term $beta_k p_k^n$ does not decay; since the poles are distinct, no other term can cancel it, so $h[n]$ is not absolutely summable. If $H(z)$ has a pole at infinity, its expansion contains a term $c_1 z$, which is a time advance, and no causal interpretation exists at all. #qed

  _Stable._ If the system is stable, then on the unit circle
  $
    |H(e^(j omega))| = lr(|sum_(n = -infinity)^infinity h[n] e^(-j omega n)|) <= sum_(n = -infinity)^infinity |h[n]| < infinity
  $
  so $H(z)$ has no pole with $|p| = 1$. Conversely, if no pole lies on the unit circle, invert each term of the expansion as right-sided if $|p_k| < 1$ and as left-sided if $|p_k| > 1$. Every term then decays away from $n = 0$, so $h[n]$ is absolutely summable. The ROC of this interpretation is the ring between the largest pole inside the unit circle and the smallest pole outside it, and the ring contains the unit circle. #qed
]

#example("Stability of LTI Systems")[
  Consider
  $
    H(z) = (3 - 4 z^(-1)) / (1 - 7/2 z^(-1) + 3/2 z^(-2)) = 1 / (1 - 1/2 z^(-1)) + 2 / (1 - 3 z^(-1))
  $
  with poles at $z = 1/2$ and $z = 3$ and zeros at $z = 0$ and $z = 4/3$. There are three possible ROCs, shown in @fig-z-roc-stab.

  - $|z| > 3$: the system is causal, but the ROC does not contain the unit circle, so it is unstable:
    $
      h[n] = (1/2)^n u[n] + 2 (3)^n u[n]
    $
  - $1/2 < |z| < 3$: the ROC contains the unit circle, so the system is stable, but not causal:
    $
      h[n] = (1/2)^n u[n] - 2 (3)^n u[-n - 1]
    $
  - $|z| < 1/2$: the system is anticausal and unstable:
    $
      h[n] = -(1/2)^n u[-n - 1] - 2 (3)^n u[-n - 1]
    $
  No choice is both causal and stable, as the first theorem predicts from the pole at $z = 3$.
]

#[
#let pz = (poles: ((0.5, 0), (3, 0)), zeros: ((0, 0), (4 / 3, 0)))
#altfig(
  placement: auto,
  alt: "Three z-plane pole-zero plots of the same H of z, with poles at one half and three, zeros at zero and four thirds, and the unit circle dashed. Panel (a) shades the exterior of the circle of radius three: causal, unstable. Panel (b) shades the ring between radius one half and radius three, which contains the unit circle: stable, not causal. Panel (c) shades the disc of radius one half: anticausal, unstable.",
  caption: [
    One $H(z)$, three ROCs: causal but unstable (a), stable but not causal
    (b), and neither (c). Only (b) contains the unit circle.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 0.5em,
      panel(
        zplane(..pz, roc: (3, none), lim: 3.6, ticks: (-3, 3), size: 3.9cm),
        [(a) $|z| > 3$],
      ),
      panel(
        zplane(..pz, roc: (0.5, 3), lim: 3.6, ticks: (-3, 3), size: 3.9cm),
        [(b) $1/2 < |z| < 3$],
      ),
      panel(
        zplane(..pz, roc: (0, 0.5), lim: 3.6, ticks: (-3, 3), size: 3.9cm),
        [(c) $|z| < 1/2$],
      ),
    )
  ],
) <fig-z-roc-stab>
]

=== (optional) Noncausal Systems

Consider the centered three-point moving average
$
  y[n] = 1/3 (x[n + 1] + x[n] + x[n - 1]) quad <=> quad H(z) = 1/3 (z + 1 + z^(-1)), quad 0 < |z| < infinity
$
$H(z)$ has a pole at $z = infinity$ (from the term $z$), so by the first theorem it has no causal interpretation: computing $y[n]$ needs the future sample $x[n + 1]$. It has no poles on the unit circle, so it is stable. Its frequency response is real,
$
  H(e^(j omega)) = 1/3 (1 + 2 cos omega)
$
so the filter smooths without shifting features in time, which is useful when the whole signal is recorded first and processed afterward, as in image processing or the post-processing of measured data. If a causal filter is needed, the output can be delayed by one sample, $y[n - 1]$, which multiplies $H(z)$ by $z^(-1)$ and removes the pole at infinity, at the cost of a linear phase.

== LTI Systems Characterized by Linear Constant-Coefficient Difference Equations

Apply the z-transform to the general LCCDE
$
  sum_(k = 0)^N a_k y[n - k] = sum_(k = 0)^M b_k x[n - k]
$
Using linearity and time shifting,
#eqalt(
  "The sum from k equals zero to N of a sub k times z to the minus k, multiplied by Y of z, equals the sum from k equals zero to M of b sub k times z to the minus k, multiplied by X of z; equivalently, H of z equals the numerator polynomial sum of b sub k z to the minus k, divided by the denominator polynomial sum of a sub k z to the minus k.",
  $
    (sum_(k = 0)^N a_k z^(-k)) Y(z) = (sum_(k = 0)^M b_k z^(-k)) X(z) quad <=> quad H(z) = (sum_(k = 0)^M b_k z^(-k)) / (sum_(k = 0)^N a_k z^(-k))
  $,
) <z-lccde>
So the system function of a system described by a difference equation is always rational. The equation alone does not fix the ROC. That takes extra information, usually that the system is causal (initial rest), in which case the ROC is the exterior of the circle through the outermost pole.

#example("Linear Constant-Coefficient Difference Equations")[
  Consider the causal LTI system from the DTFT topic,
  $
    y[n] - 3/4 y[n - 1] + 1/8 y[n - 2] = 2 x[n]
  $
  By @z-lccde,
  $
    H(z) = 2 / (1 - 3/4 z^(-1) + 1/8 z^(-2)) = 4 / (1 - 1/2 z^(-1)) - 2 / (1 - 1/4 z^(-1))
  $
  The poles are at $1/2$ and $1/4$. Causality puts the ROC at $|z| > 1/2$, which gives
  $
    h[n] = 4 (1/2)^n u[n] - 2 (1/4)^n u[n]
  $
  as found earlier with the DTFT. Here, though, we can also *see* why the DTFT method worked: both poles are inside the unit circle, so the causal system is stable and its frequency response exists.
]

=== Block Diagram Representations

The topic on LTI systems drew difference equations with adders, multipliers, and unit delays. In the z-domain, a unit delay is multiplication by $z^(-1)$, and @z-lccde suggests splitting $H(z)$ into two cascaded pieces,
$
  H(z) = underbrace((sum_(k = 0)^M b_k z^(-k)), "zeros") dot.c underbrace(1 / (sum_(k = 0)^N a_k z^(-k)), "poles")
$
Implementing the zeros first and the poles second, each with its own chain of delays, gives the _direct form I_ structure, which uses $M + N$ delays. Since the two pieces are LTI, their order can be swapped. With the poles first, both pieces delay the same intermediate signal $w[n]$, so the two delay chains can be merged into one. This is the _direct form II_ structure, which uses only $max(M, N)$ delays. @fig-z-df2 shows it for a second-order system with $a_0 = 1$:
$
  w[n] = x[n] - a_1 w[n - 1] - a_2 w[n - 2], quad y[n] = b_0 w[n] + b_1 w[n - 1] + b_2 w[n - 2]
$

#altfig(
  alt: "Direct form II block diagram for a second-order system. The input x of n enters a summing node on the left, whose output w of n runs to a central column. The column passes w of n down through two unit delays labeled z to the minus one, producing w of n minus one and w of n minus two. The delayed signals are scaled by minus a one and minus a two and fed back to the left summing nodes, and are scaled by b one and b two and fed forward to summing nodes on the right, where they are added to b zero times w of n to form the output y of n.",
  caption: [
    Direct form II for $H(z) = (b_0 + b_1 z^(-1) + b_2 z^(-2)) \/ (1 + a_1 z^(-1) + a_2 z^(-2))$.
    The feedback (left) and feedforward (right) halves share one chain of delays.
  ],
  align(center)[
    #diagram(
      debug: false,
      node-stroke: 0.1em,
      mark-scale: 100%,
      spacing: (16mm, 9mm),
      edge((-1, 0), (0, 0), "-|>-", $x[n]$, label-pos: 0, label-side: center),
      edge((0, 0), (1, 0), "-", $w[n]$, label-side: left),
      edge((1, 0), (2, 0), "-|>-", $b_0$),
      edge((2, 0), (3, 0), "-|>-", $y[n]$, label-pos: 1.2, label-side: center),
      edge((1, 0), (1, 0.5), "-|>-"),
      node((1, 0.5), $z^(-1)$, width: 2.2em),
      edge((1, 0.5), (1, 1), "-"),
      edge((1, 1), (0, 1), "-|>-", $-a_1$),
      edge((1, 1), (2, 1), "-|>-", $b_1$),
      edge((0, 1), (0, 0), "-|>-"),
      edge((2, 1), (2, 0), "-|>-"),
      edge((1, 1), (1, 1.5), "-|>-"),
      node((1, 1.5), $z^(-1)$, width: 2.2em),
      edge((1, 1.5), (1, 2), "-"),
      edge((1, 2), (0, 2), "-|>-", $-a_2$),
      edge((0, 2), (0, 1), "-|>-"),
      edge((1, 2), (2, 2), "-|>-", $b_2$),
      edge((2, 2), (2, 1), "-|>-"),
      node((0, 0), $+$),
      node((0, 1), $+$),
      node((2, 0), $+$),
      node((2, 1), $+$),
    )
  ],
) <fig-z-df2>

=== (optional) FIR and IIR Systems

If $a_k = 0$ for all $k >= 1$, the output depends only on the input, $y[n] = sum_k b_k x[n - k]$, and the impulse response $h[n] = b_n$ has finite length: the system is _finite impulse response_ (FIR). Its system function is a polynomial in $z^(-1)$, so all its poles are at $z = 0$, and an FIR system is always stable. If any $a_k != 0$ for $k >= 1$, the output feeds back, the impulse response is in general infinitely long, and the system is _infinite impulse response_ (IIR).

The simplest IIR low-pass filter is the first-order recursion
$
  y[n] = alpha y[n - 1] + (1 - alpha) x[n] quad <=> quad H(z) = (1 - alpha) / (1 - alpha z^(-1))
$
with a single pole at $z = alpha$. It is stable for $|alpha| < 1$, and the factor $1 - alpha$ normalizes the DC gain to $H(1) = 1$. Its squared magnitude response is
$
  |H(e^(j omega))|^2 = (1 - alpha)^2 / (1 - 2 alpha cos omega + alpha^2)
$
and setting this equal to $1/2$ gives the 3-dB cutoff frequency, $cos omega_c = 1 - (1 - alpha)^2 \/ (2 alpha)$. Moving the pole toward $z = 1$ narrows the passband, but it also lengthens the impulse response $(1 - alpha) alpha^n u[n]$, whose time constant is about $1 \/ (1 - alpha)$ samples. A filter that smooths more also reacts more slowly. @fig-z-iir-lp shows three choices of $alpha$. To get the same selectivity from an FIR moving average would take a filter about as long as that time constant, which is why IIR filters are cheaper for sharp responses.

#let ws = lq.linspace(0, calc.pi, num: 300)
#cdiagram(
  placement: auto,
  alt: "Magnitude responses of the first-order low-pass filter for alpha equal to 0.5, 0.8 and 0.95, plotted for omega from 0 to pi. All three equal one at omega equals zero; the larger alpha, the faster the response falls, with alpha equals 0.95 dropping below 0.1 by omega about 0.5.",
  caption: [
    Magnitude response of $H(z) = (1 - alpha) \/ (1 - alpha z^(-1))$. A pole closer
    to $z = 1$ gives a narrower passband.
  ],
  xlabel: $omega$,
  ylabel: $|H(e^(j omega))|$,
  xlim: (0, 3.4),
  ylim: (0, 1.1),
  xaxis: (
    ticks: ((0, $0$), (calc.pi / 2, $pi/2$), (calc.pi, $pi$)),
    subticks: none,
  ),
  yaxis: (ticks: lbl((0.5, 1)), subticks: none),
  legend: (position: top + right),
  ..(0.5, 0.8, 0.95)
    .enumerate()
    .map(((i, a)) => lq.plot(
      ws,
      ws.map(w => (1 - a) / vec-len(w, a, 0)),
      mark: none,
      stroke: series-stroke(i),
      label: [$alpha = #a$],
    )),
) <fig-z-iir-lp>

=== (optional) Zero-Phase Filtering

Every causal filter delays its input, and a filter with nonlinear phase also distorts the shape of a waveform. When the whole signal is available, both problems can be removed. Let $h[n]$ be real, and filter the signal with $H(z)$, then filter the result again with $H(z^(-1))$, the time-reversed filter. The overall system function is
$
  G(z) = H(z) H(z^(-1)), quad G(e^(j omega)) = H(e^(j omega)) H(e^(-j omega)) = H(e^(j omega)) H^*(e^(j omega)) = |H(e^(j omega))|^2
$
which is real and nonnegative: the cascade has zero phase, and its magnitude is the square of the original one. Filtering with $H(z^(-1))$ is done by reversing the signal in time, filtering with $H(z)$, and reversing again. This forward-backward procedure is what MATLAB's `filtfilt` does.

$G(z)$ is not causal. Each pole $p$ of $H(z)$ inside the unit circle comes with a pole $1 \/ p$ of $H(z^(-1))$ outside it, so, like the centered moving average above, $G(z)$ is stable only with a two-sided ROC, a ring around the unit circle.

=== (optional) State-Space Realizations

A system can also be described by a state vector $bold(q)[n]$ that is updated once per sample,
$
  bold(q)[n + 1] = bold(A) bold(q)[n] + bold(B) x[n], quad y[n] = bold(C) bold(q)[n] + D x[n]
$
Taking z-transforms with zero initial state, $z bold(Q)(z) = bold(A) bold(Q)(z) + bold(B) X(z)$, so $bold(Q)(z) = (z bold(I) - bold(A))^(-1) bold(B) X(z)$ and
$
  H(z) = Y(z) / X(z) = bold(C) (z bold(I) - bold(A))^(-1) bold(B) + D
$
Since $(z bold(I) - bold(A))^(-1)$ has $det(z bold(I) - bold(A))$ in its denominator, the poles of $H(z)$ are among the eigenvalues of $bold(A)$. A causal state-space system is therefore stable when every eigenvalue of $bold(A)$ lies inside the unit circle. For example, $y[n] = a y[n - 1] + x[n]$ with state $q[n] = y[n - 1]$ gives $q[n + 1] = a q[n] + x[n]$ and $y[n] = a q[n] + x[n]$, so $A = a$, $B = 1$, $C = a$, $D = 1$, and $H(z) = a \/ (z - a) + 1 = z \/ (z - a)$, as before. The delays in the direct form II structure are a natural choice of state.

== (optional) The Unilateral z-Transform

The z-transform used so far is _bilateral_: it sums over all $n$. To solve a difference equation that starts at $n = 0$ with given initial conditions, which is not initial rest, we use the _unilateral_ z-transform
$
  cal(X)(z) = sum_(n = 0)^infinity x[n] z^(-n)
$
It equals the bilateral transform of $x[n] u[n]$, so its ROC is always the exterior of a circle and need not be stated. Most properties carry over. The one that differs is time shifting, because a delay brings samples from $n < 0$ into the sum:
$
  x[n - 1] & #zpair z^(-1) cal(X)(z) + x[-1] \
  x[n - 2] & #zpair z^(-2) cal(X)(z) + x[-1] z^(-1) + x[-2]
$
Here the arrow denotes the unilateral transform. The initial conditions enter the transformed equation as extra terms.

#example("Difference Equation with a Nonzero Initial Condition")[
  Solve $y[n] - 1/2 y[n - 1] = x[n]$ for $n >= 0$, with $x[n] = u[n]$ and $y[-1] = 4$. Taking unilateral transforms,
  $
    cal(Y)(z) - 1/2 (z^(-1) cal(Y)(z) + 4) = 1 / (1 - z^(-1))
  $
  so
  $
    cal(Y)(z) = underbrace(2 / (1 - 1/2 z^(-1)), "zero-input response") + underbrace(1 / ((1 - 1/2 z^(-1))(1 - z^(-1))), "zero-state response") = 2 / (1 - 1/2 z^(-1)) + 2 / (1 - z^(-1)) - 1 / (1 - 1/2 z^(-1))
  $
  The first term is the response to the initial condition alone, and the second the response to the input from rest. Inverting,
  $
    y[n] = underbrace(2 (1/2)^n, "zero-input") + underbrace(2 - (1/2)^n, "zero-state") = 2 + (1/2)^n, quad n >= 0
  $
  As a check, the recursion gives $y[0] = 1/2 dot.c 4 + 1 = 3$ and $y[1] = 1/2 dot.c 3 + 1 = 5/2$, which match. The transient $(1/2)^n$ dies out because the pole is inside the unit circle, and $y[n]$ settles to the DC gain $H(1) = 2$.
]

== (optional) Relation Between the z-Transform and the Laplace Transform

=== Sampling and the Mapping $z = e^(s T)$

Sample a continuous-time signal with period $T$, $x[n] = x(n T)$, and represent the samples by the impulse train $x_p (t) = sum_n x(n T) delta(t - n T)$, as in the topic on sampling. Its Laplace transform is
$
  X_p (s) = sum_(n = -infinity)^infinity x(n T) e^(-s n T) = X(z) lr(|, size: #100%)_(z = e^(s T))
$
so the z-transform of the samples is the Laplace transform of the impulse train, with $z = e^(s T)$. Writing $s = sigma + j omega$ gives $|z| = e^(sigma T)$ and $angle z = omega T$:
- the left half-plane $sigma < 0$ maps inside the unit circle, and the right half-plane outside it;
- the $j omega$-axis maps onto the unit circle, with $omega$ and $omega + 2 pi \/ T$ landing on the same point. Frequencies that differ by the sampling frequency become indistinguishable, which is aliasing seen in the z-plane.

For example, sampling $e^(-a t) u(t)$ gives $(e^(-a T))^n u[n] #zpair 1 \/ (1 - e^(-a T) z^(-1))$: the s-plane pole $s = -a$ becomes the z-plane pole $z = e^(-a T)$. Stable continuous-time poles become stable discrete-time poles.

=== Discretizing a Continuous-Time System with a Zero-Order Hold

In a digital controller, a continuous-time system $H(s)$ is driven by a zero-order hold that keeps each input sample constant for $T$ seconds, and its output is sampled. The resulting discrete-time system has an exact description. A unit step $u[n]$ into the hold produces the continuous-time step $u(t)$, so the output samples are samples of the step response $s(t) = cal(L)^(-1){H(s) \/ s}$. Since $u[n] #zpair 1 \/ (1 - z^(-1))$, the discrete-time system function is
$
  H_d (z) = (1 - z^(-1)) cal(Z){s(n T)}
$
This is called the _step-invariant_ discretization. For example, $H(s) = a \/ (s + a)$ has step response $s(t) = (1 - e^(-a t)) u(t)$, so
$
  H_d (z) = (1 - z^(-1)) [1 / (1 - z^(-1)) - 1 / (1 - e^(-a T) z^(-1))] = ((1 - e^(-a T)) z^(-1)) / (1 - e^(-a T) z^(-1))
$
The pole is at $z = e^(-a T)$, as the mapping $z = e^(s T)$ predicts, and the DC gain is $H_d (1) = 1 = H(0)$. Apart from a one-sample delay, this is the first-order low-pass recursion of the FIR and IIR section above with $alpha = e^(-a T)$.

=== The Bilinear Transform and Prewarping

To turn an analog filter design into a digital one, the most common method replaces $s$ by a rational function of $z$,
$
  s = 2 / T (1 - z^(-1)) / (1 + z^(-1)) = 2 / T (z - 1) / (z + 1), quad z = (1 + s T \/ 2) / (1 - s T \/ 2)
$
This _bilinear transform_ (Tustin's method) is the trapezoidal rule for integration written in the z-domain. Its useful properties follow from the inverse map:
- $|z| < 1$ if and only if $|1 + s T \/ 2| < |1 - s T \/ 2|$, that is, if and only if $Re{s} < 0$. Stable analog filters become stable digital filters.
- For $s = j omega$, the numerator and denominator are complex conjugates, so $|z| = 1$: the $j omega$-axis maps onto the unit circle, at
$
  Omega = 2 arctan (omega T / 2), quad "equivalently" quad omega = 2 / T tan (Omega / 2)
$
where $Omega$ is the discrete-time frequency. The entire analog frequency axis is squeezed once around the circle, so there is no aliasing, but the squeeze is nonlinear: _frequency warping_. Near $Omega = 0$, $Omega approx omega T$, but the higher the frequency, the more it is compressed.

To make a critical frequency land where it should, such as a cutoff $Omega_c$, design the analog filter at the _prewarped_ frequency $omega_a = (2 \/ T) tan(Omega_c \/ 2)$ and then apply the bilinear transform.

#example("First-Order Low-Pass Filter by the Bilinear Transform")[
  We want a digital low-pass filter with a 3-dB cutoff at $f_c = 318.3$ Hz ($omega_c = 2000$ rad/s), sampled at $f_s = 2000$ Hz ($T = 0.5$ ms), starting from the analog filter $H(s) = omega_a \/ (s + omega_a)$. Substituting the bilinear transform and writing $K = omega_a T \/ 2$,
  $
    H(z) = K / (1 + K) dot.c (1 + z^(-1)) / (1 - (1 - K) / (1 + K) z^(-1)), quad |H(e^(j Omega))| = 1 / sqrt(1 + (tan(Omega \/ 2) \/ K)^2)
  $
  - *Without prewarping*, $omega_a = omega_c$ and $K = 0.5$. The digital cutoff falls where $tan(Omega \/ 2) = K$, at $Omega = 2 arctan(0.5) = 0.927$ rad, which is $295$ Hz rather than $318$ Hz.
  - *With prewarping*, the desired digital cutoff is $Omega_c = omega_c T = 1$ rad, so $omega_a = (2 \/ T) tan(0.5) = 2185$ rad/s and $K = tan(0.5) = 0.546$. Then
    $
      H(z) = 0.353 (1 + z^(-1)) / (1 - 0.293 z^(-1))
    $
    and the cutoff is exactly at $318$ Hz.

  @fig-z-bilinear compares the two designs with the analog response. Both digital responses reach zero at the Nyquist frequency $1000$ Hz, where the analog frequency $omega = infinity$ lands. This is the warping at work.

  #let T = 0.5e-3
  #let fs-axis = lq.linspace(0, 1000, num: 300)
  #let mag-d(f, K) = 1 / calc.sqrt(1 + calc.pow(calc.tan(calc.pi * f * T) / K, 2))
  #cdiagram(
    alt: "Magnitude responses from 0 to 1000 hertz. The analog first-order low-pass response with cutoff 318 hertz decays slowly and is still about 0.3 at 1000 hertz. The bilinear-transform digital response without prewarping crosses 0.707 at about 295 hertz; the one with prewarping crosses 0.707 at 318 hertz, matching the analog cutoff. Both digital responses fall to zero at 1000 hertz.",
    caption: [
      Analog prototype (gray) and the two digital designs. Prewarping moves the
      digital 3-dB point (dotted line) back to $318$ Hz. Both digital
      responses vanish at the Nyquist frequency.
    ],
    width: 9cm,
    xlabel: [$f$ (Hz)],
    ylabel: $|H|$,
    xlim: (0, 1050),
    ylim: (0, 1.1),
    xaxis: (ticks: lbl((0, 318, 1000)), subticks: none),
    yaxis: (ticks: lbl((0.707, 1)), subticks: none),
    legend: (position: top + right),
    lq.plot(
      fs-axis,
      fs-axis.map(f => 1 / calc.sqrt(1 + calc.pow(2 * calc.pi * f / 2000, 2))),
      mark: none,
      stroke: (paint: c-muted, thickness: 1.1pt),
      label: [analog],
    ),
    lq.plot(
      fs-axis,
      fs-axis.map(f => mag-d(f, 0.5)),
      mark: none,
      stroke: series-stroke(1),
      label: [no prewarping],
    ),
    lq.plot(
      fs-axis,
      fs-axis.map(f => mag-d(f, calc.tan(0.5))),
      mark: none,
      stroke: series-stroke(0),
      label: [prewarped],
    ),
    lq.plot(
      (0, 1050),
      (0.707, 0.707),
      mark: none,
      stroke: (paint: c-muted, dash: "dotted", thickness: 0.6pt),
    ),
  ) <fig-z-bilinear>
]

=== Frequency Transformations and Notch Filters

Once a low-pass filter is designed, other filter types can be derived from it by changing the variable $z$. The simplest is $z -> -z$:
$
  H_"hp" (z) = H_"lp" (-z), quad H_"hp" (e^(j omega)) = H_"lp" (e^(j (omega - pi))), quad h_"hp" [n] = (-1)^n h_"lp" [n]
$
The frequency response shifts by $pi$, which swaps $omega = 0$ and $omega = pi$ and turns a low-pass filter into a high-pass one. In the z-plane, every pole and zero is reflected through the origin. For the first-order low-pass filter above, the pole at $alpha$ moves to $-alpha$.

A _notch filter_ removes a single frequency $omega_0$, such as $60$ Hz power-line hum, and leaves the rest of the spectrum alone. The pole-zero plot tells us how to build one:
- put a pair of zeros on the unit circle at $e^(plus.minus j omega_0)$, so that $|H(e^(j omega_0))| = 0$;
- put a pair of poles just inside, at $r e^(plus.minus j omega_0)$ with $r$ slightly less than $1$.
$
  H(z) = ((1 - e^(j omega_0) z^(-1))(1 - e^(-j omega_0) z^(-1))) / ((1 - r e^(j omega_0) z^(-1))(1 - r e^(-j omega_0) z^(-1))) = (1 - 2 cos(omega_0) z^(-1) + z^(-2)) / (1 - 2 r cos(omega_0) z^(-1) + r^2 z^(-2))
$
Away from $omega_0$, the point $e^(j omega)$ is far from both the zero and its neighboring pole, the two vectors have nearly equal length, and $|H| approx 1$. Only close to $omega_0$ does the zero vector shrink much faster than the pole vector. The width of the notch is about $2 (1 - r)$ rad, so the closer the poles are to the circle, the narrower the notch. @fig-z-notch shows $omega_0 = pi \/ 3$, which corresponds to $60$ Hz at $f_s = 360$ Hz.

#let w0 = calc.pi / 3
#let ws = lq.linspace(0, calc.pi, num: 600)
#let notch(w, r) = (
  vec-len(w, 1, w0) * vec-len(w, 1, -w0) / (vec-len(w, r, w0) * vec-len(w, r, -w0))
)
#altfig(
  alt: "Left: z-plane for a notch filter, with zeros on the unit circle at angles plus and minus pi over 3 and poles just inside them at radius 0.9. Right: magnitude responses for r equal to 0.9 and r equal to 0.98, both about one everywhere except for a sharp dip to zero at omega equals pi over 3; the dip is much narrower for r equals 0.98.",
  caption: [
    Notch filter at $omega_0 = pi \/ 3$. The zeros on the unit circle force the null,
    and the poles just inside them (shown for $r = 0.9$) restore the gain
    everywhere else (left). Moving the poles closer to the circle narrows the notch
    (right).
  ],
  align(center)[
    #grid(
      columns: (1fr, 1.4fr),
      column-gutter: 1em,
      align: horizon,
      zplane(
        poles: ((0.9 * calc.cos(w0), 0.9 * calc.sin(w0)), (0.9 * calc.cos(w0), -0.9 * calc.sin(w0))),
        zeros: ((calc.cos(w0), calc.sin(w0)), (calc.cos(w0), -calc.sin(w0))),
        lim: 1.4,
      ),
      lq.diagram(
        width: 6cm,
        height: 4cm,
        xlabel: $omega$,
        ylabel: $|H(e^(j omega))|$,
        xlim: (0, 3.4),
        ylim: (0, 1.25),
        xaxis: (
          ticks: ((0, $0$), (calc.pi / 3, $pi/3$), (calc.pi, $pi$)),
          subticks: none,
        ),
        yaxis: (ticks: lbl((0.5, 1)), subticks: none),
        legend: (position: bottom + right),
        lq.plot(ws, ws.map(w => notch(w, 0.9)), mark: none, stroke: series-stroke(0), label: [$r = 0.9$]),
        lq.plot(ws, ws.map(w => notch(w, 0.98)), mark: none, stroke: series-stroke(1), label: [$r = 0.98$]),
      ),
    )
  ],
) <fig-z-notch>

The gain away from the notch is slightly above $1$ (about $1.1$ for $r = 0.9$), and can be normalized by a constant factor if needed.
