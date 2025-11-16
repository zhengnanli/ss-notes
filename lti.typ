#import "lib.typ": *

= Linear Time-Invariant Systems
#show: lq.theme.schoolbook
#show: schoolbook-style

Linear Time-Invariant (LTI) systems constitute the cornerstone of signal processing and system analysis. Two fundamental properties -- linearity and time invariance -- render these systems both practically relevant and mathematically tractable. Many physical processes can be modeled as LTI systems, and they possess an important property: complete characterization through their response to a single elementary signal.

The key insight is that LTI systems satisfy the superposition property, enabling us to decompose complex inputs into simpler components and analyze the system's response to each component separately. This chapter develops the mathematical framework for analyzing LTI systems through convolution operations.

== Discrete-Time Signal Representation

In previous sections, we examined the special property of _sampling_ discrete-time signals using unit impulse functions:
$
  // x[n_0] delta[n-n_0] = cases(x[n_0] &\, quad n = n_0, 0 &\, quad n eq.not n_0)
  x[n] delta[n-n_0] = x[n_0] delta[n - n_0]
$
Therefore, we can express $x[n]$ as:
$
  x[n] = dots.c + x[-2] delta[n + 2] + x[-1] delta[n + 1] + x[0] delta[n] + x[1] delta[n - 1] + x[2] delta[n - 2] + dots.c
$
or compactly:
$
  x[n] = sum_(k = -infinity)^(infinity) x[k] delta[n - k]
$ <sifting>
This equation is called the _sifting property_ of the discrete-time unit impulse.

=== Convolution Sum

Using @sifting, we can express the input signal $x[n]$ as a linear combination of shifted unit impulses. Let $h_k [n]$ be the response of the linear system to the shifted impulse $delta[n-k]$. Then, from the superposition property for a linear system, the response $y[n]$ to the input $x[n]$ is a weighted linear combination of these basic responses:

$
  y[n] = sum_(k = -infinity)^(infinity) x[k] h_k [n]
$

If the system is further _time invariant_, then these responses to time-shifted unit impulses are all time-shifted versions of each other. Specifically, since $delta[n-k]$ is a time-shifted version of $delta[n]$, the response $h_k [n]$ is a time-shifted version of $h_0 [n]$:
$ h_k [n] = h_0[n-k] $
For notational convenience, we drop the subscript on $h_0 [n]$ and define the _unit impulse response_ as:
$ h[n] = h_0[n] $
That is, $h[n]$ is the output of the LTI system when $delta[n]$ is the input. Then for an LTI system, we define the output $y[n]$ using the _convolution sum_:

#note("Convolution Sum")[
  The output $y[n]$ of a discrete-time LTI system is given by:
  $ y[n] = sum_(k=-infinity)^(infinity) x[k] h[n-k] = x[n] star h[n] $
  This is the convolution sum, often denoted by the $star$ symbol.
]

*Physical interpretation*: The output at time $n$ represents the superposition of all "echoes" of the impulse response. Each echo $h[n-k]$ is scaled by the corresponding input value $x[k]$ and appropriately time-shifted.

Another way of explaining the convolution sum is through the impulse response of LTI systems. The impulse response of LTI systems is defined as the output of the system when the input is an impulse, i.e.,

#align(center)[
  #diagram(
    debug: false,
    node-stroke: 0.1em,
    mark-scale: 100%,
    edge(
      (-1, 0),
      "r",
      "-|>-",
      $delta[n]$,
      label-pos: -0.5,
      label-side: center,
    ),
    edge(
      (0, 0),
      "r",
      "-|>-",
      $h[n]$,
      label-pos: 1.6,
      label-side: center,
    ),
    node((0, 0), $T{dot.c}$, width: 4em),
  )]

We now would like to examine the system response to an arbitrary input $x[n]$. Per @sifting, the output of the system can be written as
$
  y[n] = T{ sum_(k=-infinity)^(infinity) x[k] delta [n-k]}
$

If the system is linear, we can change the order of operation (per the scaling property) as
$
  y[n] = T{ sum_(k=-infinity)^(infinity) x[k] delta [n-k]} = sum_(k = -infinity)^(infinity) x[k] T{ delta[n - k] }
