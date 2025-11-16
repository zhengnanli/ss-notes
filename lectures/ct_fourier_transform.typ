#import "lib.typ": *

= The Continuous-Time Fourier Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

We developed a representation of periodic signals as linear combinations of complex exponentials. In this section, we extend these concepts to apply to signals that are not periodic. We begin by looking at the continuous-time periodic square wave again. The Fourier series coefficients $a_k$ for this square wave are
$
  a_k = (2 sin (k omega_0 T_1)) / (k omega_0 T)
$
where $omega_0 = (2 pi) / T$. Below, we plot both the time domain signal, and the Fourier series. Note that $T_1 < T_2$.

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 2em,
    [
      #let x = lq.linspace(-6, 6, num: 1000)
      #let triangle = x => if (calc.rem(x + 9, 4)) < 2 { 2.5 } else { 0 }
      #cdiagram(
        title: $x(t)$,
        xlabel: $t$,
        ylim: (-0.5, 3.5),
        xlim: (-4, 4),
        height: 4cm,
        width: 5cm,
        lq.plot(x, x.map(x => triangle(x)), mark: none),
        lq.place(-1.45, 2.5, align: center)[$1$],
        lq.place(1, -0.3, align: center)[$T_1$],
        lq.place(-1.2, -0.3, align: center)[$-T_1$],
        lq.place(2, -0.3, align: center)[$T/2$],
        lq.place(-2.3, -0.3, align: center)[$-T/2$],
        lq.place(3.8, 1.5, align: center)[$dots.c$],
        lq.place(-3.8, 1.5, align: center)[$dots.c$],
        lq.plot((2, 2), (0, 3), mark: none, stroke: (
          dash: "dashed",
          paint: red,
        )),
        lq.plot((-2, -2), (0, 3), mark: none, stroke: (
          dash: "dashed",
          paint: red,
        )),
      )],
    [
      #let n1 = lq.linspace(-6, 6, num: 31)
      #let T = 1
      #let T1 = 0.3 * T
      #let omega0 = 2 * calc.pi / T

      #cdiagram(
        title: $a_k, T = T_1$,
        xlabel: $k$,
        height: 4cm,
        width: 5cm,
        ylim: (-0.15, 1.05),
        lq.plot(n1, n1.map(n1 => if n1 == 0 { 2 * T1 / T } else {
          calc.sin(2 * calc.pi * n1 * T1 / T) / (n1 * calc.pi)
        })),
        lq.place(-0.7, 0.65, align: center)[$(2 T_1) / T$],
      )
    ],
    [
      #let n2 = lq.linspace(-6, 6, num: 61)
      #let T = 1
      #let T1 = 0.3 * T
      #let omega0 = 2 * calc.pi / T

      #cdiagram(
        title: $a_k, T = T_2$,
        xlabel: $k$,
        height: 4cm,
        width: 5cm,
        ylim: (-0.15, 1.05),
        lq.plot(n2, n2.map(n2 => if n2 == 0 { 2 * T1 / T } else {
          calc.sin(2 * calc.pi * n2 * T1 / T) / (n2 * calc.pi)
        })),
        lq.place(-0.7, 0.65, align: center)[$(2 T_1) / T$],
      )
    ],
  )
]

As we can see from the above example, intuitively, when $T arrow infinity$ (i.e., the periodic signal becomes aperiodic), the Fourier series approaches the envelop function.

== Representation of Aperiodic Signals: The Continuous-Time Fourier Transform
We start with an aperiodic signal $x(t)$, which is zero when $|t| > T_1$ for some number $T_1$. We then construct a periodic signal $tilde(x)(t)$ for which $x(t)$ is one period. As we choose the period $T$ to be larger, say $T arrow infinity$, $tilde(x)(t) arrow x(t)$.

#align(center)[
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
          color: green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 7) + 1.0) * ((x + 7) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 7) - 0.5) * ((x + 7) - 0.5) / 0.7)
          )),
          color: green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 14) + 1.0) * ((x + 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 14) - 0.5) * ((x + 14) - 0.5) / 0.7)
          )),
          color: green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x - 14) + 1.0) * ((x - 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x - 14) - 0.5) * ((x - 14) - 0.5) / 0.7)
          )),
          color: green,
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
          paint: red,
        )),
        lq.plot((-7, -7), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: red,
        )),
        lq.plot((14, 14), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: red,
        )),
        lq.plot((-14, -14), (0, 1), mark: none, stroke: (
          dash: "dashed",
          paint: red,
        )),
      )],
  )]

