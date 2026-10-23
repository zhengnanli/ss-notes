#import "lib.typ": *

= The Discrete-Time Fourier Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

Similar to the development of the continuous-time Fourier transform, we start by considering a general sequence $x[n]$ that is of finite duration, i.e., for some integers $N_1$ and $N_2$, $x[n] = 0$ outside the range $-N_1 <= n <= N_2$. A signal of this type is illustrated in the figure below. From this aperiodic signal, we construct a periodic sequence $tilde(x) [n]$ for which $x[n]$ is one period. As we choose the period $N$ to be larger (always with $N >= N_1 + N_2 + 1$, so that the shifted copies do not overlap), $tilde(x) [n]$ agrees with $x[n]$ over a longer interval, and as $N -> infinity$, $tilde(x) [n] = x[n]$ for every $n$.

// A discrete-time signal is drawn on the integers, so the stems here are at
// integer n, not on a fine grid. The support is exactly -N1 .. N2 with
// N1 = N2 = 3, so with N = 7 the shifted copies tile without overlapping.
#let N1 = 3
#let N2 = 3
#let N = 7
#let seq = n => if n < -N1 or n > N2 { 0.0 } else {
  1.5 * calc.exp(-calc.pow(n + 1, 2) / 2) + 0.8 * calc.exp(
    -calc.pow(n - 1, 2) / 4,
  )
}

#altfig(
  alt: "Two stem plots. Left: an aperiodic discrete-time sequence x of n, nonzero only on the interval from minus N sub one to N sub two. Right: its periodic extension tilde x of n, formed by repeating the sequence every N samples; the central period is shown in the accent color and adjacent copies in green, with dashed gray lines at plus and minus N and plus and minus two N.",
  caption: [
    A finite-duration sequence $x[n]$ (left) and the periodic $tilde(x)[n]$ built
    by repeating it every $N$ samples (right), with $N_1 = N_2 = 3$ and $N = 7$
    so the copies just touch without overlapping.
  ],
  align(center)[
  #grid(
    columns: (1fr, 3fr),
    column-gutter: 2em,
    [
      #let n = range(-6, 7)
      #cdiagram(
        title: $x[n]$,
        xlabel: $n$,
        width: 5cm,
        height: 3cm,
        ylim: (-0.15, 2.1),
        lq.stem(n, n.map(seq)),
        lq.place(-N1, -0.28, align: center, plabel[$-N_1$]),
        lq.place(N2, -0.28, align: center, plabel[$N_2$]),
      )],
    [
      #let n = range(-18, 19)
      #cdiagram(
        title: $tilde(x)[n]$,
        xlabel: $n$,
        width: 10cm,
        height: 3cm,
        ylim: (-0.15, 2.1),
        lq.stem(n, n.map(seq)),
        ..(-2, -1, 1, 2).map(r => lq.stem(
          n,
          n.map(m => seq(m - r * N)),
          color: c-green,
        )),
        lq.place(-N1, -0.28, align: center, plabel[$-N_1$]),
        lq.place(N2, -0.28, align: center, plabel[$N_2$]),
        lq.place(N, -0.28, align: center, plabel[$N$]),
        lq.place(-N, -0.28, align: center, plabel[$-N$]),
        lq.place(2 * N, -0.28, align: center, plabel[$2N$]),
        lq.place(-2 * N, -0.28, align: center, plabel[$-2N$]),
        lq.place(-18, 1.2, align: center)[$dots.c$],
        lq.place(18, 1.2, align: center)[$dots.c$],
        ..(-2, -1, 1, 2).map(r => lq.plot(
          (r * N, r * N),
          (0, 1.8),
          mark: none,
          stroke: (dash: "dashed", paint: c-muted),
        )),
      )],
  )],
)

We start by examining the Fourier series representation of $tilde(x) [n]$, given by
$
  tilde(x) [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k ((2 pi)/N) n)
