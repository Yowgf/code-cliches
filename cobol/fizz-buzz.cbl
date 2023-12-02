000000 IDENTIFICATION DIVISION.
000050 PROGRAM-ID. FIZZ-BUZZ.

000100 DATA DIVISION.
000150 WORKING-STORAGE SECTION.

000151*N is the input. We will print fizzbuzz until N.
000200 01 N PIC IS 9(03) VALUE 100.

000250 01 COUNTER PIC IS 9999.
000300 01 OUTPUT-STRING1 PIC IS X(4).
000350 01 OUTPUT-STRING2 PIC IS X(4).
000400 01 OUTPUT-STRING-CONC PIC IS X(16).
000450 01 REM PIC IS 9(01).
000500 01 I PIC IS 9(02).
000550 01 MAX-LENGTH PIC IS 9(02) VALUE 16.

000600 PROCEDURE DIVISION.
000650 MAIN-PROCEDURE.
000700  PERFORM CHECK-INPUT-VALUE
000800  PERFORM DISPLAY-FIZZ-BUZZES
000850  STOP RUN.
000900  CHECK-INPUT-VALUE.
000950    IF N = 0
001000      STOP RUN
001050    END-IF.
001100  DISPLAY-FIZZ-BUZZES.
001150    DISPLAY 0000
001200    MOVE 1 TO COUNTER
001250    PERFORM DISPLAY-FIZZ-BUZZ UNTIL COUNTER = N.
001300  DISPLAY-FIZZ-BUZZ.
001350    MOVE SPACES TO OUTPUT-STRING-CONC
001400    MOVE SPACES TO OUTPUT-STRING1
001450    MOVE SPACES TO OUTPUT-STRING2
001500    DIVIDE COUNTER BY 3 GIVING REM REMAINDER REM
001550    IF REM = 0
001600      MOVE "Fizz" TO OUTPUT-STRING1
001650    END-IF
001700    DIVIDE COUNTER BY 5 GIVING REM REMAINDER REM
001750    IF REM = 0
001800      MOVE "Buzz" TO OUTPUT-STRING2
001850    END-IF
001900    STRING OUTPUT-STRING1 OUTPUT-STRING2 DELIMITED BY SIZE INTO
001901      OUTPUT-STRING-CONC
001950    IF OUTPUT-STRING-CONC IS EQUAL TO SPACES
002000      MOVE COUNTER TO OUTPUT-STRING-CONC
002050    END-IF
002100    PERFORM TRIM-STRING
002150    DISPLAY OUTPUT-STRING-CONC
002200    COMPUTE COUNTER = COUNTER + 1.
002250  TRIM-STRING.
002300    PERFORM VARYING I FROM 1 BY 1 UNTIL I > MAX-LENGTH OR
002301      OUTPUT-STRING-CONC (I:1) NOT = ' '
002350        CONTINUE
002400    END-PERFORM
002450    IF I <= MAX-LENGTH
002500        MOVE OUTPUT-STRING-CONC (I: MAX-LENGTH - I + 1) TO
002501      OUTPUT-STRING-CONC
002550    END-IF.
002600 END PROGRAM FIZZ-BUZZ.
