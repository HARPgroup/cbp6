% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/monthly_max.R
\name{monthly_max}
\alias{monthly_max}
\title{Monthly Maximum Metric Function}
\usage{
monthly_max(data, num.month)
}
\arguments{
\item{data}{a dataframe with hydrologic data}

\item{num.month}{the number corresponding to the month whose maximum flow value you wish to receive}
}
\value{
The maximum flow for the specified month
}
\description{
Calculates the maximum flow for a specified month within dataframe - must be trimmed to water year
}
