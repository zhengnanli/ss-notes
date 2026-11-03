#import "lib.typ": *

= The Laplace Transform
#show: lq.theme.schoolbook
#show: schoolbook-style

#let quadratic(a, b, c) = {
  let disc = b * b - 4 * a * c
  let re = -b / (2 * a)

  if disc < 0 {
    let im = calc.sqrt(-disc) / (2 * a)
    ((re, re), (im, -im))
  } else {
    let sqrt-d = calc.sqrt(disc)
    (((re + sqrt-d / (2 * a)), (re - sqrt-d / (2 * a))), (0, 0))
  }
}

In the previous topic, we saw that the response of a linear time-invariant system with impulse response $h(t)$ to a complex exponential input of the form $e^(s t)$ is
$
  y(t) = H(s) e^(s t)
$
where
$
  H(s) = integral_RR h(t) e^(- s t) "d"t
$

For $s$ imaginary (i.e., $s = j omega$), the integral in the above equation corresponds to the Fourier transform of $h(t)$. For general values of the complex variable $s$, it is referred to as the _Laplace transform_.

#definition("The Laplace Transform")[
  The Laplace Transform of a general signal $x(t)$ is defined as
  #eqalt(
    "Capital X of s equals the integral over all real t of x of t times e to the minus s t, d t.",
    $
      X(s) = integral_RR x(t) e^(- s t) "d"t
    $,
  ) <laplace>
  For convenience, we will sometimes denote the Laplace transform in operator form as $cal(L){x(t)}$, and denote the transform relationship between $x(t)$ and $X(s)$ as $x(t) #lpair X(s)$. Note that when $s = j omega$, the Laplace transform becomes
  $
    X(j omega) = integral_RR x(t) e^(-j omega t) "d"t
  $
  which corresponds to the Fourier transform of $x(t)$, i.e.,
  $
    X(s)lr(|, size: #100%)_(s = j omega) = cal(F){x(t)}
  $
]

#example("Laplace Transform and Fourier Transform")[
  Let the signal $x(t) = e^(-a t) u(t)$. The Fourier transform $X(j omega)$ converges for $a > 0$, and is given by
  $
    X(j omega) = integral_RR e^(-a t) u(t) e^(-j omega t) "d"t = integral_0^infinity e^(-a t) e^(-j omega t) "d"t = 1 / (j omega + a), quad a > 0
  $

  The Laplace transform is
  $
    X(s) = integral_RR e^(-a t) u (t) e^(-s t) "d"t = integral_0^infinity e^(-(s + a) t)"d"t
  $
  or, with $s = sigma + j omega$,
  $
    X(sigma + j omega) = 1 / ((sigma + a) + j omega), quad sigma + a > 0
  $
  or equivalently, since $s = sigma + j omega$ and $sigma = Re{s}$,
  $
    X(s) = 1 / (s + a), quad Re{s} > -a
  $
  That is,
  $
    e^(-a t) u(t) #lpair 1 / (s + a), quad Re{s} > -a
  $
  For example, for $a = 0$, $x(t)$ is the unit step with Laplace transform $X(s) = 1 / s$, $Re{s} > 0$. Now let
  $
    x(t) = -e^(-a t) u(-t)
  $
  Then,
  $
    X(s) = - integral_RR e^(-a t) e^(-s t) u(-t) "d"t = - integral_(-infinity)^0 e^(-(s+a) t) "d"t = 1/(s+a)
  $
  For convergence in this example, we require that $Re{s + a} < 0$, or $Re{s} < -a$, that is
  $
    -e^(-a t) u(-t) #lpair 1/(s+a), quad Re{s} < -a
  $
] <ex-laplace-fourier>

In specifying the Laplace transform of a signal, both the *algebraic expression* and *the range of values* of $s$ for which this expression is valid are required. The range of values of $s$ for which the integral in @laplace converges is referred to as the _region of convergence_ (ROC). // A convenient way to display the ROC is shown below for $Re{s} > -a$.

