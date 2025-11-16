#import "lib.typ": *

= Introduction

Signals describe a wide variety of physical phenomena. In this course, we intend to develop and analyze signals within an analytical framework using mathematical descriptions and representations. Signals are represented mathematically as functions of one or more _independent_ variables. For example, a speech signal is represented mathematically by acoustic pressure as a function of time. In many other applications, such as in civil engineering, the annual average vertical wind profile (expressed in wind speed) is often a function of height. Below, we show results from spectroscopy, measuring relative intensity as a function of wavelength.

#let (λ, intensity) = lq.load-txt(
  read("spectrum_o2.txt"),
  skip-rows: 2,
  delimiter: " ",
)
#let h = 6.62607015e-34
#let c = 299792458
#let e = 1.60217733e-19
#let k = 1e9 * h * c / e

#cdiagram(
  width: 10cm,
  margin: 3%,

  xaxis: (offset: 0, mirror: false),
  xlabel: [Wavelength (nm)],
  ylabel: [Relative intensity],

  lq.plot(λ, intensity, mark: none),

  lq.xaxis(
    position: top,
    label: [Energy (eV)],
    offset: 0,
    exponent: 0,
    tick-distance: 5e-5,
    functions: (λ => k / λ, E => k / E),
  ),
)

In this course, most of our signals are functions of time, or in other words, time series. We will consider two types of signals: *continuous-time* signals (CT) and *discrete-time* (DT) signals. In general, we use $t$ to represent continuous time and $n$ for discrete time. In addition, we denote continuous-time signals as $x(t)$ and discrete-time signals as $x[n]$. We will start by discussing a few typical signals.

We begin by defining signal energy and power. The signal energy is defined as

$
  E_infinity eq.delta integral_RR |x (t)|^2 "d"t
$

and the signal power is defined as
$
  P_infinity eq.delta lim_(T arrow infinity) 1/(2T) integral_(-T)^(T) |x(t)|^2 "d" t
$
for some time interval $T$.

== Typical Signals
#show: lq.theme.schoolbook
#show: schoolbook-style

// === Basic Types of Signals

=== Continuous versus Discrete Signals

Continuous-Time Signal: independent variable in continuous dependent variable defined for each value. For example, position of a vehicle as a function of time; sun intensity as a function of time in a day.

Discrete-Time Signal: independent variable defined for only certain values so the signal is only defined for these values. For example, luggage lost each day at an airport, pixels in an image.

=== Analog versus Digital Signals

Analog Signal: over a finite interval, the signal can take infinite number of values.

Digital Signal: over a finite interval, the signal can only take finite number of values.

The discrete-time signal can be _sampled_ from continuous-time signal. We will discuss the process of sampling in great detail later in this class.

=== Deterministic versus Random Signals

Deterministic Signal: can be defined via a specific mathematical function. For example, the output voltage of a circuit.

Random Signal: ca only be described using probabilistic models. For example, the noise in a sensor's readings.

=== Periodic and Aperiodic Signals

Periodic signals are those which repeat after a finite fixed time interval has elapsed. The smallest positive value of $T$ in $x(t) = x(t + T)$ is defined as the (fundamental) period.

#example("Periodic and Aperiodic Signals")[
  - $x(t) = cos(2 pi t) + sin (2 t)$ is not periodic. We cannot find a common period that can be formed from the underlying periods.
  - $x[n] = cos (2 n)$ is also aperiodic. The `cosine` function has a period of $pi$, but $pi$ is not an integer (because $n$ has to be integer).
  - $x[n] = cos( pi n^2 )$, however, is periodic. It has a period of 1.
]

=== Finite and Infinite Signals

Finite signals are defined over a fixed time interval. Infinite signals are defined over all time, i.e., $t in (-infinity, infinity)$, or $t in RR$. In the discrete-time case, $n in NN$.

=== Even versus Odd Signals

A signal is even if when time is reversed, you obtain the same signal, i.e., $x(-t) = x(t)$, or $x[-n] = x[n]$. A signal is odd if when time is reversed, you obtain the negative of the signal, i.e., $x(-t) = -x(t)$, or $x[-n] = -x[n]$.

Given a signal $x(t)$, we can obtain the even and odd components as follows
$
  "Even"{x(t)} = 1/2 [ x(t) + x(-t) ]
$
and
$
  "Odd"{x(t)} = 1/2 [ x(t) - x(-t) ]
$

=== Complex Exponential and Sinusoidal Signals

The continuous-time _complex exponential signal_ is of the form
$ x(t) = C e^(a t) $
where $C$ and $a$ are, in general, complex numbers. This signal form serves as a building block for analyzing more complex signals and systems.

We start by examining the simplest case: _real exponential signals_, where both $C$ and $a$ are real numbers. The behavior of these signals is determined by the sign of the parameter $a$. As illustrated in the figures below, when $a$ is positive, the signal exhibits exponential growth as time increases, while when $a$ is negative, the signal decays exponentially toward zero. These exponential behaviors model physical phenomena such as population growth, radioactive decay, and the charging and discharging of capacitors in electrical circuits.

