% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/num_day_max.R
\name{num_day_max}
\alias{num_day_max}
\title{Specified Day Maximum Metric Function}
\usage{
num_day_max(data, num.day, max_or_med)
}
\arguments{
\item{data}{dataframe of date and flow data taken from import data functions}

\item{num.day}{number for days of interest}

\item{max_or_med}{maximum of maximum data, or median of maximum data}
}
\value{
specified day maximum metric
}
\description{
Measures maximum of dataframe for given number of days - data must be trimmed to water year
}
