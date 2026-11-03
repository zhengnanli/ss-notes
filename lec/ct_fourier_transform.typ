#import "lib.typ": *

= The Continuous-Time Fourier Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

We developed a representation of periodic signals as linear combinations of complex exponentials. In this section, we extend these concepts to apply to signals that are not periodic. We begin by looking at the continuous-time periodic square wave again. The Fourier series coefficients $a_k$ for this square wave are
$
  a_k = (2 sin (k omega_0 T_1)) / (k omega_0 T)
$
where $omega_0 = (2 pi) / T$. Below, we plot the time-domain signal on the left and, on the other two panels, the scaled coefficients $T a_k$ against $omega = k omega_0$ for two periods $T_a < T_b$, holding the pulse half-width $T_1$ fixed. The dashed curve is the envelope $2 sin(omega T_1) \/ omega$, which does not depend on $T$: lengthening the period leaves the envelope alone and packs the samples more densely along it.

#let T1 = 1.0
#let envelope-w = lq.linspace(-10, 10, num: 501)
// T a_k = 2 sin(k omega_0 T1) / (k omega_0), i.e. the envelope sampled at
// omega = k omega_0. Both panels evaluate the same envelope, so the only thing
// that changes between them is the sample spacing, which is the point.
#let envelope = w => 2 * T1 * sa(w * T1)
#let coeff-panel = (T, label) => {
  let omega0 = 2 * calc.pi / T
  let kmax = int(calc.floor(10 / omega0))
  let ks = range(-kmax, kmax + 1)
  lq.diagram(
    title: $T a_k, #label$,
    xlabel: $omega$,
    height: 4cm,
    width: 5cm,
    xlim: (-10.5, 10.5),
    ylim: (-0.9, 2.6),
    lq.plot(
      envelope-w,
      envelope-w.map(envelope),
      mark: none,
      stroke: (paint: c-muted, dash: "dashed", thickness: 0.7pt),
    ),
    lq.stem(
      ks.map(k => k * omega0),
      ks.map(k => envelope(k * omega0)),
      color: c-accent,
    ),
  )
}

#altfig(
  alt: "Three plots side by side. Left: periodic square wave x of t with pulse half-width T sub one and period T. Middle: the scaled Fourier series coefficients T a sub k for the shorter period T sub a, drawn as stems against omega on top of a dashed sinc envelope. Right: the same envelope for the longer period T sub b, sampled twice as densely.",
  caption: [
    A square wave (left) and its scaled coefficients $T a_k$ for two periods,
    $T_a$ (middle) and $T_b = 2 T_a$ (right). The dashed envelope is the same in
    both; only the spacing $omega_0 = 2 pi \/ T$ of the samples changes.
  ],
  align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 2em,
    [
      #let x = lq.linspace(-6, 6, num: 1000)
      #let square = x => if (calc.rem(x + 9, 4)) < 2 { 2.5 } else { 0 }
      #cdiagram(
        title: $x(t)$,
        xlabel: $t$,
        ylim: (-0.5, 3.5),
        xlim: (-4, 4),
        height: 4cm,
        width: 5cm,
        lq.plot(x, x.map(x => square(x)), mark: none),
        lq.place(-1.45, 2.5, align: center)[$1$],
        lq.place(1, -0.3, align: center, plabel[$T_1$]),
        lq.place(-1.2, -0.3, align: center, plabel[$-T_1$]),
        lq.place(2, -0.3, align: center, plabel[$T/2$]),
        lq.place(-2.3, -0.3, align: center, plabel[$-T/2$]),
        lq.place(3.8, 1.5, align: center)[$dots.c$],
        lq.place(-3.8, 1.5, align: center)[$dots.c$],
        lq.plot((2, 2), (0, 3), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
        lq.plot((-2, -2), (0, 3), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
      )],
    coeff-panel(4 * T1, $T = T_a$),
    coeff-panel(8 * T1, $T = T_b$),
  )
],
)

As we can see from the above example, when $T arrow infinity$, so that the periodic signal becomes aperiodic, the samples $T a_k$ fill in the envelope function, and the sum over $k$ becomes an integral over $omega$.

== Representation of Aperiodic Signals: The Continuous-Time Fourier Transform
We start with an aperiodic signal $x(t)$, which is zero when $|t| > T_1$ for some number $T_1$. We then construct a periodic signal $tilde(x)(t)$ for which $x(t)$ is one period. As we choose the period $T$ to be larger, say $T arrow infinity$, $tilde(x)(t) arrow x(t)$.

#altfig(
  alt: "Two plots. Left: an aperiodic pulse x of t that is nonzero only on the interval from minus T sub one to T sub one. Right: its periodic extension tilde x of t, formed by repeating the pulse every T units; the central period is drawn in the accent color and adjacent copies in green, with dashed gray lines at plus and minus T and plus and minus two T.",
  caption: [
    An aperiodic $x(t)$ of finite duration (left) and the periodic $tilde(x)(t)$
    built by repeating it every $T$ (right). Letting $T arrow infinity$ pushes
    the copies apart until only $x(t)$ is left.
  ],
  align(center)[
  #grid(
    columns: (1fr, 3fr),
    column-gutter: 2em,
    [
      #let x = lq.linspace(-6, 6, num: 400)
      #cdiagram(
        title: $x(t)$,
        xlabel: $t$,
        width: 5cm,
        height: 3cm,
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-T_1$],
        lq.place(3, -0.21, align: center)[$T_1$],
      )],
    [
      #let x = lq.linspace(-18, 18, num: 2400)
      #cdiagram(
        title: $tilde(x)(t)$,
        xlabel: $t$,
        width: 10cm,
        height: 3cm,
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x - 7) + 1.0) * ((x - 7) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x - 7) - 0.5) * ((x - 7) - 0.5) / 0.7)
          )),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 7) + 1.0) * ((x + 7) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 7) - 0.5) * ((x + 7) - 0.5) / 0.7)
          )),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 14) + 1.0) * ((x + 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 14) - 0.5) * ((x + 14) - 0.5) / 0.7)
          )),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x - 14) + 1.0) * ((x - 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x - 14) - 0.5) * ((x - 14) - 0.5) / 0.7)
          )),
          color: c-green,
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-T_1$],
        lq.place(3, -0.21, align: center)[$T_1$],
        lq.place(7, -0.21, align: center)[$T$],
        lq.place(-7, -0.21, align: center)[$-T$],
        lq.place(14, -0.21, align: center)[$2T$],
        lq.place(-14, -0.21, align: center)[$-2T$],
        lq.place(-18, 0.7, align: center)[$dots.c$],
        lq.place(18, 0.7, align: center)[$dots.c$],
        lq.plot((7, 7), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
        lq.plot((-7, -7), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
        lq.plot((14, 14), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
        lq.plot((-14, -14), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: c-muted,
        )),
      )],
  )],
)

