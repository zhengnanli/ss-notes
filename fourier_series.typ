#import "lib.typ": *

= Fourier Series
#show: lq.theme.schoolbook
#show: schoolbook-style

== The Response of LTI Systems to Complex Exponentials

It is advantageous to study LTI system by representing signals as linear combinations of basic signals that possess the following two properties

- The set of basic signals can be used to construct a broad and useful class of signals
- The response of an LTI system to each signal should be simple enough in structure to provide us with a convenient representation for the response of the system to any signal constructed as a linear combination of the basic signals.

A signal for which the system output is a (possibly complex) constant times the input is referred to an _eigenfunction_ of the system, and the amplitude factor is referred to as the system's _eigenvalue_. Now, we would like to show that in a continuous-time system system, the input $e^(s t)$ is an eigenfunction. From previous lectures, we know that the output of the system is linked to the input via the convolution integral:

$
  y(t) = integral_RR h(tau) x(t - tau) "d" tau = integral_RR h(tau) e^(s (t - tau)) "d" tau = e^(s t) integral_RR h(tau) e^(-s tau) "d" tau = H(s) e^(s t)
$

Hence, complex exponentials are eigenfunctions of LTI systems. Similarly, in the discrete-time case, it is trivial to show that $z^n$ is also the eigenfunction of the discrete-time LTI systems.

Suppose we can decompose the signal into linear combinations of complex exponentials, e.g.,
$
  x(t) = a_1 e^(s_1 t) + a_2 e^(s_2 t) + a_3 e^(s_3 t)
$
From the eigenfunction property, the response to each signal separately is
$
  a_1 e^(s_1 t) & arrow a_1 H(s_1) e^(s_1 t) \
  a_2 e^(s_2 t) & arrow a_2 H(s_2) e^(s_2 t) \
  a_3 e^(s_3 t) & arrow a_3 H(s_3) e^(s_3 t)
$
and from the superposition property the response to the sum is the sum of the responses, viz.,
$
  y(t) = a_1 H(s_1) e^(s_1 t) + a_2 H(s_2) e^(s_2 t) + a_3 H(s_3) e^(s_3 t)
$
Compactly, we can write $x(t)$ as
$
  x(t) = sum_k a_k e^(s_k t)
$
and the output will be
$
  y(t) = sum_k a_k H(s_k) e^(s_k t)
$
Similarly for discrete-time case.

== Fourier Series Representation of Continuous-Time Periodic Signals

Suppose we would like to express a periodic signal using the sum of exponentials as
$
  x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) = sum_(k = -infinity)^(infinity) a_k e^(j k (2 pi) / T t)
$
multiplying both sides by $e^(-j n omega_0 t)$ and integrating both sides from $0$ to $T = (2 pi) / omega_0$, we have
$
  integral_0^T x(t) e^(-j n omega_0 t) = integral_0^T sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) e^(-j n omega_0 t) "d" t = sum_(k=-infinity)^(infinity) a_k [ integral_0^T e^(j (k - n) omega_0 t) "d" t]
$ <intxt>
If we closely examine the last part of @intxt, we have
$
  integral_0^T e^(j (k-n) omega_0 t) "d" t = cases(T\, &quad k = n, 0\, &quad k != n)
$
and consequently, the right side of @intxt reduces to
$
  a_n = 1/T integral_0^T x(t) e^(-j n omega_0 t) "d" t
$
because when $k = n$, the integral equals to $T$. Since the signal is periodic, we denote the integration over _any_ length $T$,
$
  a_n = 1/T integral_T x(t) e^(-j n omega_0 t) "d" t
$

To summarize,
#definition("Fourier Series for Continuous-Time Periodic Signal")[
  We can decompose a periodic signal $x(t)$ as the sum of complex exponentials:
  $
    x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) = sum_(k = -infinity)^(infinity) a_k e^(j k (2 pi)/T t)
  $
  where
  $
    a_k = 1/T integral_T x(t) e^(-j k omega_0 t) "d"t = 1/T integral_T x(t) e^(-j k (2 pi)/T t) "d"t
  $
  The set of coefficients ${a_k}_(k = -infinity)^(infinity)$ is referred to as the _Fourier series coefficients_. The coefficient $a_0$ is the DC component of the $x(t)$, and is given by
  $
    a_0 = 1/T integral_T x(t) "d" t
  $
]

Two functions $phi_1 (t)$ and $phi_2 (t)$ are said to be _orthogonal_ over the interval $(a, b)$ if
$
  integral_a^b phi_1 (t) phi_2^* (t) "d" t = 0
$
If in addition
$
  integral_a^b |phi_1 (t)|^2 "d" t = integral_a^b |phi_2 (t)|^2 "d" t = 1
$
The functions are said to be _normalized_, and hence are called _orthonormal_. A set of such functions ${phi_i (t)}, i = 0, plus.minus 1, plus.minus 2, dots.c$ is called orthonormal set if each pair of functions in the set is orthonormal.

Let $x(t)$ be a given signal. Consider the following approximations of $x(t)$ over the interval $a <= t <= b$:
$
  hat(x)_N (t) = sum_(i = -N)^N a_i phi_i (t)
$
Here, $a_i$ are complex constants. To measure the deviation between $x(t)$ and $hat(x)_N$, we consider the error defined as
$
  e_N (t) = x(t) - hat(x)_N (t)
$
A criterion for measuring the "quality" of the approximation is the energy in the error signal, i.e.,
$
  E_N (t) = integral_a^b |e_N (t)|^2 "d" t
$