$

Further more, if the system is also time-invariant, i.e., $delta[n] arrow.r h[n]$, and $delta[n-k] arrow.r h[n-k]$, we have
$
  y[n] = sum_(k = -infinity)^(infinity) x[k] h[n - k]
$

Have you encountered the convolution sum before? Perhaps when multiplying two polynomials?

#example("Multiplying Two Polynomials")[
  Suppose we wish to multiply $a(x) = 3 x^2 + 2 x + 5$ with $b(x) = 2 x^2 + 8 x + 1$ using the convolution sum.

  We begin by collecting all coefficients into two vectors $bold("a") = mat(3, 2, 5, delim: "[")$ and $bold("b") = mat(2, 8, 1, delim: "[")$. Then, we reverse $accent(bold("b"), ~)$ as $mat(1, 8, 2, delim: "[")$. We slide $accent(bold("b"), ~)$ to the left and multiply $3$ by $2$. The next step involves sliding $accent(bold("b"), ~)$ one position to the right, yielding $3 times 8 + 2 times 2 = 28$. The process continues until $accent(bold("b"), ~)$ slides out of the window. In fact, the resulting vector from convolving two vectors is $mat(6, 28, 29, 42, 5, delim: "[")$, which corresponds to the polynomial $a(x) times b(x) = 6x^4+28x^3+29x^2+42x+5$.
]

=== Graphical Convolution Method

To compute $y[n]$ for a specific value of $n$, we employ the "flip, slide, and sum" approach:
1. Plot $x[k]$ as a function of $k$
2. Plot $h[n-k]$ as a function of $k$ (time-reverse $h[k]$ and shift by $n$)
3. Multiply the two sequences point-by-point: $x[k] h[n-k]$
4. Sum all products: $y[n] = sum_(k=-infinity)^(infinity) x[k] h[n-k]$

#example("Convolution Sum")[
  Suppose we would like to compute the convolution between $x[n] = {1, 4, 2, 5, 7}$ and $h[n] = {3, 2, 5}$. Note that the time indices are not specified as of now. To calculate the convolution, we do something very similar to multiplicating two numbers, but we do not carry the number:

  #table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    inset: 3pt,
    align: center,
    stroke: none,
    "", "", "", "1", "4", "2", "5", "7",
    $times$, "", "", "", "", "3", "2", "5",
    table.hline(start: 0),
    "", "", "", "5", "20", "10", "25", "35",
    "", "", "2", "8", "4", "10", "14", "",
    "", "3", "12", "6", "15", "21", "", "",
    table.hline(start: 0),
    "=", "3", "14", "19", "39", "41", "39", "35",
  )
  The convolution sum is then $y[n] = {3, 14, 19, 39, 41, 39, 35}$. The only thing left is the time indices.
]


#attention("Convolution Sum")[
  #set math.equation(numbering: none)
  Consider an LTI system with impulse response $h[n]$ and input $x[n]$, as illustrated in the following figure. For this case, since only $x[0]$ and $x[1]$ are nonzero, the convolution sum simplifies to:
  $
    y[n] = x[0] h[n - 0] + x[1] h[n - 1] = 0.5 h[n] + 2 h [n - 1]
  $

  #let t = (-2, -1, 0, 1, 2, 3, 4)
  #let h = (0, 0, 1, 1, 1, 0, 0)
  #let h1 = (0, 0, 0, 1, 1, 1, 0)
  #let x = (0, 0, 0.5, 2, 0, 0, 0)
  #let y = (0, 0, 0.5, 2.5, 2.5, 2, 0)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #lq.diagram(
          title: $h[n]$,
          xlabel: $n$,
          height: 2.5cm,
          width: 4cm,
          xlim: (-3, 6),
          ylim: (-0.2, 3),
          lq.stem(t, h),
        )],
      [
        #lq.diagram(
          title: $x[n]$,
          xlabel: $n$,
          height: 2.5cm,
          width: 4cm,
          xlim: (-3, 6),
          ylim: (-0.2, 3),
          lq.stem(t, x),
        )],
    )]

  #align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 2em,
      [
        #lq.diagram(
          title: $0.5 h[n]$,
          xlabel: $n$,
          height: 2.5cm,
          width: 4cm,
          xlim: (-3, 6),
          ylim: (-0.2, 3),
          lq.stem(t, h.map(h => 0.5 * h)),
        )],
      [
        #lq.diagram(
          title: $2h[n-1]$,
          xlabel: $n$,
          height: 2.5cm,
          width: 4cm,
          xlim: (-3, 6),
          ylim: (-0.2, 3),
          lq.stem(t, h1.map(h1 => 2 * h1)),
        )],
      [
        #lq.diagram(
          title: $y[n]$,
          xlabel: $n$,
          height: 2.5cm,
          width: 4cm,
          xlim: (-3, 6),
          ylim: (-0.2, 3),
          lq.stem(t, y),
        )],
    )]
]


