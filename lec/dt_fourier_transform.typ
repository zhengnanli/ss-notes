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

The same argument holds for the Fourier series coefficients $a_k$ of any periodic sequence $tilde(x)[n]$ whose period is one copy of an $x[n]$ that vanishes outside the range $s <= n <= s + N - 1$:
$
  a_k = 1/N sum_(n = s)^(s + N - 1) tilde(x)[n] e^(-j k omega_0 n) = 1/N sum_(n = s)^(s + N - 1) x[n] e^(-j k omega_0 n) = 1/N sum_(n = -infinity)^infinity x[n] e^(-j k omega_0 n)
$
Comparing the equation with the DTFT, we conclude that
$
  a_k = 1/N X(e^(j omega)) lr(|, size: #200%)_(omega = k omega_0)
$
where $X(e^(j omega))$ is the DTFT of $x[n]$. As in continuous time, $N a_k$ are _samples_ of the DTFT of one period of $tilde(x)[n]$.

== Convergence of the Discrete-Time Fourier Transform

The synthesis equation integrates over a finite interval of length $2 pi$, so it raises no convergence question. The analysis equation is an infinite sum, and it converges if $x[n]$ satisfies either of the following conditions:

- $x[n]$ is absolutely summable: $sum_(n = -infinity)^infinity |x[n]| < infinity$. The sum then converges uniformly to a continuous function of $omega$.
- $x[n]$ has finite energy: $sum_(n = -infinity)^infinity |x[n]|^2 < infinity$. The sum then converges in the mean-square sense.

Unlike the continuous-time case, there are no conditions on maxima, minima, or discontinuities, since a sequence has none of these within a finite interval. A sequence of finite duration always has a DTFT.

== Examples of Discrete-Time Fourier Transforms

#example("Discrete-Time Fourier Transform Pairs")[
  #set math.equation(numbering: none)

  Consider the signal
  $
    x[n] = a^n u[n], quad |a| < 1
  $
  The DTFT of it is
  $
    X(e^(j omega)) = sum_(n = 0)^infinity a^n e^(-j omega n) = sum_(n = 0)^infinity (a e^(-j omega))^n = 1 / (1 - a e^(-j omega)), quad |a| < 1
  $
  The geometric series converges because $|a e^(-j omega)| = |a| < 1$.

  Consider then the signal
  $
    x[n] = a^(|n|), quad |a| < 1, quad a "real"
  $
  The DTFT is
  $
    X(e^(j omega)) = sum_(n = 0)^infinity a^n e^(-j omega n) + sum_(n = -infinity)^(-1) a^(-n) e^(-j omega n) = 1 / (1 - a e^(-j omega)) + (a e^(j omega)) / (1 - a e^(j omega)) = (1 - a^2) / (1 - 2 a cos omega + a^2)
  $

  Let us now determine the DTFT of the unit impulse
  $
    X(e^(j omega)) = sum_(n = -infinity)^infinity delta[n] e^(-j omega n) = 1
  $

  // Unbreakable, so that "is" cannot be stranded at the foot of a page
  // with its equation on the next.
  #block(breakable: false)[
    The DTFT of the rectangular pulse
    $
      x[n] = cases(1\, quad |n| <= N_1, 0\, quad |n| > N_1)
    $
    is
    $
      X(e^(j omega)) = sum_(n = -N_1)^(N_1) e^(-j omega n) = (sin(omega (N_1 + 1\/2))) / (sin(omega \/ 2))
    $
    which follows from summing the finite geometric series and multiplying numerator and denominator by $e^(j omega \/ 2)$. At $omega = 0$ its value is $2 N_1 + 1$, the number of nonzero samples.
  ]

  // N1 = 2, so the peak is 2 N1 + 1 = 5 and the first null sits at
  // omega = 2 pi / 5, where the label is placed.
  #let N1 = 2
  #let dirichlet = w => if calc.abs(calc.sin(w / 2)) < 1e-9 { 2 * N1 + 1 } else {
    calc.sin(w * (N1 + 0.5)) / calc.sin(w / 2)
  }
  #altfig(
    alt: "Two plots. Left: a discrete-time rectangular pulse x of n, stems of height one for n from minus N sub one to N sub one. Right: its DTFT X of e to the j omega, a periodic sinc-like curve with peaks of height two N sub one plus one at omega equal to zero and plus and minus two pi, and first zero crossings at plus and minus two pi over two N sub one plus one.",
    caption: [
      A rectangular pulse with $N_1 = 2$ (left) and its DTFT (right). The
      transform has the same main-lobe shape as the continuous-time sinc, but
      it repeats every $2 pi$.
    ],
    align(center)[
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 2em,
        [
          #let n = range(-6, 7)
          #cdiagram(
            title: $x[n]$,
            xlabel: $n$,
            height: 4cm,
            width: 6cm,
            ylim: (-0.4, 1.5),
            lq.stem(n, n.map(n => if calc.abs(n) <= N1 { 1 } else { 0 })),
            lq.place(-N1, -0.25, align: center, plabel[$-N_1$]),
            lq.place(N1, -0.25, align: center, plabel[$N_1$]),
          )],
        [
          #let w = lq.linspace(-2 * calc.pi, 2 * calc.pi, num: 801)
          #cdiagram(
            title: $X(e^(j omega))$,
            xlabel: $omega$,
            height: 4cm,
            width: 6cm,
            ylim: (-3, 6),
            lq.plot(w, w.map(dirichlet), mark: none),
            lq.place(-1.7, 5, align: center, plabel[$2 N_1 + 1$]),
            lq.place(
              2 * calc.pi / (2 * N1 + 1) - 0.3,
              -2.2,
              align: left,
              plabel[$2 pi \/ (2 N_1 + 1)$],
            ),
            lq.place(2 * calc.pi, -0.6, align: center, plabel[$2 pi$]),
            lq.place(-2 * calc.pi, -0.6, align: center, plabel[$-2 pi$]),
          )
        ],
      )],
  )

  Consider a signal $x[n]$ whose DTFT is, over one period,
  $
    X(e^(j omega)) = cases(1\, quad |omega| < W, 0\, quad W < |omega| <= pi)
  $
  The inverse DTFT is
  $
    x[n] = 1 / (2 pi) integral_(-pi)^(pi) X(e^(j omega)) e^(j omega n) "d"omega = 1 / (2 pi) integral_(-W)^W e^(j omega n) "d"omega = (sin W n) / (pi n) = W / pi "sinc"((W n) / pi)
  $
  This sequence is not absolutely summable, but it has finite energy, so its DTFT converges in the mean-square sense.
]

