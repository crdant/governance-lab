package main

empty(value) {
  count(value) == 0
}

no_violations {
  empty(deny)
}