Let $phi_n (t) = e^(j n omega_0 t)$ and choose any interval of length $T = (2 pi) / omega_0$. The $a_i$ that minimize $E_N (t)$ are
$
  a_i = 1 / T integral_R x(t) e^(-j i omega_0 t) "d" t
$

== Convergence of the Fourier Series

In general, a set of conditions developed by Dirichlet guarantees that $x(t)$ _equals_ its Fourier series representation, except at isolated values of $t$ for which $x(t)$ is discontinuous. The Dirichlet conditions are as follows:

// #note("Dirichlet Conditions")[
1. Over any period, $x(t)$ must be _absolutely integrable_, i.e., $integral_T |x(t)| "d"t < infinity$
2. In any finite interval of time, $x(t)$ is of bounded variation; that is there are no more than a finite number of maxima and minima during any single period of the signal.
3. In any finite interval of time, there are only a finite number of discontinuities. Furthermore, each of these discontinuities is finite.
// ]

#example("Fourier Series for Triangle Function")[
  #set math.equation(numbering: none)
  Find the Fourier series for the following (periodic) triangle function:

  #let x = lq.linspace(-1, 1, num: 500)
  #let triangle = x => 2 * calc.abs(2 * (2 * x - calc.floor(2 * x + 0.5))) - 1
  #cdiagram(
    title: $x(t)$,
    xlabel: $t$,
    ylim: (-1.5, 1.5),
    height: 2cm,
    width: 8cm,
    lq.plot(x, x.map(x => triangle(x)), mark: none),
    lq.place(0.25, -0.4, align: center)[$1/2$],
    lq.place(-0.05, 1, align: center)[$1$],
    lq.place(1, 0.5, align: center)[$dots.c$],
    lq.place(-1, 0.5, align: center)[$dots.c$],
    lq.plot((0.25, 0), (1, 1), mark: none, stroke: (
      dash: "dashed",
      paint: red,
    )),
    lq.plot((0.25, 0.25), (1, 0), mark: none, stroke: (
      dash: "dashed",
      paint: red,
    )),
  )

  All we need to do is to calculate the Fourier series coefficients:
  $
    a_k = 1/T integral_T x(t) e^(-j k 2 pi t) = integral_(-1/2)^0 (-4 t - 1) e^(-j k 2 pi t) "d"t + integral_0^(1/2) (4 t - 1) e^(-j k 2 pi t) "d"t = dots.c
  $

]


#example("Visualization of the Gibbs Phenomenon")[
  #set math.equation(numbering: none)
  Let us look at the Fourier series of a periodic square wave, sketched below, and defined over one period as
  $
    x(t) = cases(1\, &quad |t| < T_1, 0\, &quad T_1 < |t| < T/2)
  $

  #let x = lq.linspace(-6, 6, num: 1000)
  #let triangle = x => if (calc.rem(x + 9, 4)) < 2 { 2.5 } else { 0 }
  #cdiagram(
    title: $x(t)$,
    xlabel: $t$,
    ylim: (-0.5, 3.5),
    height: 2.5cm,
    lq.plot(x, x.map(x => triangle(x)), mark: none),
    lq.place(-1.45, 2.5, align: center)[$1$],
    lq.place(1, -0.5, align: center)[$T_1$],
    lq.place(-1.2, -0.5, align: center)[$-T_1$],
    lq.place(2, -0.5, align: center)[$T/2$],
    lq.place(-2.3, -0.5, align: center)[$-T/2$],
    lq.place(5.8, 1.5, align: center)[$dots.c$],
    lq.place(-5.8, 1.5, align: center)[$dots.c$],
    lq.plot((2, 2), (0, 3), mark: none, stroke: (dash: "dashed", paint: red)),
    lq.plot((-2, -2), (0, 3), mark: none, stroke: (dash: "dashed", paint: red)),
  )

  The Fourier series coefficients are
  $
    a_k = 1/T integral_(-T_1)^(T_1) e^(-j k omega_0 k) "d"t = -1/(j k omega_0 T) e^(-j k omega_0 t) lr(|, size: #200%)_(-T_1)^(T_1) = (sin (k omega_0 T_1)) / (k pi), quad k != 0
  $
  where $omega_0 = (2 pi) / T$. When $k = 0$, $a_0 = (2 T_1) / T$. Let us look at the approximation $hat(x)_N (t)$:
  $
    hat(x)_N (t) = sum_(k = -N)^N a_k e^(j k omega_0 t)
  $

  #let T = 1
  #let T1 = 0.3 * T
  #let omega0 = 2 * calc.pi / T
  #let a = k => if k == 0 {
    2 * T1 / T
  } else {
    calc.sin(2 * calc.pi * k * T1 / T) / (k * calc.pi)
  }

  #let square_series = N => {
    let x = lq.linspace(-T / 2, T / 2, num: 501)
    let sum = ()

    for i in range(x.len()) {
      sum.push(0.0)
    }

    for i in range(x.len()) {
      sum.at(i) += a(0)

      for k in range(-N, N + 1) {
        if k != 0 {
          sum.at(i) += a(k) * calc.cos(k * omega0 * x.at(i))
        }
      }
    }
    (x, sum)
  }


  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #let N = 3
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],
      [
        #let N = 8
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],

      [
        #let N = 18
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],
      [
        #let N = 28
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],

      [
        #let N = 55
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],
      [
        #let N = 80
        #let (xx, sum) = square_series(N)
        #lq.diagram(
          title: $hat(x)_N (t)$,
          xlabel: $t$,
          ylim: (-0.4, 1.4),
          xlim: (-0.6, 0.6),
          xaxis: (ticks: (-1, 0, 1), subticks: none),
          height: 2cm,
          width: 7cm,
          lq.plot(xx, sum, mark: none),
          lq.plot((T1, T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
            dash: "dashed",
            paint: red,
          )),
          lq.place(0.5, 1.3, align: center)[$N = #N$],
          lq.place(T1, -0.3, align: center)[$T_1$],
          lq.place(-T1, -0.3, align: center)[$-T_1$],
          lq.place(T / 2, -0.3, align: center)[$T/2$],
          lq.place(-T / 2, -0.3, align: center)[$-T/2$],
        )],
    )]
]