Let us now examine the effect of this on the Fourier series representation of $tilde(x)(t)$. We represent $tilde(x)(t)$ by
$
  tilde(x) (t) = sum_(k = -infinity)^infinity a_k e^(j k omega_0 t)
$
where
$
  a_k = 1/T integral_(-T/2)^(T/2) tilde(x) (t) e^(-j k omega_0 t) "d"t
$ <aktildex>
and $omega_0 = (2 pi) / T$. Since $tilde(x)(t) = x(t)$ for $|t| < T/2$ (once $T/2 > T_1$), and $x(t) = 0$ outside this interval, we can rewrite @aktildex as
$
  a_k = 1/T integral_(-T/2)^(T/2) tilde(x)(t) e^(-j k omega_0 t) "d"t = 1/T integral_RR x(t) e^(-j k omega_0 t) "d"t
$
Therefore, defining the envelope $X(j omega)$ of $T a_k$ as
$
  X(j omega) = integral_RR x(t) e^(- j omega t) "d"t
$
we have, for the coefficients $a_k$,
$
  a_k = 1/T X(j k omega_0)
$
Then we can represent $tilde(x)(t)$ as
$
  tilde(x) (t) = sum_(k = -infinity)^infinity a_k e^(j k omega_0 t) = sum_(k = -infinity)^infinity 1/T X(j k omega_0) e^(j k omega_0 t) = 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) e^(j k omega_0 t) omega_0
$
As $T arrow infinity$, $omega_0 arrow 0$, $tilde(x) (t) arrow x(t)$, and consequently,
$
  x(t) = lim_(omega_0 arrow 0) 1 / (2 pi) sum_(k = -infinity)^(infinity) X(j k omega_0) e^(j k omega_0 t) omega_0 = 1 / (2 pi ) integral_RR X(j omega) e^(j omega t) "d"omega
$

@fig-riemann depicts the process of $omega_0 arrow 0$. As $omega_0 arrow 0$, the summation converges to the integral of $X(j omega) e^(j omega t)$.

#let x = lq.linspace(-2, 5, num: 100)
#let xd = lq.arange(-2, 5, step: 0.3)
#let f(x) = 1.5 * calc.sin(x + 2) + 0.5 * calc.sin(3 * x)
#let make-staircase(x-vals, y-vals) = {
  let points = ()
  for i in range(x-vals.len() - 1) {
    let x1 = x-vals.at(i)
    let y1 = y-vals.at(i)
    let x2 = x-vals.at(i + 1)

    points.push((x1, y1))
    points.push((x2, y1))
  }
  points
}
#let yd = xd.map(x => f(x))
#let stair-coarse = make-staircase(xd, yd)

#align(center)[
  // Floats, so that a page too short for it is filled with the text that
  // follows rather than left with a blank tail.
  #cdiagram(
    placement: auto,
    alt: "Smooth continuous curve of X of j omega times e to the j omega t plotted against omega, overlaid with a blue staircase approximation that samples the curve at spacing omega-zero. The discrete samples approach the continuous integral as omega-zero approaches zero.",
    caption: [
      The synthesis sum as a Riemann sum: rectangles of width $omega_0$ under
      $X(j omega) e^(j omega t)$. As $omega_0 arrow 0$ the sum becomes the
      inverse-transform integral.
    ],
    title: $X(j omega) e^(j omega t)$,
    xlabel: $omega$,
    ylim: (-2, 3),
    height: 5cm,
    width: 10cm,
    lq.plot(x, x.map(x => f(x)), mark: none),
    lq.plot(
      stair-coarse.map(p => p.at(0)),
      stair-coarse.map(p => p.at(1)),
      mark: none,
      stroke: (paint: c-blue, thickness: 0.4pt),
    ),
    lq.plot((xd.at(8), xd.at(8)), (0, yd.at(8)), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
    lq.plot((xd.at(9), xd.at(9)), (0, yd.at(9)), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
    lq.place(0.4, -0.2, align: left)[$omega_0$],
    lq.place(0.4, 1.8, align: left)[$X(j k omega_0) e^(j k omega_0 t)$],
  ) <fig-riemann>]

We define the Fourier transform pair as follows.
#definition("Fourier Transform Pair")[
  The Fourier transform is defined as
  #eqalt(
    "X of j omega equals the integral from negative infinity to infinity of x of t times e to the negative j omega t, d t.",
    $
      X(j omega) = integral_(-infinity)^(infinity) x(t) e^(-j omega t) "d"t
    $,
  )
  And the inverse Fourier transform is defined as
  #eqalt(
    "x of t equals one over two pi times the integral from negative infinity to infinity of X of j omega times e to the j omega t, d omega.",
    $
      x(t) = 1/(2 pi) integral_(-infinity)^(infinity) X(j omega) e^(j omega t) "d"omega
    $,
  )
]

The same argument holds for the Fourier coefficients $a_k$ of any periodic signal $tilde(x)(t)$ whose period is one copy of an $x(t)$ that vanishes outside the range $s <= t <= s + T$:
$
  a_k = 1/T integral_(s)^(s+T) tilde(x) (t) e^(-j k omega_0 t) "d"t = 1/T integral_s^(s+T) x(t) e^(-j k omega_0 t) "d"t = 1/T integral_(-infinity)^infinity x(t) e^(-j k omega_0 t) "d"t
$