#example("Discrete-Time Convolution")[
  #set math.equation(numbering: none)
  Consider $x[n] = u[n] - u[n-5]$ and $h[n] = alpha^n (u[n] - u[n-7])$, where $alpha > 1$. Calculate the convolution of these two signals. Hint: $sum_(k=0)^n alpha^k = (1 - alpha^(n+1))/(1 - alpha)$ for all $n >= 0$.

  #let n = range(-5, 16)
  #let xlims = (-5.3, 16.3)
  #let ylims = (-0.2, 10)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [
        #lq.diagram(
          title: $x[n]$,
          xlabel: $n$,
          xlim: xlims,
          ylim: ylims,
          height: 2cm,
          lq.stem(n, n.map(n => if n < 0 or n > 4 { 0 } else { 1 })),
        )],
      [
        #lq.diagram(
          title: $h[n]$,
          xlabel: $n$,
          xlim: xlims,
          ylim: ylims,
          height: 2cm,
          lq.stem(n, n.map(n => if n < 0 or n > 6 { 0 } else {
            calc.pow(1.35, n)
          })),
        )],
    )]

  - *Interval 1*: $n < 0$ or $n > 10$. There is no overlap between the nonzero portions of $x[k]$ and $h[n-k]$; therefore, $y[n] = 0$.

  - *Interval 2*: $0 <= n <= 4$:
    $
      y[n] = sum_(k=0)^n x[k] h[n-k] = sum_(k=0)^n alpha^(n-k) = alpha^n sum_(k=0)^n alpha^(-k) = alpha^n (1 - alpha^(-n-1)) / (1 - alpha^(-1)) = (1 - alpha^(n+1)) / (1 - alpha)
    $

  - *Interval 3*: $4 < n <= 6$. In this case, all of $x[n]$ overlaps with $h[n-k]$:
    $
      y[n] = sum_(k=0)^4 alpha^(n-k) = alpha^n sum_(k=0)^4 alpha^(-k) = alpha^n (1 - alpha^(-5)) / (1 - alpha^(-1)) = (alpha^(n-4) - alpha^(n+1)) / (1 - alpha)
    $

  - *Interval 4*: $6 < n <= 10$. Here, $n - 6 < 4$:
    $
      y[n] = sum_(k = n-6)^4 alpha^(n - k) = alpha^n sum_(k = n-6)^4 alpha^(-k) = (alpha^(n-4) - alpha^7)/(1 - alpha)
    $

  Summarizing, we obtain:
  $
    y[n] = cases(
      0 & quad n < 0 "or" n > 10,
      (1 - alpha^(n+1))/(1-alpha) & quad 0 <= n <= 4,
      (alpha^(n-4) - alpha^(n+1)) / (1 - alpha) & quad 4 < n <= 6,
      (alpha^(n-4)-alpha^7)/(1 - alpha) & quad 6 < n <= 10
    )
  $
]

== Continuous-Time LTI Systems: The Convolution Integral

=== Signal Representation Using Impulses

#let x = lq.linspace(-2, 5, num: 100)
#let xd = lq.arange1(-2, 5, step: 0.3)
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
    title: $x(t)$,
    xlabel: $t$,
    ylim: (-2, 2),
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
    lq.place(0.4, -0.2, align: left)[$Delta$],
  )]

As shown above, we can approximate $x(t)$ as:
$
  x(t) = lim_(Delta arrow 0) sum_(k = -infinity)^(infinity) x(k Delta) delta_Delta (t - k Delta) Delta