Let us now examine the effect of this on the Fourier series representation of $tilde(x)(t)$. We represent the $tilde(x) (t)$ by
$
  tilde(x) (t) = sum_(k = -infinity)^infinity a_k e^(j k omega_0 t)
$
where
$
  a_k = 1/T integral_(-T/2)^(T/2) tilde(x) (t) e^(-j k omega_0 t) "d"t
$ <aktildex>
and $omega_0 = (2 pi) / T$. Since $tilde(x) (t) arrow x(t)$ for $|t| < T / 2$, and $x(t)$ = 0 outside this interval, we can rewrite @aktildex as
$
  a_k = 1/T integral_(-T/2)^(T/2) tilde(x)(t) e^(-j k omega_0 t) "d" t = 1/T integral_RR x(t) e^(-j k omega_0 t) "d" t
$
Therefore, defining the envelope $X(j omega)$ of $T a_k$ as
$
  X(j omega) = integral_RR x(t) e^(- j omega t) "d"t
$
we have, for the coefficients $a_k$,
$
  a_k = 1/T X(j k omega_0)
$
then, we can represent $tilde(x) (t)$ now with
$
  tilde(x) (t) = sum_(k = -infinity)^infinity a_k e^(j k omega_0 t) = sum_(k = -infinity)^infinity 1/T X(j k omega_0) e^(j k omega_0 t) = 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) e^(j k omega_0 t) omega_0
$
As $T arrow infinity$, $omega_0 arrow 0$, $tilde(x) (t) arrow x(t)$, and consequently,
$
  x(t) = lim_(omega_0 arrow 0) 1 / (2 pi) sum_(k = -infinity)^(infinity) X(j k omega_0) e^(j k omega_0 t) omega_0 = 1 / (2 pi ) integral_RR X(j omega) e^(j omega t) "d" omega
$

The process of $omega_0 arrow infinity$ is depicted below. As $omega_0 arrow 0$, the summation converges to the integral of $X(j omega) e^(j omega t)$.

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
  #cdiagram(
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
      stroke: 0.2pt + red,
    ),
    lq.plot((xd.at(8), xd.at(8)), (0, yd.at(8)), mark: none, stroke: (
      dash: "dashed",
      paint: red,
    )),
    lq.plot((xd.at(9), xd.at(9)), (0, yd.at(9)), mark: none, stroke: (
      dash: "dashed",
      paint: red,
    )),
    lq.place(0.4, -0.2, align: left)[$omega_0$],
    lq.place(0.4, 1.8, align: left)[$X(j k omega_0) e^(j k omega_0 t)$],
  )]

We define the Fourier transform pair as follows.
#definition("Fourier Transformation Pair")[
  The Fourier transform is defined as
  $
    X(j omega) = integral_(-infinity)^(infinity) x(t) e^(-j omega t) "d"t
  $
  And the inverse Fourier transform is defined as
  $
    x(t) = 1/(2 pi) integral_(-infinity)^(infinity) X(j omega) e^(j omega t) "d" omega
  $
]

When comparing the Fourier coefficients $a_k$ of a periodic signal $tilde(x) (t)$, and exploiting the fact that $x(t)$ is zero outside the range $s <= t <= s + T$, we have
$
  a_k = 1/T integral_(s)^(s+T) tilde(x) (t) e^(-j k omega_0 t) "d"t = 1/T integral_s^(s+T) x(t) e^(-j k omega_0 t) "d"t = 1/T integral_(-infinity)^infinity x(t) e^(-j k omega t) "d"t
$

