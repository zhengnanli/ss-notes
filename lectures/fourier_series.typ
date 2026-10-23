#import "lib.typ": *

= Fourier Series
#show: lq.theme.schoolbook
#show: schoolbook-style

== The Response of LTI Systems to Complex Exponentials

It is advantageous to study LTI systems by representing signals as linear combinations of basic signals that possess the following two properties:

- The set of basic signals can be used to construct a broad and useful class of signals
- The response of an LTI system to each signal should be simple enough in structure to provide us with a convenient representation for the response of the system to any signal constructed as a linear combination of the basic signals.

A signal for which the system output is a (possibly complex) constant times the input is referred to as an _eigenfunction_ of the system, and the amplitude factor is referred to as the system's _eigenvalue_. Now, we would like to show that in a continuous-time system, the input $e^(s t)$ is an eigenfunction. From previous lectures, we know that the output of the system is linked to the input via the convolution integral:

$
  y(t) = integral_RR h(tau) x(t - tau) "d"tau = integral_RR h(tau) e^(s (t - tau)) "d"tau = e^(s t) integral_RR h(tau) e^(-s tau) "d"tau = H(s) e^(s t)
$

Hence, complex exponentials are eigenfunctions of LTI systems. Similarly, in the discrete-time case, it is straightforward to show that $z^n$ is an eigenfunction of discrete-time LTI systems.

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
The discrete-time case follows in the same way.

== Fourier Series Representation of Continuous-Time Periodic Signals

Suppose we would like to express a periodic signal using the sum of exponentials as
$
  x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) = sum_(k = -infinity)^(infinity) a_k e^(j k (2 pi) / T t)
$
Multiplying both sides by $e^(-j n omega_0 t)$ and integrating both sides from $0$ to $T = (2 pi) / omega_0$, we have
$
  integral_0^T x(t) e^(-j n omega_0 t) "d"t = integral_0^T sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) e^(-j n omega_0 t) "d"t = sum_(k=-infinity)^(infinity) a_k [ integral_0^T e^(j (k - n) omega_0 t) "d"t]
$ <intxt>
If we closely examine the last part of @intxt, we have
$
  integral_0^T e^(j (k-n) omega_0 t) "d"t = cases(T\, &quad k = n, 0\, &quad k != n)
$
so every term of the sum except $k = n$ vanishes, and the right side of @intxt reduces to $T a_n$. Therefore
$
  a_n = 1/T integral_0^T x(t) e^(-j n omega_0 t) "d"t
$
Since the signal is periodic, the integral may be taken over _any_ interval of length $T$,
$
  a_n = 1/T integral_T x(t) e^(-j n omega_0 t) "d"t
$

To summarize,
#definition("Fourier Series for Continuous-Time Periodic Signal")[
  We can decompose a periodic signal $x(t)$ as the sum of complex exponentials:
  #eqalt(
    "x of t equals the sum over k from negative infinity to infinity of a sub k times e to the j k omega-zero t, which equals the sum of a sub k times e to the j k two pi over T times t.",
    $
      x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t) = sum_(k = -infinity)^(infinity) a_k e^(j k (2 pi)/T t)
    $,
  )
  where
  #eqalt(
    "a sub k equals one over T times the integral over one period of x of t times e to the negative j k omega-zero t, d t.",
    $
      a_k = 1/T integral_T x(t) e^(-j k omega_0 t) "d"t = 1/T integral_T x(t) e^(-j k (2 pi)/T t) "d"t
    $,
  )
  The set of coefficients ${a_k}_(k = -infinity)^(infinity)$ is referred to as the _Fourier series coefficients_. The coefficient $a_0$ is the DC component of $x(t)$, and is given by
  #eqalt(
    "a sub zero equals one over T times the integral of x of t over one period.",
    $
      a_0 = 1/T integral_T x(t) "d"t
    $,
  )
]

Two functions $phi_1 (t)$ and $phi_2 (t)$ are said to be _orthogonal_ over the interval $(a, b)$ if
$
  integral_a^b phi_1 (t) phi_2^* (t) "d"t = 0
$
If in addition
$
  integral_a^b |phi_1 (t)|^2 "d"t = integral_a^b |phi_2 (t)|^2 "d"t = 1
$
then the functions are said to be _normalized_, and hence are called _orthonormal_. A set of such functions ${phi_i (t)}, i = 0, plus.minus 1, plus.minus 2, dots.c$ is called an orthonormal set if every distinct pair in the set is orthogonal and every member has unit energy.

Let $x(t)$ be a given signal. Consider the following approximation of $x(t)$ over the interval $a <= t <= b$:
$
  hat(x)_N (t) = sum_(i = -N)^N a_i phi_i (t)
$
Here, $a_i$ are complex constants. To measure the deviation between $x(t)$ and $hat(x)_N (t)$, we consider the error defined as
$
  e_N (t) = x(t) - hat(x)_N (t)
$
A criterion for measuring the "quality" of the approximation is the energy in the error signal, i.e.,
$
  E_N = integral_a^b |e_N (t)|^2 "d"t
$

Let $phi_n (t) = e^(j n omega_0 t)$, which are orthogonal (but each has energy $T$, not 1) over any interval of length $T = (2 pi)/omega_0$. The $a_i$ that minimize $E_N$ are
$
  a_i = 1 / T integral_T x(t) e^(-j i omega_0 t) "d"t
$

== Convergence of the Fourier Series

