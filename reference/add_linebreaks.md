# Add line breaks to a linear predictor string

Adds line breaks to a string, breaking it after a "+" sign to not exceed
a given width of characters and taking into account indentation.

## Usage

``` r
add_linebreaks(string, indent, width = 90L)
```

## Arguments

- string:

  a character string (linear predictor)

- indent:

  integer; number of characters the new line should be indented

- width:

  integer; the maximum number of characters per line
