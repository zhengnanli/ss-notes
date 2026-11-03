#import "lib.typ": *

= Sampling
#show: lq.theme.schoolbook
#show: schoolbook-style

In this section, we attempt to bridge the gap between continuous-time and discrete-time signals. Under certain conditions, a continuous-time signal can be completely represented by and recovered from knowledge of its values, or _samples_.

== The Sampling Theorem

#block(sticky: true)[Let us consider a system that consists of a periodic impulse train and a multiplier.]

#let x = lq.linspace(-2, 5, num: 50)
#let xd = lq.arange(-2, 5, step: 0.7)
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
#altfig(
  alt: "Block diagram and three time-domain plots illustrating impulse-train sampling. Left: x of t and p of t enter a multiplier whose output is x sub p of t. Center-left: smooth continuous signal x of t. Center-right: periodic impulse train p of t. Right: the sampled signal x sub p of t with impulses scaled by x at the sample times, overlaid by the dashed original x of t.",
  caption: [
    Impulse-train sampling: multiplying $x(t)$ by the train $p(t)$ leaves an
    impulse at each sample time, weighted by the value of $x$ there.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 2em,
      [
        #diagram(
          debug: false,
          node-stroke: 0.1em,
          mark-scale: 100%,
          edge(
            (-1, 0),
            "r",
            "-|>-",
            $x(t)$,
            label-pos: -0.5,
            label-side: center,
          ),
          edge(
            (0, 0.9),
            "t",
            "-|>-",
            $p(t)$,
            label-pos: 0,
            label-side: center,
          ),
          edge(
            (0, 0),
            "r",
            "-|>-",
            $x_p (t)$,
            label-pos: 2,
            label-side: center,
          ),
          node((0, 0), $times$, radius: 1em),
        )],
      [
        #cdiagram(
          title: $x(t)$,
          xlabel: $t$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.plot(x, x.map(x => f(x)), mark: none),
        )
      ],
      [
        #cdiagram(
          title: $p(t)$,
          xlabel: $t$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(xd, xd.map(_ => 1), mark: "^"),
        )],
      [
        #cdiagram(
          title: $x_p (t)$,
          xlabel: $t$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(xd, xd.map(xd => f(xd)), mark: "^"),
          lq.plot(x, x.map(x => f(x)), stroke: stroke(dash: "dashed")),
        )],
    )],
)

Because of the sampling property of the unit impulse discussed previously, we know that multiplying $x(t)$ by a unit impulse samples the value of the signal at the point where the impulse is located, i.e., $x(t) delta(t - t_0) = x(t_0) delta(t - t_0)$. We then represent the sampled signal $x_p (t)$ as
$
  x_p (t) = sum_(n = -infinity)^(infinity) x(n T) delta(t - n T)
$
where $p(t) = sum_(n=-infinity)^infinity delta(t - n T)$ is an impulse train with sampling period $T$, and $omega_s = (2 pi)/T$ is the sampling frequency.

Now, let us discuss the frequency domain behavior of the sampling process. From the multiplication property, we know that
$
  X_p (j omega) = 1 / (2 pi) integral_RR X(j theta) P(j (omega - theta)) "d"theta
$
and we know that the Fourier transform of the delta train is
$
  P(j omega) = (2 pi) / T sum_(k = -infinity)^(infinity) delta(omega - k omega_s)
$
Since convolution with an impulse simply shifts a signal (i.e., $X(j omega) star delta(omega - omega_0) = X(j(omega - omega_0))$), it follows that
$
  X_p (j omega) = 1 / T sum_(k = -infinity)^(infinity) X(j (omega - k omega_s))
$

That is, $X_p (j omega)$ is a periodic function of $omega$ consisting of a superposition of shifted replicas of $X(j omega)$, scaled by $1 / T$, as illustrated below.

// The spectrum of a real x(t) is even, so the sketch is two mirrored lobes.
// Both are negligible beyond |omega| = 3, the omega_M marked on the axis.
#let spec(w) = (
  1.2 * calc.exp(-(w + 1) * (w + 1) / 0.3)
    + 1.2 * calc.exp(-(w - 1) * (w - 1) / 0.3)
)

