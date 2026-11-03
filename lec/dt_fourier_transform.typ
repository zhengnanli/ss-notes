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
#qed

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
#qed
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
If $x[n]$ is real, $x^*[n] = x[n]$, so $X(e^(j omega)) = X^*(e^(-j omega))$, or equivalently $X(e^(-j omega)) = X^*(e^(j omega))$. #qed
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
where the last step uses periodicity, $X(e^(j 2 pi k)) = X(e^(j 0))$. #qed
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

== The Multiplication Property <sec-dt-multiplication>

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


== (optional) The Discrete Fourier Transform

// The DFT pair relation, local to this section. It is written out the same way
// as the course-wide pairs in `lib.typ`.
#let dftpair = $limits(arrow.l.r)^(cal("DFT"))$

The DTFT is a function of the continuous variable $omega$, so a computer cannot store it or compute it exactly. The discrete Fourier transform (DFT) is the version of Fourier analysis a computer actually performs: it takes $N$ numbers in and gives $N$ numbers out. It is defined for finite-length sequences by considering their periodic extension, sometimes after zero-padding. Let $x[n]$ be a finite-length sequence such that $x[n] = 0$ if $n in.not [0, N-1]$. The DFT is defined as
$
  X[k] = sum_(n = 0)^(N - 1) x[n] W_N^(k n), quad k = 0, 1, dots.c, N - 1
$
where $W_N = e^(-j (2pi)/N)$.

The inverse DFT is given by
$
  x[n] = 1/N sum_(k = 0)^(N - 1) X[k] W_N^(-k n), quad n = 0, 1, dots.c, N - 1
$
We write $x[n] #dftpair X[k]$ for an $N$-point DFT pair. Comparing with the discrete-time Fourier series, $X[k] = N a_k$, where $a_k$ are the Fourier series coefficients of the periodic extension of $x[n]$.

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

Comparing the DFT with the DTFT of the same finite-length $x[n]$,
$
  X[k] = X(e^(j omega)) lr(|, size: #200%)_(omega = (2 pi k) / N) = X(e^(j (2 pi) / N k))
$
In other words, the DFT values are samples of the DTFT, taken at the $N$ equally spaced frequencies $omega_k = 2 pi k \/ N$ around the unit circle. To recover the DTFT between those samples, we interpolate the DFT values with a Dirichlet kernel, the DTFT of the length-$N$ rectangular window on which $x[n]$ is supported.

Both $X[k]$ and the inverse DFT are defined for $0 <= k, n <= N - 1$, but the formulas themselves are periodic: evaluating either one outside that range repeats the same $N$ values. The DFT therefore treats $x[n]$ as one period of a periodic sequence, and every property below is a consequence of that.

=== Circular Shift and Circular Convolution

Because the DFT sees only one period, shifting $x[n]$ moves samples off one end of the interval $[0, N - 1]$ and back in at the other. To express this, we use _modulo-$N$ indexing_: $((n))_N$ denotes the remainder of $n$ divided by $N$, taken in ${0, 1, dots.c, N - 1}$. For example, with $N = 4$, $((5))_4 = 1$ and $((-1))_4 = 3$.

#block(sticky: true)[*Circular shift.* Shifting by $m$ samples, circularly, multiplies the DFT by a linear phase:]
$
  x[((n - m))_N] #dftpair W_N^(k m) X[k]
$
_Proof._ Substitute $r = ((n - m))_N$. As $n$ runs over $0, dots.c, N - 1$, so does $r$, in a different order, and $W_N^(k n) = W_N^(k (r + m))$ since $W_N^(k N) = 1$. Hence
$
  sum_(n = 0)^(N - 1) x[((n - m))_N] W_N^(k n) = W_N^(k m) sum_(r = 0)^(N - 1) x[r] W_N^(k r) = W_N^(k m) X[k]
$
#qed

This is the DFT counterpart of the time-shifting property of the DTFT, with the ordinary shift replaced by a circular one.

#block(sticky: true)[*Circular convolution.* The $N$-point circular convolution of two length-$N$ sequences is]
$
  x_1 [n] ast.op.o x_2 [n] eq.delta sum_(m = 0)^(N - 1) x_1 [m] x_2 [((n - m))_N], quad n = 0, 1, dots.c, N - 1
$
It is ordinary convolution with the flip-and-slide performed on a circle: the flipped copy of $x_2$ wraps around instead of sliding off the end.

#attention("Circular Convolution Property")[
  $
    x_1 [n] ast.op.o x_2 [n] #dftpair X_1 [k] X_2 [k]
  $
  Multiplying two $N$-point DFTs gives the DFT of the $N$-point _circular_ convolution, not of the linear convolution.
]
_Proof._ Take the inverse DFT of the product and replace $X_1 [k]$ by its definition:
$
  1 / N sum_(k = 0)^(N - 1) X_1 [k] X_2 [k] W_N^(-k n) = sum_(m = 0)^(N - 1) x_1 [m] [1 / N sum_(k = 0)^(N - 1) X_2 [k] W_N^(-k (n - m))]