Comparing the equation with the Fourier transform, we conclude that
$
  a_k = 1/T X(j omega) lr(|, size: #200%)_(omega=k omega_0)
$
where $X(j omega)$ is the Fourier transform of $x(t)$. Intuitively, $T a_k$ are _samples_ of the Fourier transform of one period of $tilde(x)(t)$.

== Convergence of Fourier Transforms

Similar to the Fourier series, there is a set of conditions which are sufficient to ensure that the signal recovered by the inverse transform equals $x(t)$ at every $t$ except at a discontinuity. The Dirichlet conditions require that

- $x(t)$ be absolutely integrable: $integral_RR |x(t)| "d"t < infinity$.
- $x(t)$ have a finite number of maxima and minima within any finite interval.
- $x(t)$ have a finite number of discontinuities within any finite interval. Furthermore, each of these discontinuities must be finite.

== Examples of Continuous-Time Fourier Transforms

#example("Fourier Transform Pairs")[
  #set math.equation(numbering: none)

  Consider the signal
  $
    x(t) = e^(-a t) u(t), quad a > 0
  $
  The Fourier transform of it is
  $
    X(j omega) = integral_RR x(t) e^(-j omega t) "d"t = integral_0^infinity e^(-a t) e^(-j omega t) "d"t = - 1/(a + j omega) e^(-(a + j omega) t) lr(|, size: #200%)^infinity_0 = 1 / (a + j omega), quad a > 0
  $

  Consider then the signal
  $
    x(t) = e^(-a|t|), quad a > 0
  $
  The Fourier transform is
  $
    X(j omega) = integral_(-infinity)^(infinity) e^(-a|t|) e^(-j omega t) "d"t = integral_(-infinity)^0 e^(a t) e^(-j omega t) "d"t + integral_0^infinity e^(- a t) e^(-j omega t) "d"t = (2a) / (a^2 + omega^2)
  $

  Let us now determine the Fourier transform of the unit impulse
  $
    X(j omega) = integral_RR delta(t) e^(-j omega t) "d"t = 1
  $

  // Unbreakable, so that "is" cannot be stranded at the foot of a page
  // with its equation on the next.
  #block(breakable: false)[
    The Fourier transform of the rectangular pulse signal
    $
      x(t) = cases(1\, quad |t| < T_1, 0\, quad |t| > T_1)
    $
    is
    $
      X(j omega) = integral_(-T_1)^(T_1) e^(-j omega t) "d"t = (2 sin(omega T_1))/omega = 2 T_1 "sinc"((omega T_1)/pi)
    $
    where $"sinc"(x) = sin(pi x) \/ (pi x)$ is the normalized sinc function of @fig-sinc.
  ]

  #altfig(
    alt: "Two plots. Left: a rectangular pulse x of t of height one, nonzero on the interval from minus T sub one to T sub one. Right: its Fourier transform X of j omega, a sinc-shaped envelope of height two T sub one with zero crossings at multiples of pi over T sub one.",
    caption: [
      A rectangular pulse (left) and its transform (right). Narrowing the pulse
      in time pushes the first null at $omega = pi \/ T_1$ outward, widening
      the main lobe, which is the time-bandwidth trade-off in its simplest form.
    ],
    align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #let x = lq.linspace(-6, 6, num: 1000)
        #let pulse = x => if calc.abs(x) < 2 { 2.5 } else { 0 }
        #cdiagram(
          title: $x(t)$,
          xlabel: $t$,
          ylim: (-0.5, 3.5),
          xlim: (-4, 4),
          height: 4cm,
          width: 6cm,
          lq.plot(x, x.map(x => pulse(x)), mark: none),
          lq.place(-1.45, 2.7, align: center)[$1$],
          lq.place(2.3, -0.3, align: center, plabel[$T_1$]),
          lq.place(-2.3, -0.3, align: center, plabel[$-T_1$]),
        )],
      [
        // Plotted against omega itself, with T1 = 1, so that the first zero
        // crossing really does sit at the labeled omega = pi / T1.
        #let T1 = 1.0
        #let w = lq.linspace(-10, 10, num: 501)

        #cdiagram(
          title: $X(j omega)$,
          xlabel: $omega$,
          height: 4cm,
          width: 6cm,
          ylim: (-0.8, 2.6),
          lq.plot(w, w.map(w => 2 * T1 * sa(w * T1)), mark: none),
          lq.place(-1.7, 2.1, align: center, plabel[$2 T_1$]),
          lq.place(calc.pi / T1, -0.62, align: center, plabel[$pi / T_1$]),
          lq.place(-calc.pi / T1, -0.62, align: center, plabel[$-pi / T_1$]),
        )
      ],
    )],
  ) <fig-rect-pulse>
  Consider a signal $x(t)$ whose Fourier transform is
  $
    X(j omega) = cases(1\, quad |omega| < W, 0\, quad |omega| > W)
  $
  The inverse Fourier transform is
  $
    x(t) = 1/(2 pi) integral_RR X(j omega) e^(j omega t) "d"omega = 1/(2 pi) integral_(-W)^W e^(j omega t) "d"omega = (sin W t)/(pi t) = W/pi "sinc"((W t)/pi)
  $
]

== Properties of the Continuous-Time Fourier Transform

We denote a Fourier pair as
$
  x(t) #ftpair X(j omega)
$

We list the properties below, with short proofs of the shifting, conjugation, and differentiation and integration properties. Each proof starts from the analysis or synthesis equation.

- Linearity:
$
  a x(t) + b y(t) #ftpair a X(j omega) + b Y(j omega)
$
#block(sticky: true)[- Time Shifting:]
$
  x(t - t_0) #ftpair e^(-j omega t_0) X(j omega)
$
_Proof._ Substituting $tau = t - t_0$ in the analysis equation,
$
  integral_RR x(t - t_0) e^(-j omega t) "d"t = integral_RR x(tau) e^(-j omega (tau + t_0)) "d"tau = e^(-j omega t_0) integral_RR x(tau) e^(-j omega tau) "d"tau = e^(-j omega t_0) X(j omega)
$
#qed
- Frequency Shifting:
$
  e^(j omega_0 t) x(t) #ftpair X(j(omega - omega_0))
$
_Proof._ The exponential combines with the kernel of the analysis equation,
$
  integral_RR e^(j omega_0 t) x(t) e^(-j omega t) "d"t = integral_RR x(t) e^(-j (omega - omega_0) t) "d"t = X(j(omega - omega_0))