== Properties of the Discrete-Time Fourier Transform

We denote a DTFT pair as
$
  x[n] #ftpair X(e^(j omega))
$

We list the properties below, with short proofs of the periodicity, shifting, conjugation, and differencing and accumulation properties.

- Periodicity:
$
  X(e^(j (omega + 2 pi))) = X(e^(j omega))
$
_Proof._ For every integer $n$, $e^(-j 2 pi n) = 1$, so
$
  X(e^(j (omega + 2 pi))) = sum_(n = -infinity)^infinity x[n] e^(-j omega n) e^(-j 2 pi n) = sum_(n = -infinity)^infinity x[n] e^(-j omega n) = X(e^(j omega))
$
The proof uses only that $n$ is an integer, which is why the CTFT has no counterpart of this property.
- Linearity:
$
  a x[n] + b y[n] #ftpair a X(e^(j omega)) + b Y(e^(j omega))
$
#block(sticky: true)[- Time and Frequency Shifting:]
$
  x[n - n_0] #ftpair e^(-j omega n_0) X(e^(j omega))
$
$
  e^(j omega_0 n) x[n] #ftpair X(e^(j (omega - omega_0)))
$
_Proof._ Substituting $m = n - n_0$ in the analysis equation, $m$ still runs over all integers, so
$
  sum_(n = -infinity)^infinity x[n - n_0] e^(-j omega n) = sum_(m = -infinity)^infinity x[m] e^(-j omega (m + n_0)) = e^(-j omega n_0) X(e^(j omega))
$
For the frequency shift, the exponential combines with the kernel,
$
  sum_(n = -infinity)^infinity e^(j omega_0 n) x[n] e^(-j omega n) = sum_(n = -infinity)^infinity x[n] e^(-j (omega - omega_0) n) = X(e^(j (omega - omega_0)))