$
The bracket is the inverse DFT of $X_2 [k]$ evaluated at $n - m$. Because the inverse DFT formula is periodic in its argument with period $N$, that value is $x_2 [((n - m))_N]$, and the right-hand side is the circular convolution. #qed

#example("Circular Convolution")[
  Let $N = 4$ and
  $
    x_1 [n] = {1, 2, 3, 4}, quad x_2 [n] = {1, 1, 0, 0}, quad n = 0, 1, 2, 3
  $
  *In the time domain.* For each $n$, flip $x_2$ circularly, rotate it by $n$, and take the inner product with $x_1$:
  #align(center, table(
    columns: 6,
    align: center + horizon,
    stroke: 0.5pt,
    table.header(
      [$n$],
      [$x_2 [((n))_4]$],
      [$x_2 [((n - 1))_4]$],
      [$x_2 [((n - 2))_4]$],
      [$x_2 [((n - 3))_4]$],
      [$y[n]$],
    ),
    [0], [1], [0], [0], [1], [$1 dot 1 + 4 dot 1 = 5$],
    [1], [1], [1], [0], [0], [$1 dot 1 + 2 dot 1 = 3$],
    [2], [0], [1], [1], [0], [$2 dot 1 + 3 dot 1 = 5$],
    [3], [0], [0], [1], [1], [$3 dot 1 + 4 dot 1 = 7$],
  ))
  Row $n$ lists the weights applied to $x_1 [0], dots.c, x_1 [3]$, so $y[n] = x_1 [n] ast.op.o x_2 [n] = {5, 3, 5, 7}$.

  *Through the DFT.* With the four-point DFT matrix above,
  $
    X_1 [k] = {10, -2 + 2 j, -2, -2 - 2 j}, quad X_2 [k] = {2, 1 - j, 0, 1 + j}
  $
  so
  $
    Y[k] = X_1 [k] X_2 [k] = {20, 4 j, 0, -4 j}
  $
  The inverse DFT is $y[n] = 1/4 [20 + 4 j dot j^n - 4 j dot (-j)^n]$, which gives $y[0] = 5$, $y[1] = (20 - 4 - 4) \/ 4 = 3$, $y[2] = 5$, and $y[3] = (20 + 4 + 4) \/ 4 = 7$, the same as before.

  The linear convolution of the same two sequences is $x_1 [n] star x_2 [n] = {1, 3, 5, 7, 4}$, which has five samples. The circular result is that sequence with its last sample, $4$, wrapped around and added to the first: $1 + 4 = 5$.
]

=== Linear Convolution via the DFT

The last observation in the example holds in general. Let $x[n]$ have length $L$ and $h[n]$ have length $M$, so that their linear convolution $y[n] = x[n] star h[n]$ has length $L + M - 1$. Pad both sequences with zeros to length $N$ and form $Y[k] = X[k] H[k]$. By the convolution property of the DTFT, $Y[k]$ is the DTFT of $y[n]$ sampled at $omega_k = 2 pi k \/ N$. Substituting the DTFT into the inverse DFT,
$
  1 / N sum_(k = 0)^(N - 1) [sum_(m = -infinity)^infinity y[m] W_N^(k m)] W_N^(-k n) = sum_(m = -infinity)^infinity y[m] [1 / N sum_(k = 0)^(N - 1) W_N^(-k (n - m))] = sum_(r = -infinity)^infinity y[n - r N]