$
where
$
  a_k = 1 / N sum_(n = chevron.l N chevron.r) tilde(x) [n] e^(-j k (2 pi) / N n)
$
Since $x[n] = tilde(x) [n], -N_1 <= n <= N_2$, it is convenient to choose the interval of summation to include this interval, so that $tilde(x) [n]$ can be replaced by $x[n]$ in the summation. Therefore,
$
  a_k = 1 / N sum_(n = -N_1)^(N_2) x[n] e^(-j k (2 pi)/N n) = 1 / N sum_(n = -infinity)^(infinity) x[n] e^(-j k (2 pi)/N n)
$
Defining
$
  X(e^(j omega)) = sum_(n = -infinity)^infinity x[n] e^(-j omega n)
$
we see that the coefficients $a_k$ are proportional to samples of $X(e^(j omega))$, i.e.,
$
  a_k = 1 / N X(e^(j k omega_0))
$
where $omega_0 = (2 pi) / N$ is the spacing of the samples in the frequency domain. Substituting $1 / N = omega_0 / (2 pi)$ into the Fourier series gives
$
  tilde(x) [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi) / N n) = sum_(k = chevron.l N chevron.r) 1/N X(e^(j k omega_0)) e^(j k omega_0 n) = 1 / (2 pi) sum_(k = chevron.l N chevron.r) X(e^(j k omega_0)) e^(j k omega_0 n) omega_0
$
As $N -> infinity$, $omega_0 -> "d"omega$, the sum over $N$ consecutive $k$ becomes an integral over an interval of length $N omega_0 = 2 pi$, and $tilde(x)[n] -> x[n]$, so
$
  x[n] = 1 / (2 pi) integral_(2 pi) X(e^(j omega)) e^(j omega n) "d"omega
$

Finally, we have the following pair of equations:
#definition("Discrete-Time Fourier Transform")[
  The _analysis equation_ is
  #eqalt(
    "X of e to the j omega equals the sum over all integer n of x of n times e to the negative j omega n.",
    $
      X(e^(j omega)) = sum_(n = -infinity)^(infinity) x[n] e^(-j omega n)
    $,
  )
  and the corresponding _synthesis equation_ is
  #eqalt(
    "x of n equals one over two pi times the integral over any two-pi-length interval of X of e to the j omega times e to the j omega n, d omega.",
    $
      x[n] = 1 / (2 pi) integral_(2 pi) X(e^(j omega)) e^(j omega n) "d"omega
    $,
  )
  Note that since $X(e^(j omega)) e^(j omega n)$ is periodic with period $2 pi$, the interval of integration can be taken as _any_ interval of length $2 pi$.
]

#example("Discrete-Time Fourier Transform")[
  #set math.equation(numbering: none)
  Consider an LTI system with impulse response
  $
    h[n] = alpha^n u[n], quad |alpha| < 1
  $
  and suppose the input to this system is
  $
    x[n] = beta^n u[n], quad |beta| < 1
  $
  Evaluating the Fourier transforms of $h[n]$ and $x[n]$, we have
  $
    H(e^(j omega)) = 1 / (1 - alpha e^(-j omega))
  $
  and
  $
    X(e^(j omega)) = 1 / (1 - beta e^(-j omega))
  $
  so that
  $
    Y(e^(j omega)) = H(e^(j omega)) X(e^(j omega)) = 1 / ((1 - alpha e^(-j omega)) (1 - beta e^(-j omega)))
  $
  The partial fraction expansion of $Y(e^(j omega))$ is of the form
  $
    Y(e^(j omega)) = A / (1 - alpha e^(-j omega)) + B / (1 - beta e^(-j omega))
  $
  Assuming $alpha != beta$, solving for $A$ and $B$ gives $A = alpha \/ (alpha - beta)$ and $B = -beta \/ (alpha - beta)$, so
  $
    y[n] = A alpha^n u[n] + B beta^n u[n] = alpha / (alpha - beta) alpha^n u[n] - beta / (alpha - beta) beta^n u[n]
  $
]