$
#qed

Shifting in time multiplies the transform by a linear phase, and multiplying by a complex exponential in time shifts the transform; the two properties are duals.
- Conjugation and Conjugate Symmetry
$
  x^*(t) #ftpair X^*(-j omega)
$
$
  X(-j omega) = X^*(j omega) quad x(t) "real"
$
_Proof._ Since $(e^(j omega t))^* = e^(-j omega t)$, the conjugate can be pulled out of the integral,
$
  integral_RR x^*(t) e^(-j omega t) "d"t = (integral_RR x(t) e^(j omega t) "d"t)^* = (integral_RR x(t) e^(-j (-omega) t) "d"t)^* = X^*(-j omega)
$
If $x(t)$ is real, then $x^*(t) = x(t)$, so the two transforms agree: $X(j omega) = X^*(-j omega)$. Replacing $omega$ by $-omega$ gives the form above. In polar form, $|X(j omega)|$ is even and $angle X(j omega)$ is odd. #qed
- Differentiation and Integration
$
  ("d"x(t))/("d"t) #ftpair j omega X(j omega)
$
$
  integral_(-infinity)^t x(tau) "d"tau #ftpair 1/(j omega) X(j omega) + pi X(0) delta(omega)
$
_Proof._ Differentiating both sides of the synthesis equation with respect to $t$, the derivative acts only on $e^(j omega t)$:
$
  ("d"x(t))/("d"t) = 1/(2 pi) integral_RR X(j omega) ("d")/("d"t) e^(j omega t) "d"omega = 1/(2 pi) integral_RR [j omega X(j omega)] e^(j omega t) "d"omega
$
The bracketed term is therefore the transform of $"d"x(t) \/ "d"t$.

For integration, note that $y(t) = integral_(-infinity)^t x(tau) "d"tau = x(t) star u(t)$, so by the convolution property (@sec-ct-convolution) $Y(j omega) = X(j omega) U(j omega)$. To find $U(j omega)$, split the step into its average value and a zero-mean part,
$
  u(t) = 1/2 + 1/2 "sgn"(t)
$
The constant transforms to $1/2 dot 2 pi delta(omega) = pi delta(omega)$. For the sign function, $"d" "sgn"(t) \/ "d"t = 2 delta(t)$, so by the differentiation property $j omega S(j omega) = 2$, and $S(j omega) = 2 \/ (j omega)$; there is no impulse at $omega = 0$ because $"sgn"(t)$ has zero average. Hence
$
  U(j omega) = 1/(j omega) + pi delta(omega)
$
and
$
  Y(j omega) = X(j omega) [1/(j omega) + pi delta(omega)] = 1/(j omega) X(j omega) + pi X(0) delta(omega)
$
since $X(j omega) delta(omega) = X(0) delta(omega)$. The impulse carries the average (DC) value of the running integral, which differentiation destroys and integration cannot recover from $X(j omega) \/ (j omega)$ alone. #qed

Unlike the DTFT, the CTFT has no periodicity property: $e^(-j omega t)$ is not periodic in $omega$ for every $t$, so $X(j omega)$ is in general not periodic.
- Time and Frequency Scaling
$
  x(a t) #ftpair 1/(|a|) X((j omega) / a)
$
A special case
$
  x(-t) #ftpair X(-j omega)
$
- Parseval's
$
  integral_RR |x(t)|^2 "d"t = 1/(2 pi) integral_RR |X(j omega)|^2 "d"omega
$

== The Convolution Property <sec-ct-convolution>

We start by looking at the inverse Fourier transform,

$
  x(t) = 1/(2 pi) integral_RR X(j omega) e^(j omega t) "d"omega = lim_(omega_0 arrow 0) 1/(2 pi) sum_(k = -infinity)^infinity X(j k omega_0) e^(j k omega_0 t) omega_0
$
The response of an LTI system with impulse response $h(t)$ to a complex exponential $e^(j k omega_0 t)$ is $H(j k omega_0) e^(j k omega_0 t)$ (complex exponentials are eigenfunctions of LTI systems), where
$
  H(j k omega_0) = integral_RR h(t) e^(-j k omega_0 t) "d"t
$
is the frequency response (or transfer function) evaluated at $omega = k omega_0$. In other words, the Fourier transform of the impulse response is the complex scaling factor that the LTI system applies to the eigenfunction $e^(j k omega_0 t)$. From the superposition property, we have (where $x(t) -> y(t)$ denotes that $y(t)$ is the output for input $x(t)$)
$
  1/(2 pi) sum_(k = -infinity)^(infinity) X(j k omega_0) e^(j k omega_0 t) omega_0 arrow 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) H(j k omega_0) e^(j k omega_0 t) omega_0
$

Therefore, the response of an LTI system to $x(t)$ is
$
  y(t) = lim_(omega_0 -> 0) 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) H(j k omega_0) e^(j k omega_0 t) omega_0 = 1/ (2 pi) integral_RR X(j omega) H(j omega) e^(j omega t) "d"omega
$
Denoting the Fourier transform of $y(t)$ by $Y(j omega)$, we also have
$
  y(t) = 1 / (2 pi) integral_RR Y(j omega) e^(j omega t) "d"omega
$
We can then identify that
$
  Y (j omega) = X(j omega) H(j omega)
$

As a more formal derivation, let us consider the convolution integral
$
  y(t) = integral_RR x(tau) h(t - tau) "d"tau
$
and its Fourier transform,
$
  Y(j omega) = cal("F"){y(t)} = integral_RR [ integral_RR x(tau) h(t - tau) "d"tau ] e^(-j omega t) "d"t = integral_RR x(tau) [integral_RR h(t - tau) e^(-j omega t) "d"t] "d"tau
$
by the time-shift property, the bracketed term is simply
$
  integral_RR h(t - tau) e^(-j omega t) "d"t = e^(-j omega tau) H(j omega)
$
We then have
$
  Y(j omega) = integral_RR x(tau) e^(-j omega tau) H(j omega) "d"tau = H(j omega) integral_RR x(tau) e^(-j omega tau) "d"tau
$
hence
$
  Y(j omega) = H(j omega) X(j omega)