#let x = lq.linspace(-2.3, 2.3)
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #cdiagram(
        title: $x(t) = C e^(a t), a > 0, a, C in bb("R")$,
        xlabel: $t$,
        lq.plot(x, x.map(x => calc.exp(x)), mark: none),
      )],
    [
      #cdiagram(
        title: $x(t) = C e^(a t), a < 0, a, C in bb("R")$,
        xlabel: $t$,
        lq.plot(x, x.map(x => calc.exp(-x)), mark: none),
      )],
  )]

=== Periodic Complex Exponential and Sinusoidal Signals

We now consider complex exponential signals of a special form. Let us examine the following signal:
$ x(t) = e^(j omega_0 t) $

This signal represents one of the most important functions in signal processing and engineering. The signal is periodic with a period related to the frequency parameter $omega_0$. To understand this periodicity, we require that
$ e^(j omega_0 t) = e^(j omega_0 (t + T)) $
Expanding the right side and using properties of complex exponentials, it follows that for the signal $x(t)$ to be periodic, we must have $e^(j omega_0 T) = 1$. This condition is satisfied when $omega_0 T = 2pi k$ for any integer $k$, giving us the period $T_0 = (2pi)/omega_0$.

A signal that is closely related to the periodic complex exponential is the _sinusoidal signal_:
$ x(t) = A cos (omega_0 t + phi) $
where $A$ is the amplitude (determining the signal's peak value), $omega_0$ is the angular frequency in radians per second, and $phi$ is the phase shift. Sinusoidal signals appear in alternating current electrical systems, mechanical vibrations, and acoustic waves. To determine the period of this sinusoidal signal, we seek the smallest positive value $T_0$ that satisfies $x(t) = x(t + T_0)$ for all $t$. Using trigonometric identities, it can be shown that $T_0 = (2 pi)/omega_0$, which matches the period of the complex exponential with the same frequency parameter.

#let x = lq.linspace(-5, 8, num: 100)
#align(center)[
  #cdiagram(
    title: $x(t) = A cos (omega_0 t + phi)$,
    xlabel: $t$,
    lq.plot(x, x.map(x => 0.5 * calc.cos(1.3 * x - 2.3)), mark: none),
    lq.place(0, -0.3, align: left)[$A cos(phi)$],
    lq.place(2.7, 0.4, align: left)[$T = (2 pi) / omega_0$],
    lq.line(
      tip: tiptoe.stealth,
      toe: tiptoe.stealth,
      (1.75, 0.5),
      (6.55, 0.5),
    ),
  )]

Euler's relation provides the connection between exponential and trigonometric functions:
#theorem("Euler's Relation")[
  // #math.equation(block: true, numbering: none)[
  $
    e^(j alpha) = cos (alpha) + j sin (alpha)
  $
  // ]
]
Using Euler's relation, we can express any sinusoid in terms of complex exponential signals:
$ A cos(omega_0 t + phi) = A Re {e^(j (omega_0 t + phi))} $
and
$ A sin(omega_0 t + phi) = A Im {e^(j (omega_0 t + phi))} $
These relationships allow us to represent real sinusoidal signals using complex exponentials, simplifying many mathematical operations in signal processing.

=== General Complex Exponential Signals

Having examined real exponentials and purely imaginary exponentials separately, we now consider the most general case where both the amplitude and the exponent can be complex. We examine the general form, which occurs when $C = |C| e^(j theta)$ and $a = r + j omega_0$, where $r$ and $omega_0$ are real numbers.

This general complex exponential combines the exponential growth or decay behavior (controlled by the real part $r$) with oscillatory behavior (controlled by the imaginary part $omega_0$). Using Euler's relation, we can expand this general form:
$
  C e^(a t) = |C| e^(r t) cos (omega_0 t + theta) + j |C| e^(r t) sin(omega_0 t + theta)
$

The real part of this expression, $|C| e^(r t) cos (omega_0 t + theta)$, represents a sinusoidal oscillation whose amplitude either grows exponentially (when $r > 0$), decays exponentially (when $r < 0$), or remains constant (when $r = 0$). This type of signal appears in the analysis of damped or growing oscillations, such as the response of an underdamped second-order system or the natural resonance of mechanical structures with energy loss or gain.

#let x = lq.linspace(-3.2, 5.2, num: 220)
#cdiagram(
  title: $Re {C e^(a t)}= |C| e^(r t) cos(omega_0 t + theta); alpha > 1$,
  xlabel: $t$,
  lq.plot(x, x.map(x => calc.exp(0.3 * x) * calc.cos(5 * x)), mark: none),
  lq.plot(
    x,
    x.map(x => calc.exp(0.3 * x)),
    mark: none,
    stroke: stroke(dash: "dotted"),
  ),
  lq.plot(
    x,
    x.map(x => -calc.exp(0.3 * x)),
    mark: none,
    stroke: stroke(dash: "dotted"),
  ),
)

=== Complex Exponential and Sinusoidal Signals