$
- Conjugation and Conjugate Symmetry
$
  x^*[n] #ftpair X^*(e^(-j omega))
$
$
  X(e^(-j omega)) = X^*(e^(j omega)) quad x[n] "real"
$
_Proof._ Pulling the conjugate out of the sum,
$
  sum_(n = -infinity)^infinity x^*[n] e^(-j omega n) = (sum_(n = -infinity)^infinity x[n] e^(j omega n))^* = (sum_(n = -infinity)^infinity x[n] e^(-j (-omega) n))^* = X^*(e^(-j omega))
$
If $x[n]$ is real, $x^*[n] = x[n]$, so $X(e^(j omega)) = X^*(e^(-j omega))$, or equivalently $X(e^(-j omega)) = X^*(e^(j omega))$.
- Differencing and Accumulation
$
  x[n] - x[n - 1] #ftpair (1 - e^(-j omega)) X(e^(j omega))
$
$
  sum_(m = -infinity)^n x[m] #ftpair 1 / (1 - e^(-j omega)) X(e^(j omega)) + pi X(e^(j 0)) sum_(k = -infinity)^infinity delta(omega - 2 pi k)
$
_Proof._ The first difference follows from linearity and the time-shifting property with $n_0 = 1$:
$
  x[n] - x[n - 1] #ftpair X(e^(j omega)) - e^(-j omega) X(e^(j omega)) = (1 - e^(-j omega)) X(e^(j omega))
$
For accumulation, $y[n] = sum_(m = -infinity)^n x[m] = x[n] star u[n]$, so by the convolution property (@sec-dt-convolution) $Y(e^(j omega)) = X(e^(j omega)) U(e^(j omega))$. As in continuous time, split the step into its average value and a zero-mean part,
$
  u[n] = 1/2 + 1/2 s[n], quad s[n] = cases(1\, quad n >= 0, -1\, quad n < 0)
$
The constant transforms to $1/2 dot 2 pi sum_k delta(omega - 2 pi k) = pi sum_k delta(omega - 2 pi k)$. For $s[n]$, the first difference is $s[n] - s[n - 1] = 2 delta[n]$, so $(1 - e^(-j omega)) S(e^(j omega)) = 2$ and $S(e^(j omega)) = 2 \/ (1 - e^(-j omega))$, with no impulses since $s[n]$ has zero average. Hence
$
  U(e^(j omega)) = 1 / (1 - e^(-j omega)) + pi sum_(k = -infinity)^infinity delta(omega - 2 pi k)
$
and
$
  Y(e^(j omega)) = 1 / (1 - e^(-j omega)) X(e^(j omega)) + pi sum_(k = -infinity)^infinity X(e^(j 2 pi k)) delta(omega - 2 pi k) = 1 / (1 - e^(-j omega)) X(e^(j omega)) + pi X(e^(j 0)) sum_(k = -infinity)^infinity delta(omega - 2 pi k)
$
where the last step uses periodicity, $X(e^(j 2 pi k)) = X(e^(j 0))$.
- Time Reversal
$
  x[-n] #ftpair X(e^(-j omega))
$
- Time Expansion. Since $n$ must be an integer, $x[a n]$ has no direct counterpart of $x(a t)$. Instead, we insert $k - 1$ zeros between samples:
$
  x_((k))[n] = cases(x[n \/ k]\, quad n "a multiple of" k, 0\, quad "otherwise") #ftpair X(e^(j k omega))
$
- Differentiation in Frequency
$
  n x[n] #ftpair j ("d"X(e^(j omega))) / ("d"omega)
$
- Parseval's
$
  sum_(n = -infinity)^infinity |x[n]|^2 = 1 / (2 pi) integral_(2 pi) |X(e^(j omega))|^2 "d"omega
$

== The Convolution Property <sec-dt-convolution>

The argument from continuous time carries over. The complex exponential $e^(j omega n)$ is an eigenfunction of a discrete-time LTI system with impulse response $h[n]$, with eigenvalue
$
  H(e^(j omega)) = sum_(n = -infinity)^infinity h[n] e^(-j omega n)
