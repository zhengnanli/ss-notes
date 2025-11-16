#import "lib.typ": *

= Sampling
#show: lq.theme.schoolbook
#show: schoolbook-style

In this section, we attempt to bridge the gap between the continuous-time signals and discrete-time signals. Under certain conditions, a continuous-time signal can be completely represented by and recovered from knowledge of its values, or _samples_.

== The Sampling Theorem

Let us consider a system that consists of a periodic impulse train and a multiplier.

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
#figure(
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
          lq.stem(xd, xd.map(xd => (xd - xd + 1)), mark: "^"),
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

Because of the sampling property of the unit impulse discussed previously, we know that multiplying $x(t)$ by a unit impulse samples the value of the signal at the point at which the impulse located, i.e., $x(t) delta(t - t_0) = x(t_0) delta(t - t_0)$. We then represent the sampled signal $x_p (t)$ as
$
  x_p (t) = sum_(n = -infinity)^(infinity) x(n T) delta(t - n T)
$

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

That is, $X_p (j omega)$ is a periodic function of $omega$ consisting of a superposition of shifted replicas of $X(j omega)$, scaled by $1 / T$, as illustrated below,

#align(center)[
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
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
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
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
        lq.place(7, -0.21, align: center)[$omega_s$],
        lq.place(-7, -0.21, align: center)[$-omega_s$],
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

As we can see from the illustrations above, to guarantee that there is no overlapping in the frequency domain, we have the following theorem
#theorem("Sampling Theorem")[
  Let $x(t)$ be a band-limited signal with $X(j omega) = 0$ for $|omega| > omega_M$. Then, $x(t)$ is uniquely determined by its samples $x(n T), n = 0, plus.minus 1, plus.minus 2, dots.c$ if
  $
    omega_s > 2 omega_M
  $
  where
  $
    omega_s = (2 pi) / T
  $
  Given these samples, we can reconstruct $x(t)$ by generating a periodic impulse train in which successive impulses have amplitudes that are successive sample values. This impulse train is then processed through an ideal lowpass filter with gain $T$ and cutoff frequency greater than $omega_M$ and less than $omega_s - omega_M$. The resulting output signal will exactly equal to $x(t)$.

  The frequency $2 omega_M$, which, under the sampling theorem, must be exceeded by the sampling frequency, is commonly referred to as the _Nyquist rate_.
]

== Reconstruction of a Signal from Its Samples using Interpolation

To construct the signal from $X_p (j omega)$, all we need to do is to apply an ideal low pass filter with the cut off frequency $omega_c$ satisfies $omega_M < omega_c < (omega_s - omega_M)$ in the frequeny domain, as illustrated below.

#align(center)[
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
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
        lq.place(7, -0.21, align: center)[$omega_s$],
        lq.place(-7, -0.21, align: center)[$-omega_s$],
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
        lq.plot((-4, -4), (0, 1.7), mark: none, stroke: (
          paint: orange,
        )),
        lq.plot((4, 4), (0, 1.7), mark: none, stroke: (
          paint: orange,
        )),
        lq.plot((-4, 4), (1.7, 1.7), mark: none, stroke: (
          paint: orange,
        )),
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
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
          mark: none,
        ),
        lq.place(-3, -0.21, align: center)[$-omega_M$],
        lq.place(3, -0.21, align: center)[$omega_M$],
      )],
  )]

When applying a lowpass filter in the frequency domain, it is eqivalent to convolve the signal with a $"sinc"$ function in the time doamin, i.e.,
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
#let sinc(x) = calc.sin(calc.pi * x) / (calc.pi * x)
#let yd = xd.map(x => f(x))
#let stair-coarse = make-staircase(xd, yd)

#figure(
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
          lq.plot(x, x.map(x => f(x)), mark: none),
          lq.stem(
            xd,
            xd.map(xd => f(xd)),
            color: red,
            mark: "x",
            label: $x_p (t)$,
          ),

          let i = 0,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
            label: $"sinc" (t - n T)$,
          ),
          let i = 2,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
          let i = 3,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
          let i = 4,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
          let i = 5,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
          let i = 6,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
          let i = 7,
          lq.plot(
            xs.map(xs => xs + xd.at(i)),
            xs.map(xs => sinc(xs) * f(xd.at(i))),
            mark: none,
            color: green,
            stroke: stroke(dash: "dashed"),
          ),
        )
      ],
    )],
)

== Sampling of Discrete-Time Signals

#let x = lq.linspace(-2, 5, num: 30)
#let xd = lq.arange1(-2, 5, step: 0.7)
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
#figure(
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
            $x_p (t)$,
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
          lq.stem(x, x.map(x => f(x))),
        )
      ],
      [
        #cdiagram(
          title: $p[n]$,
          xlabel: $n$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          lq.stem(xd, xd.map(xd => (xd - xd + 1))),
        )],
      [
        #cdiagram(
          title: $x_p [n]$,
          xlabel: $n$,
          ylim: (-2, 2),
          height: 2cm,
          width: 3cm,
          // lq.stem(xd, xd.map(xd => f(xd)), mark: "^"),
          lq.stem(xd, xd.map(xd => f(xd))),
        )],
    )],
)

Here the new sequence $x_p [n]$ resulting from the sampling process is equal to the original sequence $x[n]$ at integer multiples of the sampling period $N$ and is zero at the intermediate samples,
$
  x_p [n] = cases(x[n]\, quad n = m N, 0\, quad "o.w.")
$
where $m$ is an integer. The effect of frequency domain of discrete-time sampling is seen by using the multiplication property, we have
$
  x_p [n] = x[n] p[n] = sum_k x[k N] delta[n - k N]
$
in the frequency domain,
$
  X_p (e^(j omega)) = 1 / (2 pi) integral_(2 pi) P(e^(j theta)) X(e^(j(omega - theta))) "d" theta
$

The Fourier transform of the sampling sequence $p[n]$ is
$
  P(e^(j omega)) = (2 pi) / N sum_k delta(omega - k omega_s)
$
where $omega_s$, the sampling frequency, equals $(2 pi)/N$. We then have
$
  X_p (e^(j omega)) = 1 / N sum_(k = 0)^(N - 1) X(e^(j (omega - k omega_s)))
$

Similar to the continuous-time system, when $omega_s > 2 omega_M$, there is no aliasing. 
