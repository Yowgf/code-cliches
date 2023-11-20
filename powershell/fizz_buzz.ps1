$n=100
if ($n -eq 0) {
  exit
}
for (($i = 1); $i -le $n; $i++) {
  $output=""
  if (($i % 3) -eq 0) {
    $output="${output}Fizz"
  }
  if (($i % 5) -eq 0) {
    $output="${output}Buzz"
  }
  if ($output -eq "") {
    $output=$i
  }
  echo $output
}
