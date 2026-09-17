# Full-size case-study regression comparison against separately executed case code.
args<-commandArgs(TRUE);stopifnot(length(args)==4L)
pkg_root<-normalizePath(args[1]);repo<-normalizePath(args[2]);records<-normalizePath(args[3]);out<-args[4]
task<-as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID","0"));stopifnot(task %in% 0:4)
dir.create(out,recursive=TRUE,showWarnings=FALSE)
file<-file.path(out,sprintf("case_parity_%02d.rds",task));if(file.exists(file))stop("Refusing overwrite")
pkg<-new.env();for(f in list.files(file.path(pkg_root,"R"),pattern="[.]R$",full.names=TRUE))sys.source(f,pkg)
gold<-readRDS(file.path(records,sprintf("task_%02d.rds",task)))
stopifnot(gold$status=="complete")
config<-new.env();sys.source(file.path(repo,"CaseStudy/case_rerun_config.R"),config)
if(task<3L) {
  d<-readRDS(file.path(repo,"CaseStudy/data_preparation_20260917/nhanes_clean_3790.rds"))
  vars<-config$case_rerun_config$nhanes_input$variables
  design<-"retrospective"
} else {
  Sys.setenv(NSDUH_INPUT=file.path(repo,"CaseStudy/data_preparation_20260917/nsduh_rebuilt_17471.rds"))
  sys.source(file.path(repo,"CaseStudy/NSDUH/prepare_nsduh.R"),config)
  prep<-config$nsduh_prepare_data(repo);d<-prep$data;vars<-prep$covariates
  d$Y<-d[[c("AMIPY","SMIPY")[task-2L]]];d$survey_weight<-d$ANALWT2_C
  design<-"prospective"
}
RNGkind("Mersenne-Twister","Inversion","Rejection")
assign(".Random.seed",gold$manifest$seed_start,.GlobalEnv)
result<-pkg$wdsmatchATE(d$Y,d[vars],d$A,d$survey_weight,M=gold$manifest$M,
  sampling=design,boots=200,tie.seed=gold$manifest$tie_seed)
stopifnot(identical(.Random.seed,gold$manifest$seed_end))
reference<-gold$fits$WDSM
changes<-c(estimate=abs(result$estimate-gold$summary$estimate),
  SE=abs(result$se-gold$summary$SE),
  CI=max(abs(result$ci-c(gold$summary$lower,gold$summary$upper))),
  draws=max(abs(result$boot.estimates-reference$bootstrap_estimates)))
stopifnot(all(is.finite(changes)),all(changes<1e-9),length(result$boot.estimates)==200L)
# Compare actual allocation under exact-only versus roundoff-tolerant rules.
scores<-pkg$estimate_scores(d$Y,d[vars],d$A,d$survey_weight,NULL,NULL,
  reformulate(vars,"Z"),reformulate(vars,"Y"),design,"PATE")
exact<-pkg$wdsm_make_matches(d$A,scores$D0,scores$D1,gold$manifest$M,"PATE",
  tie_seed=gold$manifest$tie_seed,tie_tolerance=0)
roundoff<-pkg$wdsm_make_matches(d$A,scores$D0,scores$D1,gold$manifest$M,"PATE",
  tie_seed=gold$manifest$tie_seed)
stopifnot(identical(exact$matches_0,roundoff$matches_0),identical(exact$matches_1,roundoff$matches_1))
files<-list.files(file.path(pkg_root,"R"),pattern="[.]R$",full.names=TRUE)
saveRDS(list(status="complete",result=result,max_differences=changes,
  case_manifest=gold$manifest,case_record_md5=tools::md5sum(file.path(records,sprintf("task_%02d.rds",task))),
  source_md5=setNames(unname(tools::md5sum(files)),basename(files)),
  exact_and_roundoff_allocation_identical=TRUE,session=sessionInfo()),file)
print(changes,digits=14)