== Tables of Fourier Transform Properties and Basic Fourier Transform Pairs

#note("Discrete-Time Fourier Transform Properties")[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: 0.5pt,
    table.header([*Property*], [*Discrete-Time Signal*], [*DTFT*]),

    [Linearity], [$a x[n] + b y[n]$], [$a X(e^(j omega)) + b Y(e^(j omega))$],

    [Time Shifting], [$x[n - n_0]$], [$X(e^(j omega)) e^(-j omega n_0)$],

    [Frequency Shifting],
    [$x[n] e^(j omega_0 n)$],
    [$X(e^(j(omega - omega_0)))$],

    [Conjugation], [$x^*[n]$], [$X^*(e^(-j omega))$],

    [Time Reversal], [$x[-n]$], [$X(e^(-j omega))$],

    [Time Scaling (Upsampling)],
    [$x[n slash k]$ if $n = k ell$, $ell in ZZ$, else 0],
    [$X(e^(j k omega))$],

    [Time Scaling (Downsampling)],
    [$x[n M]$],
    [$1/M sum_(k=0)^(M-1) X(e^(j(omega + 2 pi k)/M))$],

    [Convolution], [$x[n] star y[n]$], [$X(e^(j omega)) Y(e^(j omega))$],

    [Multiplication],
    [$x[n] y[n]$],
    [$1/(2pi) integral_(2pi) X(e^(j theta)) Y(e^(j(omega - theta))) "d"theta$],

    [Differentiation in Frequency], [$n x[n]$], [$j "d"/("d"omega) X(e^(j omega))$],

    [First Difference],
    [$x[n] - x[n-1]$],
    [$(1 - e^(-j omega)) X(e^(j omega))$],

    [Accumulation],
    [$sum_(k=-infinity)^n x[k]$],
    [$1/(1 - e^(-j omega)) X(e^(j omega)) + pi X(e^(j 0)) sum_(k=-infinity)^(infinity) delta(omega - 2pi k)$],

    [Conjugate Symmetry for Real Signals],
    [$x[n]$ real],
    [$X(e^(j omega)) = X^*(e^(-j omega))$],

    [Symmetry for Real and Even Signals],
    [$x[n]$ real and even],
    [$X(e^(j omega))$ real and even],

    [Symmetry for Real and Odd Signals],
    [$x[n]$ real and odd],
    [$X(e^(j omega))$ purely imaginary and odd],

    [Parseval's Theorem],
    [$sum_(n=-infinity)^(infinity) |x[n]|^2$],
    [$1/(2pi) integral_(-pi)^(pi) |X(e^(j omega))|^2 "d"omega$],

    [Periodicity], [$x[n]$], [$X(e^(j omega)) = X(e^(j(omega + 2pi)))$],

    [Modulation],
    [$x[n] cos(omega_0 n)$],
    [$1/2 [X(e^(j(omega - omega_0))) + X(e^(j(omega + omega_0)))]$],
  )
]