The discrete-time analog of the complex exponential signal is given by
$ x[n] = C alpha^n $
where $C$ and $alpha$ are complex numbers. This is the fundamental building block for discrete-time signal analysis, just as $C e^(a t)$ is for continuous-time signals.

For the case where both $C$ and $alpha$ are real, we get the discrete-time real exponential sequence. The behavior of this sequence depends on the value of $alpha$: when $|alpha| > 1$, the sequence grows in magnitude, and when $|alpha| < 1$, it decays. The discrete-time complex exponential signal can also be written as
$ x[n] = e^(j omega_0 n) $
where $omega_0$ is the discrete-time frequency in radians per sample.

The discrete-time sinusoidal sequence is expressed as
$
  x[n] = A cos (omega_0 n + phi) = A / 2 e^(j phi) e^(j omega_0 n) + A / 2 e^(-j phi) e^(-j omega_0 n)
$
This representation shows how a real sinusoidal sequence can be decomposed into a sum of two complex exponential sequences, which is fundamental to frequency domain analysis.

#let x = lq.linspace(-2.3, 2.3, num: 10)
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #lq.diagram(
        title: $x[n] = C alpha^n, |alpha| > 1, alpha, C in bb("R")$,
        height: 3cm,
        ylim: (-2, 11),
        xlabel: $n$,
        lq.stem(x, x.map(x => calc.exp(x))),
      )],
    [
      #lq.diagram(
        title: $x[n] = C alpha^n, |alpha| < 1, alpha, C in bb("R")$,
        height: 3cm,
        ylim: (-2, 11),
        xlabel: $n$,
        lq.stem(x, x.map(x => calc.exp(-x))),
      )],
  )]

=== General Complex Exponential Signals

We now examine the discrete-time analog. If we write $C$ and $alpha$ in polar form, namely $C = |C| e^(j theta)$ and $alpha = |alpha| e^(j omega_0)$, we obtain the discrete-time equivalent of the general complex exponential:
$
  C alpha^n = |C| |alpha|^n cos (omega_0 n + theta) + j |C| |alpha|^n sin (omega_0 n + theta)
$

This expression shows the discrete-time counterpart to the growing or decaying sinusoidal behavior observed in continuous time. The magnitude $|alpha|$ determines whether the sequence grows ($|alpha| > 1$), decays ($|alpha| < 1$), or maintains constant amplitude ($|alpha| = 1$). The discrete frequency $omega_0$ controls the rate of oscillation, while the initial phase $theta$ determines the starting point of the oscillation.

The figure below illustrates the real part of such a sequence, showing how discrete samples follow an exponentially modulated sinusoidal pattern. The dotted envelope lines show the exponential growth or decay boundary, while the discrete samples oscillate within this envelope. This type of signal appears frequently in the analysis of discrete-time systems, digital filters, and sampled-data control systems.

#let x = lq.linspace(-3.2, 8.5, num: 220)
#let n = lq.linspace(-3.2, 8.5, num: 70)

#cdiagram(
  title: $Re {C alpha^n} = |C| |alpha|^n cos(omega_0 n + theta); alpha > 1$,
  xlabel: $n$,
  lq.stem(n, n.map(n => calc.exp(0.3 * n) * calc.cos(2 * n))),
  lq.plot(
    x,
    x.map(x => calc.exp(0.3 * x)),
    mark: none,
    stroke: stroke(dash: "dotted"),
  ),
  lq.plot(
    x,
    x.map(x => -calc.exp(0.3 * x)),
    mark: none,
    stroke: stroke(dash: "dotted"),
  ),
)

=== Periodicity Properties of Discrete-Time Complex Exponentials

In order for the signal $e^(j omega_0 n)$ to be periodic with period $N > 0$, we must have $e^(j omega_0 (n + N)) = e^(j omega_0 n)$, i.e., $omega_0 / (2 pi ) = m / N$. In continuous-time, as $omega_0$ increases, the signal will oscillate with higher frequnecy. However, this is _not_ the case in discrete-time. Consider now
$
  e^(j omega_0 n) equiv e^(j (omega_0 + 2 pi) n) = e^(j omega_0 n) e^(j -2 pi n) equiv 1
$

In discrete-time, the frequency $omega_0 + 2 pi k$ is the _same_ $omega_0$ as the frequency $omega_0$. In continuous-time, $e^(j omega_0 t)$ is unique for each frequency $omega_0$. However, this is not the case in discrete-time. The signal with frequency $omega_0$ is the same as the signal with frequency $omega_0 plus.minus 2 n pi$. Thus, in discrete-time, frequency is only defined over the interval $0 < omega_0 < 2 pi$, or $-pi < omega_0 < pi$.

Now, let us compute the period $N$ for a discrete-time sinusoid:
$
  e^(j omega_0 n) = e^(j (omega_0 n + N)) = e^(j omega_0 n) e^(j omega_0 N)
$
Therefore, we need to have
$
  omega_0 N = 2 pi k arrow N = k ((2 pi) / (omega_0))
