# Implementation checks

This directory supports the repository's continuous-integration checks and is
excluded from the CRAN source package. Package regression tests are in `tests/`.

From the repository root, run:

```sh
Rscript --vanilla validation/core_equivalence.R . validation/frozen_reference_core.R validation/results
```

The check compares the current package code with a fixed reference on 96 synthetic
settings and 768 bootstrap draws. It checks numerical implementation agreement,
not asymptotic validity or general complex-survey variance estimation.
Generated results are not tracked.

## Reference provenance

`frozen_reference_core.R` is the GPL-3 reference implementation from
`R/wdsm_core_final.R` in `ykzeng-yale/SW_DSM`, commit
`f29994650568a6c74098234035420985de97b9ad`. It is not installed or used by the
package at runtime.

SHA-256: `cfc520662596c44b221a53a810254436ef36ae633a466b42e8c2109876c9c15f`.