#example("Examples of Laplace Transform")[
  In this example, we consider a signal that is the sum of a real and a complex exponential:
  $
    x(t) = e^(-2 t) u(t) + e^(-t) (cos 3t) u(t)
  $
  Using Euler's relation, we can write
  $
    x(t) = [e^(-2 t) + 1/2 e^(-(1 - 3j) t) + 1/2 e^(-(1 + 3j) t)] u(t)
  $
  and the Laplace transform of $x(t)$ then can be expressed as
  $
    X(s) = integral_RR e^(-2 t) u(t) e^(-s t) "d"t + 1/2 integral_RR [e^(-(1-3j)t) + e^(-(1+3j) t)] u(t) e^(-s t) "d"t
  $
  It follows that
  $
         e^(-2 t) u(t) & #lpair 1 / (s + 2),      & Re{s} > -2 \
    e^(-(1-3j) t) u(t) & #lpair 1 / (s + (1-3j)), & Re{s} > -1 \
    e^(-(1+3j) t) u(t) & #lpair 1 / (s + (1+3j)), & Re{s} > -1 \
  $
  For all three Laplace transforms to converge simultaneously, we must have $Re{s} > -1$. Consequently, the Laplace transform of $x(t)$ is
  #eqalt(
    "Capital X of s equals one over s plus two, plus one half times one over s plus the quantity one minus three j, plus one half times one over s plus the quantity one plus three j; which simplifies to two s squared plus five s plus twelve, all over the product of s squared plus two s plus ten and s plus two, valid for the real part of s greater than minus one.",
    $
      X(s) = 1/(s+2) + 1/2[1/(s + (1-3j))] + 1/2[1/(s + (1+3j))] = (2 s^2 + 5s + 12)/((s^2 + 2s + 10)(s + 2)), quad Re{s} > -1
    $,
  ) <xs>

  A convenient way to display the ROC is the pole-zero plot in @fig-roc1. The shaded area is $Re{s} > -1$. Except for a scaling factor, the numerator and denominator polynomials in a rational Laplace transform can be specified by their roots. The roots of the numerator polynomial are commonly referred to as the _zeros_, denoted by $circle$ on the plot, and the roots of the denominator polynomial are referred to as the _poles_ of $X(s)$, marked by $times$.


  #let zeros = quadratic(2, 5, 12)
  #let poles-quadratic = quadratic(1, 2, 10)
  #let poles = (poles-quadratic.at(0) + (-2,), poles-quadratic.at(1) + (0,))

  #altfig(
    alt: "Pole-zero plot of X(s) in the complex s-plane. Poles, marked with crosses, are at s equals minus two and at s equals minus one plus or minus three j. Zeros, marked with circles, are at the two roots of 2 s squared plus 5 s plus 12. The region of convergence is shaded to the right of the line Re of s equals minus one.",
    caption: [
      Pole-zero plot of $X(s)$ with its region of convergence shaded. The ROC is
      bounded on the left by the rightmost poles, at $s = -1 plus.minus 3 j$,
      and contains no poles.
    ],
    align(center)[
      #lq.diagram(
        xlabel: $Re$,
        ylabel: $Im$,
        height: 4cm,
        width: 5cm,
        ylim: (-4, 4),
        xlim: (-3, 1.5),
        xaxis: (ticks: (-3, -2, -1, 0, 1), subticks: none),
        yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
        // The shading goes down first: drawn last it covers the two poles that
        // sit on its own boundary, which are the ones the reader needs to see.
        lq.rect(
          -1,
          -5,
          width: 3,
          height: 10,
          fill: c-blue.lighten(70%).transparentize(35%),
        ),
        lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
          center + horizon,
          text(mark.fill)[$circle$],
        )),
        lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
          center + horizon,
          text(mark.fill)[$times$],
        )),
        lq.place(-1, -0.5, align: center, plabel[$-1$]),
        lq.place(-0.25, 1, align: center, plabel[$1$]),
        lq.place(0.2, 3.4, align: left, plabel[$Re{s} > -1$]),
      )
    ],
  ) <fig-roc1>
]

== The Inverse Laplace Transform

As @ex-laplace-fourier suggests, the Laplace transform of a signal can be interpreted as the Fourier transform of an exponentially weighted version of the signal: with $s = sigma + j omega$, the Laplace transform of a signal $x(t)$ is
$
  X(sigma + j omega) = cal(F){x(t) e^(-sigma t)} = integral_RR x(t) e^(-sigma t) e^(-j omega t) "d"t
