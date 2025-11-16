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

In the previous chapter, we saw that the response of a linear time-invariant system with impulse response $h(t)$ to a complex exponential input of the form $e^(s t)$ is
$
  y(t) = H(s) e^(s t)
$
where
$
  H(s) = integral_RR h(t) e^(- s t) "d" t
$

For $s$ imaginary (i.e., $s = j omega$), the integral in the above equation corresponds to Fourier transform of $h(t)$. For general values of the complex variable $s$, it is referred to as the _Laplace transform_.

#definition("The Laplace Transform")[
  The Laplace Transform of a general signal $x(t)$ is defined as
  $
    X(s) = integral_RR x(t) e^(- s t) "d"t
  $ <laplace>
  For convenience, we will sometimes denote the Laplace transform in operator form as $cal(L){x(t)}$, and denote the transform relationship between $x(t)$ and $X(s)$ as $x(t) limits(arrow.l.r)^(cal("L")) X(s)$. Note that when $s = j omega$, the Laplace transform becomes
  $
    X(j omega) = integral_RR x(t) e^(-j omega t) "d" t
  $
  which corresponds to the Fourier transform of $x(t)$, i.e.,
  $
    X(s)lr(|, size: #100%)_(s = j omega) = cal(F){x(t)}
  $
]

#example("Laplace Transform and Fourier Transform")[
  Let the signal $x(t) = e^(-a t) u(t)$. The Fourier transform $X(j omega)$ converge for $a > 0$, and is given by
  $
    X(j omega) = integral_RR e^(-a t) u(t) e^(-j omega t) "d" t = integral_0^infinity e^(-a t) e^(-j omega t) "d" t = 1 / (j omega + a), quad a > 0
  $

  The Laplace transform is
  $
    X(s) = integral_RR e^(-a t) u (t) e^(-s t) "d" t = integral_0^infinity e^(-(s + a))"d" t
  $
  or, with $s = sigma + j omega$,
  $
    X(sigma + j omega) = 1 / ((sigma + a) + j omega), quad sigma + a > 0
  $
  or equivalenty, since $s = sigma + j omega$ and $sigma = Re{s}$,
  $
    X(s) = 1 / (s + a), quad Re{s} > -a
  $
  That is,
  $
    e^(-a t) u(t) limits(arrow.r.l)^(cal(L)) 1 / (s + a), quad Re{s} > -a
  $
  For example, for $a = 0$, $x(t)$ is the unit step with Laplace transform $X(s) = 1 / s$, $Re{s} > 0$. In the meantime, let
  $
    x(t) = -e^(-a t) u(-t)
  $
  Then,
  $
    X(s) = - integral_RR e^(-a t) e^(-s t) u(-t) "d" t = - integral_(-infinity)^0 e^(-(s+a)) "d" t = 1/(s+a)
  $
  For convergence in this example, we require that $Re{s + a} < 0$, or $Re{s} < -a$, that is
  $
    -e^(-a t) u(-t) limits(arrow.r.l)^(cal(L)) 1/(s+a), quad Re{s} < -a
  $
]

