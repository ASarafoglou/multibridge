% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bmult_multBfInformed.R
\name{mult_bf_informed}
\alias{mult_bf_informed}
\title{Evaluates Informed Hypotheses on Multinomial Parameters}
\usage{
mult_bf_informed(
  x,
  Hr,
  a = rep(1, length(x)),
  factor_levels = NULL,
  cred_level = 0.95,
  niter = 5000,
  bf_type = "LogBFer",
  seed = NULL,
  maxiter = 1000,
  nburnin = niter * 0.05
)
}
\arguments{
\item{x}{numeric. Vector with data}

\item{Hr}{string or character. Encodes the user specified informed hypothesis. Use either specified \code{factor_levels}
or indices to refer to parameters. See ``Note'' section for details on how to formulate informed hypotheses}

\item{a}{numeric. Vector with concentration parameters of Dirichlet distribution. Must be the same length as \code{x}. Default sets all concentration parameters to 1}

\item{factor_levels}{character. Vector with category names. Must be the same length as \code{x}}

\item{cred_level}{numeric. Credible interval for the posterior point estimates. Must be a single number between 0 and 1}

\item{niter}{numeric. Vector with number of samples to be drawn from truncated distribution}

\item{bf_type}{character. The Bayes factor type. When the informed hypothesis is compared to the encompassing hypothesis,
the Bayes factor type can be \code{LogBFer}, \code{BFer}, or \code{BFre}. When the informed hypothesis is compared to the null hypothesis,
the Bayes factor type can be \code{LogBFr0}, \code{BF0r}, or \code{BFr0}. Default is \code{LogBFer}}

\item{seed}{numeric. Sets the seed for reproducible pseudo-random number generation}

\item{maxiter}{numeric. Maximum number of iterations for the iterative updating scheme used in the bridge sampling routine.
Default is 1,000 to avoid infinite loops}

\item{nburnin}{numeric. A single value specifying the number of burn-in samples when drawing from the truncated distribution.
Minimum number of burn-in samples is 10. Default is 5\% of the number of samples. Burn-in samples are removed automatically after the sampling.}
}
\value{
List consisting of the following elements
\describe{
\item{\code{$bf_list}}{gives an overview of the Bayes factor analysis:
\itemize{
\item \code{bf_type}: string. Contains Bayes factor type as specified by the user
\item \code{bf}: data.frame. Contains Bayes factors for all Bayes factor types
\item \code{error_measures}: data.frame. Contains for the overall Bayes factor
the approximate relative mean-squared error \code{re2}, the approximate coefficient of variation \code{cv}, and the approximate percentage error \code{percentage}
\item \code{logBFe_equalities}: data.frame. Lists the log Bayes factors for all independent equality constrained hypotheses
\item \code{logBFe_inequalities}: data.frame. Lists the log Bayes factor for all independent inequality constrained hypotheses
}}
\item{\code{$cred_level}}{numeric. User specified credible interval}
\item{\code{$restrictions}}{list that encodes informed hypothesis for each independent restriction:
\itemize{
\item \code{full_model}: list containing the hypothesis, parameter names, data and prior specifications for the full model.
\item \code{equality_constraints}: list containing the hypothesis, parameter names, data and prior specifications for each equality constrained hypothesis.
\item \code{inequality_constraints}: list containing the hypothesis, parameter names, data and prior specifications for each inequality constrained hypothesis.
In addition, in \code{nr_mult_equal} and \code{nr_mult_free} encodes which and how many parameters are
equality constraint or free, in \code{boundaries} includes the boundaries of each parameter, in \code{nineq_per_hyp} states the number of inequality constraint
parameters per independent inequality constrained hypothesis, and in \code{direction} states the direction of
the inequality constraint.
}}
\item{\code{$bridge_output}}{list containing output from bridge sampling function:
\itemize{
\item \code{eval}: list containing the log prior or posterior evaluations
(\code{q11}) and the log proposal evaluations (\code{q12}) for the prior or posterior samples,
as well as the log prior or posterior evaluations (\code{q21}) and the log proposal evaluations (\code{q22})
for the samples from the proposal distribution
\item \code{niter}: number of iterations of the iterative updating scheme
\item \code{logml}: estimate of log marginal likelihood
\item \code{hyp}: evaluated inequality constrained hypothesis
\item \code{error_measures}: list containing in \code{re2} the approximate
relative mean-squared error for the marginal likelihood estimate, in \code{cv} the approximate
coefficient of variation for the marginal likelihood estimate (assumes that bridge estimate is unbiased), and
in \code{percentage} the approximate percentage error of the marginal likelihood estimate
}}
\item{\code{$samples}}{list containing a list for prior samples and a list
of posterior samples from truncated distributions which were used to evaluate inequality constraints.
Prior and posterior samples of independent inequality constraints are again saved
in separate lists. Samples are stored as matrix of dimension \code{nsamples x nparams}.}
}
}
\description{
Evaluates informed hypotheses on multinomial parameters. These hypotheses can contain
(a mixture of) inequality constraints, equality constraints, and free parameters.
Informed hypothesis \eqn{H_r} states that category proportions obey the particular constraint.
\eqn{H_r} can be tested against the encompassing hypothesis \eqn{H_e} or the null hypothesis \eqn{H_0}.
Encompassing hypothesis \eqn{H_e} states that category proportions are free to vary.
Null hypothesis \eqn{H_0} states that category proportions are exactly equal.
}
\details{
The model assumes that data follow a multinomial distribution and assigns a Dirichlet distribution as prior for the model parameters
(i.e., underlying category proportions). That is:
\deqn{x ~ Multinomial(N, \theta)}
\deqn{\theta ~ Dirichlet(\alpha)}
}
\note{
The following signs can be used to encode restricted hypotheses: \code{"<"} and \code{">"} for inequality constraints, \code{"="} for equality constraints,
\code{","} for free parameters, and \code{"&"} for independent hypotheses. The restricted hypothesis can either be a string or a character vector.
For instance, the hypothesis \code{c("theta1 < theta2, theta3")} means
\itemize{
\item \code{theta1} is smaller than both \code{theta2} and \code{theta3}
\item The parameters \code{theta2} and \code{theta3} both have \code{theta1} as lower bound, but are not influenced by each other.
}
The hypothesis \code{c("theta1 < theta2 = theta3 & theta4 > theta5")} means that
\itemize{
\item Two independent hypotheses are stipulated: \code{"theta1 < theta2 = theta3"} and \code{"theta4 > theta5"}
\item The restrictions on the parameters \code{theta1}, \code{theta2}, and \code{theta3} do
not influence the restrictions on the parameters \code{theta4} and \code{theta5}.
\item \code{theta1} is smaller than \code{theta2} and \code{theta3}
\item \code{theta2} and \code{theta3} are assumed to be equal
\item \code{theta4} is larger than \code{theta5}
}
}
\examples{
# data
x <- c(3, 4, 10, 11, 7, 30)
# priors
a <- c(1, 1, 1, 1, 1, 1)
# restricted hypothesis
factor_levels <- c('theta1', 'theta2', 'theta3', 'theta4', 'theta5', 
'theta6')
Hr            <- c('theta1', '<',  'theta2', '&', 'theta3', '=', 'theta4', 
',', 'theta5', '<', 'theta6')
output_total  <- mult_bf_informed(x, Hr, a, factor_levels, seed=2020, niter=2e3)

}
\references{
\insertRef{damien2001sampling}{multibridge}

\insertRef{gronau2017tutorial}{multibridge}

\insertRef{fruhwirth2004estimating}{multibridge}

\insertRef{sarafoglou2020evaluatingPreprint}{multibridge}
}
\seealso{
Other functions to evaluate informed hypotheses: 
\code{\link{binom_bf_equality}()},
\code{\link{binom_bf_inequality}()},
\code{\link{binom_bf_informed}()},
\code{\link{mult_bf_equality}()},
\code{\link{mult_bf_inequality}()}
}
\concept{functions to evaluate informed hypotheses}