$
for values of $s = sigma + j omega$ in the ROC. We can invert this relationship using the inverse Fourier transform. We have
$
  x(t) e^(-sigma t) = cal(F)^(-1){X(sigma + j omega)} = 1/(2 pi) integral_RR X(sigma + j omega) e^(j omega t) "d"omega
$
or, multiplying both sides by $e^(sigma t)$, we obtain
$
  x(t) = 1/(2 pi) integral_RR X(sigma + j omega) e^((sigma + j omega) t) "d"omega
$
That is, we can recover $x(t)$ from its Laplace transform evaluated for a set of values of $s = sigma + j omega$ in the ROC, with $sigma$ fixed and $omega$ varying from $-infinity$ to $+infinity$. By changing the variable of the integration, we have
$
  x(t) = 1/(2 pi j) integral_(sigma - j infinity)^(sigma + j infinity) X(s) e^(s t) "d"s
$

#example("Inverse Laplace Transform")[
  // Unbreakable, so that "Let" cannot be stranded at the foot of a page
  #block(breakable: false)[
    Let
    $
      X(s) = 1/ ((s+1) (s+2)), quad Re{s} > -1
    $
  ]
  To obtain the inverse Laplace transform, we perform a partial-fraction expansion to obtain
  $
    X(s) = 1/(s + 1) - 1/(s + 2) //, quad Re{s} > -1
  $

  Since the ROC is to the right of both poles, the same is true for each of the individual terms. Consequently, we know that each of these terms corresponds to a right-sided signal. The inverse transform can be obtained as
  $
      e^(-t) u(t) & #lpair 1/(s+1), quad Re{s} > -1 \
    e^(-2 t) u(t) & #lpair 1/(s+2), quad Re{s} > -2
  $
  Thus,
  $
    [e^(-t) - e^(-2 t)]u(t) &#lpair 1/((s+1)(s+2)), quad Re{s} > -1
  $
  Now suppose instead that
  $
    X(s) = 1/((s+1)(s+2)), quad Re{s} < -2
  $
  Then the ROC is to the left of both poles, and thus the ROC for the term corresponding to the pole at $s = -1$ is $Re{s} < -1$, while the ROC for the term with pole at $s = -2$ is $Re{s} < -2$. Then,
  $
     -e^(-t) u(-t) & #lpair 1/(s+1), quad Re{s} < -1 \
    -e^(-2t) u(-t) & #lpair 1/(s+2), quad Re{s} < -2
  $
  So,
  $
    x(t) = [-e^(-t) + e^(-2 t)] u(-t) #lpair 1/((s+1)(s+2)), quad Re{s} < -2
  $
  Finally, suppose that the ROC of $X(s)$ is now $-2 < Re{s} < -1$. In this case, the ROC is to the left of the pole at $s = -1$ so that this term corresponds to a left-sided signal, i.e., $-e^(-t) u(-t)$, while the ROC is to the right of the pole at $s = -2$, so that this term corresponds to a right-sided signal, i.e., $e^(-2 t) u(t)$. Thus,
  $
    x(t) = -e^(-t) u(-t) - e^(-2 t) u(t) #lpair 1/((s+1)(s+2)), quad -2 < Re{s} < -1
  $
]

== Properties of the Laplace Transform <sec-laplace-properties>

The properties of the Laplace transform mirror those of the continuous-time Fourier transform. The difference is that each one also says what happens to the ROC. Throughout, let
$
  x(t) #lpair X(s), quad s in R, quad quad x_1 (t) #lpair X_1 (s), quad s in R_1, quad quad x_2 (t) #lpair X_2 (s), quad s in R_2
$
where $R$, $R_1$, and $R_2$ denote the regions of convergence. We give short proofs of the properties used most often.

- Linearity:
$
  a x_1 (t) + b x_2 (t) #lpair a X_1 (s) + b X_2 (s), quad "ROC contains" R_1 inter R_2
