# wdsmatch: Weighted Double Score Matching for Survey-Weighted Causal Inference

`wdsmatch` estimates the population average treatment effect (PATE) and the
population average treatment effect on the treated (PATT) from survey-weighted
observational data using weighted double score matching.

[Preprint](https://arxiv.org/abs/2610.25870) |
[CRAN](https://cran.r-project.org/package=wdsmatch) |
[Publication code and results](https://github.com/ykzeng-yale/SW_DSM)

## Installation

```r
# Released version:
install.packages("wdsmatch")

# Development version, for users with repository access:
# install.packages("remotes")
remotes::install_github("ykzeng-yale/wdsmatch")
```

CRAN version 0.2.1 was published on September 20, 2026. Version 0.2.2 has been
submitted to CRAN and is awaiting review. This citation and documentation update
does not change the numerical code from 0.2.1. See [NEWS.md](NEWS.md) for release history.

Version 0.2.0 corrected numerical calculations in 0.1.1. Rerun analyses made
with 0.1.1 before reusing their results.

## Usage

```r
library(wdsmatch)
data(survey_obs)

covariates <- survey_obs[, c("X1", "X2", "X3", "X4", "X5", "X6")]

set.seed(20260911)
fit_ate <- wdsmatchATE(
  Y = survey_obs$Y,
  X = covariates,
  Z = survey_obs$Z,
  weights = survey_obs$survey_weight,
  M = 5,
  model.ps = Z ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
  model.pg = Y ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
  sampling = "retrospective",
  varest = TRUE, boots = 200
)
fit_ate

set.seed(20260912)
fit_att <- wdsmatchATT(
  Y = survey_obs$Y,
  X = covariates,
  Z = survey_obs$Z,
  weights = survey_obs$survey_weight,
  M = 5,
  model.ps = Z ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
  model.pg = Y ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
  sampling = "retrospective",
  varest = TRUE, boots = 200
)
fit_att
```

## Estimation and inference

Matching uses propensity probabilities and each arm's prognostic score, with
unweighted pooled standardization of the two coordinates. Missing potential
outcomes are imputed using survey-weighted averages within match sets and
aggregated using Hajek normalization. The default bias correction uses a
complete quadratic regression in each arm's own two-dimensional double score.
PATT only needs the control-side prognostic score and bias-correction regression.

For retrospective sampling, propensity-score fitting uses survey weights; for
prospective sampling it is unweighted. Prognostic-score fitting is unweighted
in both designs. Replication refits incorporate multinomial counts in addition
to the respective fitting weights and retain the original matching reuse
coefficients without re-matching.

Confidence intervals are centered normal Wald intervals:

```r
se <- sqrt(mean((fit_ate$boot.estimates - mean(fit_ate$boot.estimates))^2))
ci <- fit_ate$estimate + c(-1, 1) * qnorm(1 - fit_ate$alpha / 2) * se
```

The replication variance uses divisor `boots` (B). All B draws must succeed;
invalid fits or draws produce an informative error rather than a silently
shortened replication sample or a zero placeholder. Supplied scores remain
fixed during replication, so inference is conditional on those scores and
does not include uncertainty from their external estimation. With bias correction
enabled, internally estimated scores are refitted. With `use.bias.correction = FALSE`,
neither an outcome bias-correction regression nor unused score refits are performed
in the raw fixed-match replicates; matching discrepancies remain, so the
bias-corrected asymptotic justification does not automatically apply.

The double-robustness property concerns consistency under the stated
identification, sampling, overlap, and regularity assumptions when a required
score model is correct. It does not guarantee negligible finite-sample bias or
nominal coverage in every setting, particularly under poor overlap or joint
model misspecification. The interface accepts unit-level survey weights but
does not encode strata, primary sampling units, or survey-design-specific
replicate weights. Its multinomial procedure is not a general replacement for
variance estimation under an arbitrary complex survey design.

The default matching ratio remains `M = 5` for API compatibility. Users can
examine sensitivity to a prespecified set such as `M = 1, 3, 5`; no single ratio
is uniformly best across bias, variance, and coverage.

## Development checks

The package contains deterministic regression tests and a GitHub Actions
matrix for Linux R-release/R-devel, Windows R-release, and macOS R-release.
The workflow builds and checks source tarballs with `R CMD check --as-cran`.
Linux R-release includes the PDF manual; the other platforms omit the manual.
Configured checks are not a guarantee of statistical validity or evidence
that a particular candidate has completed validation.

## Citation

Please cite the methodological paper and the package version used.
The development version includes both references in:

```r
citation("wdsmatch")
```

**Paper (AMA style)**

Zeng Y, Tong G, Tong J, Lu H, Mukherjee B, Li F. Where to weight? Estimating
population causal effects with weighted double score matching in complex
surveys. Preprint. *arXiv*. Posted online October 19, 2026.
doi:[10.48550/arXiv.2610.25870](https://doi.org/10.48550/arXiv.2610.25870).

<details>
<summary>BibTeX</summary>

```bibtex
@misc{zeng2026weightestimatingpopulationcausal,
  title = {Where to weight? Estimating population causal effects with weighted double score matching in complex surveys},
  author = {Yukang Zeng and Guangyu Tong and Jiaqi Tong and Haidong Lu and Bhramar Mukherjee and Fan Li},
  year = {2026},
  eprint = {2610.25870},
  archivePrefix = {arXiv},
  primaryClass = {stat.ME},
  url = {https://arxiv.org/abs/2610.25870}
}
```

</details>

## License

GPL-3