Comparing the equation with the Fourier transform, we conclude that
$
  a_k = 1/T X(j omega) lr(|, size: #200%)_(omega=k omega_0)
$
where $X(j omega)$ is the Fourier transform of $x(t)$. Intuitively, $a_k$ are _samples_ of the Fourier transform of one period of $tilde(x) (t)$.

== Convergence of Fourier Transforms

Similar to the Fourier series, there is a set of contidions which are sufficient to ensure that $tilde(x) (t)$ is equals to $x(t)$ for any $t$ except at a discontinuity. The Dirichlet conditions state require that

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
    X(j omega) = integral_RR x(t) e^(-j omega t) "d"t = integral_0^infinity e^(-a t) e^(-j omega t) = - 1/(a + j omega) e^(-(a + j omega) t) lr(|, size: #200%)^infinity_0 = 1 / (a + j omega), quad a > 0
  $

  Consider then the signal
  $
    x(t) = e^(-a|t|), quad a > 0
  $
  The Fourier transform is
  $
    X(j omega) = integral_(-infinity)^(infinity) e^(-a|t|) e^(-j omega t) "d" t = integral_(-infinity)^0 e^(a t) e^(-j omega t) "d"t + integral_0^infinity e^(- a t) e^(-j omega t) "d" t = (2a) / (a^2 + omega^2)
  $

  Let us now determine the Fourier transform of the unit impulse
  $
    X(j omega) = integral_RR delta(t) e^(-j omega t) "d"t = 1
  $

  The Fourier transform of the rectangular pulse signal
  $
    x(t) = cases(1\, quad |t| < T_1, 0\, quad |t| > T_1)
  $
  is
  $
    X(j omega) = integral_(-T_1)^(T_1) e^(-j omega t) "d"t = (2 sin(omega T_1))/omega = 2 T_1 "sinc"((omega T_1)/pi)
  $

  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #let x = lq.linspace(-6, 6, num: 1000)
        #let triangle = x => if calc.abs(x) < 2 { 2.5 } else { 0 }
        #cdiagram(
          title: $x(t)$,
          xlabel: $t$,
          ylim: (-0.5, 3.5),
          xlim: (-4, 4),
          height: 4cm,
          width: 6cm,
          lq.plot(x, x.map(x => triangle(x)), mark: none),
          lq.place(-1.45, 2.7, align: center)[$1$],
          lq.place(2.3, -0.3, align: center)[$T_1$],
          lq.place(-2.3, -0.3, align: center)[$-T_1$],
        )],
      [
        #let n1 = lq.linspace(-6, 6, num: 81)
        #let T = 1
        #let T1 = 0.3 * T
        #let omega0 = 2 * calc.pi / T

        #cdiagram(
          title: $X(j omega)$,
          xlabel: $omega$,
          height: 4cm,
          width: 6cm,
          ylim: (-0.15, 0.85),
          lq.plot(
            n1,
            n1.map(n1 => if n1 == 0 { 2 * T1 / T } else {
              calc.sin(2 * calc.pi * n1 * T1 / T) / (n1 * calc.pi)
            }),
            mark: none,
          ),
          lq.place(-0.85, 0.68, align: center)[$2 T_1$],
          lq.place(1, -0.1, align: center)[$pi / T_1$],
          lq.place(-1, -0.1, align: center)[$-pi / T_1$],
        )
      ],
    )]
  Consider the Fourier transform of the signal $x(t)$
  $
    X(j omega) = cases(1\, quad |omega| < W, 0\, quad |omega| > W)
  $
  The inverse Fourier transform is
  $
    x(t) = 1/(2 pi) integral_RR X(j omega) e^(j omega t) "d"t = 1/(2 pi) integral_(-W)^W e^(j omega t) "d"t = (sin W t)/(pi t) = W/pi "sinc"((W t)/pi)
  $
]

== Properties of the Continuous-Time Fourier Transform

We denote a Fourier pair as
$
  x(t) arrow.l.r^limits(cal("F")) X(j omega)
$

We list the properties without proof below

- Linearity:
$
  a x(t) + b y(t) arrow.l.r^limits(cal("F")) a X(j omega) + b Y(j omega)
$
- Time Shifiting:
$
  x(t - t_0) arrow.l.r^limits(cal("F")) e^(-j omega t_0) X(j omega)
$
- Conjugation and Conjugate Symmetry
$
  x^*(t) arrow.l.r^limits(cal("F")) X^*(-j omega)
$
$
  X(-j omega) = X^*(j omega) quad x(t) "real"
$
- Differentiation and Integration
$
  ("d" x(t))/("d" t) arrow.l.r^limits(cal("F")) j omega X(j omega)
$
$
  integral_(-infinity)^t x(tau) "d"tau arrow.l.r^limits(cal("F")) 1/(j omega) X(j omega) + pi X(0) delta(omega)
$
- Time and Frequency Scaling
$
  x(a t) arrow.l.r^limits(cal("F")) 1/(|a|) X((j omega) / a)
$
A special case
$
  x(-t) arrow.l.r^limits(cal("F")) X(-j omega)
$
- Parseval's
$
  integral_RR |x(t)|^2 "d"t = 1/(2 pi) integral_RR |X(j omega)|^2 "d" omega
$