$
The ROC can be larger than $R_1 inter R_2$ when a pole of one term is cancelled by a zero of the other. For example, $x_1 (t) = e^(-t) u(t)$ and $x_2 (t) = e^(-t) u(t) - e^(-2 t) u(t)$ both have ROC $Re{s} > -1$, but $x_1 (t) - x_2 (t) = e^(-2 t) u(t)$ has ROC $Re{s} > -2$.
#block(sticky: true)[- Time Shifting:]
$
  x(t - t_0) #lpair e^(-s t_0) X(s), quad "ROC" = R
$
_Proof._ Substitute $tau = t - t_0$:
$
  integral_RR x(t - t_0) e^(-s t) "d"t = integral_RR x(tau) e^(-s (tau + t_0)) "d"tau = e^(-s t_0) X(s)
$
The factor $e^(-s t_0)$ is finite for every $s$, so it does not change where the integral converges. #qed
#block(sticky: true)[- Shifting in the $s$-Domain:]
$
  e^(s_0 t) x(t) #lpair X(s - s_0), quad "ROC" = R + Re{s_0}
$
_Proof._ $integral_RR e^(s_0 t) x(t) e^(-s t) "d"t = integral_RR x(t) e^(-(s - s_0) t) "d"t = X(s - s_0)$, which converges when $s - s_0 in R$. The ROC therefore moves sideways by $Re{s_0}$, and every pole and zero moves by $s_0$. #qed
- Time Scaling:
$
  x(a t) #lpair 1 / (|a|) X(s / a), quad "ROC" = a R
$
For $a < 0$, the ROC is reflected about the $j omega$-axis as well as scaled. In particular, time reversal gives $x(-t) #lpair X(-s)$ with ROC $-R$.
- Conjugation:
$
  x^*(t) #lpair X^*(s^*), quad "ROC" = R
$
If $x(t)$ is real, $X(s) = X^*(s^*)$. The poles and zeros of $X(s)$ then come in complex-conjugate pairs, as in @fig-roc1.
#block(sticky: true)[- Convolution:]
$
  x_1 (t) star x_2 (t) #lpair X_1 (s) X_2 (s), quad "ROC contains" R_1 inter R_2
$
_Proof._ Exchange the order of integration and use the time-shifting property:
$
  integral_RR [integral_RR x_1 (tau) x_2 (t - tau) "d"tau] e^(-s t) "d"t = integral_RR x_1 (tau) [integral_RR x_2 (t - tau) e^(-s t) "d"t] "d"tau = integral_RR x_1 (tau) e^(-s tau) X_2 (s) "d"tau = X_1 (s) X_2 (s)
$
#qed

As with linearity, pole-zero cancellation can enlarge the ROC. This property is the reason the system function $H(s) = Y(s) \/ X(s)$ describes an LTI system completely.
#block(sticky: true)[- Differentiation in the Time Domain:]
$
  ("d"x(t)) / ("d"t) #lpair s X(s), quad "ROC contains" R
$
_Proof._ Differentiate the inverse transform under the integral sign:
$
  ("d"x(t)) / ("d"t) = 1 / (2 pi j) integral_(sigma - j infinity)^(sigma + j infinity) s X(s) e^(s t) "d"s
$
which is the inverse transform of $s X(s)$. The ROC can grow if $X(s)$ has a pole at $s = 0$ that the factor $s$ cancels. #qed
- Differentiation in the $s$-Domain:
$
  -t x(t) #lpair ("d"X(s)) / ("d"s), quad "ROC" = R
$
_Proof._ Differentiate $X(s) = integral_RR x(t) e^(-s t) "d"t$ with respect to $s$ under the integral sign. #qed

For example, applying this to $e^(-a t) u(t) #lpair 1 \/ (s + a)$ gives
$
  t e^(-a t) u(t) #lpair 1 / (s + a)^2, quad Re{s} > -a
$
- Integration in the Time Domain:
$
  integral_(-infinity)^t x(tau) "d"tau #lpair 1 / s X(s), quad "ROC contains" R inter {Re{s} > 0}
