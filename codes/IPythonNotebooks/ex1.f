C File ex1.f
      subroutine foo (a, b, c)
      integer a, b, c
cf2py intent(out) c

      c = a+b
      print*, "Hello from Fortran!"
      print*, "a=",a
      end