In specifying the Laplace transform of a signal, both the *algebraic expression* and *the range of values* of $s$ for which this expression is valid are required. The range of values of $s$ for which the integral (i.e., @laplace) converges is referred to as the _region of convergence_ (ROC). // A convenient way to display the ROC is shown below for $Re{s} > -a$.

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
    X(s) = integral_RR e^(-2 t) u(t) e^(-s t) "d" t + 1/2 integral_RR [e^(-(1-3j)t) u(t)+ e^(-(1+3j) t)] u(t) e^(-s t) "d" t
  $
  It follows that
  $
         e^(-2 t) u(t) & limits(arrow.r.l)^(cal(L)) 1 / (s + 2),      & Re{s} > -2 \
    e^(-(1-3j) t) u(t) & limits(arrow.r.l)^(cal(L)) 1 / (s + (1-3j)), & Re{s} > -1 \
    e^(-(1+3j) t) u(t) & limits(arrow.r.l)^(cal(L)) 1 / (s + (1+3j)), & Re{s} > -1 \
  $
  For all three Laplace transforms to converge simultaneously, we must have $Re{s} > -1$. Consequently, the Laplace transform of $x(t)$ is
  $
    X(s) = 1/(s+2) + 1/2[1/(s + (1-3j))] + 1/2[1/(s + (1+3j))] = (2 s^2 + 5s + 12)/((s^2 + 2s + 10)(s + 2)), quad Re{s} > -1
  $ <xs>

  A convenient way to display the ROC is shown below. The shaded area is $Re{s} > -1$. Except for a scaling factor, the numerator and denominator polynomials in a rational Laplace transform can be specified by their roots. The roots of the numerator polynomial are commonly referred to as the _zeros_, denoted by $circle$ on the plot, and the roots of the denominator polynomial are referred to as the _poles_ of $X(s)$, marked by $times$.


  #let zeros = quadratic(2, 5, 12)
  #let poles-quadratic = quadratic(1, 2, 10)
  #let poles = (poles-quadratic.at(0) + (-2,), poles-quadratic.at(1) + (0,))

  #align(center)[
    #lq.diagram(
      xlabel: $Re$,
      ylabel: $Im$,
      height: 4cm,
      width: 5cm,
      ylim: (-4, 4),
      xlim: (-3, 1.5),
      xaxis: (ticks: (-2, -3, -1, 0, 1), subticks: none),
      yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
      lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
        center + horizon,
        text(mark.fill)[$circle$],
      )),
      lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
        center + horizon,
        text(mark.fill)[$times$],
      )),
      // lq.scatter(poles.at(0), poles.at(1), mark: "x", size: 0.8em),
      lq.place(-1, -0.5, align: center)[$-1$],
      lq.place(-0.1, 1, align: center)[$1$],
      lq.rect(
        -1,
        -5,
        width: 3,
        height: 10,
        fill: olive.lighten(50%).transparentize(50%),
      ),
      lq.place(0.8, 3)[$Re{s} > -1$],
    )
  ]
]

== The Inverse Laplace Transform

In the previous section, we discussed the interpretation of the Laplace transform of a signal as the Fourier transform of an exponentially weighted version of the signal: that is, with $s$ expressed as $s = sigma + j omega$, the Laplace transform of a signal $x(t)$ is
$
  X(sigma + j omega) = cal(F){x(t) e^(-sigma t)} = integral_RR x(t) e^(-sigma t) e^(-j omega t) "d" t
$
for values of $s = sigma + j omega$ in the ROC. We can invert this relationship using the inverse Fourier transform. We have
$
  x(t) e^(-sigma t) = cal(F)^(-1){X(sigma + j omega)} = 1/(2 pi) integral_RR X(sigma + j omega) e^(j omega t) "d" omega
$
or, multiplying both sides by $e^(sigma t)$, we obtain
$
  x(t) = 1/(2 pi) integral_RR X(sigma + j omega) e^(sigma + j omega) "d" omega
$
That is, we can recover $x(t)$ from its Laplace transform evaluated for a set of values of $s = sigma + j omega$ in the ROC, with $sigma$ fixed and $omega$ varying from $-infinity$ to $+infinity$. By changing the variable of the integration, we have
$
  x(t) = 1/(2 pi j) integral_(sigma - j infinity)^(sigma + j infinity) X(s) e^(s t) "d" s
$

#example("Inverse Laplace Transform")[
  Let
  $
    X(s) = 1/ ((s+1) (s+2)), quad Re{s} > -1
  $
  To obtain the inverse Laplace transform, we perform a partial-fraction expansion to obtain
  $
    X(s) = 1/(s + 1) - 1/(s + 2) //, quad Re{s} > -1
  $

  Since the ROC is to the right of both poles, the same is true for each of the individual terms. Consequently, we know that each of these terms corresponds to a right-sides signal. The inverse transform can be obtained as
  $
      e^(-t) u(t) & limits(arrow.l.r)^(cal("L")) 1/(s+1), quad Re{s} > -1 \
    e^(-2 t) u(t) & limits(arrow.l.r)^(cal("L")) 1/(s+2), quad Re{s} > -2
  $
  Thus,
  $
    [e^(-t) - e^(-2 t)]u(t) &limits(arrow.l.r)^(cal("L")) 1/((s+1)(s+2)), quad Re{s} > -1
  $
  If
  $
    X(s) = 1/((s+1)(s+2)), quad Re{s} < -2
  $
  The ROC is to the left of both poles, and thus, the ROC for the term corresponding to the pole at $s = -1$ is $Re{s} < -1$, while the ROC for the term with pole at $s = -2$ is $Re{s} < -2$. Then,
  $
     -e^(-t) u(-t) & limits(arrow.l.r)^(cal("L")) 1/(s+1), quad Re{s} < -1 \
    -e^(-2t) u(-t) & limits(arrow.l.r)^(cal("L")) 1/(s+2), quad Re{s} < -2
  $
  So,
  $
    x(t) = [-e^(-t) + e^(-2 t)] u(-t) limits(arrow.l.r)^(cal("L")) 1/((s+1)(s+2)), quad Re{s} < -2
  $
  Finally, suppose that the ROC of $X(s)$ is now $-2 < Re{s} < -1$. In this case, the ROC is to the left of the pole at $s = -1$ so that this term corresponds to the left-sided signal, i.e., $-e^(-t) u(-t)$, while the ROC is to the right of the pole at $s = -2$, so that this term corresponds to the right-sided signal, i.e., $e^(-2 t) u(t)$. Finally,
  $
    x(t) = -e^(-t) u(-t) - e^(-2 t) u(t) limits(arrow.l.r)^(cal("L")) 1/((s+1)(s+2)), quad -2 < Re{s} < -1
  $
]

