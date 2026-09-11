# External regression audit: the reference file is the frozen manuscript core,
# not a copy of candidate package functions. No packages or user data are needed.
args <- commandArgs(TRUE)
script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
script_dir <- if (length(script_arg)) dirname(normalizePath(sub("^--file=", "", script_arg[1]))) else "validation"
pkg_root <- if (length(args)) args[1] else file.path(script_dir, "..")
reference <- if (length(args) > 1) args[2] else file.path(script_dir, "frozen_reference_core.R")
out_dir <- if (length(args) > 2) args[3] else file.path(script_dir, "results")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
pkg <- new.env(parent = globalenv())
for (f in list.files(file.path(pkg_root, "R"), pattern = "[.]R$", full.names = TRUE)) sys.source(f, pkg)
ref <- new.env(parent = globalenv())
sys.source(reference, ref)

ps_formulas <- list(Cor = Z ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
                   Mis = Z ~ X1 + X2 + X3 + X4 + X5 + X6)
pg_formulas <- list(Cor = Y ~ X1 + X2 + X3 + X4 + X5 + X6 + X1:X2,
                   Mis = Y ~ X1 + X2 + X3 + X4 + X5 + X6)
make_fixture <- function(overlap, sampling) {
  set.seed(82296L + 113L*(overlap == "Poor") + 227L*(sampling == "prospective"))
  n <- 400L
  X <- setNames(as.data.frame(matrix(rnorm(n*6L), n)), paste0("X", 1:6))
  strength <- if (overlap == "Good") 0.45 else 1.3
  p <- plogis(strength*(0.5*X$X1 - 0.7*X$X2 + 0.35*X$X3 + 0.25*X$X1*X$X2))
  A <- rbinom(n, 1, p)
  Y <- 1 + X$X1 + 0.5*X$X2 - 0.3*X$X4 + 0.6*X$X1*X$X2 +
    A*(1 + 0.4*X$X3) + rnorm(n)
  survey_weight <- exp(0.3*X$X1 - 0.25*X$X2 + if (sampling == "retrospective") 0.4*A else 0)
  data.frame(Y, A, survey_weight, X)
}
results <- list()
row_id <- 0L
all_draws <- list()
warnings <- character()
for (overlap in c("Good", "Poor")) for (sampling in c("retrospective", "prospective")) {
  dat <- make_fixture(overlap, sampling)
  X <- dat[paste0("X", 1:6)]
  for (estimand in c("PATE", "PATT")) for (ps_spec in c("Cor", "Mis")) for (pg_spec in c("Cor", "Mis")) {
    for (M in c(1L, 3L, 5L)) {
      row_id <- row_id + 1L
      id <- paste(overlap, sampling, estimand, paste0(ps_spec, pg_spec), M, sep = "_")
      ps_formula <- ps_formulas[[ps_spec]]
      ref_formula <- ps_formula
      ref_formula[[2L]] <- as.name("A")
      pg_formula <- pg_formulas[[pg_spec]]
      B <- 8L
      seed <- 99170L + row_id
      fit_fun <- pkg[[if (estimand == "PATE") "wdsmatchATE" else "wdsmatchATT"]]
      set.seed(seed)
      candidate <- withCallingHandlers(fit_fun(dat$Y, X, dat$A, dat$survey_weight, M = M,
        model.ps = ps_formula, model.pg = pg_formula, sampling = sampling, boots = B, alpha = .05),
        warning = function(w) { warnings <<- c(warnings, paste(id, conditionMessage(w))); invokeRestart("muffleWarning") })
      set.seed(seed)
      gold <- ref$wdsm_final(dat, ref_formula, pg_formula, estimand = estimand,
        sampling_design = sampling, M = M, B = B, keep_point = TRUE)
      deltas <- c(estimate = abs(candidate$estimate-gold$estimate),
        se = abs(candidate$se-gold$se),
        ci = max(abs(candidate$ci-c(gold$ci_lower, gold$ci_upper))),
        replicates = max(abs(candidate$boot.estimates-gold$bootstrap_samples)))
      if (any(!is.finite(deltas)) || any(deltas > 1e-10))
        stop(id, " failed: ", paste(names(deltas), format(deltas, digits = 17), collapse = "; "))
      stopifnot(inherits(candidate, "wdsmatch"), length(candidate$boot.estimates) == B,
        isTRUE(all.equal(mean(candidate$ci), candidate$estimate, tolerance = 1e-13)),
        isTRUE(all.equal(candidate$se^2, mean((candidate$boot.estimates - mean(candidate$boot.estimates))^2), tolerance = 1e-13)))
      results[[row_id]] <- data.frame(id, overlap, sampling, estimand, ps_spec, pg_spec, M, B,
        seed, estimate = candidate$estimate, se = candidate$se,
        max_estimate_difference = deltas["estimate"], max_se_difference = deltas["se"],
        max_ci_difference = deltas["ci"], max_draw_difference = deltas["replicates"], row.names = NULL)
      all_draws[[id]] <- list(candidate = candidate$boot.estimates, reference = gold$bootstrap_samples)
    }
  }
}
metrics <- do.call(rbind, results)
stopifnot(nrow(metrics) == 96L, length(warnings) == 0L)
write.csv(metrics, file.path(out_dir, "core_equivalence_96_settings.csv"), row.names = FALSE)
saveRDS(list(results = metrics, bootstrap_draws = all_draws,
  reference_file = basename(reference), reference_md5 = unname(tools::md5sum(reference)),
  candidate_files_md5 = setNames(unname(tools::md5sum(list.files(file.path(pkg_root, "R"), pattern = "[.]R$", full.names = TRUE))),
    basename(list.files(file.path(pkg_root, "R"), pattern = "[.]R$", full.names = TRUE))),
  warnings = warnings, R_version = R.version.string,
  scope = "96 deterministic synthetic fixture settings x 8 multinomial draws; equivalence audit, not new performance simulations"),
  file.path(out_dir, "core_equivalence_96_settings.rds"))
cat("PASS:", nrow(metrics), "settings and", sum(metrics$B), "paired bootstrap draws.\n")
print(vapply(metrics[grep("^max_", names(metrics))], max, numeric(1)), digits = 16)