$
Since $N in NN$, $(2 pi) / N$ must be an integer. If $(2 pi) / N$ is irrational, the said signal is not periodic.

#example("Periodicity of Discrete-Time Complex Exponentials")[
  - $cos ((8 pi n) / 31) => N = k (2 pi)/((8 pi) / 31) => N = 31$.
  - $e^(j ((2 pi) / 3) n) + e^(j ((3 pi) / 4) n) => N_1 = 3, N_2 = 8/3 => N = 24$.
]

=== `sinc` signal

In general, there are two similar definitions of the `sinc` signal and alike, namely,

$
  "sa"(t) = (sin (t))/ t
$

and

$
  "sinc"(t) = (sin (pi t)) / (pi t)
$

The $"sa"(t)$ is shown below. It is easy to show that
$
  integral_(-infinity)^(infinity) "sa"(t) "d" t = pi
$

#let x = lq.linspace(-20, 20, num: 420)
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #lq.diagram(
        xlabel: $t$,
        title: $"sinc"(t)$,
        xlim: (-5, 5),
        height: 3.5cm,
        lq.plot(
          x,
          x.map(x => calc.sin(calc.pi * x) / (calc.pi * x)),
          mark: none,
        ),
        lq.place(1.2, -0.1, align: left)[$1$],
        lq.place(2.2, -0.1, align: left)[$2$],
        lq.place(3.0, -0.1, align: left)[$dots.c$],
      )],
    [
      #lq.diagram(
        xlabel: $t$,
        title: $"sa"(t)$,
        xlim: (-15, 15),
        height: 3.5cm,
        lq.plot(x, x.map(x => calc.sin(x) / x), mark: none),
        lq.place(calc.pi + 0.5, -0.1, align: left)[$pi$],
        lq.place(calc.pi * 2 + 0.1, -0.1, align: left)[$2pi$],
        lq.place(calc.pi * 3 + 0.1, -0.1, align: left)[$dots.c$],
      )
    ],
  )
]

=== Unit Impulse and Unit Step Functions

==== Discrete-Time Unit Impulse and Unit Step Functions

One of the simplest discrete-time signals is the _unit impulse_ (or _unit sample_), which is _defined_ as
#definition("Unit Impulse and Unit Step")[
  The discrete-time unit impulse function is defined as
  $
    delta[n] = cases(0 \, quad n eq.not 0, 1 \, quad n = 0)
  $
  The unit impulse is plotted on the left figure.
  The discrete-time unit step function is defined as
  $
    u[n] = cases(0 \, quad n < 0, 1 \, quad n >= 0)
  $
  and it is plotted on the right.

  #let n = range(-5, 6)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #lq.diagram(
          title: [$delta[n]$],
          xlabel: $n$,
          ylim: (-0.1, 1.2),
          width: 5cm,
          height: 3cm,
          lq.stem(
            n,
            n.map(n => if n == 0 { 1 } else { 0 }),
            stroke: 2.0pt,
            mark-size: 10pt,
          ),
        )],
      [#lq.diagram(
          title: [$u[n]$],
          xlabel: $n$,
          ylim: (-0.1, 1.2),
          width: 5cm,
          height: 3cm,
          lq.stem(
            n,
            n.map(n => if n >= 0 { 1 } else { 0 }),
            stroke: 2.0pt,
            mark-size: 10pt,
          ),
        )
      ],
    )
  ]
]

There is a close relationship between the discrete-time unit impulse and unit step. In particular, the discrete-time unit impulse is the _first difference_ of the discrete-time step:
$ delta[n] = u[n] - u[n-1] $
Conversely, the discrete-time unit step is the _running sum_ of the unit sample, viz.,
$ u[n] = sum_(m=-infinity)^(infinity) delta[m] $ <runningsum>

By changing the summation in @runningsum, we find that the discrete-time unit step can also be written as
$ u[n] = sum_(k=0)^infinity delta[n-k] $

One interesting fact about the unit impulse is that it can be used to *sample* the value of a signal at time $n = n_0$, i.e.,
$ x[n] delta[n - n_0] = x[n_0] delta[n - n_0] $

We will see more applications when we discuss sampling later in the course.

==== Continuous-Time

The continuous-time _unit step function_ $u(t)$ is defined in a manner similar to its discrete-time counterpart, i.e.,

$ u (t) = cases(0 \, quad t < 0, 1 \, quad t > 0) $

as shown below

#let t = (-1, -0.00001, 0, 0.00001, 2)
#cdiagram(
  title: [$u(t)$],
  xlabel: $t$,
  ylim: (-0.1, 1.2),
  lq.plot(t, t.map(t => if t > 0 { 1 } else { 0 }), stroke: 1.5pt, mark: none),
  height: 2cm,
  width: 5cm,
)

The continuous-time _unit impulse function_ $delta(t)$ is related to the unit step in a manner analogous to the relationship between the discrete-time unit impulse and step functions. In particular, the continuous-time unit step is the _running integral_ of the unit impulse

$ u(t) = integral_(-infinity)^t delta(tau) "d" tau $