$
_Proof._ The running integral is $x(t) star u(t)$, and $u(t) #lpair 1 \/ s$ with ROC $Re{s} > 0$. The result follows from the convolution property. #qed
#block(sticky: true)[- The Initial- and Final-Value Theorems:]
If $x(t) = 0$ for $t < 0$ and $x(t)$ contains no impulses or higher-order singularities at $t = 0$, then
$
  x(0^+) = lim_(s -> infinity) s X(s)
$
If, in addition, $s X(s)$ has all of its poles in the left half-plane, then $x(t)$ settles to a constant and
$
  lim_(t -> infinity) x(t) = lim_(s -> 0) s X(s)
$
For example, the step response of $H(s) = 1 \/ (s + 1)$ is $Y(s) = 1 \/ (s (s + 1))$. The theorems give $y(0^+) = lim_(s -> infinity) 1 \/ (s + 1) = 0$ and $y(infinity) = lim_(s -> 0) 1 \/ (s + 1) = 1$, in agreement with $y(t) = (1 - e^(-t)) u(t)$. The condition matters: for $X(s) = 1 \/ (s - 1)$, the formula gives $lim_(s -> 0) s \/ (s - 1) = 0$, yet $x(t) = e^t u(t)$ grows without bound.

== Tables of Laplace Transform Properties and Basic Laplace Transform Pairs

#note("Laplace Transform Properties")[
  #table(
    columns: 4,
    align: center + horizon,
    stroke: 0.5pt,
    table.header([*Property*], [*Signal*], [*Laplace Transform*], [*ROC*]),

    [], [$x(t)$ \ $x_1 (t)$ \ $x_2 (t)$], [$X(s)$ \ $X_1 (s)$ \ $X_2 (s)$], [$R$ \ $R_1$ \ $R_2$],

    [Linearity], [$a x_1 (t) + b x_2 (t)$], [$a X_1 (s) + b X_2 (s)$], [At least $R_1 inter R_2$],

    [Time Shifting], [$x(t - t_0)$], [$e^(-s t_0) X(s)$], [$R$],

    [Shifting in the $s$-Domain], [$e^(s_0 t) x(t)$], [$X(s - s_0)$], [$R + Re{s_0}$],

    [Time Scaling], [$x(a t)$], [$1 / (|a|) X(s / a)$], [$a R$],

    [Time Reversal], [$x(-t)$], [$X(-s)$], [$-R$],

    [Conjugation], [$x^*(t)$], [$X^*(s^*)$], [$R$],

    [Convolution], [$x_1 (t) star x_2 (t)$], [$X_1 (s) X_2 (s)$], [At least $R_1 inter R_2$],

    [Differentiation in Time], [$("d"x(t)) / ("d"t)$], [$s X(s)$], [At least $R$],

    [Differentiation in $s$], [$-t x(t)$], [$("d"X(s)) / ("d"s)$], [$R$],

    [Integration in Time],
    [$integral_(-infinity)^t x(tau) "d"tau$],
    [$1 / s X(s)$],
    [At least $R inter {Re{s} > 0}$],
  )

  *Initial- and Final-Value Theorems.* If $x(t) = 0$ for $t < 0$ and $x(t)$ contains no impulses or higher-order singularities at $t = 0$, then $x(0^+) = lim_(s -> infinity) s X(s)$. If, in addition, all poles of $s X(s)$ lie in the left half-plane, then $lim_(t -> infinity) x(t) = lim_(s -> 0) s X(s)$.
]

