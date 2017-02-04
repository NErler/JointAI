#' function doing the actual work
#' @param x a number
#' @param y a number
#' @param z a number
#' @name fun2
NULL


fun2 <- function(args) {
  list2env(args, sys.frame(sys.nframe()))

  if(type == 1) {
    res <- x + y
  }
  if(type == 2) {
    res <- x * y/z
  }
  return(res)
}


#' @rdname fun2
#' @export

fun1a <- function(x = NULL, y = NULL) {
  args <- mget(names(formals()), sys.frame(sys.nframe()))
  args$type <- 1

  res <- fun2(args)

  return(list(args = args, res = res))
}

#' @rdname fun2
#' @export
fun1b <- function(x = NULL, y = NULL, z = NULL) {
  args <- mget(names(formals()), sys.frame(sys.nframe()))
  args$type <- 2

  res <- fun2(args)

  return(list(args = args, res = res))
}



