\name{ROTS}
\alias{ROTS}
\alias{ROTS-package}
\alias{print.ROTS}
\alias{summary.ROTS}
\title{Reproducibility-Optimized Test Statistic (ROTS)}

\description{ Calculates the reproducibility-optimized test statistic
	(ROTS) for ranking genes in order of evidence for differential
	expression in two-group comparisons.
}

\usage{
ROTS(data, groups, B, K, seed = NULL, a1 = NULL, a2 = NULL)

summary(object, fdr = NULL, num.genes = NULL, verbose = TRUE)
}
\arguments{

  \item{data}{ a numeric data matrix, in which rows correspond to genes
		and columns correspond to samples.}
	\item{groups}{ a vector indicating the sample groups. }
	\item{B}{an integer specifying the number of bootstrap and permutation
		resamplings. }
	\item{K}{an integer indicating the largest top list size considered. }
	\item{seed}{ an integer seed for the random number generator. }
  \item{a1, a2}{ a non-negative parameter. See details section for
		further information.}
	\item{object}{ an object returned by \code{ROTS}. }
	\item{fdr}{a numeric value specifying the cutoff for the false discovery rate for
		the genes to be outputted. } \item{num.genes}{ an integer specifying
		the number of top genes to be outputted. }
	\item{verbose}{ logical; if \code{FALSE}, suppresses the printing.}
}

\details{ The reproducibility-optimization procedure ROTS enables the
	selection of a suitable gene ranking statistic directly from the given
	dataset. The statistic is optimized among a family of t-type
	statistics d = m/(a1+a2*s), where m is the absolute difference between
	the group averages, s is the pooled standard error, and a1 and a2 are
	the non-negative parameters to be optimized. Two special cases of this
	family are the ordinary t-statistic (a1=0, a2=1) and the signal
	log-ratio (a1=1, a2=0). The optimality is defined in terms of maximal
	overlap of top-ranked genes in group-preserving bootstrap datasets.
	Importantly, besides the group labels, no a priori information about
	the properties of the data is required and no fixed cutoff for the
	gene rankings needs to be specified.  For more details about the
	reproducibility-optimization procedure, see Elo et al. (2008).
  
  The user is given the option to adjust the largest top list size
  considered in the reproducibility calculations, since lowering this
  size can markedly reduce the computation time. In large data matrices
  with thousands of rows, we generally recommend using a size of several
  thousands. In smaller data matrices, and especially if there are many
  rows with only a few non-missing entries, the size of K should be
  decreased accordingly.
	
  ROTS tolerates a moderate number of missing values in the data matrix
  by effectively ignoring their contribution during the operation of the
  procedure. However, each row of the data matrix must contain
  at least two values in both groups. The rows containing only a few
  non-missing values should be removed; or alternatively, the missing data
  entries can be imputed using, e.g., the K-nearest neighbour
  imputation, which is implemented in the Bioconductor package
  \code{impute}.
	
	If the parameter values a1 and a2 are set by the user, then no
	optimization is	performed but the statistic and FDR-values are
	calculated for the given parameters. The false discovery rate (FDR)
	for the optimized test statistic is calculated by permuting the sample
	labels. The results for all the genes can be obtained by setting the
	FDR cutoff to 1.
}
\value{
  \code{ROTS} returns an object of class \code{ROTS}, which is a list
  containing the following components
	
	\item{data}{the expression data matrix.}
	\item{B}{the number of bootstrap and permutation resamplings.}
	\item{d}{the value of the optimized ROTS-statistic for each gene.}
  \item{FDR}{the corresponding FDR-values.}
  \item{a1}{the optimized parameter a1.}
  \item{a2}{the optimized parameter a2.}
  \item{k}{the optimized top list size.}
  \item{R}{the optimized reproducibility value.}
  \item{Z}{the optimized reproducibility Z-score.}

	\code{print} prints the optimized parameters a1 and a2, the optimized
	top list size and the corresponding reproducibility values.

	\code{summary} summarizes the results of a ROTS analysis.  If
	\code{fdr} and \code{num.genes} are not specified, then the optimized
	parameters a1 and a2, the optimized top list size and the
	corresponding reproducibility values are shown. If \code{fdr} or
	\code{num.genes} is specified, then also the gene-specific information
	is shown for the genes at the specified FDR-level or top list size,
	respectively.
}
\references{
	L. L. Elo, S. Filen, R. Lahesmaa and T. Aittokallio:
	Reproducibility-optimized test statistic for ranking genes in
	microarray studies. IEEE/ACM Transactions on Computational Biology and
	Bioinformatics 5: 423--431, 2008.
}

\author{ Laura Elo, Jukka Hiissa

	Maintainer: Laura Elo <laliel@utu.fi>
}

\seealso{ \code{\link{affySpikeIn}} }
\examples{
## ROTS-statistic for the Affymetrix spike-in data. 
rots.out <- ROTS(affySpikeIn, affySpikeIn.L, B = 500, K = 5000)
## Summary of the ROTS results.
rots.summary <- summary(rots.out, fdr = 0.05)
}
\keyword{ math }