.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw t0, 16(sp)
    sw t1, 20(sp)

    addi t0, zero, 1
    bge a1, t0, loop_prepare

    addi a1, zero, 78
    jal exit2

loop_prepare:
    add t1, zero, zero  # t1: index

loop_start:
    lw t0, 0(a0)
    bge t0, zero, loop_continue

    sw zero, 0(a0)

loop_continue:
    addi a0, a0, 4
    addi t1, t1, 1
    bge t1, a1, loop_end
    jal loop_start

loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw t0, 16(sp)
    lw t1, 20(sp)
    addi sp, sp, 24

	ret

