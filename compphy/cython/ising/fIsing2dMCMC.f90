! The program simulates 2-d Ising Model in the absence of B-field in a temprature 
! range defined by beta = 0.05, to beta = 5.0. Hamiltonian for the Ising Model in 
! the absence of B-field is

!          H = -J \sum_<ij> s_{i}s_{j}

! For employing periodic boundary conditions, what has been done is that rather than 
! working with an NxN array for N^2 spins, the program is for (N+2)x(N+2) sized array 
! in which the elements are defined as
!          spin = zero                                every is assigned 0
!          spin(1:Nj0,1:Nj0) = one                    the NxN part is chosen 1
!          spin(1:Nj0,0) = spin(1:Nj0,Nj0)            identifying the 0th column with Nth column
!          spin(0,1:Nj0) = spin(Nj0,1:Nj0)            similarly for other rows and columns
!          spin(1:Nj0,Nj0+1) = spin(1:Nj0,1)
!          spin(Nj0+1,1:Nj0) = spin(1,1:Nj0)

! Energy and magnetization are calculated at the beginning and then 
! modifications are done by adding the change in energy and change in magnetization. Calculating 
! the standard deviation of energy and magnetization leads to specific heat and susceptibility and 
! for avg magnetization, the quantity calculated is <|m|> for each Monte Carlo sweep. And <m^2> 
! is always 1 since dividing the sum of squares of spin by the number of spins gives one and the 
! same is the same.  

program main
  use mtmod
  implicit none
  interface
     subroutine hamiltonian(N,spin,Energy)
       integer, intent(in) :: N
       integer, intent(in) :: spin(0:N+1,0:N+1)
       integer, intent(out) :: Energy
     end subroutine hamiltonian
     
  end interface

  integer, parameter :: Nj0 = 32, ISEED = 9384109, zero = 0, &
       one = 1, minus1 = -1, z = 4
  integer, parameter :: sweeps = 1000, burn_in = sweeps/5, N_spins = Nj0*Nj0
  real(8), parameter :: J_f = dble(1.0), foursJ = dble(4.0)*J_f, &
       eightsJ = dble(8.0)*J_f, avg_spin_sq = dble(1.0), dble1 = dble(1.0)
  integer :: spin(0:Nj0+1,0:Nj0+1), mag, del_mag,&
       interactions, twospin_lk
  real(8) :: Energy, del_E, avg_E, avg_E2, sp_heat_c
  real(8) :: avg_mag, chi_X
  real(8) :: weight(2), beta, del_beta, beta_max
  real(8) :: flt, onebyNj02, denomr, twosJ, flip
  integer :: i,j,k,l,m,p

! initialization of the random number seed and defining variables and beta

  call sgrnd(ISEED)
  onebyNj02 = dble1/N_spins
  denomr = dble1/(sweeps-burn_in)
  flt = dble(0.05)
  beta = dble(0.2)
  del_beta = flt
  beta_max = dble(5.0)
  flip = dble(0.5)

! initializing the spin configuration of size (0:N+1,0:N+1), starting randomly
  spin = zero
  do i = 1,Nj0
     do j = 1,Nj0
        flt = grnd()
        if(flt <= flip)then
           spin(i,j) = one
        else
           spin(i,j) = minus1
        end if
     end do
  end do

! imposing the periodic boundary conditions to by redefining the rows and columns
  spin(1:Nj0,0) = spin(1:Nj0,Nj0)
  spin(0,1:Nj0) = spin(Nj0,1:Nj0)
  spin(1:Nj0,Nj0+1) = spin(1:Nj0,1)
  spin(Nj0+1,1:Nj0) = spin(1,1:Nj0)

! calculation of energy and magnetization, this needs to be done only once
  call hamiltonian(Nj0,spin,interactions)
  Energy = -J_f*interactions
  mag = sum(spin(1:Nj0,1:Nj0))
  flip = dble(0.0)
! analysis of the 2d Ising spin system for various temperature ranges
  do while(beta <= beta_max)
     flt = exp(-foursJ*beta)
     weight = [flt,flt*flt]
     avg_E = flip
     avg_E2 = flip
     avg_mag = flip
! iterating the system w.r.t. sweeps- one spin-flip per spin on an average
     do i = 1, sweeps
        do j = 1,Nj0
           do m = 1,Nj0
              l = 1 + int(Nj0*grnd())
              k = 1 + int(Nj0*grnd())
              twospin_lk = 2*spin(l,k)
              interactions = twospin_lk*(spin(l+1,k)+&
                   spin(l-1,k)+spin(l,k+1)+spin(l,k-1))
              p = interactions/z
              del_E = J_f*interactions
              del_mag = -twospin_lk
              if (del_E <= flip)then
                 spin(l,k) = -spin(l,k)
                 Energy = Energy + del_E
                 mag = mag + del_mag
              else
                 flt = grnd()
                 if (flt < weight(p))then
                    spin(l,k) = -spin(l,k)
                    Energy = Energy + del_E
                    mag = mag + del_mag
                 end if
              end if
              spin(1:Nj0,0) = spin(1:Nj0,Nj0)
              spin(0,1:Nj0) = spin(Nj0,1:Nj0)
              spin(1:Nj0,Nj0+1) = spin(1:Nj0,1)
              spin(Nj0+1,1:Nj0) = spin(1,1:Nj0)
           end do
        end do
! calculation of the relevant quantities once the burn-in period is over
        if(i>burn_in)then
           avg_E = avg_E + Energy
           avg_E2 = avg_E2 + Energy*Energy
           avg_mag = avg_mag + onebyNj02*abs(mag) 
        end if
     end do
     avg_E = avg_E*denomr
     avg_E2 = avg_E2*denomr
     avg_mag = avg_mag*denomr
     sp_heat_c = avg_E2 - avg_E*avg_E
     sp_heat_c = onebyNj02*beta*beta*sp_heat_c
     chi_X = avg_spin_sq - avg_mag*avg_mag
     chi_X = N_spins*beta*chi_X
     write(*,*)dble1/beta,avg_mag,sp_heat_c,chi_X
     beta = beta + del_beta
  end do

end program main

subroutine hamiltonian(N,spin,Energy)
  integer, intent(in) :: N
  integer, intent(in) :: spin(0:N+1,0:N+1)
  integer, intent(out) :: Energy
  integer :: i,j

  Energy = 0
  do i = 1,N
     do j = 1,N
        Energy = Energy + spin(i,j)*(spin(i+1,j)+&
             spin(i-1,j)+spin(i,j+1)+spin(i,j-1))
     end do
  end do

end subroutine hamiltonian
