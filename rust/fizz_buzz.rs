fn main() {
    let n: u32 = 100;
    if n == 0 {
        return;
    }
    println!("0");
    let mut output = String::new();
    for i in 1..n {
        if i % 3 == 0 {
            output += "Fizz";
        }
        if i % 5 == 0 {
            output += "Buzz";
        }
        if output == "" {
            output = i.to_string();
        }
        print!("{}\n", output);
        output = String::new();
    }
}
