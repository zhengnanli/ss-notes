#import "lib.typ": *

= Appendix: Math Review <nonumber>

== Complex numbers <nonumber>

Let $a, b in RR$, and $z in CC$, and the $j = sqrt(-1)$. The cartesian form of a complex number is expressed as $z = a + j b$, where $a = Re{z}$ and $b = Im{z}$ are the real and imaginary part of the complex number $z$, respectively. When expressed in polar form, i.e., $z = r e^(j theta)$, where $r in [0, infinity)$ and $theta in [0, 2 pi)$, $r = |z|$ and $theta = angle z$ are the magnitude and phase of the complex number $z$. We have $a = r cos theta$, and $b = r sin theta$. Of course, $r = sqrt(a^2 + b^2)$ and $theta = arctan b/a$.
Let $z_1 = a_1 + j b_1$ and $z_2 = a_2 + j b_2$, we have
$
  z_1 + z_2 = (a_1 + a_2) + j(b_1 + b_2)
$
when multiplying two complex numbers together, we have
$
  z_1 z_2 = (a_1 + j b_1) (a_2 + j b_2) = (a_1 a_2 - b_1 b_2) + j (a_1 b_2 + b_1 a_2)
$
and when dividing,
$
  z_1 / z_2 = (a_1 + j b_1) / (a_2 + j b_2) = ((a_1 + j b_1)(a_2 - j b_2)) / ((a_2 + j b_2)(a_2 - j b_2)) = ((a_1 a_2 + b_1 b_2) + j(a_2 b_1 - a_1 b_2)) / (a_2^2 + b_2^2)
$
Note that $(a + j b)(a - j b) = a^2 + b^2 = r^2$.

The complex conjugate of $z$ is $z^* = a - j b = r e^(-j theta)$. We have $z z^* = |z|^2 = r^2$, $z + z* = 2 Re{z}$, $z / z^* = e^(j 2 theta)$, $z - z^* = j 2 Im{z}$.

When it comes to powers, we have
$
  z^n = r^n e^(j n theta) = r^n (cos n theta + j sin n theta)
$

== Some useful formulas <nonumber>

1. Sum
$
  sum_(n = 0)^(N - 1) alpha^n = cases((1 - alpha^N)/(1-alpha)\, &quad alpha eq.not 1, N\, &quad alpha = 1)
$
$
  sum_(k = n)^(infinity) alpha^k = alpha^n / (1 - alpha), |alpha| < 1
$
$
  sum_(k = 0)^(infinity) alpha^k = 1 / (1 - alpha), |alpha| < 1
$
$
  sum_(k = 0)^(infinity) k alpha^k = alpha / (1 - alpha)^2, |alpha| < 1
$
$
  sum_(k = 0)^(infinity) k^2 alpha^k = (alpha^2 + alpha) / (1 - alpha)^3, |alpha| < 1
$
$
  sum_(k = 0)^(infinity) alpha^k / k! = e^alpha
$
$
  sum_(k = 1)^(infinity) (-1)^(k+1) / k alpha^k = ln (1 + alpha), |alpha|<1
$

2. Trigonometry
$
  e^(j theta) = cos theta + j sin theta
$
$
  cos theta = (e^(j theta) + e^(-j theta)) / 2, sin theta = (e^(j theta) - e^(-j theta)) / (2 j)
$
$
  sin^2 theta + cos^2 theta = 1
$
$
  sin (alpha plus.minus beta) = sin alpha cos beta plus.minus cos alpha sin beta, cos (alpha plus.minus beta) = cos alpha cos beta minus.plus sin alpha sin beta
$
$
  sin alpha sin beta &= 1/2 [cos (alpha - beta) - cos(alpha + beta)] \
  cos alpha cos beta &= 1/2 [cos (alpha - beta) + cos(alpha + beta)] \
  sin alpha cos beta &= 1/2 [sin (alpha - beta) + cos(alpha + beta)]
$

3. Taylor series for $f(x)$ at $x = alpha$ is

For a function $f: RR arrow.bar RR$ or $f : CC arrow.bar CC$, which is infinitely differentiable at some point $alpha$, the Taylor series of $f(alpha)$ is given by
$
  f(alpha) = sum_(k = 0)^infinity (f^((k)) (alpha)) / k! (x - alpha)^k
$
where $f^((k))$ is the $k$-th derivative of $f(x)$.

4. Binomial expansion
$
  (a+b)^n = sum_(k = 0)^(n) vec(n, k) a^k b^(n - k)
$

5. Some integrals
$
  integral_0^infinity x^n e^(-a x) "d" x = n! / (a^(n+1)), a > 0
$
$
  integral_0^infinity e^(-a x^2) "d" x = 1/2 sqrt(pi / a), a > 0
$
$
  integral_0^infinity x e^(-a x^2) "d"x = 1 / (2a), a > 0
$