In other words, the continuous-time unit impulse response can be thought of as the _first derivative_ of the continuous-time unit step, i.e.,

$ delta(t) = ("d"u(t)) / ("d" t) $

If we consider an approximiation to the unit step $u_Delta (t)$, which rises from the value 0 to the value 1 in a short time interval of length $Delta$. The unit step, of course, changes values instantaneously and thus can be thought of as an idealization of $u_Delta (t)$ for $Delta$ so short that its duration does not matter for any practical purpose. Formally, $u(t)$ is the limit of $u_Delta (t)$ as $Delta arrow 0$. This relationship is shown below.

Note that $delta_Delta (t)$ is a short pulse, of duration $Delta$, and with unit area for any value of $Delta$. As $Delta arrow 0$, $delta_Delta (t)$ becomes narrower and higher, maintaining its unit area. Its limiting form

$ delta(t) = lim_(Delta arrow 0) delta_Delta (t) $

can be thought of as an idealization of the short pulse $delta_Delta (t)$ as the duration $Delta$ becomes insignificant.

#let t = (-0.7, -0.01, 0, 0.15, 0.1501, 1)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  [
    #cdiagram(
      title: [$u_Delta (t)$],
      xlabel: $t$,
      ylim: (-0.1, 1.2),
      lq.plot(
        t,
        t.map(t => if t > 0 { 1 } else { 0 }),
        stroke: 1.5pt,
        mark: none,
      ),
      lq.place(0.1, -0.1, align: left)[$Delta$],
      lq.place(-0.1, 1.0, align: left)[$1$],
      height: 3cm,
      width: 6cm,
    )],
  [
    #cdiagram(
      title: [$delta_Delta (t) = ("d"u(t)) / ("d"t)$],
      xlabel: $t$,
      ylim: (-0.1, 1.2),
      lq.place(0.1, -0.1, align: left)[$Delta$],
      lq.place(-0.2, 1.0, align: left)[$1/Delta$],
      lq.plot(
        t,
        t.map(t => if t >= 0.1501 or t <= -0.01 { 0 } else { 1 }),
        stroke: 1.5pt,
        mark: none,
      ),
      height: 3cm,
      width: 6cm,
    )],
)

Similar to the discrete-time case, we have

$
  u(t) = integral_(-infinity)^t delta(tau) "d"tau = integral_(-infinity)^0 delta(t - sigma) "d"sigma
$

== Transformations of a Signal

=== Time Shift, Time Reversal and Time Scaling

A very important example of transforming is a _time shift_. A time shift in discrete time is illustrated below. The two signals $x[n]$ and $x[n-1]$ are identical in shape, but are displaced or shifted relative to each other. A second example of a basic transformation is _time reversal_, which is depicted below in the middle. Finally, the _time scaling_ is plotted on the right.

#let xx = lq.linspace(-4, 4, num: 9)
#let y = lq.linspace(-3, 5, num: 9)
#let x = lq.linspace(-6, 6, num: 400)
#let t = lq.linspace(-3, 3, num: 500)
#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 2em,
    [
      #lq.diagram(
        xlabel: $t$,
        lq.stem(xx, xx.map(xx => -xx), label: $x[n]$),
        lq.stem(y, y.map(y => -y + 1), label: $x[n-1]$),
        width: 5cm,
        height: 3cm,
      )],
    [
      #lq.diagram(
        lq.plot(
          x,
          x.map(x => (
            2.5 * calc.exp(-(x + 1.8) * (x + 1.8) / 0.3)
              + 0.8 * calc.exp(-(x - 3.2) * (x - 3.2) / 0.3)
          )),
          mark: none,
          label: $x(t)$,
        ),
        lq.plot(
          x,
          x.map(x => (
            2.5 * calc.exp(-(-x + 1.8) * (-x + 1.8) / 0.3)
              + 0.8 * calc.exp(-(-x - 3.2) * (-x - 3.2) / 0.3)
          )),
          mark: none,
          label: $x(-t)$,
        ),
        xlabel: $t$,
        width: 5cm,
        height: 3cm,
      )],

    [
      #lq.diagram(
        lq.plot(
          t,
          t.map(t => 2.5 * calc.exp(-(t) * (t) / 0.5)),
          mark: none,
          label: $x(t)$,
        ),
        lq.plot(
          t,
          t.map(t => 2.5 * calc.exp(-(t / 2) * (t / 2) / 0.5)),
          mark: none,
          stroke: stroke(dash: "dashed"),
          label: $x(t/2)$,
        ),
        lq.plot(
          t,
          t.map(t => 2.5 * calc.exp(-(t * 2) * (t * 2) / 0.5)),
          mark: none,
          stroke: stroke(dash: "dotted"),
          label: $x(2t)$,
        ),
        xlabel: $t$,
        width: 5cm,
        height: 3cm,
      )
    ],
  )
]


=== Miscellaneous