== Properties of Continuous-Time Fourier Series

In this section, we will use the notation
$
  x(t) limits(arrow.l.r)^(cal("FS")) a_k
$
to denote the pariing of a periodic signal with its Fourier series coefficients.


=== Linearity

Suppose $x(t) limits(arrow.l.r)^(cal("FS")) a_k$ and $y(t) limits(arrow.l.r)^(cal("FS")) b_k$, we have
$
  z(t) = A x(t) + B y(t) limits(arrow.l.r)^(cal("FS")) c_k = A a_k + B b_k
$

=== Time Shifting

When a time shift is applied to a periodic signal $x(t)$, the period $T$ is preserved. The Fourier series coefficients $b_k$ of the resulting signal $y(t) = x(t - t_0)$ may be expressed as
$
  b_k = 1/T integral_T x(t - t_0) e^(-j k omega_0 t) "d" t
$
Letting $tau = t - t_0$ in the integral and noting that the new variable $tau$ will also range over an interval of duration $T$, we have
$
  1/T integral_T x(tau) e^(-j k omega_0 (tau + t_0)) "d"t = e^(-j k omega_0 t_0) 1/T integral_T x(tau) e^(-j k omega_0 tau) "d"tau = e^(-j k omega_0 t_0) a^k
$
In short hand notation,
$
  x(t - t_0) limits(arrow.l.r)^(cal("FS")) e^(-j k omega_0 t_0) a_k
$

=== Time Reversal

Suppose we have $y(t) = x(-t)$, we have
$
  y(t) = x(-t) = sum_(k = -infinity)^(infinity) a_k e^(-j k 2 pi t / T) = sum_(m = -infinity)^(infinity) a_(-m) e^(j m 2 pi t / T), quad k = -m
$

That is, if $x(t) limits(arrow.l.r)^(cal("FS")) a_k$, we have $x(-t) limits(arrow.l.r)^(cal("FS")) a_(-k)$.

=== Time Scaling

In this case,
$
  x(alpha t) = sum_(k = -infinity)^infinity a_k e^(j k (alpha w_0) t)
$
While the Fourier coefficients have not changed, the Fourier series representation has changed because of the change in the fundamental frequency.

=== Multiplication

$
  x(t) y(t) limits(arrow.l.r)^(cal("FS")) h_k = sum_(l = -infinity)^infinity a_l b_(k - l)
$
Observe that the sum on the right-hand side may be interpreted as the discrete-time convolution of the sequence representing the Fourier coefficients of $x(t)$ and the sequence representing the Fourier coefficients of $y(t)$. In the later section, we will learn more about the fact the time domain multiplication implies frequency domain convolution, and time domain convolution implies frequency domain multiplication.

=== Conjugation

Taking the complex conjugate of a periodic signal $x(t)$ has the effect of complex conjugation and time-reversal on the corresponding Fourier series coefficients. That is, if
$
  x(t) limits(arrow.l.r)^(cal("FS")) a_k
$
then
$
  x^*(t) limits(arrow.l.r)^(cal("FS")) a_(-k)^*
$

=== Parseval's Relation

The Parseval's relation for continuous-time periodic signals is
$
  1/T integral_T |x(t)|^2 "d"t = sum_(k = -infinity)^infinity |a_k|^2
$
The Parseval's relation reveals that the average power in one domain equals the average power in another domain.

We summarize the properties below in a table.


#note("Properties of Continuous-Time Fourier Series")[
  #align(center)[
    #table(
      columns: 3,
      stroke: 0.5pt,
      align: center,
      table.header(
        [*Property*], [*Periodic Signal*], [*Fourier Series Coefficients*]
      ),

      // Linearity
      [Linearity], [$A x(t) + B y(t)$], [$A a_k + B b_k$],

      // Time Shift
      [Time Shift], [$x(t - t_0)$], [$a_k e^(-j k omega_0 t_0)$],

      // Frequency Shift
      [Frequency Shift], [$x(t) e^(j M omega_0 t)$], [$a_(k-M)$],

      // Conjugation
      [Conjugation], [$x^*(t)$], [$a^*_(-k)$],

      // Time Reversal
      [Time Reversal], [$x(-t)$], [$a_(-k)$],

      // Time Scaling
      [Time Scaling], [$x(alpha t), alpha > 0$ (period $T / alpha$)], [$a_k$],

      // Periodic convolution
      [Periodic Convolution],
      [$integral_T x(tau) y(t - tau) "d"tau$],
      [$T a_k b_k$],

      // Multiplication
      [Multiplication],
      [$x(t) y(t)$],
      [$sum_(i = -infinity)^infinity a_i b_(k-i)$],

      // Differentiation
      [Differentiation], [$dif / (dif t) x(t)$], [$j k omega_0 a_k$],

      // Integration
      [Integration],
      [$integral_(-infinity)^t x(tau) dif tau$],
      [$a_k / (j k omega_0)$ for $k != 0$; $a_0$ undefined],

      // Real Signal
      [Real Signal], [$x(t) = x^*(t)$], [$a_k = a^*_(-k)$],

      // Symmetry
      [Conjugate Symm. for Real Signals], [$x(t)$ real], [$a_k = a_(-k)^*$],
      [Real & Even], [$x(t)$], [$a_k$ real and even],
      [Real & Odd], [$x(t)$], [$a_k$ imaginary and odd],

      // Parseval's Theorem
      [Parseval's Theorem],
      [$1/T integral_T |x(t)|^2 dif t = sum_(k=-infinity)^infinity |a_k|^2$],
      // [$sum_(k=-infinity)^infinity |a_k|^2$],
    )]
]

