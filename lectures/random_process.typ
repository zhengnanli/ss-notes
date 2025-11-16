#import "lib.typ": *

= Random Processes
#show: lq.theme.schoolbook
#show: schoolbook-style

== Probability Review

=== Axioms of probability

$PP{A}$ is the probability of event $A$. The three axioms of probability states that
- $PP{A} >= 0$
- $PP{Omega} = 1$
- $PP{A union B} = PP{A} + PP{B}$ if $A union B = emptyset$.

Two events, the probability of event $A$ given event $B$ is $PP{A|B} = P{A} P{B|A}$. The total probability is $PP{A, B} = PP{A} PP{B|A}$. The formal definition of total probability is, for events ${A_i}$ that are mutually exclusive (disjoint) and exhaustive, viz., $union_i A_i = Omega$, we have
$
  PP{B} = sum_i PP{A_i} PP{B|A_i}
$

=== Probability distribution
Random variables are a mapping of events into numbers (real), e.g., $xi in A <-> X in (a, b)$. The cumulative distribution function is defined as $F_X (x) = PP {X <= x}$.

- For discrete random variables, the probability mass function is the probability of a specific outcome $x_i$, viz., $P_X (x_i) = PP {X = x_i}, i = 1, dots.c, N$. $sum_i P_X (x_i) = 1$. The cumulative distribution function is then defined as $F_X (k) = PP {X <= k} = sum_(i=1)^k P_X (i)$.
- For continuous random variables, the probability density function is defined as $f_X (x) = ("d" F_X (x))/("d" x)$. In other words, $F_X (x) = integral_(-infinity)^x f_X (xi) "d" xi$ and $integral_(-infinity)^(infinity) f_X (x) "d" x = 1$.

=== Common distribution
We list a few common distributions, continuous and discrete

- Uniform: $X ~ cal(U)(a, b)$. $f_X (x) = 1/(b-a), x in (a, b)$ and $0$ otherwise.
- Gaussian: $X ~ cal(N)(m, sigma^2)$. $f_X (x) = 1 / (sqrt(2 pi) sigma) exp (- (x - m)^2 / (2 sigma^2))$.
- Exponential: $f_X (x) = lambda exp (-lambda x), x >= 0$.
- Bernoulli: $P_X (1) = p, P_X (0) = 1 - p, f_X (x) = (1 - p) delta (x - 0) + p delta (x - 1)$.
- Binomial: $X ~ cal(B) (p, n)$. $P_K (k) = vec(n, k) p^k (1 - p)^(n - k), k = 0, 1, dots.c, n$.

=== Joint and conditional distributions
- $F_(X|A) (x|A) = (PP{X <= x, A}) / (PP{A})$, $f_(X|A) (x|A) = ("d" F_(X|A) (x|A)) / ("d" x)$.
- $PP {A} = integral_RR f_X (x) PP{A|X=x} "d" x$

#example("Which signal source is transmitting?")[
  A signal $X$ is observed. We know that it comes from either from source $S_0$ or source $S_1$. The sources are independent, and each generates a realization of a Gaussian r.v. $X$ with same variance, but while $S_0$ has zero mean, and $S_1$ has a non-zero mean $m$.

  In other words, we know that $X|S_0 ~ cal(N) (0, sigma^2)$ and $X|S_1 ~ cal(N) (m, sigma^2)$. Upon observing a particular realization $X = x$, we compare $PP{S_0|X=x}$ and $PP{S_1|X=x}$ and decide in favor of the greater. We have,

  $
    PP{S_0|X=x} = (PP{S_0} f_(X|S_0) (x|S_0))/(f_X (x))
  $
  and
  $
    PP{S_1|X=x} = (PP{S_1} f_(X|S_1) (x|S_1))/(f_X (x))
  $
  We therefore would like to compare the following
  $
    PP{S_0|X=x} gt.lt_(S_1)^(S_0) PP{S_1|X=x} <=> (f_(X|S_0) (x|S_0))/(f_(X|S_1) (x|S_1)) gt.lt_(S_1)^(S_0) (PP{S_1})/(PP{S_0}) <=> x gt.lt_(S_1)^(S_0) m/2 + sigma^2/m ln (PP{S_0})/(PP{S_1}) = gamma
  $
  If we are given $PP{S_0}$, $PP{S_1}$, all we need to do is to compare the outcome (received signal) $x$ with the threshold $gamma$.
]