#note("Laplace Transform Pairs")[
  #table(
    columns: 3,
    align: center + horizon,
    stroke: 0.5pt,
    table.header([*Signal*], [*Laplace Transform*], [*ROC*]),

    [$delta(t)$], [$1$], [All $s$],

    [$u(t)$], [$1 / s$], [$Re{s} > 0$],

    [$-u(-t)$], [$1 / s$], [$Re{s} < 0$],

    [$t^(n-1) / ((n - 1)!) u(t)$], [$1 / s^n$], [$Re{s} > 0$],

    [$-t^(n-1) / ((n - 1)!) u(-t)$], [$1 / s^n$], [$Re{s} < 0$],

    [$e^(-a t) u(t)$], [$1 / (s + a)$], [$Re{s} > -Re{a}$],

    [$-e^(-a t) u(-t)$], [$1 / (s + a)$], [$Re{s} < -Re{a}$],

    [$t^(n-1) / ((n - 1)!) e^(-a t) u(t)$], [$1 / (s + a)^n$], [$Re{s} > -Re{a}$],

    [$-t^(n-1) / ((n - 1)!) e^(-a t) u(-t)$], [$1 / (s + a)^n$], [$Re{s} < -Re{a}$],

    [$delta(t - T)$], [$e^(-s T)$], [All $s$],

    [$cos(omega_0 t) u(t)$], [$s / (s^2 + omega_0^2)$], [$Re{s} > 0$],

    [$sin(omega_0 t) u(t)$], [$omega_0 / (s^2 + omega_0^2)$], [$Re{s} > 0$],

    [$e^(-a t) cos(omega_0 t) u(t)$], [$(s + a) / ((s + a)^2 + omega_0^2)$], [$Re{s} > -a$],

    [$e^(-a t) sin(omega_0 t) u(t)$], [$omega_0 / ((s + a)^2 + omega_0^2)$], [$Re{s} > -a$],

    [$u_n (t) = ("d"^n delta(t)) / ("d"t^n)$], [$s^n$], [All $s$],

    [$u_(-n) (t) = underbrace(u(t) star dots.c star u(t), n "times")$], [$1 / s^n$], [$Re{s} > 0$],
  )
  In the two damped-sinusoid rows, $a$ is real.
]

== Analysis and Characterization of LTI Systems using the Laplace Transform

=== Causality

For a causal LTI system, the impulse response is zero for $t < 0$, and thus is right-sided. Therefore, the ROC associated with the system function for a causal system is a right-half plane. For a system with a rational system function, causality is equivalent to the ROC being the right-half plane to the right of the rightmost pole.

For example, consider a system with impulse response
$
  h(t) = e^(-t) u(t)
$

Since $h(t) = 0$ for all $t < 0$, this system is causal. Also, the system function can be obtained from previous examples as
$
  H(s) = 1/(s+1), quad Re{s} > -1
$

In this case, the system function is rational and the ROC is to the right of the rightmost pole, consistent with this statement.

=== Stability

An LTI system is stable if and only if the ROC of its system function $H(s)$ includes the entire $j omega$-axis, that is, the whole line $Re{s} = 0$. Consider the following example.