#altfig(
  alt: "Two spectra side by side. Left: the original band-limited spectrum X of j omega, nonzero only between minus omega sub M and omega sub M. Right: the sampled spectrum X sub p of j omega, a periodic train of shifted copies of X of j omega spaced by omega sub s; dashed gray lines mark the centers at plus and minus omega sub s and plus and minus two omega sub s.",
  caption: [
    Sampling in the frequency domain: the spectrum of $x_p (t)$ is the spectrum
    of $x(t)$ repeated every $omega_s$ and scaled by $1\/T$. The copies stay
    clear of one another only while $omega_s > 2 omega_M$.
  ],
  align(center)[
  #grid(
    columns: (1fr, 3fr),
    column-gutter: 2em,
    [
      #let x = lq.linspace(-6, 6, num: 400)
      #cdiagram(
        title: $X(j omega)$,
        xlabel: $omega$,
        width: 5cm,
        height: 3cm,
        lq.plot(
          x,
          x.map(x => spec(x)),
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
      )],
    [
      #let x = lq.linspace(-18, 18, num: 400)
      #cdiagram(
        title: $X_p (j omega)$,
        xlabel: $omega$,
        width: 10cm,
        height: 3cm,
        lq.plot(
          x,
          x.map(x => spec(x)),
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x - 7)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x + 7)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x + 14)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x - 14)),
          color: c-green,
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
        lq.place(7, -0.21, align: center)[$omega_s$],
        lq.place(-7, -0.21, align: center)[$-omega_s$],
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

As the illustrations above show, the shifted replicas do not overlap provided $omega_s > 2 omega_M$, which leads to the following theorem.
#theorem("Sampling Theorem")[
  Let $x(t)$ be a band-limited signal with $X(j omega) = 0$ for $|omega| > omega_M$. Then, $x(t)$ is uniquely determined by its samples $x(n T), n = 0, plus.minus 1, plus.minus 2, dots.c$ if
  #eqalt(
    "omega sub s is greater than two omega sub M.",
    $
      omega_s > 2 omega_M
    $,
  )
  where
  #eqalt(
    "omega sub s equals two pi over T.",
    $
      omega_s = (2 pi) / T
    $,
  )
  Given these samples, we can reconstruct $x(t)$ by generating a periodic impulse train in which successive impulses have amplitudes that are successive sample values. This impulse train is then processed through an ideal lowpass filter with gain $T$ and cutoff frequency greater than $omega_M$ and less than $omega_s - omega_M$. The resulting output signal will exactly equal $x(t)$.

  The frequency $2 omega_M$, which, under the sampling theorem, must be exceeded by the sampling frequency, is commonly referred to as the _Nyquist rate_.
]

== Reconstruction of a Signal from Its Samples Using Interpolation

To reconstruct the signal from $X_p (j omega)$, all we need to do is to apply an ideal lowpass filter with cutoff frequency $omega_c$ satisfying $omega_M < omega_c < (omega_s - omega_M)$ in the frequency domain, as illustrated below.

#altfig(
  alt: "Two spectra. Left: the sampled spectrum X sub p of j omega showing periodic copies, with an orange rectangle marking the ideal lowpass filter passband from minus omega sub c to omega sub c. Right: the reconstructed spectrum X sub r of j omega, recovered as the central copy of X of j omega.",
  caption: [
    Reconstruction: an ideal lowpass filter with cutoff $omega_M < omega_c <
    omega_s - omega_M$ (orange) keeps the central copy and discards the rest.
  ],
  align(center)[
  #grid(
    columns: (3fr, 1fr),
    column-gutter: 2em,

    [
      #let x = lq.linspace(-18, 18, num: 400)
      #cdiagram(
        title: $X_p (j omega)$,
        xlabel: $omega$,
        width: 10cm,
        height: 3cm,
        ylim: (-0.2, 1.9),
        lq.plot(
          x,
          x.map(x => spec(x)),
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x - 7)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x + 7)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x + 14)),
          color: c-green,
          mark: none,
        ),
        lq.plot(
          x,
          x.map(x => spec(x - 14)),
          color: c-green,
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
        lq.place(7, -0.21, align: center)[$omega_s$],
        lq.place(-7, -0.21, align: center)[$-omega_s$],
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
        lq.plot((-4, -4), (0, 1.7), mark: none, stroke: (
          paint: c-orange,
        )),
        lq.plot((4, 4), (0, 1.7), mark: none, stroke: (
          paint: c-orange,
        )),
        lq.plot((-4, 4), (1.7, 1.7), mark: none, stroke: (
          paint: c-orange,
        )),
        lq.place(4.3, 1.7, align: left)[$omega_c$],
      )],

    [
      #let x = lq.linspace(-6, 6, num: 400)
      #cdiagram(
        title: $X_r (j omega)$,
        xlabel: $omega$,
        width: 5cm,
        height: 3cm,
        ylim: (-0.2, 1.9),
        lq.plot(
          x,
          x.map(x => spec(x)),
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
      )],
  )],
)