=== Joint distributions
- $F_(X Y) (x, y) = PP{X <= x, Y <= y}$, $f_(X Y) (x, y) = (partial^2 F_(X Y) (x, y))/(partial x partial y)$.
- If $F_(X Y) (x, y) = F_X (x) F_Y (y)$, i.e., $f_(X Y) (x, y) = f_X (x) f_Y (y)$, we say that $X$ and $Y$ are independent.
- $f_X (X) = integral_RR f_(X Y) (x, y) "d" y$ is the marginal distribution of $Y$.
- Joint Gaussian distribution:
$
  f_(X Y) (x, y) = 1 / (2 pi sigma_X sigma_Y sqrt(1 - rho^2)) exp{-(1 / (1-rho^2)) [ (x - m_X)^2 / (2 sigma_X^2) - rho ((x - m_X) (y - m_Y)) / (sigma_X sigma_Y) + (y - m_Y)^2 / (2 sigma_Y^2)] }
$
where $rho$ is the correlation coefficient, and $|rho| < 1$. Let $bold(z) = vec(x, y), bold(m) = vec(m_X, m_Y)$, and $bold(C) = mat(sigma_X^2, rho sigma_x sigma_y; rho sigma_X sigma_Y, sigma_Y^2)$, we have
$
  f_(X Y) (x, y) = 1 / (2 pi sqrt(det bold(C))) exp{-1/2 (bold(z) - bold(m))^prime bold(C)^(-1) (bold(z) - bold(m))}
$

=== Expectations and moments
- $EE{X} = macron(X) = m_X$
- For discrete $EE{X} = sum_i x_i P_X (x_i)$, and for continuous $EE{X} = integral_RR x f_X (x) "d" x$.
- $EE{g(X)} = integral_RR g(x) f_X (x) "d" x$.
- Variance $sigma_X^2 = EE{|X - m_X|^2}$.


== Random Processes

A random variable $X$ is a mapping of a particular outcome $xi$ to its distribution, i.e., $xi -> X(xi) = X$. A particular output $xi$ yields a particular realization of the random variable, $X = x$, a number. A random process $X(t, xi)$ maps a particular outcome $xi$ to a particular realization of the random process, $X(t) = x(t)$. For example, we have a bag full of sinusoids with random amplitudes and random phases.
$
  X(t) = A sin (2 pi f_0 t + phi); A ~ f_A (a), phi ~ f_Phi (phi)
$
A particular realization $A = a$ and $Phi = phi$ yields a deterministic function $x(t) = a sin (2 pi f_0 t + phi)$. Another example is the stock market. Below, we plot the trend of Standard and Poor's 500 index evolving over time for each calendar month. The picture represents the ensemble $X(t)$. If we "cut the ensemble horizontally", i.e., at a fixed realization $xi = xi_0$, $X(t, xi_0) = x(t, xi_0)$ is a deterministic function. Note that $X(dot.c)$ is the random variable and $x$ is a particular realization. If we then "cut the ensemble vertically", i.e., at a given time $t = t_0$, $X(t_0, xi) = X_(t_0) (xi)$ is a random variable. It has different possible realizations. If we cut both, at a fixed realization and a fixed time, $X(t_0, xi_0) = x_(t_0)$ is a number.

// #align(center)[#image("random_process.png", height: 10cm)]

== Statistical Description of a Random Process

The distribution of $X_t$ is described by the cumulative distribution function (CDF), and the corresponding probability density function (PDF):
$
  F_X (x; t) = cal(P){X(t) <= x}; f_X (x; t) = partial/(partial x) F_X (x; t)
$

We list a few instances of moments:

