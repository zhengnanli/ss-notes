#import "lib.typ": *

= The Discrete-Time Fourier Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

Similar to the development of continuous-time Fourier transform, we start by considering a general sequence $x[n]$ that is of finite duration, i.e., for some integers $N_1$ and $N_2$, $x[n] = 0$ outside the range $-N_1 <= x <= N_2$. A signal of this type is illustrated in the figure below. From this aperiodic signal, we construct a periodic sequence $tilde(x) [n]$ for which $x[n]$ is one period. As we choose the period $N$ to be large, $tilde(x) [n]$ is identical to $x[n]$ over a longer interval, i.e., $N -> infinity$, $tilde(x) [n] = x[n]$.

#align(center)[
  #grid(
    columns: (1fr, 3fr),
    column-gutter: 2em,
    [
      #let x = lq.linspace(-6, 6, num: 61)
      #cdiagram(
        title: $x[n]$,
        xlabel: $t$,
        width: 5cm,
        height: 3cm,
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
        ),
        lq.place(-3, -0.21, align: center)[$-N_1$],
        lq.place(3, -0.21, align: center)[$N_2$],
      )],
    [
      #let x = lq.linspace(-18, 18, num: 202)
      #cdiagram(
        title: $tilde(x)[n]$,
        xlabel: $t$,
        width: 10cm,
        height: 3cm,
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-(x + 1.0) * (x + 1.0) / 0.3)
              + 0.8 * calc.exp(-(x - 0.5) * (x - 0.5) / 0.7)
          )),
        ),
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x - 7) + 1.0) * ((x - 7) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x - 7) - 0.5) * ((x - 7) - 0.5) / 0.7)
          )),
          color: green,
        ),
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 7) + 1.0) * ((x + 7) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 7) - 0.5) * ((x + 7) - 0.5) / 0.7)
          )),
          color: green,
        ),
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x + 14) + 1.0) * ((x + 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x + 14) - 0.5) * ((x + 14) - 0.5) / 0.7)
          )),
          color: green,
        ),
        lq.stem(
          x,
          x.map(x => (
            1.5 * calc.exp(-((x - 14) + 1.0) * ((x - 14) + 1.0) / 0.3)
              + 0.8 * calc.exp(-((x - 14) - 0.5) * ((x - 14) - 0.5) / 0.7)
          )),
          color: green,
        ),
        lq.place(-3, -0.21, align: center)[$-N_1$],
        lq.place(3, -0.21, align: center)[$N_2$],
        lq.place(7, -0.21, align: center)[$N$],
        lq.place(-7, -0.21, align: center)[$-N$],
        lq.place(14, -0.21, align: center)[$2N$],
        lq.place(-14, -0.21, align: center)[$-2N$],
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

We start by examine the Fourier series representation of $tilde(x) [n]$, given by
$
  tilde(x) [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k ((2 pi)/N) n)
$
where
$
  a_k = 1 / N sum_(n = chevron.l N chevron.r) tilde(x) [n] e^(-j k (2 pi) / N n)
$
Since $x[n] = tilde(x) [n], -N_1 <= n <= N_2$, it is convenient to choose the interval of summation to include this interval, so that $tilde(x) [n]$ can be replaced by $x[n]$ in the summation, therefore
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
where $omega_0 = (2 pi) / N$ is the spacing of the samples in the frequency domain. Given the fact $omega_0 = (2 pi) / N$, or equivalently $1 / N = omega_0 / (2 pi)$,
$
  tilde(x) [n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2 pi) / N n) = sum_(k = chevron.l N chevron.r) 1/N X(e^(j k omega_0)) e^(j k omega_0 n) = 1 / (2 pi) sum_(k = chevron.l N chevron.r) X(e^(j k omega_0)) e^(j k omega_0 n) omega_0
$
As $N -> infinity$, $tilde(x) [n] = x[n]$, and we have
$
  x[n] = 1 / (2 pi) integral_(2 pi) X(e^(j omega)) e^(j omega n) "d"omega
$

Finally, we have the following pair of equations:
#definition("Discrete-time Fourier Transform")[
  The _analysis equation_ is
  $
    X(e^(j omega)) = sum_(n = -infinity)^(infinity) x[n] e^(-j omega n)
  $
  and the corresponding _synthesis equation_ is
  $
    x[n] = 1 / (2 pi) integral_(2 pi) X(e^(j omega)) e^(j omega n) "d" omega
  $
  Note that since $X(e^(j omega)) e^(j omega n)$ is periodic with period $2 pi$, the interval of integration can be taken as _any_ interval of length $2 pi$.
]