Applying a lowpass filter in the frequency domain is equivalent to convolving the signal with a $"sinc"$ function in the time domain, i.e.,
$
  x_r (t) = x_p (t) star h(t)
$
or,
$
  x_r (t) = sum_(n = -infinity)^(infinity) x(n T) h(t - n T)
$

The ideal lowpass filter's impulse response $h(t)$ is
$
  h(t) = (omega_c T sin (omega_c t)) / (pi omega_c t)
$
so that
$
  x_r (t) = sum_(n = -infinity)^infinity x(n T) (omega_c T)/pi (sin (omega_c (t - n T))) / (omega_c (t - n T))
$

#let x = lq.linspace(-5, 5, num: 100)
#let xd = lq.arange1(-3, 5, step: 1)
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
#let xs = lq.linspace(-3, 3, num: 100)
#let yd = xd.map(x => f(x))
#let stair-coarse = make-staircase(xd, yd)

#altfig(
  alt: "Two plots. Left: the original continuous signal x of t. Right: its reconstruction x sub r of t, drawn as the solid curve, with one dashed green sinc kernel per sample and the sample values x sub p of t marked with blue crosses; the solid curve is x of t, which the sum of all (untruncated) kernels reproduces.",
  caption: [
    The same reconstruction seen in the time domain: one sinc kernel per sample,
    each scaled by its sample value. Every kernel is zero at all the other
    sample times, so the sum passes exactly through every sample.
  ],
  align(center)[
    #grid(
      columns: (1fr, 2fr),
      column-gutter: 2em,
      [
        #cdiagram(
          title: $x(t)$,
          xlabel: $t$,
          ylim: (-2, 2),
          width: 5cm,
          lq.plot(x, x.map(x => f(x)), mark: none),
        )],
      [
        #cdiagram(
          title: $x_r (t)$,
          xlabel: $t$,
          ylim: (-2, 2),
          width: 10cm,
          legend: (position: left + top),
          lq.plot(x, x.map(x => f(x)), mark: none, label: $x_r (t)$),
          lq.stem(
            xd,
            xd.map(xd => f(xd)),
            color: c-blue,
            mark: "x",
            label: $x_p (t)$,
          ),

          // One kernel per sample, so the family shown is the family summed
          // in the equation above rather than an arbitrary subset of it. Only
          // the first carries the legend label.
          ..range(xd.len()).map(i => lq.plot(
            xs.map(u => u + xd.at(i)),
            xs.map(u => sinc(u) * f(xd.at(i))),
            mark: none,
            color: c-green,
            stroke: stroke(dash: "dashed"),
            label: if i == 0 { $op("sinc")(t - n T)$ },
          )),
        )
      ],
    )],
)

== (optional) Quantization

The introduction distinguished _discrete-time_ signals, whose time axis has been sampled, from _digital_ signals, whose amplitude can also take only finitely many values. Sampling produces the first. A computer needs the second, because each sample must be stored in a fixed number of bits. The step that rounds each sample to one of finitely many levels is called _quantization_. An analog-to-digital converter (ADC) performs both steps: it samples, as described above, and then quantizes. Unlike sampling of a band-limited signal, quantization cannot be undone; the best we can do is to make its error small.

=== The uniform quantizer
A $B$-bit uniform quantizer covers a full-scale range $[-X_m, X_m]$ with $2^B$ equally spaced levels. The spacing, or _step size_, is
$
  Delta = (2 X_m) / 2^B