- Mean: $m_x (t) = cal(E){ x(t) } = integral_(RR) x f_X (x; t) "d" x$
- Auto-correlation: $R_X (t_1, t_2) = cal(E){ X(t_1) X^*(t_2) } = integral_RR x_1 x_2^* f_X (x_1, x_2; t_1, t_2) "d" x_1 "d" x_2$
- Auto-covariance:
#set math.equation(numbering: none)
$
  C_X (t_1, t_2) = cal(E){ [X(t_1) - m_X (t_1)] [X(t_2) - m_X (t_2)]^* } = integral_RR [x_1 - m_X (t_1)] [x_2 - m_X (t_2)]^* f_X (x_1, x_2; t_1, t_2) "d" x_1 "d" x_2
$
- Relationship between $R_X (t_1, t_2)$ and $C_X (t_1, t_2)$
$
  R_X (t_1, t_2) = C_X (t_1, t_2) + m_X (t_1) m_X^* (t_2) <= sqrt(R_X (t_1, t_1) R_X (t_2, t_2))
$
- $cal(E) { |X^2 (t)| } = R_X (t, t), sigma_X^2 = C_X (t, t)$
- Correlation coefficient
$
  rho_X (t_1, t_2) = (C_X (t_1, t_2)) / sqrt(C_X (t_1, t_1) C_X (t_2, t_2))
$

== Joint Processes

We are now discussing the joint processes of random process $X(t)$ and $Y(t)$. A few more definitions:
- Cross-correlation: $R_(X Y) (t_1, t_2) = cal(E) { X(t_1) Y^* (t_2) }$
- Cross-covariance: $C_(X Y) (t_1, t_2) = cal(E) { [X(t_1) - m_X (t_1)] [Y(t_2) - m_Y (t_2)]^*}$
- Independent: $f_(X Y) = f_X f_Y$
- Orthogonal: $R_(X Y) = 0$
- Uncorrelated: $R_(X Y) = m_X m_Y$
- Independent implies uncorrelated, but not the other way around.


== Stationarity and Ergodicity

- Strict sense stationary (SSS): $X(t + tau)$ has the same statistics as $X(t)$, $forall t$, i.e.,
$
  f_X (x; t) = f_X (x; t + tau) equiv f_X (x)
$
- Wide sense stationary (WSS):
$
  m_X (t + tau) = m_X (t) equiv m_X; R_X (t_1, t_2) = R_X (t_1 + tau, t_2 + tau) equiv R_X (t_1 - t_2)
$
- Cyclo-stationary process: for a period $T$
  - Strict sense: $f_X (x; t+T) = f_X (x; t)$, $forall t$
  - Wide sense: $m_X (t) = m_X (t + T), R_X (t_1, t_2) = R_X (t_1 + T, t_2 + T)$

- Ergodicity for WSS process:
$
  lim_(T -> infinity) 1/(2 T) integral_(-T)^T X(t) "d"t = m_x \
  cal(E){|hat(m)_X - m_X|^2} = 1 / (2 T) integral_(-T)^T C_X (Delta t) [1 - (|Delta t|)/(2 T)] "d" Delta t
$
$X(t)$ is ergodic in the mean sense iff. $cal(E){|hat(m)_X - m_X|^2} -> 0$ as $T -> infinity$.

== Power Spectral Density

The random process $X(t)$ is said to be WSS stationary if
$
  R_X (t + Delta t, t) = cal(E){ X(t + Delta t) X^* (t)} = R_X (Delta t)
$
The corresponding power spectral density is defined as
$
  S_X (f) = cal(F){R_X (Delta t)} = integral_RR R_X (Delta t) e^(-j 2 pi f Delta t) "d" Delta t
$
and the inverse process is defined via inverse Fourier transform as
$
  R_X (Delta t) = cal(F)^(-1){S_X (Delta t)} = integral_RR S_X (f) e^(j 2 pi f Delta t) "d" f
$

A special case when $Delta t = 0$:
$
  R_X (0) = cal(E) {|X^2 (t)|} = integral_RR S_X (f) "d" f
$
where the $cal(E) {|X^2 (t)|}$ is the power of the signal, and $S_X (f)$ is the power spectral _density_ (psd). A white process (white noise) is said to have $S_X (f) = S_X$, i.e., a constant power spectral density. In other words, $R_X (Delta t) = S_X delta (Delta t)$. Samples of a zero-mean white process, taken arbitrarily close together, are uncorrelated. If the process' distribution is further Gaussian, the samples are also independent.

