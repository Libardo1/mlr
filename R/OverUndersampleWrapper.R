#' @title Fuse learner with simple ove/underrsampling for imbalancy correction in binary classification.
#'
#' @description
#' Creates a learner object, which can be
#' used like any other learner object.
#' Internally uses \code{\link{oversample}} or \code{\link{undersample}} before every model fit.
#'
#' Note that observation weights do not influence the sampling and are simply passed
#' down to the next learner.
#'
#' @template arg_learner
#' @param usw.rate [\code{numeric(1)}]\cr
#'   Factor to downsample the bigger class. Must be between 0 and 1,
#'   where 1 means no downsampling, 0.5 implies reduction to 50 percent
#'   and 0 would imply reduction to 0 observations.
#'   Default is 1.
#' @param osw.rate [\code{numeric(1)}]\cr
#'   Factor to oversample the smaller class. Must be between 1 and \code{Inf},
#'   where 1 means no oversampling and 2 would mean doubling the class size.
#'   Default is 1.
#' @template ret_learner
#' @family imbalancy
#' @family wrapper
#' @export
makeUndersampleWrapper = function(learner, usw.rate = 1) {
  # FIXME: check binary classif
  learner = checkLearner(learner, "classif")
  pv = list()
  if (!missing(usw.rate)) {
    assertNumber(usw.rate, lower = 0, upper = 1)
    pv$usw.rate = usw.rate
  }
  id = paste(learner$id, "undersampled", sep = ".")
  ps = makeParamSet(
    makeNumericLearnerParam(id = "usw.rate")
  )
  makeBaseWrapper(id, learner, package = "mlr", par.set = ps, par.vals = pv,
    learner.subclass = "UndersampleWrapper", model.subclass = "UndersampleModel")
}

#' @rdname makeUndersampleWrapper
#' @export
makeOversampleWrapper = function(learner, osw.rate = 1) {
  learner = checkLearner(learner, "classif")
  pv = list()
  if (!missing(osw.rate)) {
    assertNumber(osw.rate, lower = 1)
    pv$osw.rate = osw.rate
  }
  id = paste(learner$id, "oversampled", sep = ".")
  ps = makeParamSet (
    makeNumericLearnerParam(id = "osw.rate")
  )
  makeBaseWrapper(id, learner, package = "mlr", par.set = ps, par.vals = pv,
    learner.subclass = "OversampleWrapper", model.subclass = "OversampleModel")
}

#' @export
trainLearner.UndersampleWrapper = function(.learner, .task, .subset, .weights = NULL, usw.rate = 1, ...) {
  .task = subsetTask(.task, .subset)
  .task = undersample(.task, rate = usw.rate)
  m = train(.learner$next.learner, .task, weights = .weights)
  makeChainModel(next.model = m, cl = "UndersampleModel")
}

#' @export
trainLearner.OversampleWrapper = function(.learner, .task, .subset, .weights = NULL, osw.rate = 1, ...) {
  .task = subsetTask(.task, .subset)
  .task = oversample(.task, rate = osw.rate)
  m = train(.learner$next.learner, .task, weights = .weights)
  makeChainModel(next.model = m, cl = "OversampleModel")
}

