context("average_baseflow")
library(cbp6)
data <- data.frame(date = as.Date(c("2019-01-01", "2019-01-02")),flow = c(100,500))

test_that(
  "a description of my test",
  {
    expect_equal(is.nan(average_baseflow(data)), TRUE)
  }
)