$
since the bracketed sum equals $1$ when $n - m$ is a multiple of $N$ and $0$ otherwise. So the $N$-point circular convolution is the linear convolution _aliased in time_:
$
  x[n] ast.op.o h[n] = sum_(r = -infinity)^infinity y[n - r N], quad n = 0, 1, dots.c, N - 1
$
This is the time-domain counterpart of the aliasing seen in the Sampling topic: sampling the DTFT at $N$ points makes the time sequence periodic with period $N$. If $N >= L + M - 1$, the shifted copies of $y[n]$ do not overlap, and the circular convolution equals the linear one.

#example("Choosing the DFT Length")[
  Let $x[n] = {1, 2, 3}$ and $h[n] = {1, 1, 1}$, so $L = M = 3$ and
  $
    y[n] = x[n] star h[n] = {1, 3, 6, 5, 3}
  $
  has $L + M - 1 = 5$ samples. Computing $y[n]$ as the inverse DFT of $X[k] H[k]$ with different $N$:
  - $N = 3$: $y[0] + y[3] = 6$, $y[1] + y[4] = 6$, $y[2] = 6$, giving ${6, 6, 6}$. Two samples are aliased.
  - $N = 4$: $y[0] + y[4] = 4$, then $3$, $6$, $5$, giving ${4, 3, 6, 5}$. One sample is aliased.
  - $N = 5$: ${1, 3, 6, 5, 3}$, the linear convolution, since $N = L + M - 1$.
  Any $N >= 5$ also works; the extra samples are zero.
]

This is how long convolutions are computed in practice. Zero-pad both sequences to a length $N >= L + M - 1$ (usually the next power of two), take two FFTs (see below), multiply, and take one inverse FFT. The cost grows as $N log_2 N$ rather than as $L M$ for the direct sum. For a filter applied to a very long or streaming input, the input is cut into blocks, each block is convolved this way, and the overlapping tails of consecutive outputs are added (the _overlap-add_ method).

=== Zero-Padding and Frequency Resolution

Appending zeros to $x[n]$ before taking the DFT does not change its DTFT, since the added samples contribute nothing to the sum. It only changes the number of points at which that DTFT is sampled. Padding a length-$L$ record to $N > L$ samples evaluates $X(e^(j omega))$ on a finer grid, $2 pi \/ N$ apart, which makes the plotted spectrum look smoother and locates peaks more precisely.

Zero-padding does not, however, improve _resolution_, the ability to tell two nearby frequencies apart. A record of $L$ samples is the infinitely long signal multiplied by a length-$L$ rectangular window, so by the multiplication property (@sec-dt-multiplication) its DTFT is the true spectrum convolved with the window's Dirichlet kernel. Each spectral line is smeared into a main lobe of half-width $2 pi \/ L$. Two sinusoids closer than about that are merged into one lobe, and no amount of zero-padding separates them. Only a longer record narrows the lobes.

