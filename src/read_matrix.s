.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # s3: opened file
    sw s4, 20(sp) # s4: to be returned
    sw s5, 24(sp) # s5: rows * cols
    sw s6, 28(sp)
    sw s7, 32(sp) # s7: iterator(i)
    mv s0, a0
    mv s1, a1
    mv s2, a2

    # open file
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, error90
    mv s3, a0

    # read the number of rows and cols
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error91
    lw s1, 0(s1)

    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error91
    lw s2, 0(s2)

    # malloc for matrix
    mul a0, s1, s2
    li t0, 4
    mul a0, a0, t0
    jal malloc
    beq a0, zero, error88
    mv s4, a0

    # read matrix
    mul s5, s1, s2
    li s7, 0 # i = 0
    mv s6, s4

loop_start:
    mv a1, s3
    mv a2, s6
    li a3, 4
    jal fread
    li t2, 4
    bne a0, t2, error91

    addi s7, s7, 1
    addi s6, s6, 4
    bge s7, s5, loop_end
    j loop_start

loop_end:
    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, error92
    mv a0, s4

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp) # s3: opened file
    lw s4, 20(sp) # s4: to be returned
    lw s5, 24(sp) # s5: rows * cols
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36

    ret

error88:
    li a1, 88
    jal exit2

error90:
    li a1, 90
    jal exit2

error91:
    li a1, 91
    jal exit2

error92:
    li a1, 92
    jal exit2