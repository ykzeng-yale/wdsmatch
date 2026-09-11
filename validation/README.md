# Independent implementation validation

This directory is kept in the GitHub repository and excluded from the CRAN
source package. The ordinary package regression tests remain in `tests/`.

Run from the repository root using base R only:

```sh
Rscript --vanilla validation/core_equivalence.R
```

Or supply the candidate package directory, reference file, and output directory:

```sh
Rscript --vanilla validation/core_equivalence.R . validation/frozen_reference_core.R validation/results
```

The script sources the candidate's current `R/` files in a separate environment
from the reference. It does not load a cached installed package. It compares
96 settings: two synthetic overlap fixtures, retrospective/prospective fitting,
PATE/PATT, four score-model specifications, and M=1/3/5. Every setting uses eight
identically seeded multinomial draws. Point estimates, SEs, Wald endpoints,
and all 768 draws must agree within 1e-10, with no candidate warnings. The
2026-09-11 final audit achieved exactly zero difference for all quantities.

This is an implementation equivalence audit on deterministic synthetic data,
not a new population simulation study or a proof of asymptotic validity. It
does not establish general cluster-design-valid inference from weights alone.

## Frozen reference provenance

`frozen_reference_core.R` is a byte-identical copy of
[`R/wdsm_core_final.R`](https://github.com/ykzeng-yale/SW_DSM/blob/f29994650568a6c74098234035420985de97b9ad/R/wdsm_core_final.R)
from the authors' finalized main-simulation implementation, commit
`f29994650568a6c74098234035420985de97b9ad` in `ykzeng-yale/SW_DSM`.
It is included under GPL-3, the same license as this package. It is reference
material for the audit, not part of the installed package or runtime engine.

Exact reference SHA-256:

```text
cfc520662596c44b221a53a810254436ef36ae633a466b42e8c2109876c9c15f
```

`SOURCE_SHA256SUMS.txt` records the candidate R-source files used by the final
audit. `SHA256SUMS.txt` records the validation files themselves (excluding
the checksum file). Paths in the source manifest are relative to the repository
root; paths in the validation manifest are relative to this directory.

`results/core_equivalence_96_settings.csv` reports all comparison errors;
the companion RDS also retains the 768 candidate/reference draw pairs,
the R version, and file hashes. `scientific_audit.md` documents the old defects
and the independent manual-oracle/API regression tests.
