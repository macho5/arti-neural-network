.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    addi t0, zero, 1
    bge a1, t0, loop_prepare

    addi a1, zero, 77
    jal exit2

loop_prepare:
    li t1, 0  # t1: index
    lw s0, 0(a0)  # t2: max in vector
    li s1, 0  # t3: the index of max

loop_start:


    lw t0, 0(a0)
    bge s0, t0, loop_continue

    add s1, zero, t1
    add s0, zero, t0


loop_continue:
    addi t1, t1, 1
    addi a0, a0, 4
    bge t1, a1, loop_end
    jal loop_start

loop_end:
    add a0, s1, zero

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12

    ret