$
Each input $x$ is replaced by the nearest level $Q(x)$. As long as the input stays within the full-scale range, the _quantization error_
$
  e = Q(x) - x
$
satisfies $|e| <= Delta \/ 2$ (@fig-quantization). Each additional bit halves $Delta$ and therefore halves the worst-case error.


=== The additive noise model
The error is a deterministic function of the input, but for a busy signal and a small step it behaves like noise. The standard model treats $e$ as a random variable uniformly distributed on $[-Delta \/ 2, Delta \/ 2]$ and independent of the signal. Its mean is zero and its variance (the noise power) is
$
  sigma_e^2 = integral_(-Delta \/ 2)^(Delta \/ 2) e^2 dot 1 / Delta "d"e = 1 / Delta [e^3 / 3]_(-Delta \/ 2)^(Delta \/ 2) = Delta^2 / 12
$
The quantized signal is then modeled as the original plus additive noise, $Q(x[n]) = x[n] + e[n]$.

#let B = 3
#let delta-q = 2 / calc.pow(2, B)
#let quant(x) = calc.clamp(delta-q * (calc.floor(x / delta-q) + 0.5), -1 + delta-q / 2, 1 - delta-q / 2)
#let tq = lq.linspace(0, 1, num: 600)
#let xq = tq.map(t => calc.sin(2 * calc.pi * t))
#altfig(
  alt: "Two stacked plots over one period of a sinusoid, time from 0 to 1. Top: a unit-amplitude sine wave drawn as a smooth curve, and its 3-bit quantized version drawn as a staircase that takes only the eight levels plus or minus 0.125, 0.375, 0.625 and 0.875. Bottom: the quantization error, the difference between the staircase and the sine, which is a sawtooth-like signal that stays between minus 0.125 and 0.125, the dashed lines at plus and minus half a step.",
  caption: [
    A 3-bit quantizer with $X_m = 1$, so $Delta = 1/4$. Top: the input
    $x(t) = sin(2 pi t)$ and its quantized version $Q(x(t))$, which takes
    only $2^3 = 8$ levels. Bottom: the error $e = Q(x) - x$ stays within
    $plus.minus Delta \/ 2$ (dashed).
  ],
  align(center)[
    #stack(
      spacing: 0.6em,
      lq.diagram(
        width: 10cm,
        height: 3.5cm,
        ylim: (-1.15, 1.15),
        xaxis: (ticks: shared-ticks((0, 0.25, 0.5, 0.75, 1), false), subticks: none),
        yaxis: (ticks: (-0.875, -0.375, 0.125, 0.625), subticks: none),
        lq.plot(tq, xq, mark: none, color: c-muted, label: $x(t)$),
        lq.plot(tq, xq.map(quant), mark: none, color: c-accent, label: $Q(x(t))$),
        legend: (position: right + bottom),
      ),
      lq.diagram(
        xlabel: $t$,
        width: 10cm,
        height: 2.2cm,
        title: $e(t) = Q(x(t)) - x(t)$,
        ylim: (-0.2, 0.2),
        xaxis: (ticks: shared-ticks((0, 0.25, 0.5, 0.75, 1), false), subticks: none),
        yaxis: (ticks: (-0.125, 0, 0.125), subticks: none),
        lq.plot(tq, xq.map(x => quant(x) - x), mark: none, color: c-blue),
        lq.plot((0, 1), (0.125, 0.125), mark: none, stroke: (dash: "dashed", paint: c-muted)),
        lq.plot((0, 1), (-0.125, -0.125), mark: none, stroke: (dash: "dashed", paint: c-muted)),
      ),
    )
  ],
) <fig-quantization>

=== Signal-to-quantization-noise ratio
Consider a full-scale sinusoid $x(t) = X_m cos(omega_0 t)$, whose average power is $X_m^2 \/ 2$. With $Delta = 2 X_m \/ 2^B$, the signal-to-quantization-noise ratio is
$
  "SQNR" = (X_m^2 \/ 2) / (Delta^2 \/ 12) = (6 X_m^2) / Delta^2 = (6 X_m^2 dot 2^(2 B)) / (4 X_m^2) = 3 / 2 dot 2^(2 B)
