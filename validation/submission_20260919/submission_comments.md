## wdsmatch 0.2.1: correctness update to 0.2.0

Please consider this correction to version 0.2.0, published September 11, 2026.
It replaces deterministic donor-row priority at a tied Mth-distance boundary
with uniform selection without replacement within each recipient's boundary
group. Strictly closer donors are retained; each recipient receives exactly M
donors, with replacement allowed across recipients. This addresses donor
concentration when scores arise from discrete covariates.

A separate tie seed preserves the caller's RNG state and bootstrap count
stream. Original matches and weighted reuse coefficients remain fixed during
replication. Optional arguments are appended to the existing interfaces; there
are no API removals or new package dependencies. R >= 3.6.0 is required for the
specified rejection-sampling RNG.

## Checks and numerical verification

The submitted source archive was built and checked on Ubuntu with R 4.6.1.
The equivalent source also passed Windows, macOS, and Linux R-devel checks
(R-devel 2026-09-16 r90549). All four platforms report zero errors/warnings and
1,275 passing test assertions, with no test failures, warnings, or skips.

All platforms note the recent release (six days before the September 17
checks). Linux release additionally notes unavailable HTML tidy/V8; its PDF
manual passed. We request this early update because it corrects discrete-score
donor allocation. The archive SHA256 is
 a41a4aea58814e889f1fc4d8a0f7a71f0876647520f480911d7b1055ecbdb73b.

The checked source agrees exactly with the frozen 0.2.0 estimator for all 96
continuous-score settings and 768 paired bootstrap draws per platform. Five
full-size application fits and 1,000 replication draws agree with independently
executed case-study code to within 4.58e-16. Tests also cover tied boundaries,
independent imputation/replication oracles, RNG preservation, and validation.
Fresh CRAN source metadata on September 19 lists no reverse dependencies under
Depends, Imports, LinkingTo, Suggests, or Enhances.

## Current CRAN check-page status and request for consideration

We consulted the CRAN check page again on September 19: twelve flavors list
0.2.0, all OK; r-release-linux-x86_64 still lists 0.1.1, also OK. macOS arm64
has updated since our September 17 review.

We recognize the policy request to wait for the check page to fully update.
The remaining Linux entry has not updated. We disclose this explicitly and
request consideration of this substantive correction based on the successful
current-platform checks above. Please let us know if submission should instead
wait for that entry to refresh. We are not claiming that the page is fully
updated or that an exception has already been granted.