#note("Discrete-Time Fourier Transform Pairs", breakable: false)[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: 0.5pt,
    table.header(
      [*Discrete-Time Signal*],
      [*DTFT*],
      [*FS Coefficients (if periodic)*],
    ),

    [$delta[n]$], [$1$], [N/A],

    [$1$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - 2pi k)$],
    [$a_0 = 1$, $a_k = 0$ otherwise],

    [$e^(j omega_0 n)$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - omega_0 - 2pi k)$],
    [$a_k = delta[k - k_0]$ where $omega_0 = 2pi k_0/N$],

    [$cos(omega_0 n)$],
    [$pi sum_(k=-infinity)^(infinity) [delta(omega - omega_0 - 2pi k) + delta(omega + omega_0 - 2pi k)]$],
    [$a_(plus.minus k_0) = 1/2$, others = 0],

    [$sin(omega_0 n)$],
    [$j pi sum_(k=-infinity)^(infinity) [delta(omega + omega_0 - 2pi k) - delta(omega - omega_0 - 2pi k)]$],
    [$a_(k_0) = -j/2$, $a_(-k_0) = j/2$, others = 0],

    [$u[n]$],
    [$1/(1 - e^(-j omega)) + pi sum_(k=-infinity)^(infinity) delta(omega - 2pi k)$],
    [N/A],

    [$a^n u[n]$, $|a| < 1$], [$1/(1 - a e^(-j omega))$], [N/A],

    [$-a^n u[-n-1]$, $|a| > 1$], [$1/(1 - a e^(-j omega))$], [N/A],

    [$n a^n u[n]$, $|a| < 1$], [$a e^(-j omega)/(1 - a e^(-j omega))^2$], [N/A],

    [$delta[n - n_0]$], [$e^(-j omega n_0)$], [N/A],

    [Rectangular: $cases(1 "if" 0 <= n <= M-1, 0 "otherwise")$],
    [$(sin(omega M/2))/(sin(omega/2)) e^(-j omega (M-1)/2)$],
    [N/A],

    [$(sin(omega_c n))/(pi n)$, $0 < omega_c < pi$],
    [Rectangle: $cases(1 "if" |omega| < omega_c, 0 "if" omega_c < |omega| <= pi)$ (periodic with period $2pi$)],
    [N/A],

    [$sum_(n=-infinity)^(infinity) delta[n - r N]$],
    [$(2pi)/N sum_(k=-infinity)^(infinity) delta(omega - 2pi k/N)$],
    [$a_k = 1/N$ for all $k$],

    [Square wave: $cases(1 "if" |n| <= N_1, 0 "if" N_1 < |n| <= N\/2)$],
    [$2pi sum_(k=-infinity)^(infinity) a_k delta(omega - (2 pi k)/N)$],
    [$a_k = 1/N (sin[2 pi k (N_1 + 1\/2) \/ N])/(sin(pi k \/ N))$ for $k != 0, plus.minus N, plus.minus 2N, dots.c$; $a_k = (2 N_1 + 1)/N$ for $k = 0, plus.minus N, dots.c$],

    [$(-1)^n$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - pi - 2pi k)$],
    [$a_k = delta[k - N/2]$ for even $N$],

    [$r^n cos(omega_0 n) u[n]$, $|r| < 1$],
    [$(1 - r cos(omega_0) e^(-j omega))/(1 - 2r cos(omega_0) e^(-j omega) + r^2 e^(-2j omega))$],
    [N/A],
  )
]


== Duality


We have seen four Fourier representations:

- CT FS
$
  a_k = 1 / T integral_T x(t) e^(-j k omega_0 t) "d"t, quad x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t)
$
- CT FT
$
  X(j omega) = integral_RR x(t) e^(-j omega t) "d"t, quad x(t) = 1 / (2 pi) integral_RR X(j omega) e^(j omega t) "d"omega
$
- DT FS
$
  a_k = 1 / N sum_(n = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n), quad x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2pi)/N n)
$
- DT FT
$
  X(e^(j omega)) = sum_(n = -infinity)^(infinity) x[n] e^(-j omega n), quad x[n] = 1 / (2pi) integral_(2pi) X(e^(j omega)) e^(j omega n) "d"omega
$

The key duality principle is that periodicity in one domain corresponds to discreteness in the other. A periodic signal has a discrete spectrum, a discrete signal has a periodic spectrum, and a signal that is both periodic and discrete, as in the DT Fourier series, has a spectrum that is both.

== Systems Characterized by Linear Constant-Coefficient Difference Equations

A general linear constant-coefficient difference equation for an LTI system with input $x[n]$ and output $y[n]$ is of the form

$
  sum_(k = 0)^N a_k y[n - k] = sum_(k = 0)^(M) b_k x[n - k]
