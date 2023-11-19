using System;

public class FizzBuzz
{
		public static void Main(string[] args)
		{
        const uint n = 100;
        if (n == 0) {
            return;
        }
        Console.Write("0\n");
        string output = "";
        for (int i = 1; i <= n; i++) {
            if (i % 3 == 0) {
                output += "Fizz";
            }
            if (i % 5 == 0) {
                output += "Buzz";
            }
            if (output == "") {
                output += i.ToString();
            }
            output += "\n";
            Console.Write(output);
            output = "";
        }
		}
}