$
the frequency response. The synthesis equation writes $x[n]$ as a superposition of these exponentials, each weighted by $X(e^(j omega))$, so the system scales each one by $H(e^(j omega))$, and $Y(e^(j omega)) = H(e^(j omega)) X(e^(j omega))$.

As a more formal derivation, let us consider the convolution sum
$
  y[n] = sum_(k = -infinity)^infinity x[k] h[n - k]
$
and its DTFT,
$
  Y(e^(j omega)) = sum_(n = -infinity)^infinity [sum_(k = -infinity)^infinity x[k] h[n - k]] e^(-j omega n) = sum_(k = -infinity)^infinity x[k] [sum_(n = -infinity)^infinity h[n - k] e^(-j omega n)]
$
by the time-shift property, the bracketed term is simply
$
  sum_(n = -infinity)^infinity h[n - k] e^(-j omega n) = e^(-j omega k) H(e^(j omega))
$
We then have
$
  Y(e^(j omega)) = H(e^(j omega)) sum_(k = -infinity)^infinity x[k] e^(-j omega k) = H(e^(j omega)) X(e^(j omega))
$

#attention("Convolution Property")[
  #eqalt(
    "y of n equals h of n convolved with x of n, which Fourier-transforms to Y of e to the j omega equal to H of e to the j omega times X of e to the j omega.",
    $
      y[n] = h[n] star x[n] #ftpair Y(e^(j omega)) = H(e^(j omega)) X(e^(j omega))
    $,
  )
]

#example("Obtaining Outputs in Frequency Domain")[
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

== The Multiplication Property

As in continuous time, multiplication in the time domain corresponds to convolution in the frequency domain, but the convolution is now _periodic_. Let $z[n] = x[n] y[n]$. Replacing $x[n]$ by its synthesis equation, written with the dummy frequency variable $theta$, gives
$
  Z(e^(j omega)) = sum_(n = -infinity)^infinity x[n] y[n] e^(-j omega n) = sum_(n = -infinity)^infinity [1/(2 pi) integral_(2 pi) X(e^(j theta)) e^(j theta n) "d"theta] y[n] e^(-j omega n)
$
Exchanging the sum and the integral,
$
  Z(e^(j omega)) = 1/(2 pi) integral_(2 pi) X(e^(j theta)) [sum_(n = -infinity)^infinity y[n] e^(-j (omega - theta) n)] "d"theta = 1/(2 pi) integral_(2 pi) X(e^(j theta)) Y(e^(j(omega - theta))) "d"theta
$
since the bracketed sum is the DTFT of $y[n]$ evaluated at $omega - theta$.

The integral differs from the continuous-time case in one way: it runs over a single interval of length $2 pi$, not over the whole real line. Both $X(e^(j theta))$ and $Y(e^(j(omega - theta)))$ are periodic in $theta$ with period $2 pi$, so their product is too, and integrating it over all of $RR$ would diverge (unless the product is zero). Integrating over one period, which can be any interval of length $2 pi$, gives the _periodic convolution_
$
  X(e^(j omega)) ast.op.o Y(e^(j omega)) eq.delta integral_(2 pi) X(e^(j theta)) Y(e^(j(omega - theta))) "d"theta
$
As with the continuous-time convolution, $omega$ is the variable of the result and $theta$ is integrated out. The result is itself periodic in $omega$ with period $2 pi$, as a DTFT must be.

#attention("Multiplication Property")[
  #eqalt(
    "z of n equals x of n times y of n, which Fourier-transforms to Z of e to the j omega equal to one over two pi times the integral over any two-pi-length interval of X of e to the j theta times Y of e to the j times omega minus theta, d theta.",
    $
      z[n] = x[n] y[n] #ftpair Z(e^(j omega)) = 1/(2 pi) integral_(2 pi) X(e^(j theta)) Y(e^(j(omega - theta))) "d"theta
    $,
  )
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

#note("Discrete-Time Fourier Transform Pairs")[
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

    [$a^(|n|)$, $a$ real, $|a| < 1$], [$(1 - a^2)/(1 - 2a cos omega + a^2)$], [N/A],

    [$((n + r - 1)!)/(n! (r - 1)!) a^n u[n]$, $|a| < 1$], [$1/(1 - a e^(-j omega))^r$], [N/A],

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
