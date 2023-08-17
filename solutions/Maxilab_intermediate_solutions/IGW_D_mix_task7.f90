      subroutine IGW_D_mix(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         integer :: k
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return

         print *, 'I am using IGW_D_mix'
         
         do k=1, s% nz
            s% D_mix(k) = 1d4
         end do

      end subroutine IGW_D_mix
