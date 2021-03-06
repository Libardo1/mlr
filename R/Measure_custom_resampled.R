#' @title Construct your own resampled performance measure.
#'
#' @description
#' Construct your own performance measure, used after resampling.
#' Note that individual training / test set performance values will be set to \code{NA}, you
#' only calculate an aggregated value. If you can define a function that makes sense
#' for every single training / test set, implement your own \code{\link{Measure}}.
#'
#' @param id [\code{character(1)}]\cr
#'   Name of aggregated measure.
#' @inheritParams makeMeasure
#' @param fun [\code{function(task, pred, group, pred, extra.args)}]\cr
#'   Calculates performance value from \code{\link{ResamplePrediction}} object.
#'   For rare case you can also use the task, the grouping or the extra arguments \code{extra.args}.
#' @param extra.args [\code{list}]\cr
#'   List of extra arguments which will always be passed to \code{fun}.
#'   Default is empty list.
#' @template ret_measure
#' @family performance
#' @export
makeCustomResampledMeasure = function(id, minimize = TRUE, properties = character(0L),
  fun, extra.args = list(), best = NULL, worst = NULL) {

  assertString(id)
  assertFlag(minimize)
  assertCharacter(properties, any.missing = FALSE)
  assertFunction(fun)
  assertList(extra.args)

  force(fun)
  fun1 = function(task, model, pred, feats, extra.args) NA_real_
  # args are checked here
  custom = makeMeasure(id = "custom", minimize, properties, fun1, extra.args,
   best = best, worst = worst)
  fun2 = function(task, perf.test, perf.train, measure, group, pred)
    fun(task, group, pred, extra.args)
  aggr = makeAggregation(id = id, fun = fun2)
  setAggregation(custom, aggr)
}