#example("Stability of LTI Systems")[
  Let us consider an LTI system with system function
  $
    H(s) = (s-1)/((s+1)(s-2))
  $
  Since the ROC has not been specified, we know from our discussion in previous sections that there are several different ROCs and, consequently, several different system impulse responses that can be associated with the algebraic expression for $H(s)$ given above.


  #let zeros = ((1,), (0,))
  #let poles = quadratic(1, -1, -2)

  #altfig(
    alt: "Three pole-zero plots of H(s) equals (s minus 1) divided by (s plus 1)(s minus 2), each showing the same poles at s equals minus one and s equals two and a zero at s equals one, but with three different choices of region of convergence. Panel (a) shades the right half plane to the right of the pole at s equals two, the causal but unstable choice. Panel (b) shades the vertical strip between the two poles, which is the only choice containing the j omega axis and is therefore the stable choice. Panel (c) shades the left half plane to the left of the pole at s equals minus one, which is anticausal and unstable.",
    caption: [
      One algebraic expression, three regions of convergence, three different
      systems: causal but unstable (a), stable but not causal (b), and neither
      (c). Only (b) contains the $j omega$-axis.
    ],
    align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      [
        #figure(
          lq.diagram(
            xlabel: $Re$,
            ylabel: $Im$,
            height: 4cm,
            width: 5cm,
            ylim: (-2.5, 2.5),
            xlim: (-3, 3.5),
            xaxis: (ticks: (-3, -2, -1, 0, 1, 2), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.rect(
              2,
              -5,
              width: 3,
              height: 10,
              fill: c-blue.lighten(70%).transparentize(35%),
            ),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center, plabel[$-1$]),
            lq.place(1, -0.3, align: center, plabel[$1$]),
            lq.place(2, -0.3, align: center, plabel[$2$]),
            lq.place(-0.3, 1, align: center, plabel[$1$]),
            lq.place(-0.5, -1, align: center, plabel[$-1$]),
          ),
          caption: "(a)",
          // A panel of the figure above, not a figure of its own: no
          // supplement and no number, so it does not consume one.
          supplement: none,
          numbering: none,
        )
      ],
      [
        #figure(
          lq.diagram(
            xlabel: $Re$,
            ylabel: $Im$,
            height: 4cm,
            width: 5cm,
            ylim: (-2.5, 2.5),
            xlim: (-3, 3.5),
            xaxis: (ticks: (-3, -2, -1, 0, 1, 2), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.rect(
              -1,
              -5,
              width: 3,
              height: 10,
              fill: c-blue.lighten(70%).transparentize(35%),
            ),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center, plabel[$-1$]),
            lq.place(1, -0.3, align: center, plabel[$1$]),
            lq.place(2, -0.3, align: center, plabel[$2$]),
            lq.place(-0.3, 1, align: center, plabel[$1$]),
            lq.place(-0.5, -1, align: center, plabel[$-1$]),
          ),
          caption: "(b)",
          // A panel of the figure above, not a figure of its own: no
          // supplement and no number, so it does not consume one.
          supplement: none,
          numbering: none,
        )
      ],
      [
        #figure(
          lq.diagram(
            xlabel: $Re$,
            ylabel: $Im$,
            height: 4cm,
            width: 5cm,
            ylim: (-2.5, 2.5),
            xlim: (-3, 3.5),
            xaxis: (ticks: (-3, -2, -1, 0, 1, 2), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.rect(
              -4,
              -5,
              width: 3,
              height: 10,
              fill: c-blue.lighten(70%).transparentize(35%),
            ),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center, plabel[$-1$]),
            lq.place(1, -0.3, align: center, plabel[$1$]),
            lq.place(2, -0.3, align: center, plabel[$2$]),
            lq.place(-0.3, 1, align: center, plabel[$1$]),
            lq.place(-0.5, -1, align: center, plabel[$-1$]),
          ),
          caption: "(c)",
          // A panel of the figure above, not a figure of its own: no
          // supplement and no number, so it does not consume one.
          supplement: none,
          numbering: none,
        )
      ],
    )
    ],
  ) <fig-roc3>

  If the system is known to be _causal_, the ROC will be that indicated in panel (a) of @fig-roc3, with impulse response
  $
    h(t) = (2/3 e^(-t) + 1/3 e^(2 t)) u(t)
  $
  Note that this choice of ROC does not include the $j omega$-axis, and consequently the system is not stable.

  On the other hand, if the system is known to be _stable_, the ROC is that given in panel (b), and the corresponding impulse response is
  $
    h(t) = 2/3 e^(-t) u(t) - 1/3 e^(2 t) u(-t)
  $
  which is absolutely integrable, i.e., $integral_RR |h(t)| "d"t < infinity$. Finally, for the ROC in panel (c), the system is both anticausal and unstable, with
  $
    h(t) = -(2/3 e^(-t) + 1/3 e^(2 t)) u(-t)
  $
]

For one particular and very important class of systems, stability can be characterized very simply in terms of the locations of the poles. Specifically, consider a causal LTI system with a rational system function $H(s)$. Since the system is causal, the ROC is to the right of the rightmost pole. Consequently, for this system to be stable (i.e., for the ROC to include the $j omega$-axis), the rightmost pole of $H(s)$ must be to the left of the $j omega$-axis, that is: _a causal system with rational system function $H(s)$_ is *stable* if and only if all of the poles of $H(s)$ lie in the left half of the $s$-plane, i.e., _all of the poles have negative real parts_.

== LTI Systems Characterized by Linear Constant-Coefficient Differential Equations

Consider a general LCCDE of the form
$
  sum_(k = 0)^N a_k ("d"^k y(t))/("d"t^k) = sum_(k = 0)^M b_k ("d"^k x(t))/("d"t^k)
$