$
where $Delta$ is the rectangular width, and $x(k Delta) delta_Delta (t - k Delta)$ is the rectangular height. Through a limiting process from rectangular pulse approximations, any continuous-time signal can be expressed using the continuous-time sifting property, representing $x(t)$ as a weighted integral of shifted unit impulses:

$ x(t) = integral_(-infinity)^(infinity) x(tau) delta(t - tau) "d"tau $

=== Convolution Integral Derivation

Analogous to the discrete-time system, for a continuous-time LTI system with impulse response $h(t)$:

#attention("Convolution Integral")[
  The output $y(t)$ of a continuous-time LTI system is given by:
  $
    y(t) = integral_(-infinity)^(infinity) x(tau) h(t - tau) "d"tau = x(t) star h(t)
  $

  This is the *convolution integral* or *superposition integral*.
]

*Key principle*: An LTI system is completely characterized by its impulse response $h(t)$ or $h[n]$. Knowledge of the impulse response enables computation of the system's response to any input.

#example("Continuous-Time Convolution")[
  #set math.equation(numbering: none)

  Consider $x(t) = e^(-a t) u(t)$ and $h(t) = u(t)$, where $a > 0$.

  For $t > 0$:
  $
    y(t) = integral_(-infinity)^infinity x(tau) h(t - tau) "d"tau = integral_0^t e^(-a tau) "d"tau = [-1/a e^(-a tau)]_0^t = (1-e^(-a t))/a
  $

  For $t < 0$: $y(t) = 0$. Therefore: $ y(t) = (1-e^(-a t))/a u(t) $
]

== Properties of Linear Time-Invariant Systems

=== Fundamental Properties of Convolution

1. Commutativity: Convolution is commutative:
  - Discrete-time: $x[n] star h[n] = h[n] star x[n]$
  - Continuous-time: $x(t) star h(t) = h(t) star x(t)$

2. Distributivity: Convolution distributes over addition:
  - Discrete-time: $x[n] star (h_1[n] + h_2[n]) = x[n] star h_1[n] + x[n] star h_2[n]$
  - Continuous-time: $x(t) star (h_1(t) + h_2(t)) = x(t) star h_1(t) + x(t) star h_2(t)$

  System interpretation: Parallel LTI systems can be combined into a single system with impulse response equal to the sum of individual impulse responses.

3. Associativity: Convolution is associative:
  - Discrete-time: $x[n] star (h_1[n] star h_2[n]) = (x[n] star h_1[n]) star h_2[n]$
  - Continuous-time: $x(t) star (h_1(t) star h_2(t)) = (x(t) star h_1(t)) star h_2(t)$

  System interpretation: The order of cascaded LTI systems does not affect the overall response.

=== System Characteristics

1. Memory
  - Memoryless: $h[n] = K delta[n]$ (discrete) or $h(t) = K delta(t)$ (continuous)
  - With memory: $h[n] != 0$ for $n != 0$ or $h(t) != 0$ for $t != 0$

2. Invertibility
  An LTI system is invertible if there exists an inverse system such that:
  - Discrete-time: $h[n] star h_i [n] = delta[n]$
  - Continuous-time: $h(t) star h_i (t) = delta(t)$

3. Causality
  An LTI system is causal if and only if:
  - Discrete-time: $h[n] = 0$ for $n < 0$
  - Continuous-time: $h(t) = 0$ for $t < 0$

  Physical meaning: The impulse response is zero before the impulse occurs.

4. Stability
  An LTI system is stable if and only if its impulse response is absolutely summable/integrable:
  - Discrete-time: $sum_(k=-infinity)^(infinity) |h[k]| < infinity$
  - Continuous-time: $integral_(-infinity)^(infinity) |h(tau)| "d"tau < infinity$

  This is both necessary and sufficient for bounded-input-bounded-output (BIBO) stability.

=== Unit Step Response

The unit step response $s[n]$ or $s(t)$ is related to the impulse response by:
- *Discrete-time*: $s[n] = sum_(k=-infinity)^n h[k]$ and $h[n] = s[n] - s[n-1]$
- *Continuous-time*: $s(t) = integral_(-infinity)^t h(tau) "d"tau$ and $h(t) = ("d"s(t))/("d"t)$

