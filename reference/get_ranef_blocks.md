# Random effects that share one covariance matrix

Usually, each outcome has its own random effects per grouping level,
`b_<outcome>_<lvl>`, with covariance matrix `D_<outcome>_<lvl>`. With
`rd_vcov = "full"`, the random effects of several outcomes form one
vector `b_<lvl>` with covariance matrix `D_<lvl>`; the attribute
"ranef_index" of `rd_vcov` gives the positions of each outcome in it
(e.g. `"1:2"`).

## Usage

``` r
get_ranef_blocks(info_list)
```

## Arguments

- info_list:

  list with the model information of each sub-model
  (`get_model_info()`).

## Value

List with one element per covariance matrix: `name` (`b_<name>`,
`D_<name>`), `lvl` (grouping level), and `parts`, one per outcome, with
`info` (model info), `lvl_info` (hierarchical-centring information of
the level) and `cols` (positions of the outcome's random effects).