- A _periodic_ signal has the property that there is a positive value of $T$ for which $x(t) = x(t + T)$ for all values of $t$.
- A signal is referred to as an _even_ signal if it is identical to its time-reversed counterpart, i.e., $x(-t) = x(t)$ or $x[-n] = x[n]$. To decompose signal into even signals, $x_e (t) = 1 / 2 (x(t) + x(-t))$.
- An _odd_ signal is defined as $x(-t) = -x(t)$ or $x[-n] = -x[n]$. $x_o (t) = 1/2 (x(t) - x(-t))$.

=== Example

#example("Signal Operations")[
  Given the signal $x(t)$ shown below, plot $3/5 x(-5/2 t + 1)$.

  #let t = lq.linspace(-2, 4, num: 1000)
  #let x_func = t => {
    if t < 0 {
      0
    } else if t >= 0 and t <= 1 {
      1
    } else if t > 1 and t <= 2 {
      1 - (t - 1)
    } else {
      0
    }
  }

  #let x_t_plus_1 = t.map(t => x_func(t + 1))
  #let x_neg_t_plus_1 = t.map(t => x_func(-t + 1))
  #let x_5_2_t = t.map(t => x_func(-5 / 2 * t))
  #let x_5_2_t_plus_1 = t.map(t => 3 / 5 * x_func(-5 / 2 * t + 1))

  #cdiagram(
    title: $x(t)$,
    xlabel: [$t$],
    lq.plot(t, t.map(t => x_func(t)), mark: none, stroke: 2pt),
    ylim: (-0.2, 1.2),
    xaxis: (ticks: (-2, -1, 0, 1, 2, 3, 4)),
    yaxis: (ticks: (0, 1)),
    height: 2cm,
    width: 5cm,
  )

  The operations are depicted below.

  #align(center)[
    #grid(
      columns: 2,
      column-gutter: 5em,
      row-gutter: 1em,
      lq.diagram(
        width: 5cm,
        height: 2.5cm,
        title: [$x(t+1)$],
        xlabel: [$t$],
        xlim: (-2, 4),
        ylim: (-0.2, 1.2),
        xaxis: (ticks: (-2, -1, 0, 1, 2, 3, 4)),
        yaxis: (ticks: (0, 1)),
        lq.plot(t, x_t_plus_1, mark: none, stroke: 2pt),
      ),
      lq.diagram(
        width: 5cm,
        height: 2.5cm,
        title: [$x(-t+1)$],
        xlabel: [$t$],
        xlim: (-2, 4),
        ylim: (-0.2, 1.2),
        xaxis: (ticks: (-2, -1, 0, 1, 2, 3, 4)),
        yaxis: (ticks: (0, 1)),
        lq.plot(t, x_neg_t_plus_1, mark: none, stroke: 2pt),
      ),

      lq.diagram(
        width: 5cm,
        height: 2.5cm,
        title: [$x(-5/2 t)$],
        xlabel: [$t$],
        xlim: (-2, 4),
        ylim: (-0.2, 1.2),
        xaxis: (ticks: (-2, -1, 0, 1, 2, 3, 4)),
        yaxis: (ticks: (0, 1)),
        lq.plot(t, x_5_2_t, mark: none, stroke: 2pt),
      ),
      lq.diagram(
        width: 5cm,
        height: 2.5cm,
        title: [$3/5 x(-5/2 t + 1)$],
        xlabel: [$t$],
        xlim: (-2, 4),
        ylim: (-0.2, 1.2),
        xaxis: (ticks: (-2, -1, 0, 1, 2, 3, 4)),
        yaxis: (ticks: (0, 1)),
        lq.plot(t, x_5_2_t_plus_1, mark: none, stroke: 2pt),
      ),
    )]
]

== Continuous-Time and Discrete-Time Systems

In many context, a _system_ can be interpreted as a process in which input signals are transformed by the system, or cause the system to respond in some way, resulting in other signals as outputs. For example, a high fidelity system takes a recorded audio signal and generates a reproduction of that signal.

A _continuous-time system_ is a system in which continuous-time input signals are applied and result in continuous-time output signals. Similarly, a _discrete-time system_ transforms discrete-time inputs into discrete-time outputs. Throughout the course, we will often represent the input-output relation of a system by notations such as $x(t) arrow y(t)$ and $x[n] arrow y[n]$ for both continuous-time and discrete-time, respectively. They are often depicted as


#align(center)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #diagram(
        debug: false,
        node-stroke: 2pt,
        spacing: (15mm, 10mm),
        mark-scale: 150%,
        node((1, 0), "system"),
        edge((0, 0), (1, 0), "->-", label: $x(t)$),
        edge((1, 0), (2, 0), "->-", label: $y(t)$),
      )],
    [
      #diagram(
        debug: false,
        node-stroke: 2pt,
        spacing: (15mm, 10mm),
        mark-scale: 150%,
        node((1, 0), "system"),
        edge((0, 0), (1, 0), "->-", label: $x[n]$),
        edge((1, 0), (2, 0), "->-", label: $y[n]$),
      )],
  )
]

=== Interconnections of Systems

