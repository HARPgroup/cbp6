% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/num_day_min.R
\name{num_day_min}
\alias{num_day_min}
\title{Specified Day Minimum Metric Function}
\usage{
num_day_min(data, num.day, min_or_med)
}
\arguments{
\item{data}{dataframe of date and flow data taken from import data functions}

\item{num.day}{number for days of interest}

\item{min_or_med}{minimum of minimum data, or median of minimum data}
}
\value{
specified day minimum metric
}
\description{
Measures minimum of dataframe for given number of days - data must be trimmed to water year
}