$
We then have
#attention("Convolution Property")[
  #eqalt(
    "y of t equals h of t convolved with x of t, which Fourier-transforms to Y of j omega equal to H of j omega times X of j omega.",
    $
      y(t) = h(t) star x(t) #ftpair Y (j omega) = H (j omega) X (j omega)
    $,
  )
]

// #example("Examples")[
//   Consider a continuous-time LTI system with impulse response
//   $
//     h(t) = delta(t - t_0)
//   $
//   The frequency response of this system is the Fourier transform of $h(t)$, and is given by
//   $
//     H(j omega) = e^(-j omega t_0)
//   $
//   Thus, for any input $x(t)$ with Fourier transform $X(j omega)$, the Fourier transform of the output is
//   $
//     Y(j omega) = H(j omega) X(j omega) = e^(-j omega t_0) X(j omega)
//   $
// ]
//
#example("Obtaining Outputs in Frequency Domain")[
  Consider the response of an LTI system with impulse response
  $
    h(t) = e^(-a t) u(t), quad a > 0
  $
  to the input signal
  $
    x(t) = e^(-b t) u(t), quad b > 0, b != a
  $
  Rather than computing $y(t) = x(t) star h(t)$, let us transform the problem into the frequency domain. The Fourier transforms of $x(t)$ and $h(t)$ are
  $
    X(j omega) = 1 / (b + j omega), quad H(j omega) = 1 / (a + j omega)
  $
  Therefore,
  $
    Y(j omega) = 1 / ((a + j omega) (b + j omega)) = A / (a + j omega) + B / (b + j omega) = (1 / (b-a))(1 / (a + j omega) - 1 / (b + j omega))
  $
  with $A = 1/(b-a)$ and $B = -1/(b-a)$.
  Hence,
  $ y(t) = 1/(b-a) (e^(-a t) u(t) - e^(-b t) u(t)) $
]

== The Multiplication Property

The convolution property has a dual: multiplication in the time domain corresponds to convolution in the frequency domain. Let $z(t) = x(t) y(t)$. Replacing $x(t)$ by its inverse Fourier transform, written with the dummy frequency variable $theta$, gives
$
  Z(j omega) = integral_RR x(t) y(t) e^(-j omega t) "d"t = integral_RR [1/(2 pi) integral_RR X(j theta) e^(j theta t) "d"theta] y(t) e^(-j omega t) "d"t
$
Exchanging the order of integration,
$
  Z(j omega) = 1/(2 pi) integral_RR X(j theta) [integral_RR y(t) e^(-j (omega - theta) t) "d"t] "d"theta
$
The bracketed term is the Fourier transform of $y(t)$ evaluated at frequency $omega - theta$, that is, $Y(j(omega - theta))$. Hence
$
  Z(j omega) = 1/(2 pi) integral_RR X(j theta) Y(j(omega - theta)) "d"theta
$
The integral is a convolution in the frequency variable: it has the same form as the convolution integral $integral_RR x(tau) h(t - tau) "d"tau$, with $omega$ in place of $t$ and the dummy variable $theta$ in place of $tau$. We write it as
$
  X(j omega) star Y(j omega) eq.delta integral_RR X(j theta) Y(j(omega - theta)) "d"theta
$
Note that $omega$ is the variable of the result, and $theta$ is integrated out; the notation does not mean that $X$ and $Y$ are multiplied at the same frequency.

#attention("Multiplication Property")[
  #eqalt(
    "z of t equals x of t times y of t, which Fourier-transforms to Z of j omega equal to one over two pi times the integral over all theta of X of j theta times Y of j times omega minus theta, d theta.",
    $
      z(t) = x(t) y(t) #ftpair Z(j omega) = 1/(2 pi) X(j omega) star Y(j omega) = 1/(2 pi) integral_RR X(j theta) Y(j(omega - theta)) "d"theta
    $,
  )
]
The factor $1\/(2 pi)$ comes from the $1\/(2 pi)$ in the synthesis equation; it would disappear if we used frequency $f$ in hertz, where $x(t) y(t) #ftpair X(f) star Y(f)$.

== (optional) Linear Phase and Group Delay <sec-group-delay>

The time-shifting property says that delaying a signal by $t_0$ multiplies its transform by $e^(-j omega t_0)$. An ideal delay is therefore the LTI system
$
  H(j omega) = e^(-j omega t_0), quad |H(j omega)| = 1, quad angle H(j omega) = -omega t_0
$
Its phase is a _linear_ function of frequency, with slope $-t_0$. Every frequency component is delayed by the same $t_0$, so the output has exactly the shape of the input.

A general system has a phase $angle H(j omega)$ that is not a straight line. To measure the delay it imposes near a frequency $omega$, we use the local slope of the phase.

#definition("Group Delay")[
  The _group delay_ of an LTI system with frequency response $H(j omega)$ is
  $
    tau(omega) = - "d" / ("d"omega) angle H(j omega)
  $
  where the phase is _unwrapped_, that is, taken as a continuous function of $omega$ without the $2 pi$ jumps that a principal value would introduce. For the ideal delay, $tau(omega) = t_0$ at every frequency.
]

The name comes from what happens to a narrowband pulse, a slowly varying envelope $s(t)$ that modulates a carrier at $omega_0$:
$
  x(t) = s(t) cos(omega_0 t) = Re{s(t) e^(j omega_0 t)}
$
Suppose that $S(j omega)$ is negligible outside a small band $|omega| < W$, with $W << omega_0$. By the frequency-shifting property, the complex signal $s(t) e^(j omega_0 t)$ has transform $S(j(omega - omega_0))$, which is concentrated near $omega_0$. Over that narrow band we may approximate the magnitude by a constant and the phase by its tangent line. Write $phi(omega) = angle H(j omega)$, so that
$
  H(j omega) approx |H(j omega_0)| e^(j [phi(omega_0) - tau(omega_0) (omega - omega_0)]), quad |omega - omega_0| < W
$
The output for the complex input is then
$
  |H(j omega_0)| e^(j phi(omega_0)) e^(-j tau(omega_0) (omega - omega_0)) S(j(omega - omega_0)) #ftpair |H(j omega_0)| e^(j phi(omega_0)) s(t - tau(omega_0)) e^(j omega_0 t)