$
In decibels,
$
  "SQNR"_"dB" = 10 log_10 (3 / 2) + 20 B log_10 2 approx 1.76 + 6.02 B "dB"
$
This is the "6 dB per bit" rule: each extra bit improves the SQNR by about 6 dB. A 16-bit audio converter, for instance, achieves about 98 dB. The uniform model is only approximate when $B$ is small; for the 3-bit quantizer of @fig-quantization the formula gives 19.8 dB, while the actual SQNR of a full-scale sinusoid is about 19.1 dB, because the error is visibly not random there.

== Sampling of Discrete-Time Signals

// A discrete-time signal lives on the integers, so every stem plot below is
// drawn at integer n. x[n] samples the same smooth f as above, and p[n] has
// period N = 3, so x_p[n] keeps exactly every third stem of x[n].
#let n = range(-9, 13)
#let g(m) = f(m / 3)
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
#altfig(
  alt: "Block diagram and three discrete-time plots illustrating discrete-time sampling. Left: x of n and an impulse train p of n equal to the sum over k of delta of n minus k N enter a multiplier whose output is x sub p of n. Center-left: stem plot of x of n. Center-right: stem plot of p of n. Right: stem plot of x sub p of n, equal to x of n at multiples of N and zero elsewhere.",
  caption: [
    Discrete-time sampling: $x_p [n]$ keeps every $N$th sample of $x[n]$ and
    sets the rest to zero, rather than discarding them.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 2em,
      [
        #diagram(
          debug: false,
          node-stroke: 0.1em,
          mark-scale: 100%,
          edge(
            (-1, 0),
            "r",
            "-|>-",
            $x[n]$,
            label-pos: -0.5,
            label-side: center,
          ),
          edge(
            (0, 0.9),
            "t",
            "-|>-",
            $p[n] = sum_k delta[n - k N]$,
            label-pos: 0,
            label-side: center,
          ),
          edge(
            (0, 0),
            "r",
            "-|>-",
            $x_p [n]$,
            label-pos: 2,
            label-side: center,
          ),
          node((0, 0), $times$, radius: 1em),
        )],
      [
        #cdiagram(
          title: $x[n]$,
          xlabel: $n$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(n, n.map(g)),
        )
      ],
      [
        #cdiagram(
          title: $p[n]$,
          xlabel: $n$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(n, n.map(m => if calc.rem(m, 3) == 0 { 1 } else { 0 })),
        )],
      [
        #cdiagram(
          title: $x_p [n]$,
          xlabel: $n$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(n, n.map(m => if calc.rem(m, 3) == 0 { g(m) } else { 0 })),
        )],
    )],
)

Here the new sequence $x_p [n]$ resulting from the sampling process is equal to the original sequence $x[n]$ at integer multiples of the sampling period $N$ and is zero at the intermediate samples,
$
  x_p [n] = cases(x[n]\, quad n = m N, 0\, quad "otherwise")
$
where $m$ is an integer. The frequency-domain effect of discrete-time sampling follows from the multiplication property. In the time domain,
$
  x_p [n] = x[n] p[n] = sum_k x[k N] delta[n - k N]
$
and in the frequency domain,
$
  X_p (e^(j omega)) = 1 / (2 pi) integral_(2 pi) P(e^(j theta)) X(e^(j(omega - theta))) "d"theta
$

The Fourier transform of the sampling sequence $p[n]$ is
$
  P(e^(j omega)) = (2 pi) / N sum_k delta(omega - k omega_s)
$
where $omega_s$, the sampling frequency, equals $(2 pi)/N$. We then have
$
  X_p (e^(j omega)) = 1 / N sum_(k = 0)^(N - 1) X(e^(j (omega - k omega_s)))
$

Similar to the continuous-time case, if $X(e^(j omega)) = 0$ for $omega_M < |omega| <= pi$ and $omega_s > 2 omega_M$, the shifted replicas do not overlap (there is no _aliasing_), and $x[n]$ is recovered from $x_p [n]$ by an ideal lowpass filter with gain $N$ and cutoff between $omega_M$ and $omega_s - omega_M$.