== Fourier Series Representation of Discrete-Time Periodic Signals

As defined in previous topics, a discrete-time signal $x[n]$ is periodic with period $N$ if
$
  x[n] = x[n + N]
$

The fundamental period is the smallest positive integer $N$ for which the above equation holds, and $omega_0 = (2 pi)/N$ is the fundamental frequency. The set of all discrete-time complex exponential signals that are periodic with period $N$ is given by
$
  phi_k [n] = e^(j k omega_0 n) = e^(j k (2 pi)/N n), k = 0, plus.minus 1, plus.minus 2, dots.c
$
All of these signals have fundamental frequencies that are multiples of $(2 pi) / N$ and thus are harmonically related. There are only $N$ distinct signals in the set given by the above equation. In general,
$
  phi_(k) [n] = phi_(k + r N) [n]
$
That is, when $k$ is changed by any integer ($r$) multiple of $N$, the identical sequence is generated. this differs from the continuous-time in which the signals $phi_k (t)$ are different from one another.

We now wish to express the periodic DT sequence in terms of linear combinations of the sequence $phi_k [n]$. Such a linear combination has the form
$
  x[n] = sum_k a_k phi_k [n] = sum_k a_k e^(j k omega_0 n) = sum_k a_k e^(j k (2 pi) / N n)
$
Since the sequence $phi_k [n]$ are distinct only over a range of $N$ successive values of $k$, thus, the summation only need ton inlucde terms over this range, beginning with any values of $k$. We denote this by expressing the limits of the summation as $k = chevron.l N chevron.r$, viz.,

$
  x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n) = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/ N n)
$

If we examine the sum of the $phi_k [n]$,
$
  sum_(n = chevron.l N chevron.r) phi_k [n] = sum_(n = chevron.l N chevron.r) e^(j k (2 pi)/N n) = cases(N\, quad k = 0\, plus.minus 1\, plus.minus 2\, dots.c, 0\, quad "otherwise")
$

Similar to the continuous-time counterpart, we consider the Fourier series representation, i.e.,
$
  x[n] = sum_(k = chevron.l N chevron.r) a_k phi_k [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/N n)
$

Multiplying both sides with $e^(-j r (2 pi)/N n)$ and summing over $N$ terms, we obtain
$
  sum_(k = chevron.l N chevron.r) x[n] e^(-j r (2 pi)/N n) = sum_(n = chevron.l N chevron.r) sum_(k = chevron.l N chevron.r) a_k e^(j (k-r) (2 pi)/N n) = sum_(k = chevron.l N chevron.r) a_k sum_(n = chevron.l N chevron.r) e^(j (k - r) (2 pi) / N n)
$ <dtfs>

We know that
$
  sum_(n = chevron.l N chevron.r) e^(j (k - r) (2 pi)/N n)
$

Hence,
$
  sum_(n = chevron.l N chevron.r) e^(j (k - r) (2 pi) / N n) = cases(N\, quad k = r, 0\, quad "otherwise")
$

The right side of @dtfs reduces to $N a_r$. And we have,
$
  a_r = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j r (2 pi)/N n)
$

#definition("Fourier Series for Discrete-Time Periodic Signals")[
  We can express the periodic discrete-time signal $x[n]$ as
  $
    x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n) = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/ N n)
  $
  where
  $
    a_k = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n)
  $
  The notation $n = chevron.l N chevron.r$ represents the variable $n$ varies over a range of $N$ successive integers, beginning with any value $k$. Ditto for $k$.
]

#example("Discrete-time Periodic Signal Fourier Series")[
  Consider the signal $x[n] = sin omega_0 n$, which is the discrete-time counterpart of signal $x(t) = sin omega_0 t$. $x[n]$ is periodic only if $(2 pi) / omega_0$ is an integer, or a ratio of integers. For those cases, when $(2 pi) / omega_0$ is an integer $N$, $x[n]$ is periodic with fundamental period $N$. Expanding the signal as a sum of two complex exponentials, we get
  $
    x[n] = 1/(2 j) e^(j (2 pi)/N n) - 1/(2 j) e^(-j (2 pi)/N n)
  $
  Comparing with
  $
    x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n)
  $
  we have
  $
    a_1 = 1 / (2 j), a_(-1) = - 1 / (2 j)
  $
  and the remaining coefficients over the interval of $N$ consecutive numbers are zero.

  Consider now the signal
  $
    x[n] = 1 + sin (2 pi)/N n + 3 cos (2 pi)/N n + cos ((4 pi)/N n + pi/2)
  $
  This signal is periodic with period $N$, and we can expand $x[n]$ using Euler's relation,
  $
    x[n] &= 1 + 1/(2j) (e^(j (2 pi)/N n) - e^(-j (2 pi)/N n)) + 3/2 (e^(j (2 pi)/N n) + e^(-j (2 pi)/N n)) + 1/2 (e^(j (4 pi n)/N + pi/2) + e^(-j (4 pi n)/N + pi/2)) \
    &= 1 + (3/2 + 1/(2j)) e^(j (2 pi)/N n) + (3/2 - 1/(2j)) e^(-j (2 pi)/N n) + (1/2 e^(j pi / 2)) e^(j 2 (2 pi / N) n) + (1/2 e^(-j pi/2)) e^(-j 2 (2 pi)/N n)
  $
  Hence, the coefficients for this example are
  $
    a_0 = 1, quad a_1 = 3/2 + 1/(2j), quad a_(-1) = 3/2 - 1/(2j), quad a_2 = 1/2 j, quad a_(-2) = -1/2 j
  $
]
Let us also consider a periodic discrete-time square wave shown below.