In general, a set of conditions developed by Dirichlet guarantees that $x(t)$ _equals_ its Fourier series representation, except at isolated values of $t$ for which $x(t)$ is discontinuous. The Dirichlet conditions are as follows:

// #note("Dirichlet Conditions")[
1. Over any period, $x(t)$ must be _absolutely integrable_, i.e., $integral_T |x(t)| "d"t < infinity$
2. In any finite interval of time, $x(t)$ is of bounded variation; that is, there are no more than a finite number of maxima and minima during any single period of the signal.
3. In any finite interval of time, there are only a finite number of discontinuities. Furthermore, each of these discontinuities is finite.
// ]

#example("Fourier Series for Triangle Function")[
  #set math.equation(numbering: none)
  Find the Fourier series for the periodic triangle function of @fig-triangle.

  The period is $T = 1$, so the wave falls linearly from $1$ at $t = -1 \/ 2$ to
  $-1$ at $t = 0$ and rises back to $1$ at $t = 1 \/ 2$.

  #let x = lq.linspace(-1.5, 1.5, num: 601)
  // One period of the wave described by the integrals below: -1 at t = 0 and
  // +1 at t = +/- 1/2, repeating with period T = 1.
  #let triangle = t => 4 * calc.abs(t - calc.round(t)) - 1
  #cdiagram(
    alt: "Periodic triangle wave x of t of period one, equal to negative one at every integer t and to one at every half-integer t. Dashed gray guidelines mark the peak of height one at t equal to one half.",
    caption: [
      The periodic triangle wave whose Fourier series is computed below, drawn
      over three periods.
    ],
    title: $x(t)$,
    xlabel: $t$,
    ylim: (-1.5, 1.5),
    height: 2cm,
    width: 8cm,
    lq.plot(x, x.map(x => triangle(x)), mark: none),
    lq.place(0.5, -0.45, align: center, plabel[$1/2$]),
    lq.place(-0.08, 1, align: center, plabel[$1$]),
    lq.place(1.45, 0.4, align: center)[$dots.c$],
    lq.place(-1.45, 0.4, align: center)[$dots.c$],
    lq.plot((0.5, 0), (1, 1), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
    lq.plot((0.5, 0.5), (1, 0), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
  ) <fig-triangle>

  All we need to do is to calculate the Fourier series coefficients, with $T = 1$ and $omega_0 = 2 pi$:
  $
    a_k = 1/T integral_T x(t) e^(-j k 2 pi t) "d"t = integral_(-1/2)^0 (-4 t - 1) e^(-j k 2 pi t) "d"t + integral_0^(1/2) (4 t - 1) e^(-j k 2 pi t) "d"t
  $
  The wave is even, so only the cosine part of $e^(-j k 2 pi t)$ survives, and $integral_0^(1/2) cos(2 pi k t) "d"t = 0$ for $k != 0$. Hence $a_0 = 0$, and for $k != 0$,
  $
    a_k = 8 integral_0^(1/2) t cos(2 pi k t) "d"t = (2((-1)^k - 1))/(pi^2 k^2)
  $
  i.e., $a_k = -4/(pi^2 k^2)$ for odd $k$ and $a_k = 0$ for even $k != 0$.

]