#example("Discrete-Time Fourier Transform")[
  #set math.equation(numbering: none)
  Consider an LTI system with impulse response
  $
    h[n] = alpha^n u[n], quad |alpha| < 1
  $
  and the suppose the input to this system is
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
  Solving for $A$ and $B$, we have
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
    [*Property*], [*Discrete-Time Signal*], [*DTFT*],

    [Linearity], [$a x[n] + b y[n]$], [$a X(e^(j omega)) + b Y(e^(j omega))$],

    [Time Shifting], [$x[n - n_0]$], [$X(e^(j omega)) e^(-j omega n_0)$],

    [Frequency Shifting],
    [$x[n] e^(j omega_0 n)$],
    [$X(e^(j(omega - omega_0)))$],

    [Conjugation], [$x^*[n]$], [$X^*(e^(-j omega))$],

    [Time Reversal], [$x[-n]$], [$X(e^(-j omega))$],

    [Time Scaling (Upsampling)],
    [$x[n slash k]$ if $n = k ell$, $ell in NN$, else 0],
    [$X(e^(j k omega))$],

    [Time Scaling (Downsampling)],
    [$x[n M]$],
    [$1/M sum_(k=0)^(M-1) X(e^(j(omega + 2 pi k)/M))$],

    [Convolution], [$x[n] * y[n]$], [$X(e^(j omega)) Y(e^(j omega))$],

    [Multiplication],
    [$x[n] y[n]$],
    [$1/(2pi) integral_(2pi) X(e^(j theta)) Y(e^(j(omega - theta))) d theta$],

    [Differentiation in Frequency], [$n x[n]$], [$j d/d omega X(e^(j omega))$],

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
    [$1/(2pi) integral_(-pi)^(pi) |X(e^(j omega))|^2 d omega$],

    [Periodicity], [$x[n]$], [$X(e^(j omega)) = X(e^(j(omega + 2pi)))$],

    [Modulation],
    [$x[n] cos(omega_0 n)$],
    [$1/2 [X(e^(j(omega - omega_0))) + X(e^(j(omega + omega_0)))]$],
  )
]

#note("Discrete-Time Fourier Transform Pairs")[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: 0.5pt,
    [*Discrete-Time Signal*], [*DTFT*], [*FS Coefficients (if periodic)*],

    [$delta[n]$], [$1$], [N/A],

    [$1$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - 2pi k)$],
    [$a_k = 1/N$ for all $k$],

    [$e^(j omega_0 n)$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - omega_0 - 2pi k)$],
    [$a_k = delta[k - k_0]$ where $omega_0 = 2pi k_0/N$],

    [$cos(omega_0 n)$],
    [$pi sum_(k=-infinity)^(infinity) [delta(omega - omega_0 - 2pi k) + delta(omega + omega_0 - 2pi k)]$],
    [$a_(plus.minus k_0) = 1/2$, others = 0],

    [$sin(omega_0 n)$],
    [$j pi sum_(k=-infinity)^(infinity) [delta(omega + omega_0 - 2pi k) - delta(omega - omega_0 - 2pi k)]$],
    [$a_(plus.minus k_0) = plus.minus j/2$, others = 0],

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

    [$(sin(omega_c n))/(pi n)$],
    [Rectangle: $cases(1 "if" |omega| < omega_c, 0 "if" omega_c < |omega| <= pi)$],
    [N/A],

    [$sum_(n=-infinity)^(infinity) delta[n - r N]$],
    [$(2pi)/N sum_(k=-infinity)^(infinity) delta(omega - 2pi k/N)$],
    [$a_k = 1/N$ for all $k$],

    [Periodic rec.: $cases(1 "if" 0 <= n <= N_1-1, 0 "if" N_1 <= n <= N-1)$],
    [$(2pi)/N sum_(k=-infinity)^(infinity) (sin(pi k N_1/N))/(sin(pi k/N)) delta(omega - (2 pi k)/N)$],
    [$a_k = (sin(pi k N_1/N))/(N sin(pi k/N))$ for $k != 0$, $a_0 = N_1/N$],

    [$(omega_c/pi) (sin(omega_c n))/(omega_c n)$],
    [Ideal lowpass: $cases(1 "if" |omega| <= omega_c, 0 "if" omega_c < |omega| <= pi)$],
    [N/A],

    [$(-1)^n$],
    [$2pi sum_(k=-infinity)^(infinity) delta(omega - pi - 2pi k)$],
    [$a_k = delta[k - N/2]$ for even $N$],

    [$r^n cos(omega_0 n + phi) u[n]$, $|r| < 1$],
    [$(1 - r cos(phi) e^(-j omega))/(1 - 2r cos(omega_0) e^(-j omega) + r^2 e^(-2j omega))$],
    [N/A],
  )
]


== Duality


We have seen four Fourier representations:

- CT FS
$
  a_k = 1 / T integral_T x(t) e^(-j k omega_0 n) "d" t, quad x(t) = sum_(k = -infinity)^(infinity) a_k e^(j k omega_0 t)
