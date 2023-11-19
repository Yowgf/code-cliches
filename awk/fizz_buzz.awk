BEGIN {
    n=100
    if (n == 0) {
        exit
    }
    for (i = 1; i <= n; i++) {
        output=""
        if (i % 3 == 0) {
            output=output"Fizz"
        }
        if (i % 5 == 0) {
            output=output"Buzz"
        }
        if (output == "") {
            output=i
        }
        print(output)
    }
}