== Analysis and Characterization of LTI Systems using the Laplace Transform

=== Causality

For a causal LTI system, the impulse response is zero for $t < 0$, and thus is right-sided. Therefore, the ROC associated with the system function for a causal system is a right-half plane.

For example, consider a system with impulse response
$
  h(t) = e^(-t) u(t)
$

Since $h(t) = 0$ for all $t < 0$, this system is causal. Also, the system function can be obtained from previous examples as
$
  H(s) = 1/(s+1), Re{s} > -1
$

In this case, the system function is rational and the ROC is to the right of the rightmost pole, consistent with our statement that causality for systems with rational system functions is equivalent to the ROC being to the right of the rightmost pole.

=== Stability

An LTI system is stable iff. the ROC of its system function $H(s)$ includes the entire $j omega$-axis. In other words, $Re{s} = 0$. Let us look at a few examples:

#example("Stability of LTI Systems")[
  Let us consider an LTI system with system function
  $
    H(s) = (s-1)/((s+1)(s-2))
  $
  Since th ROC has not been specified, we know from our discussion in previous sections that there are several different ROCs and, consequently, several different system impulse responses that can be associated with the algebraic expression for $H(s)$ given above.


  #let zeros = ((1,), (0,))
  #let poles = quadratic(1, -1, -2)

  #align(center)[
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
            xaxis: (ticks: (-2, -3, -1, 0, 1), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center)[$-1$],
            lq.place(1, -0.3, align: center)[$1$],
            lq.place(-0.3, 1, align: center)[$1$],
            lq.place(-0.5, -1, align: center)[$-1$],
            lq.rect(
              2,
              -5,
              width: 3,
              height: 10,
              fill: olive.lighten(50%).transparentize(50%),
            ),
          ),
          caption: "(a)",
          supplement: none,
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
            xaxis: (ticks: (-2, -3, -1, 0, 1), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center)[$-1$],
            lq.place(1, -0.3, align: center)[$1$],
            lq.place(-0.3, 1, align: center)[$1$],
            lq.place(-0.5, -1, align: center)[$-1$],
            lq.rect(
              -1,
              -5,
              width: 3,
              height: 10,
              fill: olive.lighten(50%).transparentize(50%),
            ),
          ),
          caption: "(b)",
          supplement: none,
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
            xaxis: (ticks: (-2, -3, -1, 0, 1), subticks: none),
            yaxis: (ticks: (-3, -2, -1, 0, 1, 2, 3), subticks: none),
            lq.scatter(zeros.at(0), zeros.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$circle$],
            )),
            lq.scatter(poles.at(0), poles.at(1), mark: mark => place(
              center + horizon,
              text(mark.fill)[$times$],
            )),
            lq.place(-1, -0.3, align: center)[$-1$],
            lq.place(1, -0.3, align: center)[$1$],
            lq.place(-0.3, 1, align: center)[$1$],
            lq.place(-0.5, -1, align: center)[$-1$],
            lq.rect(
              -4,
              -5,
              width: 3,
              height: 10,
              fill: olive.lighten(50%).transparentize(50%),
            ),
          ),
          caption: "(c)",
          supplement: none,
        )
      ],
    )
  ]

  If the system is known to be _causal_, the ROC will be that indicated in the (a), with impulse response
  $
    h(t) = (2/3 e^(-t) + 1/3 e^(2 t)) u(t)
  $
  Note that this particular system choice of ROC does not include the entire $j omega$-axis (within the ROC, $Re{s} = 0$ is not included), consequentily, the system is not stable.

  On the other hand, if the system is known to be _stable_, the ROC is that given in (b), and the corresponding impulse response is
  $
    h(t) = 2/3 e^(-t) u(t) - 1/3 e^(2 t) u(-t)
  $

  which is absolutely integrable, i.e., $integral_RR |h(t)| < infinity$. Finally, for the ROC in figure (c), the system is both anticausal and unstable, with
  $
    h(t) = -(2/3 e^(-t) + 1/3 e^(2 t)) u(-t)
  $
]