== The Convolution Property

We start by looking at the inverse Fourier transform,

$
  x(t) = 1/(2 pi) integral_RR X(j omega) e^(j omega t) "d" omega = lim_(omega_0 arrow 0) 1/(2 pi) sum_(k = -infinity)^infinity X(j k omega_0) e^(j k omega_0 t) omega_0
$
The response of a linear system with impulse response $h(t)$ to a complex exponential $e^(j k omega_0 t)$ is $H(j k omega_0) e^(j k omega_0 t)$ (i.e., the eigenfunction), where
$
  H(j k omega_0) = integral_RR h(t) e^(-j k omega_0 t) "d"t
$
is the frequency response (or transfer function) evaluated at $omega = k omega_0$. In other words, the Fourier transform of the impulse response is the complex scaling factor that the LTI system applies to the eigenfunction $e^(j k omega_0 t)$. From the superposition property, we have
$
  1/(2 pi) sum_(k = -infinity)^(infinity) X(j k omega_0) e^(j k omega_0 t) omega_0 arrow 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) H(j k omega_0) e^(j k omega_0 t) omega_0
$
Note that $x(t) -> y(t)$ denotes the output $y(t)$ corresponds to the input $x(t)$.

Therefore, the response of linear system to $x(t)$ is
$
  y(t) = lim_(omega_0 -> 0) 1 / (2 pi) sum_(k = -infinity)^infinity X(j k omega_0) H(j k omega_0) e^(j k omega_0 t) omega_0 = 1/ (2 pi) integral_RR X(j omega) H(j omega) e^(j omega t) "d"omega
$
We also know that the Fourier transform of $y(t)$ is $Y(j omega)$:
$
  y(t) = 1 / (2 pi) integral_RR Y(j omega) e^(j omega t) "d" t
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
  Y(j omega) = cal("F"){y(t)} = integral_RR [ integral_RR x(tau) h(t - tau) "d"tau ] e^(-j omega t) "d"t = integral_RR x(tau) [integral_RR h(t - tau) e^(-j omega t) "d"t] "d" tau
$
by the time-shift property, the bracked term is simply
$
  integral_RR h(t - tau) e^(-j omega t) "d" t = e^(-j omega tau) H(j omega)
$
We the have
$
  Y(j omega) = integral_RR x(tau) e^(-j omega tau) H(j omega) "d"tau = H(j omega) integral_RR x(tau) e^(-j omega tau) "d"tau
$
hence
$
  Y(j omega) = H(j omega) X(j omega)
$
We then have
#attention("Convolution Property")[
  $
    y(t) = h(t) star x(t) arrow.l.r^limits(cal("F")) Y (j omega) = H (j omega) X (j omega)
  $
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
    x(t) = e^(-b t) u(t), quad b > 0
  $
  Rather than computing $y(t) = x(t) star h(t)$, let us transform the problem into the frequency domain. The Fourier transform of $x(t)$ and $h(t)$ are
  $
    X(j omega) = 1 / (b + j omega), quad H(j omega) = 1 / (a + j omega)
  $
  Therefore,
  $
    Y(j omega) = 1 / ((a + j omega) (b + j omega)) = A / (a + j omega) + B / (b + j omega) = (1 / (b-a))(1 / (a + j omega) - 1 / (b + j omega))
  $
  Hence,
  $ y(t) = 1/(b-a) (e^(-a t) u(t) - e^(-b t) u(t)) $
]

== Table of Fourier Properties and of Basic Fourier Transformation Pairs

#note("Continuous-Time Fourier Transform Properties")[
  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      stroke: 0.5pt,
      [*Property*], [*Aperiodic Signal*], [*Fourier Transform*],

      [Linearity], [$a x(t) + b y(t)$], [$a X(j omega) + b Y(j omega)$],

      [Time Shifting], [$x(t - t_0)$], [$X(j omega) e^(-j omega t_0)$],

      [Frequency Shifting], [$x(t) e^(j omega_0 t)$], [$X(j(omega - omega_0))$],

      [Conjugation], [$x^*(t)$], [$X^*(-j omega)$],

      [Time Reversal], [$x(-t)$], [$X(-j omega)$],

      [Time Scaling], [$x(a t)$], [$1/(|a|) X(j omega / a)$],

      [Frequency Scaling], [$1/(|a|) x(t / a)$], [$X(j a omega)$],

      [Convolution], [$x(t) star y(t)$], [$X(j omega) Y(j omega)$],

      [Multiplication], [$x(t) y(t)$], [$1/(2 pi) X(j omega) star Y(j omega)$],

      [Differentiation in Time], [$"d"/("d"t) x(t)$], [$j omega X(j omega)$],

      [Integration],
      [$integral_(-infinity)^t x(tau) d tau$],
      [$1/(j omega) X(j omega) + pi X(0) delta(omega)$],

      [Differentiation in Frequency], [$t x(t)$], [$j d/d omega X(j omega)$],

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
      [$integral_(-infinity)^(infinity) |x(t)|^2 d t$],
      [$1/(2 pi) integral_(-infinity)^(infinity) |X(j omega)|^2 d omega$],
    )]
]