== LTI System Response to Random Signals

Consider a linear time-invariant system that is characterized by its impulse response $h(t)$, or, equivalently, by its frequency response $H(f)$, where $h(t)$ and $H(f)$ are a Fourier transform pair. Let $x(t)$ be the input signal to the system and $y(t)$ denote the output signal. The output of the system may be expressed in terms of the convolution integral as
$
  y(t) = integral_RR h(tau) x(t - tau) "d" tau
$

Suppose that $x(t)$ is a sample function of a stationary stochastic process $X(t)$. Then the output $y(t)$ is a sample function of a stochastic process $Y(t)$. We wish to determine the mean and autocorrelation functions of the output.

Since the convolution is a linear operation performed on the input signal $x(t)$, the expected value of the integral is equal to the integral of the expected value. Thus
$
  m_Y = cal(E) {Y(t)} = integral_RR cal(E){h(tau) X(t - tau)} "d" tau = integral_RR h(tau) cal(E){X(t - tau)} "d" tau
$
If the process $X(t)$ is also stationary, i.e., $cal(E) {X(t - tau)} = cal(E) {X(t)} = m_X$,
$
  m_Y = m_X integral_RR h(tau) "d" tau = m_X H(0)
$

The autocorrelation function of the output is
$
  R_(Y) (t_1, t_2) = cal(E) { Y(t_1) Y^*(t_2)} &= cal(E) { integral_RR h(tau_1) X(t_1 - tau_1) "d" tau_1 integral_RR h^*(tau_2) X^*(t_2 - tau_2) "d" tau_2 } \
  &= integral_RR integral_RR h(tau_1) h^*(tau_2) cal(E){X(t_1 - tau_1) X^*(t_2 - tau_2)} "d" tau_1 "d" tau_2 \
  &= integral_RR integral_RR h(tau_1) h^*(tau_2) R_X (t_1 - t_2 + tau_2 - tau_1) "d" tau_1 "d" tau_2
$

If the process is further assumed wide sense stationary,
$
  R_Y (tau) = integral_RR integral_RR h(tau_1) h^* (tau_2) R_X (tau + tau_2 - tau_1) "d" tau_1 "d" tau_2
$

The power spectral density of the output, $S_Y (f)$ is then
$
  S_Y (f) = cal(F) {R_Y (tau)} &= integral_RR R_Y (tau) e^(-j 2 pi f tau) "d" tau \
  &= integral_RR integral_RR integral_RR h(tau_1) h^*(tau_2) R_Y (tau + tau_2 - tau_1) e^(-j 2 pi f tau) "d" tau "d" tau_1 "d" tau_2 \
$

Letting $u = tau + tau_2 - tau_1$, we have
$
  S_Y (f) &= integral_RR h(tau_1) e^(-j 2 pi f tau_1) "d" tau_1 dot.c integral_RR h^*(tau_2) e^(j 2 pi f tau_2) "d" tau_2 integral_RR R_X (u) e^(-j 2 pi f u) "d" u \
  &= H^*(f) H(f) S_X (f) = S_X (f) dot.c |H(f)|^2
$

#example("Random Process")[
  A random process $X(t)$ has zero mean and $R_X (t_1, t_2) = min(t_1, t_2)$. Consider a new process $Y(t) = e^t X(e^(-2 t))$. Suppose $Y(t)$ passes through a LTI system to yield an output $Z(t)$ according to
  $
    "d"/("d" t) Z(t) + 2 Z(t) = "d" / ("d" t) Y(t) + Y(t)
  $
  Find $R_Z (tau)$.

  The system response is given by
  $
    H(omega) = (1 + j omega) / (2 + j omega)
  $
  The magnitude therefore is
  $
    |H(omega)|^2 = (1 + omega^2) / (4+omega^2)
  $
  Hence, the output autocorrelation function is
  $
    R_Y (tau) = e^(-|tau|) <-> S_Y (omega) = 2 / (1 + omega^2)
  $
  and
  $
    S_Z (omega) = |H(omega)|^2 S_Y (omega) = 2 / (4 + omega^2)
  $
  Hence,
  $
    R_Z (tau) = 1/2 e^(-2|tau|)
  $
]