#let N1 = 2
#let N = 7
#let square_series = n => { if calc.abs(n) <= N1 { 1 } else { 0 } }
#let k = lq.linspace(-15, 15, num: 31)

#align(center)[
  #lq.diagram(
    title: $h[n]$,
    xlabel: $n$,
    height: 2.5cm,
    width: 10cm,
    ylim: (-0.2, 1.3),
    lq.stem(k, k.map(k => square_series(k))),
    lq.stem(k, k.map(k => square_series(k - N))),
    lq.stem(k, k.map(k => square_series(k + N))),
    lq.place(N, -0.3, align: center)[$N$],
    lq.place(-N, -0.3, align: center)[$-N$],
    lq.place(N1, -0.3, align: center)[$N_1$],
    lq.place(-N1, -0.3, align: center)[$-N_1$],
    lq.place(-N1 * 2 - N, 0.5, align: center)[$dots.c$],
    lq.place(N1 * 2 + N, 0.5, align: center)[$dots.c$],
  )
]

The Fourier series is then
$
  a_k = 1 / N sum_(k = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1 / N sum_(k = -N_1)^(N_1) e^(-j k (2 pi)/N n)
$
Letting $m = n + N_1$, we have
$
  a_k &= 1/N sum_(m = 0)^(2 N_1) e^(-j k (2 pi)/N (m - N_1)) = 1/N e^(j k (2 pi)/N N_1) sum_(m = 0)^(2 N_1) e^(-j k (2 pi) / N m) \
  &= 1/N e^(j k (2 pi)/N N_1) ( (1 - e^(-j k 2 pi (2 N_1 + 1)/N)) / (1 - e^(-j k (2 pi) / N))) = 1/N (sin [2 pi k (N_1 + 1/2) / N]) / (sin((pi k)/ N)), quad k != 0, plus.minus N, plus.minus 2 N, dots.c
$
$
  a_k = (2 N_1 + 1) / N, quad k = 0, plus.minus N, plus.minus 2 N, dots.c
$

We now know that the Fourier series coefficients are

$
  a_k = 1/N (sin [2 pi k (N_1 + 1/2) / N]) / (sin((pi k)/ N)), quad k != 0, plus.minus N, plus.minus 2 N, dots.c
$
and
$
  a_0 = (2 N_1 + 1) / N, quad k = 0
$

Let us plot the sequence for different cases. In the following plots, we set $2 N_1 + 1 = 5$,
#let N1 = 2
#let k = lq.linspace(-25, 25, num: 51)

#align(center)[

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #let N = 10
      #let fs_square = k => {
        if k == 0 { (2 * N1 + 1) / N } else {
          (
            1
              / N
              * calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
              / calc.sin(calc.pi * k / N)
          )
        }
      }
      #lq.diagram(
        title: $a_k$,
        xlabel: $k$,
        height: 2cm,
        width: 7cm,
        ylim: (-0.2, 0.7),
        lq.stem(k, k.map(k => fs_square(k))),
        lq.place(5, 0.5, align: center)[$N = #N$],
      )
    ],
    [
      #let N = 20
      #let fs_square = k => {
        if k == 0 { (2 * N1 + 1) / N } else {
          (
            1
              / N
              * calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
              / calc.sin(calc.pi * k / N)
          )
        }
      }
      #lq.diagram(
        title: $a_k$,
        xlabel: $k$,
        height: 2cm,
        width: 7cm,
        ylim: (-0.2, 0.7),
        lq.stem(k, k.map(k => fs_square(k))),
        lq.place(5, 0.5, align: center)[$N = #N$],
      )
    ],

    [
      #let N = 30
      #let fs_square = k => {
        if k == 0 { (2 * N1 + 1) / N } else {
          (
            1
              / N
              * calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
              / calc.sin(calc.pi * k / N)
          )
        }
      }
      #lq.diagram(
        title: $a_k$,
        xlabel: $k$,
        height: 2cm,
        width: 7cm,
        ylim: (-0.2, 0.7),
        lq.stem(k, k.map(k => fs_square(k))),
        lq.place(5, 0.5, align: center)[$N = #N$],
      )
    ],
    [
      #let N = 40
      #let fs_square = k => {
        if k == 0 { (2 * N1 + 1) / N } else {
          (
            1
              / N
              * calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
              / calc.sin(calc.pi * k / N)
          )
        }
      }
      #lq.diagram(
        title: $a_k$,
        xlabel: $k$,
        height: 2cm,
        width: 7cm,
        ylim: (-0.2, 0.7),
        lq.stem(k, k.map(k => fs_square(k))),
        lq.place(5, 0.5, align: center)[$N = #N$],
      )
    ],
  )]