Applying the Laplace transform to both sides and using the linearity and differentiation properties repeatedly, we have
#eqalt(
  "The sum from k equals zero to N of a sub k times s to the k, multiplied by Y of s, equals the sum from k equals zero to M of b sub k times s to the k, multiplied by X of s; equivalently, H of s equals the numerator polynomial sum from k equals zero to M of b sub k s to the k, divided by the denominator polynomial sum from k equals zero to N of a sub k s to the k.",
  $
    (sum_(k = 0)^N a_k s^k) Y(s) = (sum_(k = 0)^M b_k s^k) X(s) <=> H(s) = (sum_(k = 0)^M b_k s^k) / (sum_(k = 0)^N a_k s^k)
  $,
) <laplace-lccde>

Thus, the system function for a system specified by a differential equation is always rational, with zeros and poles at the solutions of the following two equations, respectively:
$
  sum_(k = 0)^M b_k s^k = 0, quad sum_(k = 0)^N a_k s^k = 0
$

#example("RLC Circuit and LCCDE")[
  1. An RLC circuit whose capacitor voltage and inductor current are initially zero constitutes an LTI system describable by an LCCDE.
    #altfig(
      alt: "A series RLC circuit: voltage source v sub S of t on the left drives a loop containing, in order, a resistor R with voltage v sub R of t, an inductor L with voltage v sub L of t, and a capacitor C with voltage v sub C of t, the capacitor voltage being the output.",
      caption: [
        The series RLC circuit, with the source voltage as input and the
        capacitor voltage as output.
      ],
      align(center)[
      #zap.circuit({
        import zap: *

        vsource("V", (0, 0), rotate: 90deg)
        resistor("R", (1, 1), variant: "ieee", label: $R$)
        inductor("L", (3, 1), variant: "ieee", label: $L$)
        capacitor("C", (5, 0), variant: "ieee", rotate: 270deg, label: $C$)

        wire((0, 0), (0, 1), "R.in")
        wire("R.out", "L.in")
        wire("L.out", (5, 1), "C.in")
        wire("C.out", (5, -1), (0, -1), "V.in")

        draw.content((-1.5, 0), $v_S (t)$, anchor: "west")
        draw.content((3.6, 0), $v_C (t)$, anchor: "west")
        draw.content((0.6, 0.5), $v_R (t)$, anchor: "west")
        draw.content((3, 0.7), $v_L (t)$, anchor: "north")
      })
      ],
    )
    If the input signal is the source voltage, i.e., $x(t) = v_S (t)$, and the output signal is the capacitor voltage, i.e., $y(t) = v_C (t)$, then

    $
      R C ("d"y(t))/("d"t) + L C ("d"^2 y(t))/("d"t^2) + y(t) = x(t)
    $

    Applying @laplace-lccde, we obtain
    $
      H(s) = (1/ (L C))/(s^2 + (R/L) s + (1/(L C)))
    $
  // If the values of $R$, $L$ and $C$ are all positive, the poles of this system function will have negative real parts, and consequently, the system will be stable.
  2. Suppose we know the input and the output of an LTI system are

    $
      x(t) = e^(-3 t) u(t); quad y(t) = [e^(-t) - e^(-2 t)] u(t)
    $
    Taking the Laplace transform of both $x(t)$ and $y(t)$ yields
    $
      X(s) = 1/(s+3), quad Re{s} > -3; quad Y(s) = 1/((s+1)(s+2)), quad Re{s} > -1
    $
    Hence,
    $
      H(s) = (Y(s))/(X(s)) = (s+3)/((s+1)(s+2)) = (s+3)/(s^2 + 3s + 2)
    $
    Since the ROC of $Y(s)$ must include at least the intersection of the ROCs of $X(s)$ and $H(s)$, examining the three possible choices of the ROC of $H(s)$ (i.e., $Re{s} < -2$, $-2 < Re{s} < -1$, and $Re{s} > -1$), we see that the only choice consistent with the ROCs of $X(s)$ and $Y(s)$ is $Re{s} > -1$. Since this is to the right of the rightmost pole of $H(s)$, we conclude that the system is causal. Since both poles of $H(s)$ have negative real parts, the system is also stable. Assuming initial rest, the system is described by the LCCDE
    $
      ("d"^2 y(t))/("d"t^2) + 3 ("d"y(t))/("d"t) + 2 y(t) = ("d"x(t))/("d"t) + 3 x(t)
    $
]