#example("Stability of Infinite Impulse Response (IIR) Systems")[
  We are interested in the linearity, causality and stability of the following system:
  $
    y[n] = x[n] - x[n-1] - y[n-1]
  $

  This system is generally referred to as the infinite impulse response (IIR) system. It is a typical type of digital filters that is widely used in signal processing. The general form of an IIR filter is
  $
    y[n] = sum_(i = 0)^P b_i x[n - i] + sum_(j = 1)^Q a_j y[n - j]
  $

  - It is causal.
  - Regarding BIBO stability,
  $
    |y[n]| = |sum_k x[k] h[n-k]| <= sum_k |x[k]| |h[n-k]| <= sum_k |h[n-k]| ||x||_infinity = ||x||_infinity sum_k |h[k]| = B_x sum_k |h[k]|
  $
  To examine the (BIBO) stability, we give the system an impulse, i.e., $x[n] = [1, 0, 0, dots]$. We then have
  $
    y[0] & = x[0] - 0 - 0 = 1 \
    y[1] & = x[1] - x[0] - y[0] = 0 - 1 - 1 = -2 \
    y[2] & = x[2] - x[1] - y[1] = 0 - 0 + 2 = 2 \
    y[3] & = x[3] - x[2] - y[2] = 0 - 0 - 2 = -2 \
    y[4] & = dots.c
  $
  The impulse response is $h[n] = delta[n] + 2 (-1)^n u[n-1]$. The sum $sum_k |h[k]| = 1 + |2 sum_(n = 1)^infinity (-1)^n|$ is not bounded (diverge). // Later in this class, we will learn more about _z-transform_, and from there, the (BIBO) stability of such a system can be determined by the positions of their poles. _If all poles of the z-transform of the system are strictly within the unit circle, the said system is stable._
  - To examine the linearity and time-invariance, we can use mathematical induction. For an signal $x[n]$ that starts at time zero,
  $
    y[0] & = x[0] \
    y[1] & = x[1] - x[0] - y[0] = x[1] - x[0] - x[0] = x[1] - 2 x[0] \
    y[2] & = x[2] - x[1] - y[1] = x[2] - 2x[1] + 2x[0] \
    y[3] & = x[3] - x[2] - y[2] = x[3] - 2x[2] + 2x[1] - 2x[0] \
    y[4] & = ...
  $
  If now the system is now replaced by $x_1[n] eq.delta x[n - m]$, which is $x[n]$ delayed by $m$ samples, then the output $y_1[n] = 0$, for all $n < m$, followed by
  $
        y_1[m] & = x[0] \
    y_1[m + 1] & = x[1] - x[0] - y_1[m] = x[1] - 2x[0] \
    y_1[m + 2] & = x[2] - x[1] - y_1[m+1] = x[2] - 2x[1] + 2x[0] \
    y_1[m + 3] & = ...
  $
  or in other words, $y_1[n] = y[n - m], forall n >= m >= 0$. This establishes that every output of the system can be expressecd as a time-invariant linear combination of present and past samples. Therefore, it is a linear and time-invariant (LTI) system.
]



== Causal LTI Systems with Differential and Difference Equations

An important class of continuous-time systems comprises those for which the input and output are related through a _linear constant-coefficient differential equation_. Its discrete-time counterpart is termed a _linear constant-coefficient difference equation_.

=== Linear Constant-Coefficient Differential Equations

Linear constant-coefficient differential equations (LCCDE) of finite order always take the following form:
$
  a_n y^((n)) (t) + a_(n-1) y^((n-1)) (t) + dots.c + a_1 y^prime (t) + a_0 y(t) = b_0 x(t) + b_1 x^prime (t) + dots.c + b_m x^((m)) (t)
$