#example("Visualization of the Gibbs Phenomenon")[
  #set math.equation(numbering: none)
  Let us look at the Fourier series of the periodic square wave in @fig-square-wave, defined over one period as
  $
    x(t) = cases(1\, &quad |t| < T_1, 0\, &quad T_1 < |t| < T/2)
  $

  #let x = lq.linspace(-6, 6, num: 1000)
  #let square = x => if (calc.rem(x + 9, 4)) < 2 { 2.5 } else { 0 }
  #cdiagram(
    alt: "Periodic square wave x of t equal to one for the absolute value of t less than T sub one, and zero between T sub one and T over two. Dashed gray lines mark the half-period points at plus and minus T over two.",
    caption: [
      The periodic square wave: one on $|t| < T_1$ and zero out to $|t| = T\/2$,
      repeating with period $T$.
    ],
    title: $x(t)$,
    xlabel: $t$,
    ylim: (-0.5, 3.5),
    height: 2.5cm,
    lq.plot(x, x.map(x => square(x)), mark: none),
    lq.place(-1.45, 2.5, align: center)[$1$],
    lq.place(1, -0.5, align: center)[$T_1$],
    lq.place(-1.2, -0.5, align: center)[$-T_1$],
    lq.place(2, -0.5, align: center)[$T/2$],
    lq.place(-2.3, -0.5, align: center)[$-T/2$],
    lq.place(5.8, 1.5, align: center)[$dots.c$],
    lq.place(-5.8, 1.5, align: center)[$dots.c$],
    lq.plot((2, 2), (0, 3), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
    lq.plot((-2, -2), (0, 3), mark: none, stroke: (
      dash: "dashed",
      paint: c-muted,
    )),
  ) <fig-square-wave>

  The Fourier series coefficients are
  $
    a_k = 1/T integral_(-T_1)^(T_1) e^(-j k omega_0 t) "d"t = -1/(j k omega_0 T) e^(-j k omega_0 t) lr(|, size: #200%)_(-T_1)^(T_1) = (sin (k omega_0 T_1)) / (k pi), quad k != 0
  $
  where $omega_0 = (2 pi) / T$. When $k = 0$, $a_0 = (2 T_1) / T$. Let us look at the approximation $hat(x)_N (t)$, plotted in @fig-gibbs:
  $
    hat(x)_N (t) = sum_(k = -N)^N a_k e^(j k omega_0 t)
  $

  #let T = 1
  #let T1 = 0.3 * T
  #let omega0 = 2 * calc.pi / T
  #let a = k => ct-square-ak(k, period: T, half-width: T1)

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


  #let gibbs-panel = N => {
    let (xx, sum) = square_series(N)
    lq.diagram(
      title: $hat(x)_N (t)$,
      xlabel: $t$,
      ylim: (-0.4, 1.4),
      xlim: (-0.6, 0.6),
      xaxis: (ticks: (-0.5, 0, 0.5), subticks: none),
      height: 2cm,
      width: 7cm,
      lq.plot(xx, sum, mark: none),
      lq.plot((T1, T1), (0, 1), mark: none, stroke: (
        dash: "dashed",
        paint: c-muted,
      )),
      lq.plot((-T1, -T1), (0, 1), mark: none, stroke: (
        dash: "dashed",
        paint: c-muted,
      )),
      lq.plot((-T1, T1), (1, 1), mark: none, stroke: (
        dash: "dashed",
        paint: c-muted,
      )),
      lq.place(0.5, 1.3, align: center, plabel[$N = #N$]),
      lq.place(T1, -0.3, align: center, plabel[$T_1$]),
      lq.place(-T1, -0.3, align: center, plabel[$-T_1$]),
      lq.place(T / 2, -0.3, align: center, plabel[$T/2$]),
      lq.place(-T / 2, -0.3, align: center, plabel[$-T/2$]),
    )
  }

  #altfig(
    alt: "Six partial-sum approximations of the square wave for N equal to three, eight, eighteen, twenty-eight, fifty-five, and eighty. As N grows, the approximation tightens against the rectangular pulse, but a persistent overshoot near the discontinuities at plus and minus T sub one remains, illustrating the Gibbs phenomenon.",
    caption: [
      Partial sums $hat(x)_N (t)$ of the square wave for $N = 3, 8, 18, 28, 55,$
      and $80$. The ripples crowd toward the two discontinuities as $N$ grows,
      but their peak overshoot does not shrink: this is the Gibbs phenomenon.
    ],
    align(center)[
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 2em,
        row-gutter: 0.5em,
        ..(3, 8, 18, 28, 55, 80).map(gibbs-panel),
      )],
  ) <fig-gibbs>
]

== Properties of Continuous-Time Fourier Series

In this section, we will use the notation
$
  x(t) #fspair a_k
$
to denote the pairing of a periodic signal with its Fourier series coefficients.


=== Linearity

If $x(t) #fspair a_k$ and $y(t) #fspair b_k$, both with period $T$, then
$
  z(t) = A x(t) + B y(t) #fspair c_k = A a_k + B b_k
$

=== Time Shifting

When a time shift is applied to a periodic signal $x(t)$, the period $T$ is preserved. The Fourier series coefficients $b_k$ of the resulting signal $y(t) = x(t - t_0)$ may be expressed as
$
  b_k = 1/T integral_T x(t - t_0) e^(-j k omega_0 t) "d"t
$
Letting $tau = t - t_0$ in the integral and noting that the new variable $tau$ will also range over an interval of duration $T$, we have
$
  1/T integral_T x(tau) e^(-j k omega_0 (tau + t_0)) "d"tau = e^(-j k omega_0 t_0) 1/T integral_T x(tau) e^(-j k omega_0 tau) "d"tau = e^(-j k omega_0 t_0) a_k
$
In shorthand notation,
$
  x(t - t_0) #fspair e^(-j k omega_0 t_0) a_k
$

=== Time Reversal

For $y(t) = x(-t)$,
$
  y(t) = x(-t) = sum_(k = -infinity)^(infinity) a_k e^(-j k 2 pi t / T) = sum_(m = -infinity)^(infinity) a_(-m) e^(j m 2 pi t / T), quad k = -m
$

That is, if $x(t) #fspair a_k$, we have $x(-t) #fspair a_(-k)$.

=== Time Scaling

In this case,
$
  x(alpha t) = sum_(k = -infinity)^infinity a_k e^(j k (alpha omega_0) t)
$
While the Fourier coefficients have not changed, the Fourier series representation has changed because of the change in the fundamental frequency.

=== Multiplication

$
  x(t) y(t) #fspair h_k = sum_(l = -infinity)^infinity a_l b_(k - l)
$
Observe that the sum on the right-hand side may be interpreted as the discrete-time convolution of the sequence representing the Fourier coefficients of $x(t)$ and the sequence representing the Fourier coefficients of $y(t)$. In a later section, we will learn more about the fact that multiplication in the time domain implies convolution in the frequency domain, and that convolution in the time domain implies multiplication in the frequency domain.

=== Conjugation

Taking the complex conjugate of a periodic signal $x(t)$ has the effect of complex conjugation and time-reversal on the corresponding Fourier series coefficients. That is, if
$
  x(t) #fspair a_k
$
then
$
  x^*(t) #fspair a_(-k)^*
$

=== Parseval's Relation

Parseval's relation for continuous-time periodic signals is
$
  1/T integral_T |x(t)|^2 "d"t = sum_(k = -infinity)^infinity |a_k|^2