In the continuous-time case, we observed the Gibbs phenomenon at the discontinuity, whereby, as the number of terms increased, the ripples in the partial sum became compressed toward the discontinuity, with the peak amplitude of the ripples remaining constant independently of the number of terms in the partial sum. Let us now consider the *analogous* sequence of partial sums for the discrete-time square wave, where, for convenience, we will assume that the period $N$ is odd:

$
  hat(x)_M [n] = sum_(k = -M)^(M) a_k e^(j k (2 pi)/N n)
$

Let us look at the approximation function $hat(x)_M$. In the following case $N = 9$, and $2 N_1 + 1 = 5$.

#let N = 9
#let N1 = 2
#let k = lq.linspace(-20, 20, num: 41)
#let fs_square = k => {
  if k == 0 { (2 * N1 + 1) / N } else {
    (
      1
        / N
        * calc.sin(2 * calc.pi * k * (N1 + 0.5) / N)
        / calc.sin(calc.pi * k / N)
    )
  }
}
#let xhat = M => {
  let sum = ()

  for i in range(k.len()) {
    sum.push(0.0)
  }

  for i in range(k.len()) {
    sum.at(i) += fs_square(0) / 2

    for m in range(1, M + 1) {
      sum.at(i) += fs_square(m) * calc.cos(m * calc.pi * 2 / N * k.at(i))
    }
  }
  sum
}
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    [
      #let M = 1
      #lq.diagram(
        title: $hat(x)_M [n]$,
        xlabel: $n$,
        height: 2.5cm,
        width: 7cm,
        ylim: (-0.2, 1.3),
        lq.stem(k, xhat(M)),
        lq.place(4, 1, align: center)[$M = #M$],
      )],
    [
      #let M = 2
      #lq.diagram(
        title: $hat(x)_M [n]$,
        xlabel: $n$,
        height: 2.5cm,
        width: 7cm,
        ylim: (-0.2, 1.3),
        lq.stem(k, xhat(M)),
        lq.place(4, 1, align: center)[$M = #M$],
      )],

    [
      #let M = 3
      #lq.diagram(
        title: $hat(x)_M [n]$,
        xlabel: $n$,
        height: 2.5cm,
        width: 7cm,
        ylim: (-0.2, 1.3),
        lq.stem(k, xhat(M)),
        lq.place(4, 1, align: center)[$M = #M$],
      )],
    [
      #let M = 4
      #lq.diagram(
        title: $hat(x)_M [n]$,
        xlabel: $n$,
        height: 2.5cm,
        width: 7cm,
        ylim: (-0.2, 1.3),
        lq.stem(k, xhat(M)),
        lq.place(4, 1, align: center)[$M = #M$],
      )],
  )]

We see that if $N$ is odd and we take $M = (N - 1)/2$, the sum includes exactly $N$ terms, consequently, from the synthesis equations, we have
$
  hat(x)_M [n] = x[n]
$
Similarly, if $N$ is even, and we let $hat(x)_M [n] = sum_(k = -M + 1)^M a_k e^(j k (2 pi)/N n)$, then with $M = N / 2$, this sum consists of $N$ terms, and again, we conclude that $hat(x)_M [n] = x[n]$.

== Properties of Discrete-Time Fourier Series

#note("Properties of Discrete-Time Fourier Series")[
  #align(center)[
    #table(
      columns: 3,
      stroke: 0.5pt,
      align: center,
      table.header(
        [*Property*], [*Periodic Signal*], [*Fourier Series Coefficients*]
      ),

      // Linearity
      [Linearity], [$A x[n] + B y[n]$], [$A a_k + B b_k$],

      // Time Shift
      [Time Shift], [$x[n - n_0]$], [$a_k e^(-j k (2 pi)/N n_0)$],

      // Frequency Shift
      [Frequency Shift], [$x[n] e^(j M (2 pi)/ N n)$], [$a_(k-M)$],

      // Conjugation
      [Conjugation], [$x^*[n]$], [$a^*_(-k)$],

      // Time Reversal
      [Time Reversal], [$x[-n]$], [$a_(-k)$],

      // Time Scaling
      [Time Scaling],
      [$x_((m))[n] = cases(x[n/m]\, quad n = r m, 0\, quad "otherwise")$],
      [$1/m a_k$],

      // Periodic convolution
      [Periodic Convolution],
      [$sum_(r = chevron.l N chevron.r) x[r] y[n-r]$],
      [$N a_k b_k$],

      // Multiplication
      [Multiplication],
      [$x[n] y[n]$],
      [$sum_(l = chevron.l N chevron.r) a_l b_(k-l)$],

      // Differentiation
      [First Difference], [$x[n] - x[n-1]$], [$(1 - e^(-j k (2 pi)/N)) a_k$],

      // Integration
      [Running Sum],
      [$sum_(k = -infinity)^n x[k]$, finit & periodc only if $a_0 = 0$],
      [$1/(1 - e^(-j k (2 pi)/N)) a_k$],

      // Real Signal
      [Real Signal], [$x[n] = x^*[n]$], [$a_k = a^*_(-k)$],

      // Symmetry
      // [Conjugate Symm. for Real Signals], [$x(t)$ real], [$a_k = a_(-k)^*$],
      [Real & Even], [$x[n]$], [$a_k$ real and even],
      [Real & Odd], [$x[n]$], [$a_k$ imaginary and odd],

      // Even-Odd Decomposition of Real Signals
      [Even-Odd Decomposition],
      [$x_e [n] = "Even"{ x[n] }$, $x[n]$ real],
      [$Re{a_k}$],

      [Even-Odd Decomposition],
      [$x_o [n] = "Odd"{ x[n] }$, $x[n]$ real],
      [$j Im{a_k}$],

      // Parseval's Theorem
      [Parseval's Theorem],
      [$1/N sum_(n = chevron.l N chevron.r) |x[n]|^2 = sum_(k = chevron.l N chevron.r) |a_k|^2$],
      // [$sum_(k=-infinity)^infinity |a_k|^2$],
    )]
]