While one can construct a variety of system interconnections, there are several basic ones that are frequently encountered. A _series_ or _cascade_ connection of two systems is illustrated below.

#grid(
  columns: (1fr),
  column-gutter: 1em,
  align: (auto, bottom),
  // figure(
  //   image("totk-fused.jpg", width: 100%),
  //   caption: "Fusion in The Legend of Zelda: Tears of the Kingdom",
  //   numbering: none,
  // ),
  figure(
    align(center)[
      #diagram(
        debug: false,
        node-stroke: 2pt,
        spacing: (15mm, 10mm),
        mark-scale: 150%,
        node((1, 0), "system 1"),
        node((2, 0), "system 2"),
        edge((0, 0), (1, 0), "->-", label: $x[n]$),
        edge((1, 0), (2, 0), "->-"),
        edge((2, 0), (3, 0), "->-", label: $y[n]$),
      )
    ],
    caption: "Block diagram of cascaded systems",
    numbering: none,
  ),
)

It is also possible to have a series-parallel connection, as shown below.

#figure(
  align(center)[
    #diagram(
      debug: false,
      node-stroke: 2pt,
      spacing: (15mm, 10mm),
      mark-scale: 150%,
      let (s1, s2, s3, p) = ((0, 0), (1, 0), (0.5, 1), (2, 0)),
      edge(
        (-2.3, 0),
        (-1.3, 0),
        "r",
        "->-",
        $x[n]$,
        label-pos: 0,
        label-side: center,
      ),
      node(s1, "system 1"),
      node(s2, "system 2"),
      node(s3, "system 3"),
      node(p, inset: -1pt, stroke: 0pt),
      edge(s1, s2, "->-"),
      edge(s2, p),
      edge((-2, 0), (-1, 0), (-1, 1), s3, "->-"),
      edge((1.5, 1), (0.78, 1), "r,u"),
      edge(p, (2.5, 0), "->-", $y[n]$, label-pos: 2, label-side: center),
    )
  ],
  caption: "Block diagram of series-parallel interconnection",
  numbering: none,
)

Another important type of system interconnection is a _feedback interconnection_, an example of which is illustrated below. Here, the output of system 1 is the input to system 2, while the output of system 2 is fed back and added to the external input to produce the actual input to system 1.

#figure(
  align(center)[
    #diagram(
      debug: false,
      node-stroke: 2pt,
      spacing: (15mm, 10mm),
      mark-scale: 150%,
      node((2, 0), "system 1"),
      node((2, -1), "system 2"),
      edge((0, 0), (1, 0), "->-", label: $x(t)$),
      edge((2, 0), (3, 0), "->-"),
      edge((3, 0), (4, 0), "->-", label: $y(t)$),
      edge((1, 0), (2, 0), "->-"),
      edge((3, 0), (3, -1), "->-"),
      edge((3, -1), (2, -1), "->-"),
      edge((2, -1), (1, -1), "->-"),
      edge((1, -1), (1, 0), "->-"),
    )
  ],
  caption: "Block diagram of feedback system",
  numbering: none,
)

=== Basic System Properties

==== System with and without Memory

#definition("Memoryless")[
  A system is said to be _memoryless_ if its output for each value of the independent variable at a given time is dependent on the input at only that same time.
]

For example, $y[n] = (2 x[n] - x^2 [n])^2$ is memoryless, as the value of $y[n]$ at any particular time $n_0$ depends only on the value of $x[n]$ at that time.

An example of a discrete-time system with memory is an _accumulator_, viz.,
$
  y[n] = sum_(k = -infinity)^(n) x[k]
$
and a second example is a _delay_,
$
  y[n] = x[n-1]
$

==== Invertibility and Inverse Systems

#definition("Invertibility")[
  A system is said to be _invertible_ if distinct inputs lead to distinct outputs. If a system is invertible, then an _inverse system_ exists that, when cascaded with the original system, yields an output $w[n]$ equal to the input $x[n]$ to the first system.
]

For example, an invertible continuous-time system is $y(t) = 2 x(t)$, for which the inverse system is $w(t) = 1/2 y(t)$.

==== Causality

#definition("Causality")[
  A system is _causal_ if the output at any time depends on values of the input at only the present and past times. Such a system is often referred to as being _nonanticipative_, as the system output does not anticipate future values of the input.
]

The accumulator system, i.e., $y[n] = sum_(k = -infinity)^n x[k]$, is causal, but $y[n] = x[n] - x[n+1]$ and $y(t) = x(t + 1)$ are not. _All_ memoryless systems are causal. An interesting example is this system:

$
  y[n] = x[-n]
$

Note that the output $y[n_0]$ at a positive time $n_0$ depends only on the value of the input signal $x[-n_0]$ at time $-n_0$, which is in the past. However, for $n_0 < 0$, the system output depends on the future value of the input. Hence, the system is not causal.


==== Stability

#definition("Stability")[
  If the input to a _stable_ system is bounded (i.e., if its magnitude does not grow without bound), then the output must be bounded (i.e., cannot diverge). This definition is often referred to as the bounded-input-bounded-output (BIBO) condition.
]