$
It states that the average power of the signal over one period equals the sum of the powers $|a_k|^2$ carried by its individual harmonics.

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
      [Differentiation], [$"d" / ("d"t) x(t)$], [$j k omega_0 a_k$],

      // Integration
      [Integration],
      [$integral_(-infinity)^t x(tau) "d"tau$, finite and periodic only if $a_0 = 0$],
      [$a_k / (j k omega_0)$],

      // Symmetry
      [Conjugate Symm. for Real Signals], [$x(t)$ real], [$a_k = a_(-k)^*$],
      [Real & Even], [$x(t)$ real and even], [$a_k$ real and even],
      [Real & Odd], [$x(t)$ real and odd], [$a_k$ imaginary and odd],

      // Parseval's Theorem
      [Parseval's Theorem],
      table.cell(colspan: 2)[
        $1/T integral_T |x(t)|^2 "d"t = sum_(k=-infinity)^infinity |a_k|^2$
      ],
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
That is, when $k$ is changed by any integer ($r$) multiple of $N$, the identical sequence is generated. This differs from the continuous-time case, in which the signals $phi_k (t)$ are different from one another.

We now wish to express the periodic DT sequence in terms of linear combinations of the sequences $phi_k [n]$. Such a linear combination has the form
$
  x[n] = sum_k a_k phi_k [n] = sum_k a_k e^(j k omega_0 n) = sum_k a_k e^(j k (2 pi) / N n)
$
Since the sequences $phi_k [n]$ are distinct only over a range of $N$ successive values of $k$, the summation only needs to include terms over this range, beginning with any value of $k$. We denote this by expressing the limits of the summation as $k = chevron.l N chevron.r$, viz.,

$
  x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n) = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/ N n)
$

If we examine the sum of the $phi_k [n]$ over one period,
$
  sum_(n = chevron.l N chevron.r) phi_k [n] = sum_(n = chevron.l N chevron.r) e^(j k (2 pi)/N n) = cases(N\, quad k = 0\, plus.minus N\, plus.minus 2 N\, dots.c, 0\, quad "otherwise")
$

Similar to the continuous-time counterpart, we consider the Fourier series representation, i.e.,
$
  x[n] = sum_(k = chevron.l N chevron.r) a_k phi_k [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/N n)
$

Multiplying both sides with $e^(-j r (2 pi)/N n)$ and summing over $N$ terms, we obtain
$
  sum_(n = chevron.l N chevron.r) x[n] e^(-j r (2 pi)/N n) = sum_(n = chevron.l N chevron.r) sum_(k = chevron.l N chevron.r) a_k e^(j (k-r) (2 pi)/N n) = sum_(k = chevron.l N chevron.r) a_k sum_(n = chevron.l N chevron.r) e^(j (k - r) (2 pi) / N n)
$ <dtfs>

From the sum computed above, with $k - r$ in place of $k$,
$
  sum_(n = chevron.l N chevron.r) e^(j (k - r) (2 pi) / N n) = cases(N\, quad k = r, 0\, quad "otherwise")
$
since $k$ and $r$ both range over one period and can therefore differ by a multiple of $N$ only if they are equal.

The right side of @dtfs reduces to $N a_r$. And we have,
$
  a_r = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j r (2 pi)/N n)
$

#definition("Fourier Series for Discrete-Time Periodic Signals")[
  We can express the periodic discrete-time signal $x[n]$ as
  #eqalt(
    "x of n equals the sum over k in one period of N of a sub k times e to the j k omega-zero n.",
    $
      x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n) = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi)/ N n)
    $,
  )
  where
  #eqalt(
    "a sub k equals one over N times the sum over n in one period of N of x of n times e to the negative j k omega-zero n.",
    $
      a_k = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n)
    $,
  )
  The notation $n = chevron.l N chevron.r$ indicates that the variable $n$ varies over a range of $N$ successive integers, beginning at any value one likes. The same applies to $k$.
]

#example("Discrete-time Periodic Signal Fourier Series")[
  Consider the signal $x[n] = sin omega_0 n$, which is the discrete-time counterpart of the signal $x(t) = sin omega_0 t$. $x[n]$ is periodic only if $(2 pi) / omega_0$ is an integer, or a ratio of integers. For those cases, when $(2 pi) / omega_0$ is an integer $N$, $x[n]$ is periodic with fundamental period $N$. Expanding the signal as a sum of two complex exponentials, we get
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
    x[n] &= 1 + 1/(2j) (e^(j (2 pi)/N n) - e^(-j (2 pi)/N n)) + 3/2 (e^(j (2 pi)/N n) + e^(-j (2 pi)/N n)) + 1/2 (e^(j ((4 pi n)/N + pi/2)) + e^(-j ((4 pi n)/N + pi/2))) \
    &= 1 + (3/2 + 1/(2j)) e^(j (2 pi)/N n) + (3/2 - 1/(2j)) e^(-j (2 pi)/N n) + (1/2 e^(j pi / 2)) e^(j 2 (2 pi)/N n) + (1/2 e^(-j pi/2)) e^(-j 2 (2 pi)/N n)
  $
  Hence, the coefficients for this example are
  $
    a_0 = 1, quad a_1 = 3/2 + 1/(2j), quad a_(-1) = 3/2 - 1/(2j), quad a_2 = j/2, quad a_(-2) = -j/2
  $
]
Let us also consider the periodic discrete-time square wave of @fig-dt-square.

#let N1 = 2
#let N = 7
#let square_series = n => { if calc.abs(n) <= N1 { 1 } else { 0 } }
#let k = lq.linspace(-15, 15, num: 31)

