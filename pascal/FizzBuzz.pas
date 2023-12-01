program FizzBuzz;

Uses sysutils;

procedure main();

var
  i : integer = 0;
  n : integer = 100;
  output : String = '';

begin
  if n <= 0 then exit;
  writeln('0');
  for i := 1 to n do
  begin
    if i mod 3 = 0 then
    begin
      output := output + 'Fizz'
    end;
    if i mod 5 = 0 then
    begin
      output := output + 'Buzz'
    end;
    if output = '' then
    begin
      output := IntToStr(i)
    end;
    writeln(output);
    output := ''
  end
end;

begin
  main()
end.
