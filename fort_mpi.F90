program mpi_example
    use mpi
    implicit none

    integer :: rank, size, ierr, source, dest, tag
    integer :: send_data, recv_data, global_sum
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
        send_data = 42
        call MPI_Send(send_data, 1, MPI_INTEGER, dest, tag, MPI_COMM_WORLD, ierr)
        print *, 'Process', rank, 'sent data', send_data, 'to process', dest
    else if (rank == dest) then
        call MPI_Recv(recv_data, 1, MPI_INTEGER, source, tag, MPI_COMM_WORLD, status, ierr)
        print *, 'Process', rank, 'received data', recv_data, 'from process', source
    end if

    ! All processes contribute their rank to the sum using MPI_Allreduce
    call MPI_Allreduce(rank, global_sum, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)

    ! Print the result of the global sum (should be sum of all ranks)
    print *, 'Process', rank, ': Global sum of all ranks is', global_sum

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_example