#altfig(
  alt: "Stem plot of a periodic discrete-time square wave. Each period of length N consists of stems of height one for n from minus N sub one to N sub one, and zero elsewhere. Three consecutive periods are shown.",
  caption: [
    The discrete-time periodic square wave, one on $|n| <= N_1$ within each
    period of length $N$, drawn here with $N_1 = 2$ and $N = 7$.
  ],
  align(center)[
  #lq.diagram(
    title: $x[n]$,
    xlabel: $n$,
    height: 2.5cm,
    width: 10cm,
    ylim: (-0.2, 1.3),
    // One color for all three periods: they are the same signal.
    lq.stem(k, k.map(k => square_series(k)), color: c-accent),
    lq.stem(k, k.map(k => square_series(k - N)), color: c-accent),
    lq.stem(k, k.map(k => square_series(k + N)), color: c-accent),
    lq.place(N, -0.3, align: center, plabel[$N$]),
    lq.place(-N, -0.3, align: center, plabel[$-N$]),
    lq.place(N1, -0.3, align: center, plabel[$N_1$]),
    lq.place(-N1, -0.3, align: center, plabel[$-N_1$]),
    lq.place(-N1 * 2 - N, 0.5, align: center)[$dots.c$],
    lq.place(N1 * 2 + N, 0.5, align: center)[$dots.c$],
  )
],
) <fig-dt-square>

The Fourier series is then
$
  a_k = 1 / N sum_(n = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1 / N sum_(n = -N_1)^(N_1) e^(-j k (2 pi)/N n)
$
Letting $m = n + N_1$, we have
$
  a_k &= 1/N sum_(m = 0)^(2 N_1) e^(-j k (2 pi)/N (m - N_1)) = 1/N e^(j k (2 pi)/N N_1) sum_(m = 0)^(2 N_1) e^(-j k (2 pi) / N m) \
  &= 1/N e^(j k (2 pi)/N N_1) ( (1 - e^(-j k 2 pi (2 N_1 + 1)/N)) / (1 - e^(-j k (2 pi) / N))) = 1/N (sin [2 pi k (N_1 + 1/2) / N]) / (sin((pi k)/ N)), quad k != 0, plus.minus N, plus.minus 2 N, dots.c
$
and, where the quotient above is $0 \/ 0$,
$
  a_k = (2 N_1 + 1) / N, quad k = 0, plus.minus N, plus.minus 2 N, dots.c
$

Let us plot the sequence for different cases. In @fig-dt-ak, we hold the pulse width fixed at $2 N_1 + 1 = 5$ and increase the period $N$.
#let N1 = 2
#let k = lq.linspace(-25, 25, num: 51)

// One panel per period N, with the pulse width 2 N1 + 1 held fixed, so the
// four plots differ only in the quantity the text says they differ in.
#let ak-panel = N => lq.diagram(
  title: $a_k$,
  xlabel: $k$,
  height: 2cm,
  width: 7cm,
  ylim: (-0.2, 0.7),
  lq.stem(k, k.map(k => dt-square-ak(k, N: N, N1: N1))),
  lq.place(5, 0.5, align: center, plabel[$N = #N$]),
)

#altfig(
  alt: "Four stem plots of Fourier series coefficients a sub k for N equal to ten, twenty, thirty, and forty, all with two N sub one plus one fixed at five. As N increases, the discrete coefficients sample a sinc-shaped envelope more densely while the peak amplitude decreases.",
  caption: [
    Coefficients $a_k$ for $N = 10, 20, 30,$ and $40$, with the pulse width held
    at $2 N_1 + 1 = 5$. Lengthening the period samples the same envelope more
    densely and scales every coefficient down by $1\/N$.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      row-gutter: 0.5em,
      ..(10, 20, 30, 40).map(ak-panel),
    )],
) <fig-dt-ak>

In the continuous-time case, we observed the Gibbs phenomenon at the discontinuity, whereby, as the number of terms increased, the ripples in the partial sum became compressed toward the discontinuity, with the peak amplitude of the ripples remaining constant independently of the number of terms in the partial sum. Let us now consider the *analogous* sequence of partial sums for the discrete-time square wave, where, for convenience, we will assume that the period $N$ is odd:

$
  hat(x)_M [n] = sum_(k = -M)^(M) a_k e^(j k (2 pi)/N n)
$

@fig-dt-partial-sums plots the approximation $hat(x)_M [n]$ for $N = 9$ and $2 N_1 + 1 = 5$.

#let N = 9
#let N1 = 2
#let k = lq.linspace(-20, 20, num: 41)
// The partial sum is x-hat_M[n] = sum_(k = -M)^M a_k e^(j k 2 pi n / N). The
// coefficients are real and even, so pairing k with -k turns each pair into
// 2 a_k cos(2 pi k n / N) and leaves a_0 standing alone. Dropping either factor
// of two halves the whole curve, which is what made an earlier version of this
// figure disagree with the claim below that x-hat_M = x once M = (N - 1) / 2.
#let xhat = M => k.map(n => {
  let total = dt-square-ak(0, N: N, N1: N1)
  for m in range(1, M + 1) {
    total += 2 * dt-square-ak(m, N: N, N1: N1) * calc.cos(
      2 * calc.pi * m * n / N,
    )
  }
  total
})

