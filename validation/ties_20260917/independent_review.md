# Independent wdsmatch 0.2.1 review

Review date: 2026-09-17. Read-only source audit of commit `8ff6ac3`; no package source edits, Git writes, CRAN submissions, or outgoing messages were performed.

## Finding

No material numerical implementation or compatibility defect found in the 0.2.1 tie correction. The candidate is numerically checked and prepared for submission. **Hold CRAN upload until the current published package's official check page has fully updated to 0.2.0.** This is a concrete current CRAN prerequisite, not a request for additional user authorization.

## Implementation inspected

- `R/wdsm_ties.R`, `R/matching.R`, `R/wdsm.R`, public ATE/ATT entry points, bootstrap and reuse helpers, matching tests, independent imputation/replication oracles, generated documentation, DESCRIPTION/NEWS, archive exclusion rules, and the CI workflow.
- The shared tie helper is byte-identical to SW_DSM's active helper. It retains all distances below the numerical boundary, chooses the remaining donors uniformly without replacement for each recipient, and allows donor reuse between recipients. Its separate seeded stream restores the caller's RNG kind and seed, including previously absent seeds and error exits.
- Original donor sets and weighted reuse coefficients remain fixed during replication. Public optional arguments were appended, preserving prior positional arguments. The documented R >= 3.6.0 minimum supports the specified rejection-sampling RNG.
- The default numerical tolerance is explicitly documented. It is not literal exact floating-point equality: the saved SMIPY comparison records 17 changed recipient donor sets when switching to zero tolerance, and a point-estimate change of about 0.000194. This is an alternative numerical boundary definition, not failed parity between implementations. No unqualified exact-tie equivalence should be claimed.
- These checks validate the numerical implementation and recorded comparisons; they do not prove discrete-score inference or arbitrary complex-survey validity. The public documentation retains those limits.

## Evidence independently verified

- GitHub Actions run 35258885396 completed successfully on the checked source commit `ae88efa4b99ae3b6e9f1d3a009d690a001b07e85`.
- All four stored platform check logs report zero errors/warnings and all test logs show `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 1275 ]`. Notes concern the recent release and unavailable HTML validation tooling on Linux release; the Linux PDF manual check passed. The local full macOS check additionally records an unverifiable-current-time note.
- The saved continuous-score comparison contains 96 settings and 768 draws with every recorded maximum estimate/SE/CI/draw difference equal to zero.
- All five full-size case parity records have status complete, 200 finite draws, and source MD5 hashes matching current `R/` files. The largest recorded difference across all estimate/SE/CI/draw comparisons is 4.57966997657877e-16.
- The local canonical source archive contains 26 files, no `.git`, validation records, or check artifacts, and source-equivalent contents. DESCRIPTION differs only by standard build reflow and generated fields.
- Current-release and R-devel CI archives were independently compared with the canonical archive: no substantive content differences after normalizing CRLF and excluding generated Packaged metadata.

## Preferred submission artifact

Use the already-built and checked current R release archive:

`/Users/yukang/.codex/workspaces/wdsmatch_audit_20260917/github_checks/ubuntu-latest-R-release/wdsmatch_0.2.1.tar.gz`

Built/check session: R version 4.6.1 (2026-06-24).
SHA256: `a41a4aea58814e889f1fc4d8a0f7a71f0876647520f480911d7b1055ecbdb73b`.

The R-devel archive has identical substantive contents and SHA256 `acb28d493c716a3d40b43bd874c60f774d6075120b2c15b2bdd1a65f2ece5f5e`; its session is R Under development (2026-09-16 r90549). The local R 4.4.0 archive SHA256 is `a03360f60f1435ec1889c6f9b9c171f5f26867ae528142e534fca198947556f6`.

## Live CRAN status and submission prerequisite

Primary sources read live:

- [Package page](https://cran.r-project.org/web/packages/wdsmatch/index.html): current published version 0.2.0, published 2026-09-11; maintainer Yukang Zeng, ykzeng2019@gmail.com.
- [Official check page](https://cran.r-project.org/web/checks/check_results_wdsmatch.html): page says last updated 2026-09-17 20:57:47 CEST. All flavors are OK, but two still report 0.1.1.
- [CRAN Repository Policy](https://cran.r-project.org/web/packages/policies.html), Re-submission section: “wait for that page to be fully updated after publication of a version”. The policy also requests source archives built using current release/patched R and explains notes/recent updates in submission comments.

| Official flavor | Version | Status |
|---|---|---|
| r-devel-linux-x86_64-debian-clang | 0.2.0 | OK |
| r-devel-linux-x86_64-debian-gcc | 0.2.0 | OK |
| r-devel-linux-x86_64-fedora-clang | 0.2.0 | OK |
| r-devel-linux-x86_64-fedora-gcc | 0.2.0 | OK |
| r-devel-windows-x86_64 | 0.2.0 | OK |
| r-patched-linux-x86_64 | 0.2.0 | OK |
| r-release-linux-x86_64 | **0.1.1** | OK |
| r-release-macos-arm64 | **0.1.1** | OK |
| r-release-macos-x86_64 | 0.2.0 | OK |
| r-release-windows-x86_64 | 0.2.0 | OK |
| r-oldrel-macos-arm64 | 0.2.0 | OK |
| r-oldrel-macos-x86_64 | 0.2.0 | OK |
| r-oldrel-windows-x86_64 | 0.2.0 | OK |

No reverse dependencies are listed on the live package page. This was independently confirmed from fresh CRAN source PACKAGES metadata with `available.packages(..., filters=list())` and reverse Depends/Imports/LinkingTo/Suggests/Enhances lookup: `character(0)`. Metadata also reports wdsmatch 0.2.0.

The remaining action before upload is to recheck the official check page and confirm its two stale entries have updated. Keep the substantive early-update explanation and platform notes in the submission comments. A successful upload/confirmation would still not mean CRAN acceptance.