$

Taking the DTFT of both sides we have
$
  sum_(k = 0)^N a_k e^(-j k omega) Y(e^(j omega)) = sum_(k = 0)^M b_k e^(-j k omega) X(e^(j omega))
$
or equivalently,
$
  H(e^(j omega)) = (Y(e^(j omega))) / (X(e^(j omega))) = (sum_(k = 0)^(M) b_k e^(-j k omega)) / (sum_(k = 0)^N a_k e^(-j k omega))
$

#example("Linear Constant-Coefficient Difference Equations")[
  Consider a causal LTI system that is characterized by the difference equation
  $
    y[n] - 3/4 y[n - 1] + 1/8 y[n - 2] = 2 x[n]
  $
  The frequency response is
  $
    H(e^(j omega)) = 2 / (1 - 3/4 e^(-j omega) + 1/8 e^(-j 2 omega))
  $
  Using partial fractions, it can be expanded as
  $
    H(e^(j omega)) = 4 / (1 - 1/2 e^(-j omega)) - 2 / (1 - 1/4 e^(-j omega))
  $
  The inverse transform is
  $
    h[n] = 4 (1/2)^n u[n] - 2 (1/4)^n u[n]
  $
]


== The Discrete Fourier Transform

The discrete Fourier transform (DFT) is defined for finite-length sequences by considering their periodic extension (sometimes with zero-padding). Let $x[n]$ be a finite-length sequence such that $x[n] = 0$ if $n in.not [0, N-1]$. The DFT is defined as
$
  X[k] = sum_(n = 0)^(N - 1) x[n] W_N^(k n), quad k = 0, 1, dots.c, N - 1
$
where $W_N = e^(-j (2pi)/N)$.

The inverse DFT is given by
$
  x[n] = 1/N sum_(k = 0)^(N - 1) X[k] W_N^(-k n), quad n = 0, 1, dots.c, N - 1
$

Suppose we are given the _samples_ of a signal, $bold(x) = [x[0], x[1], dots.c, x[N-1]]^top$, and we would like the DFT of it, $bold(X) = [X[0], X[1], dots.c, X[N-1]]^top$. We can obtain it by a matrix multiplication,

$ bold(X) = bold(W) bold(x), quad bold(x) = 1/N bold(W)^H bold(X) $

where $bold(W)^H$ is the conjugate transpose and
$
  bold(W) = mat(1, 1, dots.h, 1; 1, W_N, dots.h, W_N^(N-1); dots.v, dots.v, dots.down, dots.v; 1, W_N^(N-1), dots.h, W_N^((N-1)(N-1)); delim:"[")
$

Note that $1/sqrt(N) bold(W)$ is unitary: $(1/sqrt(N) bold(W))^(-1) = 1/sqrt(N) bold(W)^H$.

For example, a four-point discrete Fourier transform is simply
$
  mat(X[0]; X[1]; X[2]; X[3]; delim:"[") = mat(1, 1, 1, 1;1, -j, -1, j; 1, -1, 1, -1; 1, j, -1, -j; delim:"[") mat(x[0]; x[1]; x[2]; x[3]; delim:"[")
$
since $W_4 = e^(-j pi \/ 2) = -j$.

The fast Fourier transform (FFT) uses divide-and-conquer, reducing the number of multiplications from $cal("O")(N^2)$ to $cal("O")(N log N)$. Exercise: show how a DFT routine can compute the IDFT.

Comparing the DFT with the DTFT of the same finite-length $x[n]$,
$
  X[k] = X(e^(j omega)) lr(|, size: #200%)_(omega = (2 pi k) / N) = X(e^(j (2 pi) / N k))
$
In other words, the DFT values are samples of the DTFT. To recover the DTFT between those samples, we interpolate the DFT values with a Dirichlet kernel, the DTFT of the length-$N$ rectangular window on which $x[n]$ is supported.
