# Tie-correction verification, September 17, 2026

The shared donor-allocation helper is byte-identical to SW_DSM's active helper.
Both use independent recipient-specific selection and preserve the bootstrap RNG.
All five full-size WDSM application fits were independently rerun through the
package on Bouchet with their saved input data and starting RNG states. All
1,000 replication draws agree with the separately executed case functions to
at most 4.58e-16. Maximum estimate difference is 5.56e-17; maximum SE difference
is 1.05e-17. The corresponding records retain every draw and source/input hashes.

## Numerical tolerance diagnostic

Zero tolerance and the default roundoff tolerance select identical donor sets
in four cases. In NSDUH SMIPY, zero tolerance changes 17 recipient match sets;
the point estimate changes from 0.016319329864 to approximately 0.0165130919
(a 0.0194-percentage-point difference). This does not make either parameter
setting a programming failure: they deliberately implement different numerical
boundary definitions. The default is documented and shared by the case code,
simulation code, and package. No score jitter is added.

The first SMIPY audit stopped after estimator/draw parity had passed because
an exploratory assertion incorrectly required the two tolerance settings to
be identical. The revised audit records the alternative-setting effect instead;
the package code and reported primary analysis were unchanged.

## Platform checks

GitHub run 35258885396 checked source commit ae88efa4b99ae3b6e9f1d3a009d690a001b07e85.
Current Linux, Windows, macOS, and Linux R-devel all passed 1,275 assertions with
zero test warnings or skips, and zero package errors/warnings. Each independently
reproduced all 96 continuous-score reference settings and 768 paired draws
exactly. All built archives match the canonical archive's substantive contents;
only generated Packaged metadata and Windows line endings differ.

Every platform reports the expected recent-release note (0.2.0 was published
six days earlier). Linux release additionally reports unavailable HTML tidy/V8;
its PDF manual passed. The full local macOS R 4.4.0 check passed both manuals,
with the recent-release and unverifiable-current-time notes.

See `platform_verification.json`, platform logs, and the saved case records.
This is a numerical implementation audit, not a proof of discrete-score or
complex-survey replication validity. Version 0.2.1 has not been submitted to CRAN.

## Submission readiness

The independent source and artifact review found no material implementation or
compatibility defect. The preferred submission archive was built and checked
with current R 4.6.1 on Linux; SHA256
`a41a4aea58814e889f1fc4d8a0f7a71f0876647520f480911d7b1055ecbdb73b`.
Fresh CRAN source metadata lists no reverse dependencies.

At the September 17 review, the official check page still listed 0.1.1 for
`r-release-linux-x86_64` and `r-release-macos-arm64`; the other 11 flavors
listed the current 0.2.0 release. All reported OK. CRAN's re-submission policy
asks maintainers to wait until that page is fully updated after publication.
Accordingly, the tested 0.2.1 archive is ready but has not been uploaded. Recheck
[the official page](https://cran.r-project.org/web/checks/check_results_wdsmatch.html)
before submission. See [independent_review.md](independent_review.md) for the
source audit, all platform versions, archive hashes, and policy link.