$
where the time-shifting property (with delay $tau(omega_0)$) acts on the envelope and the frequency-shifting property restores the carrier. For a real $h(t)$, the response to $x(t)$ is the real part of this:
$
  y(t) approx |H(j omega_0)| thin s(t - tau(omega_0)) cos(omega_0 t + phi(omega_0))
$
The envelope arrives late by the group delay $tau(omega_0)$, the slope of the phase. The carrier is shifted by the phase itself, $phi(omega_0)$, which in general is a different amount. The two agree only when the phase is linear and passes through the origin.

If the phase is not linear, components at different frequencies are delayed by different amounts, and a broadband input comes out with a different shape even if $|H(j omega)| = 1$ at every frequency. This is _phase distortion_. Where the shape of a waveform matters, as in data transmission or audio, a filter is therefore designed to have nearly constant group delay across its passband, not merely the right magnitude response.

#example("Group Delay of a First-Order System")[
  #block(sticky: true)[
    Consider the first-order lowpass system
  ]
  $
    H(j omega) = 1 / (1 + j omega tau_0), quad angle H(j omega) = - arctan(omega tau_0)
  $
  Differentiating the phase,
  $
    tau(omega) = "d" / ("d"omega) arctan(omega tau_0) = tau_0 / (1 + (omega tau_0)^2)
  $
  Near $omega = 0$ the phase is close to the line $-omega tau_0$, and low-frequency components are delayed by about $tau_0$. As $omega$ grows, the phase bends toward $-pi \/ 2$ and the group delay falls to zero (@fig-group-delay). For a narrowband pulse at $omega_0 = 2 \/ tau_0$, the envelope is delayed by $tau(omega_0) = tau_0 \/ 5$ and scaled by $|H(j omega_0)| = 1 \/ sqrt(5)$.
]

#altfig(
  placement: auto,
  alt: "Two plots against omega tau sub zero from zero to five. Left: the phase of H, minus the arctangent of omega tau sub zero, starting at zero and bending down toward minus pi over two; a dashed straight line, minus omega tau sub zero, is tangent to it at the origin. Right: the group delay tau of omega divided by tau sub zero, equal to one over one plus omega squared tau sub zero squared, starting at one and decaying toward zero; a dashed horizontal line at one marks the constant delay of the tangent line.",
  caption: [
    Phase (left) and group delay (right) of $H(j omega) = 1 \/ (1 + j omega tau_0)$.
    The dashed lines belong to the ideal delay $e^(-j omega tau_0)$, whose
    phase is the tangent at the origin and whose group delay is constant.
  ],
  align(center)[
    #let w = lq.linspace(0, 5, num: 201)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      cdiagram(
        title: $angle H(j omega)$,
        xlabel: $omega tau_0$,
        width: 6cm,
        height: 4cm,
        ylim: (-2, 0.3),
        yaxis: (
          ticks: ((0, $0$), (-calc.pi / 4, $-pi/4$), (-calc.pi / 2, $-pi/2$)),
          subticks: none,
        ),
        lq.plot(w, w.map(w => -calc.atan(w).rad()), mark: none),
        lq.plot(
          w.filter(w => w <= 2),
          w.filter(w => w <= 2).map(w => -w),
          mark: none,
          stroke: series-stroke(1),
        ),
        lq.place(1.45, -1.75, align: right, plabel(fill: c-blue)[$-omega tau_0$]),
      ),
      cdiagram(
        title: $tau(omega) \/ tau_0$,
        xlabel: $omega tau_0$,
        width: 6cm,
        height: 4cm,
        ylim: (0, 1.25),
        lq.plot(w, w.map(w => 1 / (1 + w * w)), mark: none),
        lq.plot(w, w.map(w => 1), mark: none, stroke: series-stroke(1)),
      ),
    )
  ],
) <fig-group-delay>

The same ideas carry over to discrete time. A delay of $n_0$ samples has frequency response $e^(-j omega n_0)$ and group delay $n_0$. A finite impulse response that is symmetric about its midpoint, $h[n] = h[M - 1 - n]$, has phase $-omega (M - 1) \/ 2$ apart from jumps of $pi$ where the real amplitude changes sign. Its group delay is the constant $(M - 1) \/ 2$, which is why symmetric FIR filters, such as the moving average, are the standard choice when phase distortion must be avoided. We return to this in the discrete-time chapters.

== (optional) The Time-Bandwidth Relation <sec-time-bandwidth>

The rectangular pulse of @fig-rect-pulse showed that narrowing a pulse widens the main lobe of its transform. The time-scaling property makes this exact for any signal:
$
  x(a t) #ftpair 1 / (|a|) X((j omega) / a)
$
Compressing a signal in time by a factor $a > 1$ stretches its transform in frequency by the same factor. A signal cannot be made both short in time and narrow in frequency by rescaling it. The question this section answers is whether a cleverer choice of _shape_ can do better.

To answer it, we need a measure of width that applies to any signal, not just to pulses with a clear first null. Let $x(t)$ have finite energy $E = integral_RR |x(t)|^2 "d"t$, and assume for simplicity that it is centered at $t = 0$ and that its spectrum is centered at $omega = 0$ (otherwise, measure from the centers). Treating $|x(t)|^2 \/ E$ and $|X(j omega)|^2 \/ (2 pi E)$ as distributions of energy over time and over frequency, which by Parseval's relation both integrate to one, define the _RMS duration_ and _RMS bandwidth_
$
  Delta_t^2 = 1 / E integral_RR t^2 |x(t)|^2 "d"t, quad Delta_omega^2 = 1 / (2 pi E) integral_RR omega^2 |X(j omega)|^2 "d"omega
$

#theorem("Time-Bandwidth Relation")[
  For any finite-energy signal $x(t)$ for which these quantities exist,
  $
    Delta_t Delta_omega >= 1 / 2
  $
  with equality if and only if $x(t)$ is a Gaussian pulse, $x(t) = A e^(-t^2 \/ (2 sigma^2))$.
]

