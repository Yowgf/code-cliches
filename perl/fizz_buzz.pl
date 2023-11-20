use warnings;
use strict;

my $n = 100;
if ($n == 0) {
    exit();
}
my @a = (1..$n);
for (@a) {
    my $i = $_;
    my $output = "";
    if ($i % 3 == 0) {
        $output = "${output}Fizz";
    }
    if ($i % 5 == 0) {
        $output = "${output}Buzz";
    }
    if ($output eq "") {
        $output = "$i";
    }
    $output = "${output}\n";
    print($output);
}