#let xhat-panel = M => lq.diagram(
  title: $hat(x)_M [n]$,
  xlabel: $n$,
  height: 2.5cm,
  width: 7cm,
  ylim: (-0.2, 1.6),
  lq.stem(k, xhat(M)),
  lq.place(9, 1.45, align: center, plabel[$M = #M$]),
)

#altfig(
  alt: "Four stem plots of the discrete-time partial-sum approximation x hat sub M of n for M equal to one, two, three, and four, with N equal to nine. As M grows, the stems converge toward the square-wave samples; once M equals four (which is N minus one over two), the approximation matches the original square wave exactly.",
  caption: [
    Partial sums $hat(x)_M [n]$ for $M = 1, 2, 3, 4$ with $N = 9$. Unlike the
    continuous-time case there is no convergence issue: at $M = (N-1)\/2 = 4$ the
    sum has $N$ terms and reproduces $x[n]$ exactly.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      row-gutter: 0.5em,
      ..(1, 2, 3, 4).map(xhat-panel),
    )],
) <fig-dt-partial-sums>

We see that if $N$ is odd and we take $M = (N - 1)/2$, the sum includes exactly $N$ terms; consequently, from the synthesis equation, we have
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
      [$sum_(r = -infinity)^n x[r]$, finite and periodic only if $a_0 = 0$],
      [$1/(1 - e^(-j k (2 pi)/N)) a_k$],

      // Symmetry
      [Conjugate Symm. for Real Signals], [$x[n]$ real], [$a_k = a^*_(-k)$],
      [Real & Even], [$x[n]$ real and even], [$a_k$ real and even],
      [Real & Odd], [$x[n]$ real and odd], [$a_k$ imaginary and odd],

      // Even-Odd Decomposition of Real Signals
      [Even-Odd Decomposition],
      [$x_e [n] = "Even"{ x[n] }$, $x[n]$ real],
      [$Re{a_k}$],

      [Even-Odd Decomposition],
      [$x_o [n] = "Odd"{ x[n] }$, $x[n]$ real],
      [$j Im{a_k}$],

      // Parseval's Theorem
      [Parseval's Theorem],
      table.cell(colspan: 2)[
        $1/N sum_(n = chevron.l N chevron.r) |x[n]|^2 = sum_(k = chevron.l N chevron.r) |a_k|^2$
      ],
    )]
]

#example("Discrete-Time Fourier Series Properties")[

  Suppose we are given the following facts about a sequence $x[n]$

  - $x[n]$ is periodic with period $N = 6$.
  - $sum_(n = 0)^5 x[n] = 2, sum_(n = 2)^7 (-1)^n x[n] = 1$.
  - $x[n]$ has the minimum power per period among the set of signals satisfying the preceding two conditions.

  Let us determine the sequence $x[n]$. We denote the Fourier series coefficients of $x[n]$ by $a_k$. Per definition,
  $
    a_k = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k omega_0 n) = 1/N sum_(n = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n)
  $
  The sums in the second condition each run over one full period, so each equals $N$ times a Fourier series coefficient. The first gives $a_0 = 1/6 sum_(n=0)^5 x[n] = 1/3$ directly. For the second, note that $(-1)^n = e^(-j pi n)$ and that $pi = 3 dot (2 pi) \/ 6$, so
  $
    sum_(n = 2)^7 (-1)^n x[n] = sum_(n = chevron.l 6 chevron.r) x[n] e^(-j 3 (2 pi)/6 n) = N dot a_3 = 1
  $
  Hence, $a_3 = 1/6$. From Parseval's relation, the average power per period is
  $
    P = 1/N sum_(n = chevron.l N chevron.r) |x[n]|^2 = sum_(k = chevron.l N chevron.r) |a_k|^2
  $
  The two facts fix $a_0$ and $a_3$ and say nothing about the remaining four coefficients, each of which only adds to the sum on the right. The power is therefore smallest when $a_1 = a_2 = a_4 = a_5 = 0$, and $x[n] = a_0 + a_3 e^(j pi n) = 1/3 + (1/6) (-1)^n$.
]

== Table of Fourier Series Pairs

The table below collects the basic Fourier series pairs derived in this chapter. In continuous time, $x(t)$ has period $T$ and $omega_0 = 2 pi \/ T$. In discrete time, $x[n]$ has period $N$ and $omega_0 = 2 pi \/ N$, and the coefficients $a_k$ are themselves periodic with period $N$, so a value given for $k = M$ also holds at $k = M plus.minus N, M plus.minus 2 N, dots.c$.