// Two unit-amplitude cosines at 0.40 pi and 0.43 pi. Their separation, 0.03 pi,
// is less than the main-lobe half-width 2 pi / 32 = 0.0625 pi for L = 32, and
// more than 2 pi / 128 = 0.016 pi for L = 128. Both panels plot |X| / L on
// the same axes; the stems in (a) are the unpadded 32-point DFT, at the bins
// omega = 2 pi k / 32 = (k / 16) pi that fall inside the plotted range.
#let two-tones = n => calc.cos(0.40 * calc.pi * n) + calc.cos(0.43 * calc.pi * n)
#let dtft-mag = (x, w) => {
  let re = 0.0
  let im = 0.0
  for (n, v) in x.enumerate() {
    re += v * calc.cos(w * n)
    im -= v * calc.sin(w * n)
  }
  calc.sqrt(re * re + im * im)
}
#let w-zoom = lq.linspace(0.25, 0.6, num: 281)
#let rec32 = range(32).map(two-tones)
#let rec128 = range(128).map(two-tones)
#altfig(
  alt: "Two plots of normalized DTFT magnitude against omega over pi, from 0.25 to 0.6. Left, a 32-sample record: the zero-padded spectrum is a single broad lobe peaking near 0.415, and the six stems of the unpadded 32-point DFT, at multiples of one sixteenth, sample that lobe coarsely. Right, a 128-sample record of the same signal: two narrow, separate peaks of height about one half at 0.40 and 0.43, marked by dashed vertical lines.",
  caption: [
    $x[n] = cos(0.40 pi n) + cos(0.43 pi n)$, magnitude spectrum $|X(e^(j omega))| \/ L$.
    (a) $L = 32$: the 32-point DFT (stems) and the same record zero-padded to
    a fine grid (curve) show one lobe. (b) $L = 128$: the longer record
    resolves the two tones, marked by the dashed lines.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      cdiagram(
        title: [(a) $L = 32$],
        xlabel: $omega \/ pi$,
        width: 6.5cm,
        height: 4cm,
        xlim: (0.25, 0.6),
        ylim: (0, 0.8),
        yaxis: (position: 0.25, ticks: (0.5,)),
        xaxis: (ticks: (0.3, 0.4, 0.5)),
        lq.place(0.25, 0.5, align: right, pad(right: 3pt, plabel[$1\/2$])),
        ..(0.3, 0.4, 0.5).map(v => lq.place(v, -0.07, align: top, plabel[#v])),
        lq.plot(
          w-zoom,
          w-zoom.map(w => dtft-mag(rec32, w * calc.pi) / 32),
          mark: none,
        ),
        lq.stem(
          range(4, 10).map(k => k / 16),
          range(4, 10).map(k => dtft-mag(rec32, k * calc.pi / 16) / 32),
          color: c-blue,
        ),
      ),
      cdiagram(
        title: [(b) $L = 128$],
        xlabel: $omega \/ pi$,
        width: 6.5cm,
        height: 4cm,
        xlim: (0.25, 0.6),
        ylim: (0, 0.8),
        yaxis: (position: 0.25, ticks: (0.5,)),
        xaxis: (ticks: (0.3, 0.4, 0.5)),
        lq.place(0.25, 0.5, align: right, pad(right: 3pt, plabel[$1\/2$])),
        ..(0.3, 0.4, 0.5).map(v => lq.place(v, -0.07, align: top, plabel[#v])),
        lq.vlines(0.40, 0.43, stroke: (paint: c-muted, dash: "dashed")),
        lq.plot(
          w-zoom,
          w-zoom.map(w => dtft-mag(rec128, w * calc.pi) / 128),
          mark: none,
        ),
      ),
    )
  ],
) <fig-dft-resolution>

In @fig-dft-resolution, the tones are $0.03 pi$ apart. With $L = 32$ the main-lobe half-width is $2 pi \/ 32 approx 0.06 pi$, so the two lobes merge into one peak, and padding only traces that single peak more finely. With $L = 128$ the half-width is $2 pi \/ 128 approx 0.016 pi$, smaller than the spacing, and two peaks appear. As a rule of thumb, resolving two frequencies $Delta omega$ apart requires a record of at least $L approx 2 pi \/ Delta omega$ samples, whatever the DFT length.

=== Windowing and Spectral Leakage

The rectangular window causes a second effect, visible even with a single sinusoid. Let $x[n] = cos(omega_0 n)$, $0 <= n <= N - 1$. If $omega_0 = 2 pi k_0 \/ N$ for an integer $k_0$, the record holds a whole number of periods, its periodic extension is the original cosine, and the DFT is zero except at $k = k_0$ and $k = N - k_0$. If $omega_0$ falls between two bins, the periodic extension has a jump where the end of the record meets its start. The DFT then samples the Dirichlet kernel away from its zeros, and every bin picks up some energy. This spreading of a single frequency across the whole spectrum is called _spectral leakage_.

Leakage is controlled by the shape of the window, not its length. Multiplying the record by a window $w[n]$ that tapers to zero at both ends removes the jump. A common choice is the Hann window,
$
  w[n] = 1 / 2 [1 - cos((2 pi n) / (L - 1))], quad 0 <= n <= L - 1
$
By the multiplication property, the DTFT of the windowed record is the true spectrum convolved with $W(e^(j omega))$, so the window's own DTFT decides what the spectrum looks like:
- The _main lobe_ sets the resolution. The rectangular window has the narrowest main lobe, with first nulls at $plus.minus 2 pi \/ L$; the Hann window's main lobe is twice as wide, with nulls near $plus.minus 4 pi \/ L$.
- The _side lobes_ set the leakage. The highest side lobe of the rectangular window is only $13$ dB below the peak, so a weak tone near a strong one can be hidden under the strong tone's side lobes. The Hann window's highest side lobe is about $31$ dB down, and its side lobes decay much faster.

Choosing a window is therefore a trade-off between resolution and leakage. A longer record improves both.

// N = 32-point DFTs of a unit cosine, bins k = 0 .. 16 (the rest mirror these).
// k0 = 4 is on a bin, k0 = 4.5 is halfway between bins 4 and 5. The window
// spectra in (c) are 20 log10 of |W| / W(0) for L = 32, clamped at -90 dB so
// the exact nulls of the rectangular window do not send the curve to -inf.
#let dft-bins = range(17)
#let cos-dft = (k0, k) => dtft-mag(
  range(32).map(n => calc.cos(2 * calc.pi * k0 * n / 32)),
  2 * calc.pi * k / 32,
)
#let rect32 = range(32).map(n => 1.0)
#let hann32 = range(32).map(n => 0.5 * (1 - calc.cos(2 * calc.pi * n / 31)))
#let w-full = lq.linspace(0, 1, num: 401)
#let win-db = (win, w) => {
  let mag = dtft-mag(win, w * calc.pi) / win.sum()
  calc.max(-90, 20 * calc.log(calc.max(mag, 1e-9), base: 10))
}
#altfig(
  alt: "Three plots. Left: the 32-point DFT magnitude of a cosine exactly on bin 4, a single stem of height 16 at k equals 4 and zeros elsewhere. Middle: the same for a cosine at bin 4.5, two stems near 10 at k equals 4 and 5 and smaller stems that decay slowly across all other bins. Right: window spectra in decibels against omega over pi from 0 to 1 for length 32; the rectangular window, solid, has a narrow main lobe and side lobes starting near minus 13 dB that decay slowly; the Hann window, dashed, has a main lobe twice as wide and side lobes starting near minus 31 dB that fall off quickly.",
  caption: [
    Spectral leakage. A 32-point DFT of $cos(2 pi k_0 n \/ 32)$ with (a) $k_0 = 4$,
    on a bin, and (b) $k_0 = 4.5$, between bins. (c) The DTFTs of the
    length-32 rectangular (solid) and Hann (dashed) windows, in dB.
  ],
  align(center)[
    #grid(
      columns: (1fr, 1fr, 1.3fr),
      column-gutter: 1.2em,
      cdiagram(
        title: [(a) $k_0 = 4$],
        xlabel: $k$,
        width: 4cm,
        height: 3.5cm,
        ylim: (0, 17),
        xaxis: (ticks: (4, 8, 12, 16)),
        yaxis: (ticks: (16,)),
        lq.place(0, 16, align: right, pad(right: 3pt, plabel[16])),
        ..(4, 8, 12, 16).map(v => lq.place(v, -1.2, align: top, plabel[#v])),
        lq.stem(dft-bins, dft-bins.map(k => cos-dft(4, k))),
      ),
      cdiagram(
        title: [(b) $k_0 = 4.5$],
        xlabel: $k$,
        width: 4cm,
        height: 3.5cm,
        ylim: (0, 17),
        xaxis: (ticks: (4, 8, 12, 16)),
        yaxis: (ticks: (16,)),
        lq.place(0, 16, align: right, pad(right: 3pt, plabel[16])),
        ..(4, 8, 12, 16).map(v => lq.place(v, -1.2, align: top, plabel[#v])),
        lq.stem(dft-bins, dft-bins.map(k => cos-dft(4.5, k))),
      ),
      cdiagram(
        title: [(c) $20 log_10 (|W(e^(j omega))| \/ W(e^(j 0)))$],
        xlabel: $omega \/ pi$,
        width: 5.5cm,
        height: 3.5cm,
        ylim: (-90, 0),
        xaxis: (position: -90, ticks: (0.5, 1)),
        yaxis: (ticks: (-31, -13)),
        lq.hlines(-13, -31, stroke: (paint: c-muted, dash: "dotted", thickness: 0.5pt)),
        lq.place(0, -13, align: right, pad(right: 3pt, plabel[$-13$])),
        lq.place(0, -31, align: right, pad(right: 3pt, plabel[$-31$])),
        ..(0.5, 1).map(v => lq.place(v, -96, align: top, plabel[#v])),
        lq.plot(w-full, w-full.map(w => win-db(rect32, w)), mark: none),
        lq.plot(
          w-full,
          w-full.map(w => win-db(hann32, w)),
          mark: none,
          stroke: series-stroke(1),
        ),
      ),
    )
  ],
) <fig-dft-leakage>

In @fig-dft-leakage(b), the off-bin tone appears in every bin, its energy falling off only slowly away from $k = 4.5$. That slow decay is the rectangular window's side lobes in (c). With a Hann window, the same tone would occupy a few bins around $k = 4.5$ and leave the rest nearly empty, at the price of a wider peak.

=== The Fast Fourier Transform

Computing all $N$ values of $X[k]$ directly from the definition takes $N$ complex multiplications per value, or $N^2$ in total. The fast Fourier transform (FFT) is a family of algorithms that computes exactly the same $N$ values with on the order of $N log_2 N$ operations, using divide-and-conquer. The simplest is the _radix-2 decimation-in-time_ FFT, for $N$ a power of two.

Split the sum into its even- and odd-indexed samples, $n = 2 r$ and $n = 2 r + 1$, and use $W_N^2 = W_(N\/2)$:
$
  X[k] = sum_(r = 0)^(N\/2 - 1) x[2 r] W_(N\/2)^(r k) + W_N^k sum_(r = 0)^(N\/2 - 1) x[2 r + 1] W_(N\/2)^(r k) = G[k] + W_N^k H[k]
$
where $G[k]$ and $H[k]$ are the $(N\/2)$-point DFTs of the even and odd samples. Both are periodic in $k$ with period $N \/ 2$, and $W_N^(k + N\/2) = -W_N^k$, so the second half of the outputs reuses the same two numbers:
$
  X[k] = G[k] + W_N^k H[k], quad X[k + N/2] = G[k] - W_N^k H[k], quad k = 0, 1, dots.c, N/2 - 1
$
Each pair costs one multiplication, by the _twiddle factor_ $W_N^k$, and one addition and one subtraction. The flow graph of this step, drawn in @fig-fft-butterfly, is called a _butterfly_.

#altfig(
  alt: "A butterfly flow graph. Two inputs on the left, G of k at the top and H of k at the bottom. The H of k branch is multiplied by the twiddle factor W sub N to the k. Lines from both inputs cross to two outputs on the right: the top output X of k is G of k plus W sub N to the k H of k, and the bottom output X of k plus N over 2 is G of k minus W sub N to the k H of k, the minus sign marked on the crossing branch.",
  caption: [
    The radix-2 butterfly: one complex multiplication by $W_N^k$ produces
    two outputs, $X[k]$ and $X[k + N\/2]$.
  ],
  align(center)[
    #diagram(
      node-stroke: none,
      spacing: (2.5em, 2em),
      mark-scale: 100%,
      node((0, 0), $G[k]$, name: <g>),
      node((0, 1), $H[k]$, name: <h>),
      node((1, 0), $bullet$, name: <a>),
      node((1, 1), $bullet$, name: <b>),
      node((3, 0), $bullet$, name: <c>),
      node((3, 1), $bullet$, name: <d>),
      node((4, 0), $X[k]$, name: <x0>),
      node((4, 1), $X[k + N\/2]$, name: <x1>),
      edge(<g>, <a>, "-"),
      edge(<h>, <b>, "-|>", $W_N^k$, label-side: right),
      edge(<a>, <c>, "-|>"),
      edge(<a>, <d>, "-|>"),
      edge(<b>, <c>, "-|>"),
      edge(<b>, <d>, "-|>", $-1$, label-pos: 0.75, label-side: right),
      edge(<c>, <x0>, "-"),
      edge(<d>, <x1>, "-"),
    )
  ],
) <fig-fft-butterfly>

The two $(N\/2)$-point DFTs are split the same way into four $(N\/4)$-point DFTs, and so on, until only 2-point DFTs, which are single butterflies, remain. There are $log_2 N$ stages, each made of $N \/ 2$ butterflies, so the whole transform takes $(N\/2) log_2 N$ complex multiplications. For $N = 1024$ this is $5120$, against about $10^6$ for the direct sum, a factor of $200$. This saving is what made the DFT, and the fast convolution described above, practical.

Exercise: show how a DFT routine can compute the IDFT.
