program fizz_buzz
  character(len=32) :: output
  integer :: i = 0
  n = 100
  if (n == 0) then
    stop
  end if
  write(output, '(I32)') 0
  print *, trim(adjustl(output))
  do i = 1, n
    output = ""
    if (mod(i, 3) == 0) then
      output = trim(output) // "Fizz"
    end if
    if (mod(i, 5) == 0) then
      output = trim(output) // "Buzz"
    end if
    if (len_trim(output) == 0) then
      write(output, '(I32)') i
    end if
    print *, trim(adjustl(output))
  end do
end program fizz_buzz