#example("Discrete-Time Fourier Series Properties")[

  Suppose we are given the following facts about a sequence $x[n]$

  - $x[n]$ is periodic with period $N = 6$.
  - $sum_(n = 0)^5 x[n] = 2, sum_(n = 2)^7 (-1)^n x[n] = 1$.
  - $x[n]$ has the minimum power per period among the set of signals satisfying the preceding two conditions.

  Let us detmine the sequence $x[n]$. We denote the Fourier series coefficients of $x[n]$ by $a_k$. Per definition,
  $
    a_k = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n)
  $
  From fact 2, we conclude that $a_0 = 1/6 sum_(n=0)^5 x[n] = 1/6 sum_(n=10)^(15) x[n] = 1/3$. Noting that $(-1)^n = e^(-j pi n)$, therefore, we can _treat_ fact 2 also as a Fourier series, i.e.,
  $
    sum_(n = 2)^7 (-1)^n x[n] = sum_(n = chevron.l N chevron.r) e^(-j pi n) x[n] = sum_(n = chevron.l 6 chevron.r) x[n] e^(-j k (2 pi)/6 3 n) = N dot a_3 = 1
  $
  Hence, $a_3 = 1/6$. From Parseval's relation, the average power is
  $
    P = sum_(n = chevron.l N chevron.r) |x[n]|^2 = sum_(k = chevron.l N chevron.r) |a_k|^2
  $
  We have already found $a_0$ and $a_3$, so with $a_1 = a_2 = a_4 = a_5 = 0$, it is the only way that the total power is minimized. Finally, we have $x[n] = a_0 + a_3 e^(-j pi n) = 1/3 + (1/6) (-1)^n$.
]


== Fourier Series and LTI Systems

In the previous sections, we have seen that the Fourier series representation can be used to construct any periodic signal in discrete-time and essentially all periodic continuous-time signals of practical importance. In addition, we saw that the response of an LTI system to a linear combination of complex exponentials takes a particularly simple form. Specifically, in continuous time, if
$
  x(t) = e^(s t)
$
is the input of a continuous-time LTI system, then the output is given by
$
  y(t) &= integral_RR h(tau) x (t - tau) "d" tau = integral_RR h(tau) e^(s (t - tau)) "d" tau = integral_RR h(tau) e^(s t) e^(-s tau) "d" tau \
  &= e^(s t) integral_RR h(tau) e^(-s tau) "d" tau equiv e^(s t) H(s)
$
where
$
  H(s) = integral_RR h(tau) e^(-s tau) "d" tau
$
is the Laplace transform.

Similarly, when the input to a discrete-time LTI system is $x[n] = z^n$, we have
$
  y[n] = sum_k h[k] x[n-k] = sum_k h[k] z^(n - k) = z^n sum_k h[k] z^(-k) = z^n H(z)
$
where
$
  H(z) = sum_k h[k] z^(-k)
$
is the $z$-transform. When $s$ or $z$ are general complex numbers, $H(s)$ and $H(z)$ are referred to as the *system functions* of the corresponding system. The system function of the form $s = j omega$, i.e., $H(j omega)$ viewed ats a function of $omega$, is referred to as the _frequency response_ of the system.

#definition("Frequency Response of an LTI System")[
  We define the _frequency response_ of a _continuous-time_ system is given by
  $
    H(j omega) = integral_RR h(t) e^(-j omega t) "d"t
  $
  where $h(t)$ is the impulse response of the said LTI system. In the _discrete-time_ case, the frequency response is given by
  $
    H(j omega) = sum_n h[n] e^(-j omega n)
  $
]

Now, suppose that the input is now
$
  x(t) = sum_k a_k e^(s_k t) = sum_k a_k e^(j k omega_0 t)
$
The output of the LTI system is then
$
  y(t) &= integral_RR h(tau) x(t - tau) "d" tau = integral_RR h(tau) sum_k a_k e^(s_k (t - tau)) = sum_k a_k [integral_RR h(tau) e^(- s_k tau)] e^(s_k t) \ &= sum_k a_k H(s_k) e^(s_k t) = sum_k a_k H(j k omega_0) e^(j k omega_0 t)
$
Similarly, if the input to a discrete-time LTI system is now
$
  x[n] = sum_k a_k z_k^n = sum_k a_k e^(j omega_0 n)
$
The output is
$
  y[n] & = sum_k h[k] x[n - k] = sum_k a_k H(z_k) z_k^n
$

#example("Calculate Fourier series coefficients through frequency response")[
  Suppose the impulse response of an LTI system is
  $
    h(t) = e^(-t) u(t)
  $
  and the input periodic signal $x(t)$ is defined as
  $
    x(t) = sum_(k = -3)^3 a_k e^(j k 2 pi t)
  $
  with $a_0 = 1, a_1 = a_(-1) = 1/4, a_2 = a_(-2) = 1/2, a_3 = a_(-3) = 1/3$.

  To calculate the Fourier series coefficients of the output $y(t)$, we first compute the frequency response
  $
    H(j omega) = integral_RR h(tau) e^(-j omega tau) "d" tau = integral_0^infinity e^(-tau ) e^(-j omega tau) "d" tau = -1/(1+j omega) e^(-tau - j omega tau) lr(|, size: #200%)_(0)^(infinity) = 1 / (1 + j omega)
  $
  Therefore, according to
  $
    y(t) = sum_k a_k H(j k omega_0) e^(j k omega_0 t)
  $
  and with the fact that $omega_0 = 2 pi$, we have
  $
    y(t) = sum_(k=-3)^(3) a_k H(j k 2 pi) e^(j k 2 pi t)
  $

  Further, since both the input and the impulse response are real-valued signal, the output $y(t)$ must also be real-valued. This can be verified that $a_k^* H^*(j k 2 pi) = a_(-k) H(-j k 2 pi)$.


]

