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

Version 0.2.0 was submitted on 2026-09-11 using the existing maintainer address
ykzeng2019@gmail.com. Maintainer email confirmation completed at 21:04 UTC;
the submission interface and receipt email confirmed delivery to CRAN for review.
This records receipt, not CRAN acceptance or publication.

## Check environments and results

- Final source tarball name and SHA256: `wdsmatch_0.2.0.tar.gz`,
  `5303ec6e6dc43af0674a7a3639d6c9119411a30825ec98c6f6c6e0af922139e6`.
- Current R 4.6.1 Debian arm64 build and `R CMD check --as-cran --no-manual`:
  0 errors, 0 warnings, and 0 notes; 323 test assertions passed with no
  skips. The source tarball was built and checked in the same isolated
  current-R environment.
- R-devel Linux, 4.7.0 (2026-09-10 r90519), --as-cran --no-manual:
  0 errors, 0 warnings, 0 notes.
- R-release Windows, 4.6.1, --as-cran --no-manual:
  0 errors, 0 warnings, 0 notes.
- R-release macOS arm64, 4.6.1, --as-cran --no-manual:
  0 errors, 0 warnings, 0 notes.
- R-release Linux x86_64, 4.6.1, full --as-cran: 0 errors, 0 warnings,
  1 environment note because HTML checking requires tidy or the R package V8.
  The PDF manual passed. This note was disclosed in the submission comment.
- Local macOS arm64, R 4.4.0: full --as-cran check including PDF/HTML manuals and examples passed with 0 errors, 0 warnings, and one environment note (unable to verify current time). This is an additional compatibility check, not a substitute for current R.
- Local regression suite: 41 tests and 323 assertions passed without test warnings or skips. Frozen-reference comparison: all 96 settings and 768 paired draws agreed exactly.

Completed GitHub run: https://github.com/ykzeng-yale/wdsmatch/actions/runs/34646035889
All four jobs passed 323 assertions without skips or warnings and matched all
96 settings and 768 paired draws exactly. All four built archives match the
submitted archive's substantive content; differences are limited to generated
Packaged metadata and Windows text line endings. Binary data is byte-identical.

## Downstream dependencies

A fresh CRAN package-database lookup on 2026-09-11 (24,976 packages) found
no reverse Depends, Imports, LinkingTo, Suggests, or Enhances dependencies.
There were therefore no reverse-dependent packages to recheck.

## Notes

The environment-only Linux HTML-tools note and older local macOS clock note
are described above. Neither indicates an estimator or test failure. Current
R checks on Debian ARM64, Windows, macOS, and Linux R-devel are clean.