Let us examine two particular systems, namely, $cal("S")_1: y(t) = t x(t)$, and $cal("S")_2: y(t) = e^(x(t))$. For system $cal("S")_1$, a constant input $x(t) = 1$ yields $y(t) = t$, which is unbounded, since no matter what finite constant we pick, $|y(t)|$ will exceed that constant for some $t$. Therefore, $cal("S")_1$ is not stable.

For system $cal("S")_2$, which happens to be stable, we would not be able to find a bounded input that results in an unbounded output. Specifically, let $B in NN^+$, and let $x(t)$ be an arbitrary signal bounded by $B$, i.e., $|x(t)| < B$ for all $t$. Using the definition of $cal("S")_2$, we then see that if $x(t)$ satisfies $|x(t)|<B$, then $|y(t)|<e^B$. In other words, if any input to $cal("S")_2$ is bounded by an arbitrary positive number $B$, then the corresponding output is guaranteed to be bounded by $e^B$. Thus, $cal("S")_2$ is stable.

Later in this class, we will learn more about linear and time-invariant system. The (BIBO) stability criteria is then
$
  |y[n]| = |sum_k x[k] h[n-k]| <= sum_k |x[k]| |h[n-k]| <= sum_k |h[n-k]| ||x||_infinity = ||x||_infinity sum_k |h[k]| < infinity
$
In the continuous-time case,
$
  integral_(-infinity)^(infinity) |h(tau)| "d"tau < infinity
$
In other words, an LTI system is stable iff. its impulse response is absolutely summable / integrable.

==== Time Invariance

#definition("Time Invariance")[
  A system is said to be time invariant if a time shift in the input signal results in an identical time shift in the output signal. That is, if $y[n]$ is the output of a discrete-time, time-invariant system when $x[n]$ is the input, then $y[n - n_0]$ is the output when $x[n - n_0]$ is applied.
]

Let us consider the following system $cal("S"): y[n] = n x[n]$. This is a time-varying system. Suppose $x_1[n] = delta [n]$, which yields $y_1[n]$ that is identically 0. However, the input $x_2[n] = delta [n-1]$ yields the output $y_2[n] = delta [n-1]$, which is not a shifted version of $y_1[n]$. We can also show that for $x_1[n] = x[n-n_0]$, the system yields the output $y_1[n] = n x[n-n_0]$, which is not the shifted version of $y[n]$, i.e., $y[n-n_0] = (n-n_0) x[n - n_0] eq.not y_1[n]$.


==== Linearity

#definition("Linearity")[
  A _linear system_, in continuous time or discrete time, is a system that possesses the important property of superposition: if an input consists of the weighted sum of several signals, then the output is the suposition -- that is, the weighted sum -- of the responses of the system to each signals. More preciously, let $y_1(t)$ be the response of a continuous-time system to an input $x_1(t)$, and let $y_2(t)$ be the output corresponding to the input $x_2(t)$. Then the system is linear if

  - The response to $x_1(t) + x_2(t)$ is $y_1(t) + y_2(t)$.
  - The response to $a x_1(t)$ is $a y_1(t)$, where $a$ is any complex constant.
]

The first of these two properties is known as the _additivity_ property, while the second is known as the _scaling_ or _homogeneity_ property. These two properties defining a linear system can be combined into a single statement:

- Continuous time: $a x_1(t) + b x_2(t) arrow a y_1(t) + b y_2(t)$, $forall a, b in CC$.
- Discrete time: $a x_1[n] + b x_2[n] arrow a y_1[n] + b y_2[n]$, $forall a, b in CC$.

#example("Linearity")[
  Let us look at the following two systems. Are these systems linear?
  1. $cal("S")_1: y(t) = t x(t)$
  2. $cal("S")_2: y[n] = 2 x[n] + 3$

  To determine whether or not $cal("S")_1$ is linear, we consider two arbitrary inputs $x_1(t)$ and $x_2(t)$, $x_1(t) arrow y_1(t) = t x_1(t)$ and $x_2(t) arrow y_2(t) = t x_2(t)$. Let $x_3(t)$ be a linear combination of $x_1(t)$ and $x_2(t)$, that is $x_3(t) = a x_1(t) + b x_2(t)$, where $a$ and $b$ are arbitrary scalar constants. If $x_3(t)$ is the input to the system $cal("S")_1$, then the corresponding output may be expressed as $y_3(t) = t x_3(t) = t(a x_1(t) + b x_2(t)) = a y_1(t) + b y_2(t)$. Therefore, system $cal("S")_1$ is linear.

  However, system $cal("S")_2$ is not linear. Suppose $x_1[n] arrow y_1[n] = 2 x_1[n] + 3$ and $x_2[n] arrow y_2[n] = 2 x_2[n] + 3$, however, the response to $x_3[n] = x_1[n] + x_2[n]$ is $y_3[n] = 2 (x_1[n] + x_2[n]) + 3 eq.not y_1[n] + y_2[n]$. Hence, the system $cal("S")_2$ is not linear.
]
