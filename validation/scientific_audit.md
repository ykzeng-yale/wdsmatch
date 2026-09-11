# Independent scientific audit of wdsmatch 0.1.1

The public CRAN 0.1.1 source archive was preserved in a separate audit workspace. This audit compares
its estimators with the frozen corrected manuscript implementation
`WDSM_final_20260909/R/wdsm_core_final.R`. A scientific implementation mismatch
is distinguished from a mathematical or asymptotic validity claim.

## Confirmed implementation defects

1. **PATE bootstrap omits all observed-outcome residual terms.** Point matching
   stores controls in `matches_0[[treated_i]]` and treated donors in
   `matches_1[[control_i]]`. The bootstrap reads the opposite list for every
   recipient, finds zero-length lists, and skips every residual adjustment.
   The resulting draw is only a survey-weighted difference of fitted outcomes.
   The old loop also attempted to renormalize donor weights within the draw;
   fixing the index alone would not produce the fixed-original-reuse estimator.
2. **Both PATE and PATT report percentile intervals and B-1 variances.** The
   corrected manuscript protocol uses centered Wald intervals and the mean
   squared deviation across B draws. Percentile intervals are not inherently
   invalid; they do not implement the selected manuscript protocol.
3. **Prospective replicate PS fitting ignores the sampling argument.** Both
   bootstrap functions use multinomial counts times survey weights, whereas
   prospective fitting must use counts alone. Point PS fitting does respect
   the sampling argument, creating a point/replicate inconsistency.
4. **Disabling bias correction only changes the point estimator.** Both old
   bootstrap paths still refit the polynomial bias correction. For uncorrected
   direct imputation the algebraic fixed-reuse representation requires
   q0=q1=0, not the original prognostic predictions.
5. **Supplied scores are silently replaced in replicates.** The old public APIs
   invent default formulas and refit scores even when externally estimated ps
   or pg were supplied. Holding those scores fixed is a coherent conditional
   inference option, but it must be disclosed as excluding uncertainty in their
   external estimation. One cannot reconstruct an external fitting procedure
   from its prediction vector.
6. **Empty-arm multinomial draws are retained as zeros.** The numeric result
   vector is initialized to zero and the loop executes `next`; subsequent
   removal of NA values does not remove these zero placeholders. Every required
   draw should be valid, or the call should fail with its replicate number.
7. **PS numerical fits are unchecked and weight-sensitive.** No convergence,
   score-residual, rank, probability-saturation, or prediction checks exist.
   The corrected core uses checked zero-coefficient starts and rejects invalid
   fits instead of proceeding with a numerically failed nuisance model.
8. **PATT unnecessarily fits treated-arm prognostic and correction models.**
   The treated prognostic enters the joint correction sieve although PATT
   counterfactual imputation needs only the control mean. This can cause failure
   from a nuisance model the estimand does not require.

## Differences requiring explicit version documentation

The old package uses clipped propensity logits, survey-weighted score
standardization, and a joint ten-term sieve involving both prognostic scores.
The frozen manuscript uses propensity probabilities, pooled unweighted
standardization (multinomial counts in replicates), and a complete quadratic
basis in each arm's own probability/prognostic pair. These choices can change
matches and point estimates; they are protocol alignment changes, not merely
interval formatting fixes. None is by itself a universal mathematical error.

## Correct reuse convention

For every target i and original donor j in its match set, accumulate
`K[j] += w[i] * w[j] / sum(w[donors_i])`. K therefore has survey-weight units.
For PATE the old package stores dimensionless K, requiring multiplication by
the recipient's own donor weight before use in the corrected formula. For PATT
the old K0_w is already the raw weighted K; multiplying it by the donor weight
again would introduce a new error. The existing PATT residual formula itself
already uses the correct raw-K structure.

PATE replicate numerator is
`sum(m*w*(q1-q0) + m*(2*A-1)*(w+K)*(Y-qA))`, with denominator `sum(m*w)`.
PATT replicate numerator is
`sum_treated(m*w*(Y-q0)) - sum_control(m*K*(Y-q0))`, with denominator
`sum_treated(m*w)`. The all-ones multiplicity must equal direct corrected
imputation; q=0 must equal direct uncorrected imputation. Original K and donor
sets stay fixed in every replicate.

## Additional public API defects

- Input validation allows weight recycling, invalid M, nonfinite/missing values,
  insufficient arms, dimension mismatches, malformed score vectors, and invalid
  bootstrap or confidence-level arguments. Insufficient donors silently reduce
  M even though output reports the requested M.
- Printed output always says 95% even when alpha requests another level.
- Existing tests mostly check finiteness and interval ordering. No test checks
  the replicate equation, point/replicate identity, sampling-specific nuisance
  weighting, retention of all requested draws, or the bias-correction flag.

## Independent executable checks

`reproduce_cran_011_defects.R` demonstrates the old PATE residual omission exactly,
the ignored sampling argument, identical replicate vectors with/without bias
correction in both estimands, percentile endpoints, and retained zero draws.
Its output is `cran_011_defect_demonstration.{dput,rds,log}`.

`core_equivalence.R` compares candidate public PATE/PATT functions against the
separately sourced frozen manuscript core in 96 settings: two overlap fixtures,
two designs, two estimands, four model specifications, and M=1/3/5. Every point,
SE, CI, and eight paired draws per setting must agree within 1e-10, with no
warnings. This is a deterministic implementation regression, not a substitute
for a population-level simulation study or proof.

The package test file `tests/testthat/test-corrected-inference.R` independently
checks hand-calculated six-unit reuse fractions, direct imputation identities,
nonuniform multiplicities, invariance to a common rescaling of survey weights,
all 12 uncorrected estimand/design/M paths against a separate matching oracle,
every retained draw, the B divisor, Wald centering, and supplied-score behavior.
It also checks PATT's independence from the supplied treated prognostic score,
successful point estimation with only one treated unit when PS is supplied,
and failure at the exact index of an empty-arm draw rather than retaining zero.

## Candidate verification outcome (2026-09-11)

The corrected candidate passed all 96 synthetic settings and all 768 paired
bootstrap draws. Maximum absolute differences from the separately sourced
frozen core were exactly zero for estimates, SEs, CI endpoints, and every
replicate. All seven independent regression tests passed (172 expectations). The candidate calls
emitted no warnings; the local testthat installation printed its unrelated
"built under R version 4.4.1" startup notice when run with R 4.4.0.

These results establish equivalence for the bounded regression fixtures and
the tested algebraic/API properties. They do not newly establish asymptotic
validity or empirical coverage for untested data-generating or survey designs.

## Additional formula and supplied-score regressions

Both public estimands and both sampling designs reproduce explicit X1 + X2
formulas exactly when using `~ .`, including four paired bootstrap draws. The
propensity formula excludes Y. Mixed supplied-PS and supplied-PG paths retain
only the supplied component while fitting the other, and changing an unused
formula leaves every result unchanged. One-column and two-column supplied PG
inputs produce identical PATT estimates and draws in both sampling designs.

This repository directory contains the portable parity script, byte-identical
frozen reference, and final parity results. The separately retained CRAN
defect demonstration and package test logs are summarized above; the numerical
package regression tests themselves are in `tests/testthat/test-corrected-inference.R`.
