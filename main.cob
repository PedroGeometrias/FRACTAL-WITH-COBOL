      *>> this is a division, cobol respects a structured way to code
      * which can be pretty annoying, so basically we have divisions,
      * that inside them weh have sections, inside sections we have 
      * paragrahs, and finally we have sentences
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BURNING-SHIP.
       AUTHOR. PEDRO HARO.

      *>> this divisions is empty because I don't really think that I
      *have a target, compiler will just ignore this
       ENVIRONMENT DIVISION.
      *>> in this division I declare all the data that is used by the
      *system
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *>> these variables are declared here as a POINTER, which
      *basically means that I'm declaring them as something like 
      *void*, the reason for that is that I'm going to use them 
      *as my SDL renderer ans window, but COBOL doesn't need to know
      *that, it needs only to know that these two variables should be
      *passed around and used as pointers
       01 REN                USAGE POINTER.
       01 WIN                USAGE POINTER.
      *>> this variable is used to check return values from the c
      *functions, I also declare my loop control variable, it acts
      *basically like a boolean with default value set to false
       01 RETURN-VAL         PIC S9(9)  COMP-5.
       01 IS-RUNNING         PIC S9(9)  COMP-5 VALUE 0.

      *>> WIDTH and HEIGHT of the window, I declare them here since I'm
      *going to use them on my operations
       01 WIDTH              PIC S9(9)  COMP-5 VALUE 880.
       01 HEIGHT             PIC S9(9)  COMP-5 VALUE 880.

      *>> these variables will describe my pixels, like their position
      *and color
       01 X                  PIC S9(9)  COMP-5.
       01 Y                  PIC S9(9)  COMP-5.
       01 R                  PIC S9(9)  COMP-5.
       01 G                  PIC S9(9)  COMP-5.
       01 B                  PIC S9(9)  COMP-5.
       01 A                  PIC S9(9)  COMP-5.

      *>>  SCALE here is pretty important, cobol doesn't have native
      *floating points variables, so we use this variables to scale all
      *interers for fixed point arimethic, for example the value 1.234
      *will be stored as 12340000
       01 SCALE              PIC S9(9)  COMP-5 VALUE 1000000.

      *>> ITERATOR is basically a loop counter, MAX-ITERATOR will tell
      *us how deeply the program should calculate the formula, giving
      *more details:w
       01 ITERATOR           PIC S9(9)  COMP-5.
       01 MAX-ITERATOR       PIC S9(9)  COMP-5 VALUE 100.

      *>> these variables are used to determine the complex region,
      *basically focusing only on the place where the SHIP is  
       01 REAL-SPAN-MIN          PIC S9(18) COMP-5 VALUE -1840000.
       01 REAL-SPAN-MAX          PIC S9(18) COMP-5 VALUE -1720000.
       01 IMAG-SPAN-MIN          PIC S9(18) COMP-5 VALUE  -80000.
       01 IMAG-SPAN-MAX          PIC S9(18) COMP-5 VALUE   60000.

       01 IMAG-SPAN-TOTAL        PIC S9(18) COMP-5.
       01 REAL-SPAN-TOTAL        PIC S9(18) COMP-5.

      *>> these guys are like temporary variables, they will be used to
      *store the current value and then pass it to the next iteration of
      *the formula
       01 CURRENT-REAL       PIC S9(18) COMP-5.
       01 CURRENT-IMAG       PIC S9(18) COMP-5.

      *>> these variables are a conversion of the complex number to a
      *pixel place
       01 PIXEL-REAL         PIC S9(18) COMP-5.
       01 PIXEL-IMAG         PIC S9(18) COMP-5.

      *>> these two are absulete values of the CURRENT REAL and IMAG
       01 AX                 PIC S9(18) COMP-5.
       01 AY                 PIC S9(18) COMP-5.

      *>> two temporary variables
       01 XR2                PIC S9(18) COMP-5.
       01 YI2                PIC S9(18) COMP-5.

      *>> these two are used to update CURRENT REAL and IMAG
       01 NEXT-REAL          PIC S9(18) COMP-5.
       01 NEXT-IMAG          PIC S9(18) COMP-5.

      *>> SQUARE distance from origin and maximum escape treshold,
      *ESCAPED is used to indicate if the pixel has escaped
       01 RSQ                PIC S9(18) COMP-5.
       01 BAILOUT            PIC S9(18) COMP-5 VALUE 4000000.
       01 ESCAPED            PIC S9(9)  COMP-5.

      *>> STEP size of pixels on the complex plane, used for conversion
       01 REAL-STEP          PIC S9(18) COMP-5.
       01 IMAG-STEP          PIC S9(18) COMP-5.

      *>> how many rows have been rendered, used to update if the number
      *of rows rendered reaches a certain value
       01 COUNTER            PIC S9(9)  COMP-5.

      *>> USED to close the window and cancel rendering 
       01 QUIT-FLAG          PIC 9      VALUE 0.
       01 TWO-AXAY           PIC S9(18) COMP-5.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
      *>> x and y on the complex plane, scaled to fit on the maldebroot
      *scale
           COMPUTE IMAG-SPAN-TOTAL = IMAG-SPAN-MAX - IMAG-SPAN-MIN
           COMPUTE REAL-SPAN-TOTAL = REAL-SPAN-MAX - REAL-SPAN-MIN

      *>> taking the scaled coordinates, and dividing them by the window
      *plane, getting me the "TILE" size of the grid
           COMPUTE REAL-STEP = REAL-SPAN-TOTAL / (WIDTH - 1)
           COMPUTE IMAG-STEP = IMAG-SPAN-TOTAL / (HEIGHT - 1)

      *>> calling the c function and passing the correct type of
      *variable, it weird that for the definition of the type of
      *variable the keyword BY is used, because that KEYWORD is also
      *used in other types of commands, this also goes for other
      *examples
           CALL "create_window"
           USING BY REFERENCE REN BY REFERENCE WIN
           BY VALUE WIDTH BY VALUE HEIGHT
           RETURNING RETURN-VAL
           END-CALL

           IF RETURN-VAL NOT = 0
               DISPLAY "Failed to create SDL window" 
               STOP RUN
           END-IF

      *>> same goes for this function call, this whole function could be
      *interpreted as a "game loop", without update(), so this stuff is
      *pretty normal
           CALL "sdl_set_draw_color_px" 
           USING BY VALUE REN BY VALUE 255 255 255 255 
           END-CALL

           CALL "render_clear"
           USING BY VALUE REN 
           END-CALL

           DISPLAY "Rendering Burning Ship fractal..."

           MOVE 0 TO COUNTER
           MOVE 0 TO QUIT-FLAG
      *>> this nested loop basically will traverse the entire window,
      *and save the current index position, which should be interpreted
      *as the current pixel coordinate on the window plane, which is a
      *normal cartesian plane where the bigger the Y the lower the pixel
           PERFORM VARYING X FROM 0 BY 1 UNTIL X >= WIDTH
      *>> this is the conversion, we know that a imaginary number is
      *made out of (a + bi), which are respectvly:
      *a -> real part 
      *b -> imaginary part
      *i -> imaginary unit, which i*i = -1
      * I'm basically here making my current X into the real part,
      * sounds weird but it makes sense, since we know the step on the
      * complex plane, by multplying it by the current coord we scale
      * it, adding the real span we basically go to the correct location
      * on the maldebrot grid
               COMPUTE PIXEL-REAL = REAL-SPAN-MIN + (X * REAL-STEP)
               END-COMPUTE

               PERFORM VARYING Y FROM 0 BY 1 UNTIL Y >= HEIGHT
      *>> same thing here but for Y, Y is the b from the imaginary
      *number formula
                   COMPUTE PIXEL-IMAG = IMAG-SPAN-MIN + (Y * IMAG-STEP)
                   END-COMPUTE
      *>> mking the z = 0, which is the seed for the burning ship
                   MOVE 0 TO CURRENT-REAL
                   MOVE 0 TO CURRENT-IMAG
      *>> control varibles
                   MOVE 0 TO ITERATOR
                   MOVE 0 TO ESCAPED
      *>> this is the loop that will reiterate the burning ship formula,
      *which is this:
      * zn+1=(∣Re(zn)∣+i∣Im(zn)∣)2+c      
      * I will link the wikipedia page at the end, and some other
      * resources, I will also explain it
      * as we go along, all of that should make it very clear to
      * everyone, cobol is also quite easy to read, which is a
      * detrement to the language but useful for this context
                   PERFORM UNTIL ITERATOR >= MAX-ITERATOR 
                       OR ESCAPED = 1

      *>> here we are taking the aboslute value of current real and
      *imaginary, that's why we create AX and AY, those will be used for
      *the calcs
                       COMPUTE AX = FUNCTION ABS(CURRENT-REAL)
                       COMPUTE AY = FUNCTION ABS(CURRENT-IMAG)

      *>> here I use the temp values to hold, they are on the formula,
      *they basically mean xn and yn, if you look at the formula they
      *are squared
                       COMPUTE XR2 = (AX * AX) / SCALE
                       COMPUTE YI2 = (AY * AY) / SCALE
      *>> caculating zx and zy, real and imaginary parts of z
                       COMPUTE NEXT-REAL = XR2 - YI2 + PIXEL-REAL
                       COMPUTE TWO-AXAY = (2 * AX * AY) / SCALE
                       COMPUTE NEXT-IMAG = TWO-AXAY + PIXEL-IMAG

      *>> squared magnetude scaled
                       COMPUTE RSQ = (NEXT-REAL * NEXT-REAL) / SCALE
                       + (NEXT-IMAG * NEXT-IMAG) / SCALE

      *>> scape condition if maginetude is bigger then then the whole
      *sequence
                       IF RSQ > BAILOUT
                           MOVE 1 TO ESCAPED
                       ELSE
                           MOVE NEXT-REAL TO CURRENT-REAL
                           MOVE NEXT-IMAG TO CURRENT-IMAG
                           ADD 1 TO ITERATOR
                       END-IF
                   END-PERFORM

      *>> here I'm declaring the coloring variables, based on it's
      *degree of iteration
                   IF ITERATOR >= MAX-ITERATOR
                       MOVE 0 TO R G B
                   ELSE
                       COMPUTE R = (255 * ITERATOR) / MAX-ITERATOR
                       COMPUTE G = (128 * ITERATOR) / MAX-ITERATOR
                       COMPUTE B = (64 * ITERATOR) / MAX-ITERATOR
                   END-IF

                   MOVE 255 TO A

      *>> here on out is basically normal SDL stuff
                   CALL "sdl_set_draw_color_px" 
                   USING BY VALUE REN BY VALUE R G B A 
                   END-CALL

                   CALL "sdl_draw_point"       
                   USING BY VALUE REN BY VALUE X Y     
                   END-CALL
               END-PERFORM

               ADD 1 TO COUNTER
               IF COUNTER >= 10 OR X = WIDTH - 1
                   MOVE 0 TO COUNTER
                   CALL "sdl_present" 
                   USING BY VALUE REN 
                   END-CALL

                   CALL "sdl_poll_quit" 
                   RETURNING IS-RUNNING 
                   END-CALL

                   IF IS-RUNNING = 1
                       MOVE 1 TO QUIT-FLAG
                       EXIT PERFORM
                   END-IF
               END-IF
                       END-PERFORM

                       IF QUIT-FLAG = 0
                           CALL "sdl_present" 
                           USING BY VALUE REN 
                           END-CALL
                       END-IF

                       MOVE 0 TO IS-RUNNING
                       PERFORM UNTIL IS-RUNNING = 1
                           CALL "sdl_poll_quit" 
                           RETURNING IS-RUNNING 
                           END-CALL

                           CALL "sdl_delay" 
                           END-CALL
                       END-PERFORM

                       CALL "quit_SDL" 
                       USING BY VALUE REN BY VALUE WIN 
                       END-CALL

                       DISPLAY 
                       "Burning Ship fractal rendered successfully!"
                       STOP RUN.
