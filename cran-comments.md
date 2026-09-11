## Update from 0.1.1 to 0.2.0

This update corrects numerical behavior in the PATE and PATT estimators and
their replication procedure. It uses propensity probabilities and arm-specific
quadratic bias correction, corrects the fixed-reuse residual contributions,
applies the sampling-design-specific propensity weighting in every replicate,
and uses centered normal Wald confidence intervals with B-divisor replication
variance. It also adds strict numerical/input checks and regression tests.
Existing public function arguments and result components are retained, with
additional inference metadata. The maintainer and license are unchanged.

## Submission preparation status

This file is a draft for the release candidate. No submission has been made.
Replace the pending entries below with completed results from the final source
tarball before uploading it to CRAN.

## Check environments and results

- Final source tarball name and SHA256: pending final build.
- Current R-release/patched build and R CMD check --as-cran: pending.
- R-devel Linux R CMD check --as-cran: pending.
- R-release Windows R CMD check --as-cran: pending.
- R-release macOS R CMD check --as-cran: pending.
- Local macOS arm64, R 4.4.0: full --as-cran check including PDF/HTML manuals and examples passed with 0 errors, 0 warnings, and one environment note (unable to verify current time). This is an additional compatibility check, not a substitute for current R.
- Local regression suite: 41 tests and 323 assertions passed without test warnings or skips. Frozen-reference comparison: all 96 settings and 768 paired draws agreed exactly.

The repository workflow checks Linux R-release and R-devel, Windows R-release,
and macOS R-release. Linux R-release includes the PDF manual; the other environments omit it. Workflow configuration is not
evidence that any of these checks has completed.

## Downstream dependencies

A fresh CRAN package-database lookup on 2026-09-11 (24,976 packages) found
no reverse Depends, Imports, LinkingTo, Suggests, or Enhances dependencies.
There were therefore no reverse-dependent packages to recheck.

## Notes

Record and explain any actual check notes here. Do not copy the previous
version's zero-error/zero-warning/zero-note statement without a new check.
