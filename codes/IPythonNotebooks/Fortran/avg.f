C FILE: FIB1.F
      SUBROUTINE AVG(A, B, C, N)
C
C     CALCULATE FIRST N FIBONACCI NUMBERS
C
      INTEGER N
      REAL*8 A(N)
      REAL*8 B(N)
      REAL*8 C(1)
      C = 10
      DO I=1,N
            C  = C + 4*A(I) + B(I)
      ENDDO
      END
C END FILE FIB1.F