#note("Continuous-Time Fourier Transform Pairs")[
  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      stroke: 0.5pt,
      [*Signal*],
      [*Fourier Transform*],
      [*Fourier Series Coefficients (if periodic)*],

      [$sum_k a_k e^(j k omega_0 t)$],
      [$2 pi sum_k a_k delta (omega - k omega_0)$],
      [$a_k$],

      [$e^(j omega_0 t)$],
      [$2 pi delta(omega - omega_0)$],
      [$a_k = delta[k - k_0]$ where $omega_0 = k_0 omega_0$],

      [$cos(omega_0 t)$],
      [$pi [delta(omega - omega_0) + delta(omega + omega_0)]$],
      [$a_(plus.minus 1) = 1/2$, others = 0],

      [$sin(omega_0 t)$],
      [$j pi [delta(omega + omega_0) - delta(omega - omega_0)]$],
      [$a_(plus.minus 1) = plus.minus j/2$, others = 0],

      [$1$], [$2 pi delta(omega)$], [$a_0 = 1$, $a_k = 0$, $k != 0$],

      [Periodic square wave, period $T$],
      [$2pi/T sum_(k=-infinity)^(infinity) (sin(k omega_0 T_1))/(k omega_0 T_1) delta(omega - k omega_0)$],
      [$a_k = (sin(k omega_0 T_1))/(k omega_0 T_1)$ where $T_1$ is pulse width],

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

      [$t^(n-1) / ((n-1)!) e^(-a t) u(t)$], [$1 / (a + j omega)^n$], [N/A],

      // [$(sin(pi t / T))/((pi t) / T) cos(omega_0 t)$],
      // [$T/2 [text("rect")((omega - omega_0)T/(2pi)) + text("rect")((omega + omega_0)T/(2pi))]$],
      // [N/A],
    )
  ]
]

== Systems Characterized by Linear Constant-Coefficient Differential Equations

We consider the following continuous-time LTI systems
$
  sum_(k = 0)^N a_k ("d"^(k) y(t)) / ("d" t^k) = sum_(k = 0)^M b_k ("d"^(k) x(t)) / ("d" t^k)
$

From the convolution property, we have
$
  Y(j omega) = H(j omega) X(j omega)
$

Let us perform the Fourier transform to both sides
$
  cal("F"){sum_(k = 0)^N a_k ("d"^(k) y(t)) / ("d" t^k)} = cal("F"){sum_(k = 0)^M b_k ("d"^(k) x(t)) / ("d" t^k)}
$
From the linearity property, this becomes
$
  sum_(k = 0)^N a_k cal("F"){a_k ("d"^(k) y(t)) / ("d" t^k)} = sum_(k = 0)^M b_k cal("F"){b_k ("d"^(k) x(t)) / ("d" t^k)}
$
and from the differentiation property,
$
  sum_(k = 0)^N a_k (j omega)^k Y(j omega) = sum_(k = 0)^M b_k (j omega)^* X(j omega)
$
or equivalently
$
  Y(j omega)[ sum_(k = 0)^N a_k (j omega)^k ] = X(j omega)[ sum_(k = 0)^M b_k (j omega)^k ]
$
Therefore,
$
  H(j omega) = (Y(j omega))/(X(j omega)) = (sum_(k = 0)^M b_k (j omega)^k) / (sum_(k = 0)^N a_k (j omega)^k)
$

#example("Continuous-time Differential Equation Solution Using Fourier Transform")[
  #set math.equation(numbering: none)
  Consider a stable LTI system that is characterized by the differential equation
  $
    ("d"^2 y(t)) / ("d" t^2) + 4 ("d" y(t)) / ("d" t) + 3 y(t) = ("d" x(t))/("d" t) + 2 x(t) 
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


