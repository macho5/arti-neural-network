.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    bge a2, t0, assert1

    li a1, 75
    j exit2

assert1:
    bge a3, t0, assert2

    li a1, 76
    j exit2


assert2:
    bge a4, t0, loop_prepare

    li a1, 76
    j exit2

    
loop_prepare:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    li t2, 4
    li t3, 4
    mul t2, a3, t2
    mul t3, a4, t3
    li t0, 0 # t0: index
    li s0, 0 # s0: sum

loop_start:
    lw s1, 0(a0)
    lw s2, 0(a1)
    mul t1, s1, s2
    add s0, s0, t1 
    addi t0, t0, 1
    beq t0, a2, loop_end

   
    add a0, a0, t2
    add a1, a1, t3
    j loop_start

loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    
    ret