_Proof (for real $x(t)$)._ By the differentiation property, $x'(t) #ftpair j omega X(j omega)$, so Parseval's relation gives
$
  integral_RR omega^2 |X(j omega)|^2 "d"omega = 2 pi integral_RR |x'(t)|^2 "d"t, quad "that is," quad Delta_omega^2 = 1 / E integral_RR |x'(t)|^2 "d"t
$
Next, since $x(t) x'(t) = 1/2 "d" / ("d"t) x^2 (t)$, integration by parts (with $t x^2 (t) -> 0$ as $|t| -> infinity$) gives
$
  integral_RR t x(t) x'(t) "d"t = [1/2 t x^2 (t)]_(-infinity)^infinity - 1/2 integral_RR x^2 (t) "d"t = -E / 2
$
The Cauchy-Schwarz inequality, $|integral_RR f g "d"t|^2 <= integral_RR f^2 "d"t integral_RR g^2 "d"t$, applied with $f = t x(t)$ and $g = x'(t)$, then yields
$
  E^2 / 4 <= integral_RR t^2 x^2 (t) "d"t integral_RR x'^2 (t) "d"t = (E Delta_t^2) (E Delta_omega^2)
$
which is $Delta_t Delta_omega >= 1 \/ 2$. Equality in Cauchy-Schwarz requires $x'(t) = -c thin t x(t)$ for a constant $c > 0$, whose solutions are exactly the Gaussians $A e^(-c t^2 \/ 2)$. #qed

#example("The Gaussian Pulse")[
  #block(sticky: true)[
    The Fourier transform of a Gaussian pulse is again a Gaussian:
  ]
  $
    e^(-t^2 \/ (2 sigma^2)) #ftpair sigma sqrt(2 pi) thin e^(-sigma^2 omega^2 \/ 2)
  $
  A Gaussian of width $sigma$ in time is a Gaussian of width $1 \/ sigma$ in frequency (@fig-gaussians). Here $|x(t)|^2 = e^(-t^2 \/ sigma^2)$ is a Gaussian with variance $sigma^2 \/ 2$, so $Delta_t = sigma \/ sqrt(2)$. Likewise $|X(j omega)|^2$ has variance $1 \/ (2 sigma^2)$, so $Delta_omega = 1 \/ (sqrt(2) sigma)$. The product is
  $
    Delta_t Delta_omega = sigma / sqrt(2) dot.c 1 / (sqrt(2) sigma) = 1 / 2
  $
  which meets the bound with equality for every $sigma$.

  #altfig(
    alt: "Two plots. Left: three Gaussian pulses e to the minus t squared over two sigma squared, all of height one, for sigma equal to one half, one, and two; the pulse with sigma equal to two is the widest. Right: their Fourier transforms, sigma root two pi times e to the minus sigma squared omega squared over two, against omega; the transform for sigma equal to two is the tallest and narrowest, and the one for sigma equal to one half is the lowest and widest.",
    caption: [
      Gaussian pulses of three widths (left) and their transforms (right),
      drawn in matching styles. The widest pulse has the narrowest spectrum;
      the product of the two RMS widths is $1 \/ 2$ for all three.
    ],
    align(center)[
      #let t = lq.linspace(-5, 5, num: 301)
      #let w = lq.linspace(-6, 6, num: 301)
      #let sigmas = (0.5, 1.0, 2.0)
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 2em,
        cdiagram(
          title: $x(t)$,
          xlabel: $t$,
          width: 6cm,
          height: 4cm,
          ylim: (0, 1.6),
          ..sigmas.enumerate().map(((i, s)) => lq.plot(
            t,
            t.map(t => calc.exp(-t * t / (2 * s * s))),
            mark: none,
            stroke: series-stroke(i),
          )),
        ),
        cdiagram(
          title: $X(j omega)$,
          xlabel: $omega$,
          width: 6cm,
          height: 4cm,
          ylim: (0, 5.5),
          legend: (position: right + top),
          ..sigmas.enumerate().map(((i, s)) => lq.plot(
            w,
            w.map(w => s * calc.sqrt(2 * calc.pi) * calc.exp(-s * s * w * w / 2)),
            mark: none,
            stroke: series-stroke(i),
            label: $sigma = #s$,
          )),
        ),
      )
    ],
  ) <fig-gaussians>
]

The rectangular pulse, by contrast, has infinite RMS bandwidth: $|X(j omega)|^2$ decays only like $1 \/ omega^2$, so $omega^2 |X(j omega)|^2$ does not decay at all. Its jumps put impulses into $x'(t)$. This is why the main-lobe width, not $Delta_omega$, was the natural measure of its bandwidth in @fig-rect-pulse. Sharp edges in time always cost bandwidth.

== Table of Fourier Properties and of Basic Fourier Transform Pairs

#note("Continuous-Time Fourier Transform Properties")[
  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      stroke: 0.5pt,
      table.header([*Property*], [*Aperiodic Signal*], [*Fourier Transform*]),

      [Linearity], [$a x(t) + b y(t)$], [$a X(j omega) + b Y(j omega)$],

      [Time Shifting], [$x(t - t_0)$], [$X(j omega) e^(-j omega t_0)$],

      [Frequency Shifting], [$x(t) e^(j omega_0 t)$], [$X(j(omega - omega_0))$],

      [Conjugation], [$x^*(t)$], [$X^*(-j omega)$],

      [Time Reversal], [$x(-t)$], [$X(-j omega)$],

      [Time Scaling], [$x(a t)$], [$1/(|a|) X(j omega / a)$],

      [Frequency Scaling], [$1/(|a|) x(t / a)$], [$X(j a omega)$],

      [Convolution], [$x(t) star y(t)$], [$X(j omega) Y(j omega)$],

      [Multiplication], [$x(t) y(t)$], [$1/(2 pi) integral_RR X(j theta) Y(j(omega - theta)) "d"theta$],

      [Differentiation in Time], [$"d"/("d"t) x(t)$], [$j omega X(j omega)$],

      [Integration],
      [$integral_(-infinity)^t x(tau) "d"tau$],
      [$1/(j omega) X(j omega) + pi X(0) delta(omega)$],

      [Differentiation in Frequency], [$t x(t)$], [$j "d"/("d"omega) X(j omega)$],

      [Conjugate Symmetry for Real Signals],
      [$x(t)$ real],
      [$X(j omega) = X^*(-j omega)$],

      [Symmetry for Real and Even Signals],
      [$x(t)$ real and even],
      [$X(j omega)$ real and even],

      [Symmetry for Real and Odd Signals],
      [$x(t)$ real and odd],
      [$X(j omega)$ purely imaginary and odd],

      [Parseval's Theorem],
      [$integral_(-infinity)^(infinity) |x(t)|^2 "d"t$],
      [$1/(2 pi) integral_(-infinity)^(infinity) |X(j omega)|^2 "d"omega$],
    )]
]