$
- CT FT
$
  X(j omega) = integral_RR x(t) e^(-j omega t) "d" t, quad x(t) = 1 / (2 pi) integral_RR X(j omega) e^(j omega t) "d" omega
$
- DT FS
$
  a_k = 1 / N sum_(k = chevron.l N chevron.r) x[n] e^(-j k (2 pi)/N n), quad x[n] = sum_(k = chevron.l N chevron.r) a_k e^(j k (2pi)/N n)
$
- DT FT
$
  X(e^(j omega)) = sum_(n = -infinity)^(infinity) x[n] e^(-j omega n), quad x[n] = 1 / (2pi) integral_(2pi) X(e^(j omega)) e^(j omega n) "d" omega
$

The key duality principles are
- Periodicity in one domain $<->$ Discreteness in the other domain
- Discreteness in one domain $<->$ Periodicity in the other domain

== Systems Characterized by Linear Constant-Coefficient Difference Equations

A general linear constant-coefficient difference equation for an LTI system with input $x[n]$ and output $y[n]$ is of the form

$
  sum_(k = 0)^N a_k y[n - k] = sum_(k = 0)^(M) b_k x[n - k]
$

Taking the DTFT of both sides we have
$
  sum_(k = 0)^N a_k e^(0j k omega) Y(e^(j omega)) = sum_(k = 0)^M b_k e^(-j k omega) X(e^(j omega))
$
or equivalently,
$
  H(e^(j omega)) = (Y(e^(j omega))) / (X(e^(j omega))) = (sum_(k = 0)^(M) b_k e^(j k omega)) / (sum_(k = 0)^N a_k e^(-j k omega))
$

#example("Linear Constant-Coefficient Difference Equations")[
  Consider a causal LTI system that is characterized by the difference equation
  $
    y[n] - 3/4 y[n - 1] + 1/8 y[n - 2] = 2 x[n]
  $
  The frequency response is
  $
    H(e^(j omega)) = 1 / (1 - 3/4 e^(-j omega) + 1/8 e^(-j 2 omega))
  $
  Again, it can be expanded as
  $
    H(e^(j omega)) = 4 / (1 - 1/2 e^(-j omega)) - 2 / (1 - 1/4 e^(-j omega))
  $
  The inverse transform is
  $
    h[n] = 4 (1/2)^n u[n] - 2 (1/4)^n u[n]
  $
]


== Discrete Fourier Transform (NOT DTFT)

Discrete Fourier Transform (DFT) is defined for finite length sequences by considering their periodic extension (sometimes with zero-padding). Let $x[n]$ be a finite length sequencey such that $x[n] = 0$ if $n in.not [0, N-1]$, the DFT is defined as
$
  x[k] = sum_(n = 0)^(N - 1) x[n] W_N^(k n), quad k = 0, 1, dots.c, N - 1
$
where $W_N = e^(-j (2pi)/N)$.

The inverse DFT is given by
$
  x[n] = 1/N sum_(n = 0)^(N - 1) X[k] W_N^(-k n), quad n = 0, 1, dots.c N - 1
$

Suppose we are given the _samples_ of a signal $bold(x)$, $bold(upright(x)) = vec(x(0)& x(1) & dots.c & x(N-1), delim: "[")^top$, we would like to get the DTFT of it, $bold(upright(X)) = vec(X(0)&X(1)&dots.c&X(N-1), delim: "[")^top$. We can do so by matrix multiplications 

$ bold(X) = bold(W x), bold(x) = 1/N bold(W)^prime bold(X) $

where $w_N = e^(-j (2 pi) / N)$ and
$
  bold(W) = mat(1, 1, dots.h, 1; 1, w_N, dots.h, w_N^(N-1); dots.h, dots.h, dots.down, dots.v; 1, w_N^(N-1), dots.h, w_N^((N-1)(N-1)); delim:"[")
$

Note that $1/sqrt(N) bold(W)$ is unitary (orthogonal): $(1/sqrt(N) bold(W))^(-1) = 1/sqrt(N) bold(W)^prime$.

For example, a four-point discrete Fourier transform is simply
$
  mat(X(0); X(1); X(2); X(3); delim:"[") = 1/4 mat(1, 1, 1, 1;1, -j, -1, j; 1, -1, 1, -1; 1, j, -1, -j; delim:"[") mat(x(0); x(1); x(2); x(3); delim:"[")
$

The fast Fourier transform uses divide-and-conquer, reducing the number of multiplications from $cal("O")(N^2)$ to $cal("O")(N log N)$. Can you use DFT to calculate IDFT?

We can say that when comparing DFT with DTFT,
$
  X[k] = X(e^(j omega)) lr(|, size: #200%)_(omega = (2 pi k) / N) = X(e^(j (2 pi) / N k))
$
In other words, DFT values are samples from DTFT. To construct DTFT from DFT, we can convolve the DFT values with a `sinc` function (corresponds to multiplication with a finite length rectangular pulse in DT domain).