#note("Basic Fourier Series Pairs")[
  #align(center)[
    #table(
      columns: 2,
      align: center + horizon,
      stroke: 0.5pt,
      table.header([*Periodic Signal*], [*Fourier Series Coefficients*]),

      table.cell(colspan: 2)[*Continuous time*: period $T$, $omega_0 = 2 pi \/ T$],

      [$sum_(k = -infinity)^infinity a_k e^(j k omega_0 t)$], [$a_k$],

      [$e^(j M omega_0 t)$], [$a_M = 1$, $a_k = 0$ otherwise],

      [$cos(M omega_0 t)$], [$a_(plus.minus M) = 1/2$, $a_k = 0$ otherwise],

      [$sin(M omega_0 t)$], [$a_M = 1/(2 j)$, $a_(-M) = -1/(2 j)$, $a_k = 0$ otherwise],

      [$1$], [$a_0 = 1$, $a_k = 0$ otherwise],

      [Square wave: $cases(1 & |t| < T_1, 0 & T_1 < |t| <= T\/2)$],
      [$a_k = (sin(k omega_0 T_1))/(k pi)$ for $k != 0$, $a_0 = (2 T_1)/T$],

      [$sum_(n = -infinity)^infinity delta(t - n T)$], [$a_k = 1/T$ for all $k$],

      table.cell(colspan: 2)[*Discrete time*: period $N$, $omega_0 = 2 pi \/ N$],

      [$sum_(k = chevron.l N chevron.r) a_k e^(j k omega_0 n)$], [$a_k$],

      [$e^(j M omega_0 n)$], [$a_M = 1$, $a_k = 0$ otherwise in one period],

      [$cos(M omega_0 n)$], [$a_(plus.minus M) = 1/2$, $a_k = 0$ otherwise in one period],

      [$sin(M omega_0 n)$],
      [$a_M = 1/(2 j)$, $a_(-M) = -1/(2 j)$, $a_k = 0$ otherwise in one period],

      [$1$], [$a_0 = 1$, $a_k = 0$ otherwise in one period],

      [Square wave: $cases(1 & |n| <= N_1, 0 & N_1 < |n| <= N\/2)$],
      [$a_k = 1/N (sin[2 pi k (N_1 + 1\/2) \/ N])/(sin(pi k \/ N))$ for $k != 0$, $a_0 = (2 N_1 + 1)/N$],

      [$sum_(r = -infinity)^infinity delta[n - r N]$], [$a_k = 1/N$ for all $k$],

      [$(-1)^n$, $N$ even], [$a_(N\/2) = 1$, $a_k = 0$ otherwise in one period],
    )
  ]
]


== Fourier Series and LTI Systems

In the previous sections, we have seen that the Fourier series representation can be used to construct any periodic signal in discrete-time and essentially all periodic continuous-time signals of practical importance. In addition, we saw that the response of an LTI system to a linear combination of complex exponentials takes a particularly simple form. Specifically, in continuous time, if
$
  x(t) = e^(s t)
$
is the input of a continuous-time LTI system, then the output is given by
$
  y(t) &= integral_RR h(tau) x (t - tau) "d"tau = integral_RR h(tau) e^(s (t - tau)) "d"tau = integral_RR h(tau) e^(s t) e^(-s tau) "d"tau \
  &= e^(s t) integral_RR h(tau) e^(-s tau) "d"tau equiv e^(s t) H(s)
$
where
$
  H(s) = integral_RR h(tau) e^(-s tau) "d"tau
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
is the $z$-transform. When $s$ or $z$ is a general complex number, $H(s)$ and $H(z)$ are referred to as the *system functions* of the corresponding system. The system function restricted to $s = j omega$, i.e., $H(j omega)$ viewed as a function of $omega$, is referred to as the _frequency response_ of the system.

#definition("Frequency Response of an LTI System")[
  The _frequency response_ of a _continuous-time_ system is given by
  #eqalt(
    "H of j omega equals the integral over the real line of h of t times e to the negative j omega t, d t.",
    $
      H(j omega) = integral_RR h(t) e^(-j omega t) "d"t
    $,
  )
  where $h(t)$ is the impulse response of the said LTI system. In the _discrete-time_ case, the frequency response is written $H(e^(j omega))$, since the system function $H(z)$ is evaluated on the unit circle $z = e^(j omega)$ rather than on the imaginary axis:
  #eqalt(
    "H of e to the j omega equals the sum over all n of h of n times e to the negative j omega n.",
    $
      H(e^(j omega)) = sum_n h[n] e^(-j omega n)
    $,
  )
]

Now suppose that the input is
$
  x(t) = sum_k a_k e^(s_k t) = sum_k a_k e^(j k omega_0 t)
$
with $s_k = j k omega_0$. The output of the LTI system is then
$
  y(t) &= integral_RR h(tau) x(t - tau) "d"tau = integral_RR h(tau) sum_k a_k e^(s_k (t - tau)) "d"tau = sum_k a_k [integral_RR h(tau) e^(- s_k tau) "d"tau] e^(s_k t) \ &= sum_k a_k H(s_k) e^(s_k t) = sum_k a_k H(j k omega_0) e^(j k omega_0 t)
$
Similarly, if the input to a discrete-time LTI system is now
$
  x[n] = sum_k a_k z_k^n = sum_k a_k e^(j k omega_0 n)
$
with $z_k = e^(j k omega_0)$, the output is
$
  y[n] & = sum_k h[k] x[n - k] = sum_k a_k H(z_k) z_k^n = sum_k a_k H(e^(j k omega_0)) e^(j k omega_0 n)
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
    H(j omega) = integral_RR h(tau) e^(-j omega tau) "d"tau = integral_0^infinity e^(-tau ) e^(-j omega tau) "d"tau = -1/(1+j omega) e^(-tau - j omega tau) lr(|, size: #200%)_(0)^(infinity) = 1 / (1 + j omega)
  $
  Therefore, according to
  $
    y(t) = sum_k a_k H(j k omega_0) e^(j k omega_0 t)
  $
  and with the fact that $omega_0 = 2 pi$, we have
  $
    y(t) = sum_(k=-3)^(3) a_k H(j k 2 pi) e^(j k 2 pi t)
  $

  Further, since both the input and the impulse response are real-valued signals, the output $y(t)$ must also be real-valued. One can verify this by checking that $a_k^* H^*(j k 2 pi) = a_(-k) H(-j k 2 pi)$, so the terms at $k$ and $-k$ are complex conjugates and their sum is real.

  Hence the Fourier series coefficients of $y(t)$ are $b_k = a_k H(j k 2 pi) = a_k/(1 + j 2 pi k)$, e.g., $b_0 = 1$, $b_1 = 1/(4(1 + j 2 pi))$, $b_(-1) = 1/(4(1 - j 2 pi))$.
]