#note("Continuous-Time Fourier Transform Pairs")[
  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      stroke: 0.5pt,
      table.header(
        [*Signal*],
        [*Fourier Transform*],
        [*Fourier Series Coefficients (if periodic)*],
      ),

      [$sum_k a_k e^(j k omega_0 t)$],
      [$2 pi sum_k a_k delta (omega - k omega_0)$],
      [$a_k$],

      [$e^(j omega_0 t)$],
      [$2 pi delta(omega - omega_0)$],
      [$a_1 = 1$, $a_k = 0$ for $k != 1$],

      [$cos(omega_0 t)$],
      [$pi [delta(omega - omega_0) + delta(omega + omega_0)]$],
      [$a_(plus.minus 1) = 1/2$, others = 0],

      [$sin(omega_0 t)$],
      [$j pi [delta(omega + omega_0) - delta(omega - omega_0)]$],
      [$a_1 = -j/2$, $a_(-1) = j/2$, others = 0],

      [$1$], [$2 pi delta(omega)$], [$a_0 = 1$, $a_k = 0$, $k != 0$],

      [Periodic square wave, period $T$],
      [$sum_(k=-infinity)^(infinity) (2 sin(k omega_0 T_1))/k delta(omega - k omega_0)$],
      [$a_k = (sin(k omega_0 T_1))/(k pi)$, where $T_1$ is the pulse half-width],

      [$sum_(n=-infinity)^(infinity) delta(t - n T)$],
      [$(2pi)/T sum_(k=-infinity)^(infinity) delta(omega - k omega_0)$],
      [$a_k = 1/T$ for all $k$],

      [Rectangular pulse: $cases(1 "if" |t| < T/2, 0 "if" |t| > T/2)$],
      [$T (sin(omega T/2))/(omega T/2)$],
      [N/A],

      [$(sin(W t))/(pi t)$],
      [Rectangle: $cases(1 "if" |omega| < W, 0 "if" |omega| > W)$],
      [N/A],

      [Triangular pulse: $cases(1 - (|t|)/T "if" |t| < T, 0 "if" |t| > T)$],
      [$T (sin(omega T/2))^2/(omega T/2)^2$],
      [N/A],

      [$delta(t)$], [$1$], [N/A],

      [$u(t)$], [$1/(j omega) + pi delta(omega)$], [N/A],
      [$delta(t - t_0)$], [$e^(-j omega t_0)$], [N/A],
      // [$"sgn"(t)$], [$2/(j omega)$], [N/A],

      [$e^(-a t) u(t)$, $Re{a} > 0$], [$1/(a + j omega)$], [N/A],

      [$t e^(-a t) u(t)$, $Re{a} > 0$], [$1/(a + j omega)^2$], [N/A],

      [$e^(-a |t|)$, $Re{a} > 0$], [$2a/(a^2 + omega^2)$], [N/A],

      [$t^(n-1) / ((n-1)!) e^(-a t) u(t)$, $Re{a} > 0$], [$1 / (a + j omega)^n$], [N/A],

      // [$(sin(pi t / T))/((pi t) / T) cos(omega_0 t)$],
      // [$T/2 [text("rect")((omega - omega_0)T/(2pi)) + text("rect")((omega + omega_0)T/(2pi))]$],
      // [N/A],
    )
  ]
]

== Systems Characterized by Linear Constant-Coefficient Differential Equations

We consider continuous-time LTI systems described by
$
  sum_(k = 0)^N a_k ("d"^(k) y(t)) / ("d"t^k) = sum_(k = 0)^M b_k ("d"^(k) x(t)) / ("d"t^k)
$
where $a_k$ and $b_k$ are now the coefficients of the differential equation, not Fourier series coefficients.

Taking the Fourier transform of both sides gives
$
  cal("F"){sum_(k = 0)^N a_k ("d"^(k) y(t)) / ("d"t^k)} = cal("F"){sum_(k = 0)^M b_k ("d"^(k) x(t)) / ("d"t^k)}
$
From the linearity property, this becomes
$
  sum_(k = 0)^N a_k cal("F"){("d"^(k) y(t)) / ("d"t^k)} = sum_(k = 0)^M b_k cal("F"){("d"^(k) x(t)) / ("d"t^k)}
$
and from the differentiation property,
$
  sum_(k = 0)^N a_k (j omega)^k Y(j omega) = sum_(k = 0)^M b_k (j omega)^k X(j omega)
$
or equivalently
$
  Y(j omega)[ sum_(k = 0)^N a_k (j omega)^k ] = X(j omega)[ sum_(k = 0)^M b_k (j omega)^k ]
$
Therefore, by the convolution property $Y(j omega) = H(j omega) X(j omega)$,
$
  H(j omega) = (Y(j omega))/(X(j omega)) = (sum_(k = 0)^M b_k (j omega)^k) / (sum_(k = 0)^N a_k (j omega)^k)
$

#example("Continuous-time Differential Equation Solution Using Fourier Transform")[
  #set math.equation(numbering: none)
  Consider a stable LTI system that is characterized by the differential equation
  $
    ("d"^2 y(t)) / ("d"t^2) + 4 ("d"y(t)) / ("d"t) + 3 y(t) = ("d"x(t))/("d"t) + 2 x(t)
  $
  The frequency response is simply
  $
    H(j omega) = ((j omega) + 2) / ((j omega)^2 + 4 (j omega) + 3) = (j omega + 2)/ ((j omega + 1)(j omega + 3)) = (1/2)/(j omega + 1) + (1/2)/(j omega + 3)
  $
  The inverse transform is
  $
    h(t) = 1/2 e^(-t) u(t) + 1/2 e^(-3 t) u(t)
  $
]