For one particular and very important class of systems, stability can be characterized very simply in terms of the locations of the poles. Specifically, consider a causal LTI system with a rational system function $H(s)$. Since the system is causal, the ROC is to the right of the rightmost pole. Consequently, for this system to be stable (i.e., for the ROC to include the $j omega$-axis), the rightmost pole of $H(s)$ must be to the left of the $j omega$-axis, that is: _a causal system with rational system function $H(s)$_ is *stable* iff. all of the poles of $H(s)$ lie in the left-half of the $s$-plane, i.e., _all of the poles have negative real parts_.

== LTI Systems Characterized by Linear Constant-Coefficient Differential Equations

Consider a general LCCDE of the form
$
  sum_(k = 0)^N a_k ("d"^k y(t))/("d" t^k) = sum_(k = 0)^M b_k ("d"^k x(t))/("d" t^k)
$

Applying the Laplace transform to both sides and using the linearity and differentiation properties repeatedly, we have
$
  (sum_(k = 0)^N a_k s^k) Y(s) = (sum_(k = 0)^M b_k s^k) X(s) <=> H(s) = (sum_(k = 0)^M b_k s^k) / (sum_(k = 0)^N a_k s^k)
$ <laplace-lccde>

Thus, the system function for a system specified by a differential equation is always rational, with zeros and poles at the solutions the following two equations, respectively:
$
  sum_(k = 0)^M b_k s^k = 0, quad sum_(k = 0)^N a_k s^k = 0
$

#example("RLC Circuit and LCCDE")[
  1. An RLC circuit whose capacitor voltage and inductor current are initially zero constitutes an LTI system describable by a LCCDE.
    #align(center)[
      #zap.circuit({
        import zap: *

        vsource("V", (0, 0), variant: "pretty", rotate: 90deg)
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
    ]
    Suppose the input signal is the voltage measured around the voltage source, i.e., $x(t) = v_S (t)$, and the voltage of the capacitor is the output signal, i.e., $y(t) = v_C (t)$, we obtain

    $
      R C ("d" y(t))/("d" t) + L C ("d"^2 y(t))/("d" t^2) + y(t) = x(t)
    $

    Applying @laplace-lccde, we obtain
    $
      H(s) = (1/ (L C))/(s^2 + (R/L) s + (1/(L C)))
    $
  // If the values of $R$, $L$ and $C$ are all positive, the poles of this system function will have negative real parts, and consequently, the system will be stable.
  2. Suppose we know the input and the output to an LTI system are

    $
      x(t) = e^(-3 t) u(t); quad y(t) = [e^(-t) - e^(-2 t)] u(t)
    $
    Taking the Laplace transform of both $x(t)$ and $y(t)$ yields
    $
      X(s) = 1/(s+3), Re{s} > 3; quad Y(s) = 1/((s+1)(s+2)), Re{s} > -1
    $
    Hence,
    $
      H(s) = (Y(s))/(X(s)) = (s+3)/((s+1)(s+2)) = (s+3)/(s^2 + 3s + 2)
    $
    Since the ROC of $Y(s)$ must include at least the intersections of the ROCs of $X(s)$ and $H(s)$. Examming the three possible choices of the ROC of $H(s)$ (i.e., $Re{s} < -2$, $-2 < Re{s} < -1$, and $Re{s} > -1$), we see that only the choice that is consistent with the ROCs of $X(s)$ and $Y(s)$ is $Re{s} > -1$. Since this is to the right of the rightmost pole of $H(s)$, we conclude that the system is causal. Besides, both poles of $H(s)$ have negative real parts, the system is stable. The LCCDE describing the system is given as, assuming initial rest,
    $
      ("d"^2 y(t))/("d" t^2) + 3 ("d" y(t))/("d" t) + 2 y(t) = ("d" x(t))/("d" t) + 3 x(t)
    $
]