== Examples of Filters Described by Differential Equations

// In many applications, frequency-selective filtering is accomplished through the use of LTI systems described by linear constant-coefficient differential (or difference) equations.

#example("LCCDE via difference equations")[

  Suppose an LTI system is described by the first-order difference equation
  $
    y[n] - a y[n-1] = x[n]
  $
  From the eigenfunction property of the complex exponentials, we know that if $x[n] = e^(j omega n)$, then $y[n] = H(e^(j omega)) e^(j omega n)$, where $H(e^(j omega))$ is the frequency responses of the system. We obtain
  $
    H(e^(j omega)) e^(j omega n) - a H(e^(j omega)) e^(j omega (n-1)) = e^(j omega n)
  $
  therefore
  $
    H(e^(j omega)) = 1 / (1 - a e^(-j omega))
  $
  and the corresponding impulse response is
  $
    h[n] = a^n u[n]
  $
  The step response is then $s[n] = u[n] star h[n]$
  $
    s[n] = (1 - a^(n + 1)) / (1 - a) u[n]
  $

  If we would like to know the transfer function of a _moving-average filter_, which is of the form
  $
    y[n] = 1/3 (x[n-1] + x[n] + x[n+1])
  $
  so that each output $y[n]$ is the average of three consecutive input values. The impulse response is
  $
    h[n] = 1/3 (delta [n+1] + delta [n] + delta [n-1])
  $
  Thus, the corresponding frequency response is then
  $
    H(e^(j omega)) = sum_k h[k] e^(-j omega k) = 1/3 [e^(j omega) + 1 + e^(-j omega)]
  $
]

#example("RC Circuit")[
  An RLC circuit whose capacitor voltage is initially zero consistutudes an LTI system describable by a linear constant-coefficient differential equation (LCCDE). Consider the following series RLC circuit. Let the voltage source be the input signal $x(t)$, and let the voltage measured across the capacitor be the output signal $y(t)$.

  #align(center)[
    #zap.circuit({
      import zap: *

      vsource("V", (0, 0), variant: "pretty", rotate: 90deg)
      resistor("R", (2, 1), variant: "ieee", label: $R$)
      capacitor("C", (4, 0), variant: "ieee", rotate: 270deg, label: $C$)

      wire((0, 0), (0, 1), "R.in")
      wire("R.out", (4, 1), "C.in")
      wire("C.out", (4, -1), (0, -1), "V.in")

      draw.content((-1.5, 0), $v_S (t)$, anchor: "west")
      draw.content((2.6, 0), $v_C (t)$, anchor: "west")
      draw.content((2, 0.7), $v_R (t)$, anchor: "north")
    })]

  If we take the capacitor's voltage as the output, we have
  $
    R C ("d" v_C (t)) / ("d" t) + v_C (t) = v_S (t)
  $

  Assuming initial rest, the system described by the above LCCDE is LTI. In order to determine its frequency response $H(j omega)$, we note that, by definition, with input voltage $v_S (t) = e^(j omega t)$, we must have the output voltage $v_C (t) = H(j omega) e^(j omega t)$. If we substitute these expressions into the above LCCDE, we obtain
  $
    R C "d"/("d" t) [H(j omega) e^(j omega t)] + H(j omega) e^(j omega t) = e^(j omega t)
  $
  It directly follows that
  $
    H(j omega) = 1 / (1 + R C j omega)
  $
  The $|H (j omega)|$ decreases with an increasing $|omega|$. Thus, this simple RC filter with $v_C (t)$ as the output is a lowpass filter.

  If we choose the voltage across the resistor $v_R (t)$ as the output, the LCCDE is then
  $
    R C ("d" v_R (t))/("d" t) + v_R (t) = R C ("d" v_S (t))/("d" t)
  $

  The transfer function (frequency response) is then obtained by substituting $v_S (t) = e^(j omega t)$ and we obtain $v_R (t) = G(j omega) e^(j omega t)$, viz.,
  $
    G (j omega) = (j omega R C) / (1 + j omega R C)
  $
  We can see that the amplitude $|G(j omega)|$ increases with increasing $|omega|$, hence a highpass filter.
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #let x = lq.linspace(-5, 5, num: 99)
        #cdiagram(
          title: $|H(j omega)|$,
          xlabel: $omega$,
          width: 5cm,
          height: 3cm,
          ylim: (-0.2, 1.2),
          lq.plot(x, x.map(x => 1 / (calc.sqrt(1 + x * x))), mark: none),
        )],
      [
        #let x = lq.linspace(-5, 5, num: 99)
        #cdiagram(
          title: $|G(j omega)|$,
          xlabel: $omega$,
          width: 5cm,
          height: 3cm,
          ylim: (-0.2, 1.2),
          lq.plot(
            x,
            x.map(x => calc.abs(x) / (calc.sqrt(1 + x * x))),
            mark: none,
          ),
        )],
    )]
]