#note("General Form - CT")[
  The general form of an LCCDE is:
  $
    sum_(i=0)^N a_i ("d"^i y(t))/("d"t^i) = sum_(j=0)^M b_j ("d"^j x(t))/("d"t^j), quad a_k, b_k in RR
  $
  or equivalently:
  $
    sum_(k = 0)^N a_k y^((k)) (t) = sum_(k = 0)^M b_k x^((k)) (t), quad a_k, b_k in RR
  $
  The order $N$ refers to the highest derivative of the output $y(t)$. For a causal LTI system: if $x(t) = 0$ for $t <= t_0$, then $y(t) = 0$ for $t <= t_0$. This condition is referred to as the *initial rest condition*.
  // This condition ensures the system is both LTI and causal.

  The complete solution consists of $y(t) = y_p (t) + y_h (t)$:
  - $y_p (t)$: particular solution (forced response)
  - $y_h (t)$: homogeneous solution (natural response)
  - Total solution: $y(t) = y_p (t) + y_h (t)$

  #set math.equation(numbering: none)
  Now, let us the solution of:
  $
    ("d" y(t))/("d" t) + 2 y(t) = x(t)
  $
  when the input signal is:
  $
    x(t) = K e^(3t), quad t > 0
  $
  where $K in RR$. The complete solution consists of the sum of a _particular solution_, $y_p (t)$, and a _homogeneous solution_, $y_h (t)$:
  $
    y(t) = y_p (t) + y_h (t)
  $
  where $y_p (t)$ satisfies $x(t)$ and $y_h(t)$ is a solution of the homogeneous differential equation:
  $
    ("d" y(t)) / ("d" t) + 2 y(t) = 0
  $

  *Particular solution*

  A method for finding the particular solution is to seek the so-called _forced response_. We hypothesize a solution of the form:
  $
    y_p (t) = Y e^(3t) u(t)
  $
  where $Y$ is a constant we must determine. Substituting:
  $
    3 Y e^(3t) + 2 Y e^(3t) = K e^(3t)
  $
  Then we have $Y = K / 5$; therefore:
  $
    y_p (t) = K / 5 e^(3 t), quad t > 0
  $

  *Homogeneous solution*

  To determine $y_h (t)$, we hypothesize a solution of the form:
  $
    y_h (t) = A e^(s t)
  $ <yht>

  Substituting:
  $
    A s e^(s t) + 2 A e^(s t) = A e^(s t) (s + 2) = 0
  $
  We obtain $s = -2$. Therefore, the solution for the differential equation is:
  $
    y(t) = A e^(-2 t) + K / 5 e^(3 t), quad t > 0
  $
  To determine $A$, we enforce the rest condition by evaluating $y(t)$ at $t = 0$ and setting $y(0) = 0$. We obtain $A = - K / 5$. Therefore:
  $
    y(t) = K / 5 [e^(3 t) - e^(-2 t)] u(t)
  $
]

=== Linear Constant-Coefficient Difference Equations

Similar to the continuous-time counterpart, discrete-time linear constant-coefficient difference equations are defined as:

#note("General Form - DT")[
  The general form for discrete-time LCCDE is:
  $
    sum_(k=0)^N a_k y[n-k] = sum_(k=0)^M b_k x[n-k], quad a_k, b_k in RR
  $ <lccdedt>

  This can be rearranged into recursive form:
  $
    y[n] = 1/a_0 {sum_(k=0)^M b_k x[n-k] - sum_(k=1)^N a_k y[n-k]}
  $
]

An equation of this type can be solved analogously to differential equations. Specifically, the solution $y[n]$ can be written as the sum of a particular solution to @lccdedt and a solution to the homogeneous equation:
$
  sum_(k = 0)^N a_k y[n-k] = 0
$

One key difference between the discrete-time and continuous-time versions of the LCCDE is that the discrete-time version can be solved iteratively.

#example("First-Order Difference Equation - Discrete Time")[
  #set math.equation(numbering: none)

  Consider the difference equation:
  $
    y[n] - 1/2 y[n-1] = x[n]
  $
  which can be expressed as:
  $
    y[n] = x[n] + 1/2 y[n-1]
  $

  Suppose we impose the condition of initial rest and consider the input $x[n] = K delta[n]$. In this case, $x[n] = 0$ for $n < 0$. The condition of initial rest implies $y[n] = 0$ for $n <= -1$, giving us the initial condition $y[-1] = 0$. Starting from the initial condition, we can solve for successive values of $y[n]$ for $n >= 0$:
  $
    y[0] & = x[0] + 1/2 y[-1] = K \
    y[1] & = x[1] + 1/2 y[0] = 1/2 K \
    y[2] & = x[2] + 1/2 y[1] = 1/4 K \
         & dots.v \
    y[n] & = (1/2)^n K quad n >= 0
  $
  Setting $K = 1$:
  $
    y[n] = (1/2)^n u[n]
  $
]

