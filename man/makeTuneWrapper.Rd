% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/TuneWrapper.R
\name{makeTuneWrapper}
\alias{makeTuneWrapper}
\title{Fuse learner with tuning.}
\usage{
makeTuneWrapper(learner, resampling, measures, par.set, control,
  show.info = getMlrOption("show.info"))
}
\arguments{
\item{learner}{[\code{\link{Learner}} | \code{character(1)}]\cr
The learner.
If you pass a string the learner will be created via \code{\link{makeLearner}}.}

\item{resampling}{[\code{\link{ResampleInstance}} | \code{\link{ResampleDesc}}]\cr
Resampling strategy to evaluate points in hyperparameter space. If you pass a description,
it is instantiated once at the beginning by default, so all points are
evaluated on the same training/test sets.
If you want to change that behavior, look at \code{\link{TuneControl}}.}

\item{measures}{[list of \code{\link{Measure}} | \code{\link{Measure}}]\cr
Performance measures to evaluate. The first measure, aggregated by the first aggregation function
is optimized, others are simply evaluated.}

\item{par.set}{[\code{\link[ParamHelpers]{ParamSet}}]\cr
Collection of parameters and their constraints for optimization.}

\item{control}{[\code{\link{TuneControl}}]\cr
Control object for search method. Also selects the optimization algorithm for tuning.}

\item{show.info}{[\code{logical(1)}]\cr
Print verbose output on console?
Default is set via \code{\link{configureMlr}}.}
}
\value{
[\code{\link{Learner}}].
}
\description{
Fuses a base learner with a search strategy to select its hyperparameters.
Creates a learner object, which can be used like any other learner object,
but which internally uses \code{\link{tuneParams}}.
If the train function is called on it,
the search strategy and resampling are invoked
to select an optimal set of hyperparameter values. Finally, a model is fitted on the
complete training data with these optimal hyperparameters and returned.
See \code{\link{tuneParams}} for more details.

After training, the optimal hyperparameters (and other related information) can be retrieved with
\code{\link{getTuneResult}}.
}
\examples{
task = makeClassifTask(data = iris, target = "Species")
lrn = makeLearner("classif.ksvm")
# stupid mini grid
ps = makeParamSet(
  makeDiscreteParam("C", values = 1:2),
  makeDiscreteParam("sigma", values = 1:2)
)
ctrl = makeTuneControlGrid()
inner = makeResampleDesc("Holdout")
outer = makeResampleDesc("CV", iters = 2)
lrn = makeTuneWrapper(lrn, resampling = inner, par.set = ps, control = ctrl)
mod = train(lrn, task)
print(getTuneResult(mod))
# nested resampling for evaluation
# we also extract tuned hyper pars in each iteration
r = resample(lrn, task, outer, extract = getTuneResult)
print(r$extract)
}
\seealso{
Other tune: \code{\link{ModelMultiplexer}},
  \code{\link{makeModelMultiplexer}};
  \code{\link{TuneControl}},
  \code{\link{TuneControlCMAES}},
  \code{\link{TuneControlGenSA}},
  \code{\link{TuneControlGrid}},
  \code{\link{TuneControlIrace}},
  \code{\link{TuneControlRandom}},
  \code{\link{makeTuneControlCMAES}},
  \code{\link{makeTuneControlGenSA}},
  \code{\link{makeTuneControlGrid}},
  \code{\link{makeTuneControlIrace}},
  \code{\link{makeTuneControlRandom}};
  \code{\link{getTuneResult}};
  \code{\link{makeModelMultiplexerParamSet}};
  \code{\link{tuneParams}}; \code{\link{tuneThreshold}}

Other wrapper: \code{\link{CostSensClassifModel}},
  \code{\link{CostSensClassifWrapper}},
  \code{\link{makeCostSensClassifWrapper}};
  \code{\link{CostSensRegrModel}},
  \code{\link{CostSensRegrWrapper}},
  \code{\link{makeCostSensRegrWrapper}};
  \code{\link{makeBaggingWrapper}};
  \code{\link{makeDownsampleWrapper}};
  \code{\link{makeFeatSelWrapper}};
  \code{\link{makeFilterWrapper}};
  \code{\link{makeImputeWrapper}};
  \code{\link{makeMulticlassWrapper}};
  \code{\link{makeOverBaggingWrapper}};
  \code{\link{makeOversampleWrapper}},
  \code{\link{makeUndersampleWrapper}};
  \code{\link{makePreprocWrapperCaret}};
  \code{\link{makePreprocWrapper}};
  \code{\link{makeSMOTEWrapper}};
  \code{\link{makeWeightedClassesWrapper}}
}

