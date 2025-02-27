test_that("handles grouping correctly", {
  d <- diamonds[1:1000, ]
  all_ones <- function(x) all.equal(mean(x), 1)

  base <- ggplot(d, aes(cut, clarity))

  ret <- layer_data(base + stat_sum())
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_true(all_ones(ret$prop))

  ret <- layer_data(base + stat_sum(aes(group = 1)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_equal(sum(ret$prop), 1)

  ret <- layer_data(base + stat_sum(aes(group = cut)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_true(all_ones(tapply(ret$prop, ret$x, FUN = sum)))

  ret <- layer_data(base + stat_sum(aes(group = cut, colour = cut)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_true(all_ones(tapply(ret$prop, ret$x, FUN = sum)))

  ret <- layer_data(base + stat_sum(aes(group = clarity)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_true(all_ones(tapply(ret$prop, ret$y, FUN = sum)))

  ret <- layer_data(base + stat_sum(aes(group = clarity, colour = cut)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), nrow(d))
  expect_true(all_ones(tapply(ret$prop, ret$y, FUN = sum)))

  ret <- layer_data(base + stat_sum(aes(group = 1, weight = price)))
  expect_equal(nrow(ret), 38)
  expect_equal(sum(ret$n), sum(d$price))
  expect_equal(sum(ret$prop), 1)
})


# Visual tests ------------------------------------------------------------

test_that("summaries are drawn correctly", {
  expect_doppelganger("summary with color and lines",
    ggplot(mtcars, aes(x = cyl, y = mpg, colour = factor(vs))) +
      geom_point() +
      stat_summary(fun = mean, geom = "line", size = 2)
  )
  expect_doppelganger("summary with crossbars, no grouping",
    ggplot(mtcars, aes(x = cyl, y = mpg)) +
      geom_point() +
      stat_summary(
        fun.data = mean_se,
        colour = "red",
        geom = "crossbar",
        width = 0.2
      )
  )
  expect_doppelganger("summary with crossbars, manual grouping",
    ggplot(mtcars, aes(x = cyl, y = mpg, group = cyl)) +
      geom_point() +
      stat_summary(
        fun.data = mean_se,
        colour = "red",
        geom = "crossbar",
        width = 0.2
      )
  )
})