*System classification*:
- *FIR (Finite Impulse Response)*: $N = 0$, finite duration $h[n]$
- *IIR (Infinite Impulse Response)*: $N >= 1$, infinite duration $h[n]$

=== Block Diagram Representations

*Basic elements*:
- *Discrete-time*: Adder, coefficient multiplier, unit delay ($D$)
- *Continuous-time*: Adder, coefficient multiplier, differentiator, integrator

The following diagrams represent addition:
#figure(
  align(center)[
    #grid(
      columns: (1fr, 1fr),
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
            $x_1[n]$,
            label-pos: -0.5,
            label-side: center,
          ),
          edge(
            (0, 0.9),
            "t",
            "-|>-",
            $x_2[n]$,
            label-pos: 0,
            label-side: center,
          ),
          edge(
            (0, 0),
            "r",
            "-|>-",
            $x_1[n] + x_2[n]$,
            label-pos: 2,
            label-side: center,
          ),
          node((0, 0), $+$, radius: 1em),
        )],
      [#diagram(
        debug: false,
        node-stroke: 0.1em,
        spacing: (15mm, 10mm),
        mark-scale: 100%,
        edge(
          (-1, 0),
          "r",
          "-|>-",
          $x_1[n]$,
          label-pos: -0.3,
          label-side: center,
        ),
        edge(
          (0, -1),
          "b",
          "-|>-",
          $x_2[n]$,
          label-pos: -0.3,
          label-side: center,
        ),
        edge(
          (0, 0),
          "r",
          "-|>-",
          $x_1[n] + x_2[n]$,
          label-pos: 1.8,
          label-side: center,
        ),
        node((0, 0)),
      )],
    )],
)

The following diagrams represent multiplication by a coefficient and a unit delay:
#figure(
  align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      [#diagram(
        debug: false,
        node-stroke: 0.1em,
        spacing: (15mm, 10mm),
        mark-scale: 100%,
        edge(
          (-1, 0),
          "r",
          "-",
          $x[n]$,
          label-pos: -0.3,
          label-side: center,
        ),
        edge((-0.5, 0), "r", "-|>-", $a$),
        edge(
          (0, 0),
          "r",
          "-",
          $a x[n]$,
          label-pos: 1.8,
          label-side: center,
        ),
        node((0, 0)),
      )],
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
            (0, 0),
            "r",
            "-|>-",
            $x[n-1]$,
            label-pos: 1.6,
            label-side: center,
          ),
          node((0, 0), $D$, width: 2em),
        )],
    )],
)

Finally, the causal system described by the first-order difference equation:
$ y[n] + a y[n-1] = b x[n] $
has the following block diagram:
#align(center)[
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
      (1, 0),
      "r",
      "-|>-",
      $y[n]$,
      label-pos: 1.6,
      label-side: center,
    ),
    edge((0, 0), "r", "-|>-"),
    edge((-1, 0), "r", "-|>-", $b$),
    edge((1, 0), "d", "-|>-"),
    edge((1, 1), (1, 2), (0, 2), (0, 0), "-|>-", $-a$),
    node((0, 0), $+$),
    node((1, 1), $D$, width: 2em),
  )
]

Similarly, the continuous-time counterpart defined as:
$ y(t) = -1/a ("d" y(t)) / ("d" t) + b/a x(t) $
can be represented by the following block diagram:
#align(center)[
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
      (1, 0),
      "r",
      "-|>-",
      $y(t)$,
      label-pos: 1.6,
      label-side: center,
    ),
    edge((0, 0), "r", "-|>-"),
    edge((-1, 0), "r", "-|>-", $b/a$),
    edge((1, 0), "d", "-|>-"),
    edge((1, 1), (1, 2), (0, 2), (0, 0), "-|>-", $-1/a$),
    node((0, 0), $+$),
    node((1, 1), $D$, width: 2em),
  )
]