== Examples of Filters Described by Differential and Difference Equations

// In many applications, frequency-selective filtering is accomplished through the use of LTI systems described by linear constant-coefficient differential (or difference) equations.

#example("First-Order Difference Equation and Moving Average")[

  Suppose an LTI system is described by the first-order difference equation
  $
    y[n] - a y[n-1] = x[n]
  $
  From the eigenfunction property of the complex exponentials, we know that if $x[n] = e^(j omega n)$, then $y[n] = H(e^(j omega)) e^(j omega n)$, where $H(e^(j omega))$ is the frequency response of the system. We obtain
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
  assuming $|a| < 1$ so that the frequency response exists. The step response is then $s[n] = u[n] star h[n]$
  $
    s[n] = (1 - a^(n + 1)) / (1 - a) u[n]
  $

  Consider next a _moving-average filter_, described by
  $
    y[n] = 1/3 (x[n-1] + x[n] + x[n+1])
  $
  so that each output $y[n]$ is the average of three consecutive input values. The impulse response is
  $
    h[n] = 1/3 (delta [n+1] + delta [n] + delta [n-1])
  $
  The corresponding frequency response is thus
  $
    H(e^(j omega)) = sum_k h[k] e^(-j omega k) = 1/3 [e^(j omega) + 1 + e^(-j omega)]
  $
]

#example("RC Circuit")[
  An RC circuit whose capacitor voltage is initially zero constitutes an LTI system describable by a linear constant-coefficient differential equation (LCCDE). Consider the series RC circuit of @fig-rc, driven by the source voltage $v_S (t)$, with $v_R (t)$ across the resistor and $v_C (t)$ across the capacitor.

  #altfig(
    alt: "Series RC circuit schematic. A voltage source v sub S of t drives a resistor R in series with a capacitor C; the voltage across the resistor is v sub R of t and the voltage across the capacitor is v sub C of t.",
    caption: [
      The series RC circuit. Taking $v_C (t)$ as the output gives a lowpass
      filter; taking $v_R (t)$ gives a highpass one.
    ],
    align(center)[
      #zap.circuit({
        import zap: *

        vsource("V", (0, 0), rotate: 90deg)
        resistor("R", (2, 1), variant: "ieee", label: $R$)
        capacitor("C", (4, 0), variant: "ieee", rotate: 270deg, label: $C$)

        wire((0, 0), (0, 1), "R.in")
        wire("R.out", (4, 1), "C.in")
        wire("C.out", (4, -1), (0, -1), "V.in")

        draw.content((-1.5, 0), $v_S (t)$, anchor: "west")
        draw.content((2.6, 0), $v_C (t)$, anchor: "west")
        draw.content((2, 0.7), $v_R (t)$, anchor: "north")
      })],
  ) <fig-rc>

  If we take the capacitor's voltage as the output, we have
  $
    R C ("d"v_C (t)) / ("d"t) + v_C (t) = v_S (t)
  $

  Assuming initial rest, the system described by the above LCCDE is LTI. In order to determine its frequency response $H(j omega)$, we note that, by definition, with input voltage $v_S (t) = e^(j omega t)$, we must have the output voltage $v_C (t) = H(j omega) e^(j omega t)$. If we substitute these expressions into the above LCCDE, we obtain
  $
    R C "d"/("d"t) [H(j omega) e^(j omega t)] + H(j omega) e^(j omega t) = e^(j omega t)
  $
  It directly follows that
  $
    H(j omega) = 1 / (1 + R C j omega)
  $
  The magnitude $|H (j omega)|$ decreases as $|omega|$ increases. Thus, this simple RC filter with $v_C (t)$ as the output is a lowpass filter.

  If we choose the voltage across the resistor $v_R (t)$ as the output, the LCCDE is then
  $
    R C ("d"v_R (t))/("d"t) + v_R (t) = R C ("d"v_S (t))/("d"t)
  $

  Substituting $v_S (t) = e^(j omega t)$ and $v_R (t) = G(j omega) e^(j omega t)$ into this LCCDE gives the frequency response
  $
    G (j omega) = (j omega R C) / (1 + j omega R C)
  $
  We can see that the magnitude $|G(j omega)|$ increases as $|omega|$ increases, hence a highpass filter. The two magnitude responses are plotted in @fig-rc-responses.

  #let x = lq.linspace(-5, 5, num: 99)
  #altfig(
    alt: "Two magnitude responses. Left: H of j omega, a lowpass shape that peaks at one at omega equal zero and rolls off symmetrically toward zero as the absolute value of omega grows. Right: G of j omega, a highpass shape that is zero at omega equal zero and rises symmetrically toward one.",
    caption: [
      Magnitude responses of the same RC circuit, with $R C = 1$: lowpass when
      the capacitor voltage is the output (left), highpass when the resistor
      voltage is (right).
    ],
    align(center)[
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 2em,
        cdiagram(
          title: $|H(j omega)|$,
          xlabel: $omega$,
          width: 5cm,
          height: 3cm,
          ylim: (-0.2, 1.2),
          lq.plot(x, x.map(x => 1 / (calc.sqrt(1 + x * x))), mark: none),
        ),
        cdiagram(
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
        ),
      )],
  ) <fig-rc-responses>
]


