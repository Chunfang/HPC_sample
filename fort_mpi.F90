program mpi_example
    use mpi
    implicit none

    integer :: rank, size, ierr, source, dest, tag
    integer :: dat_sent, dat_rec, sum_rank
    integer :: status(MPI_STATUS_SIZE)

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    source = 0
    dest = 1
    tag = 99

    ! Send and Receive between rank 0 and 1
    if (rank == source) then
        dat_sent = 42
        call MPI_Send(dat_sent, 1, MPI_INTEGER, dest, tag, MPI_COMM_WORLD, ierr)
        print *, 'rank', rank, 'sent', dat_sent, 'to rank', dest
    else if (rank == dest) then
        call MPI_Recv(dat_rec, 1, MPI_INTEGER, source, tag, MPI_COMM_WORLD, status, ierr)
        print *, 'rank', rank, 'received data', dat_rec, 'from rank', source
    end if

    ! All ranks add their rank_num to the sum using MPI_Allreduce
    call MPI_Allreduce(rank, sum_rank, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)

    ! print sum of all ranks)
    print *, 'Process', rank, ': Global sum of all ranks is', sum_rank
    call MPI_Finalize(ierr)

end program mpi_example
