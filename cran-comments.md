## Update from 0.2.0 to 0.2.1

Version 0.2.0 is the current CRAN release, published 2026-09-11 (verified
2026-09-17). This candidate replaces deterministic donor-row priority at the
Mth-distance boundary with independent recipient-specific random selection.
Strictly closer donors are retained; every recipient receives exactly M
opposite-arm donors. Matching remains with replacement across recipients.

The separate tie seed preserves the caller's RNG state and bootstrap count
stream. Original match sets and weighted reuse are held fixed during every
replication. New optional arguments are appended to the existing interfaces.
R >= 3.6.0 is required for the specified rejection-sampling RNG.

## Validation status

The local regression tests pass, including discrete-score donor-allocation,
independent point/replication oracles, RNG preservation, and validation checks.
All 96 continuous-score settings and 768 paired bootstrap draws agree exactly
with the separately frozen 0.2.0 reference. Full-size case comparisons and
current-platform checks are being completed before submission.

Version 0.2.1 has not yet been submitted. The original 0.2.0 submission/check
record is preserved in validation/cran_comments_020_historical.md.
