# CRAN submission record: wdsmatch 0.2.1

Status observed September 19, 2026, 21:39 UTC: **submitted and maintainer-confirmed; CRAN acceptance pending**.

- Submission ID: **355876**.
- Maintainer: Yukang Zeng, `ykzeng2019@gmail.com`.
- Upload and metadata review completed September 19 at approximately 21:37 UTC.
- CRAN sent the maintainer confirmation email with subject `CRAN Submission of wdsmatch 0.2.1 - Confirmation Link` at 17:37 EDT.
- The confirmation link was opened from the maintainer mailbox. The three completed policy/check declarations were confirmed, and the final action completed at approximately 21:38 UTC.
- The official confirmation page displayed: **“The package has been uploaded successfully to CRAN submission team.”**
- At 21:39:17 UTC the package was present in CRAN's `incoming/pretest/` directory. Its reported modification time was 21:38:29 UTC.
- The archive downloaded from CRAN was **byte-identical** to the tested upload candidate: 35,572 bytes, SHA256 `a41a4aea58814e889f1fc4d8a0f7a71f0876647520f480911d7b1055ecbdb73b`. See [received_archive_verification.json](received_archive_verification.json).

The email confirmation token and private mailbox content are not included in this public record. Do not upload a duplicate while this submission is being processed. Completion of upload and maintainer confirmation does not imply CRAN acceptance or publication.

## Submitted artifact and testing

The exact archive was built and checked with Ubuntu R 4.6.1. Its substantive source is the source tested in GitHub run [35258885396](https://github.com/ykzeng-yale/wdsmatch/actions/runs/35258885396), source commit `ae88efa4b99ae3b6e9f1d3a009d690a001b07e85`. Later changes before submission were documentation and validation records only. No estimator code or archive was rebuilt for this submission.

All four platforms (Linux release, Linux R-devel, Windows release, macOS release) passed 1,275 assertions each with zero errors, warnings, failures, or skips. The package-check notes were explained in the submitted comments. Independent numerical checks reproduced all 96 continuous-score settings and 768 paired replication draws per platform exactly. Five full-size application fits and 1,000 replication draws agreed with independent application code to at most 4.58e-16. See the [September 17 verification evidence](../ties_20260917/README.md).

The exact uploaded comment is preserved in [submission_comments.md](submission_comments.md). Fresh September 19 CRAN source metadata lists no reverse dependencies in Depends, Imports, LinkingTo, Suggests, or Enhances; see [reverse_dependencies.json](reverse_dependencies.json).

## Disclosed CRAN check-page lag

On September 19, twelve flavors listed published version 0.2.0 and Linux release still listed 0.1.1; all were OK. The [official policy](https://cran.r-project.org/web/packages/policies.html) requests waiting for the page to fully update. Following the maintainer's renewed instruction to submit the completed, tested update, the comment explicitly disclosed the remaining stale entry and requested CRAN consideration of the substantive correction. It did not claim that the page was fully updated or an exception had been granted. CRAN's decision on this request is pending.

## Follow-up state

Recurring automatic checks remain paused at the maintainer's request. The simulation reruns, case studies, and raw-results publication were already completed; no additional numerical rerun was performed for this submission.
