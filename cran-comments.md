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

All 1,275 local regression assertions pass without skips or test warnings,
including discrete-score donor-allocation,
independent point/replication oracles, RNG preservation, and validation checks.
All 96 continuous-score settings and 768 paired bootstrap draws agree exactly
with the separately frozen 0.2.0 reference. A full local macOS R 4.4.0 check, including PDF and HTML manuals, reports
zero errors and zero warnings. The two notes concern the recent CRAN release
(six days ago) and inability to verify current time. This patch addresses a
substantive donor-concentration issue with discrete covariates.
All five full-size application WDSM fits and their 1,000 draws agree with the
independently executed case code to within 4.58e-16. Current Linux, Windows,
macOS, and Linux R-devel checks all completed with zero errors/warnings and
1,275 assertions passing per platform (GitHub run 35258885396). All platforms
note the release six days earlier; Linux release additionally notes unavailable
HTML tidy/V8. Its PDF manual passed. All platform archives match the canonical
archive substantively, after accounting for generated metadata and CRLF.

Version 0.2.1 has not yet been submitted. The original 0.2.0 submission/check
record is preserved in validation/cran_comments_020_historical.md.
