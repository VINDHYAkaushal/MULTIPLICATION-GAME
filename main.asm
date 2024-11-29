#---------------------------------------------
# Name: Giao Quynh Nguyen & Vindhya Kaushal
# Program name: Input
# Purpose: take user's and computer's input
#          and update the board
# Date: 11/17/2023
#---------------------------------------------
# Data segment
.data

	result: .word 0        	# store the product (user_mov times sys_mov)

	sys_mov: .word 0		# store computer's move

	user_in: .word 0		# store user's move (aka the multiplicand)

	user_ct: .word 0		# store number of user's move

	sys_ct: .word 0			# store number of computer's move

	res_f: .word 0			# store Found value in board search

	

	init_prompt: .asciiz "\nEnter an integer from 1 to 9: "

    sysmove_prompt: .asciiz "\n\nComputer's move: "

    usermove_prompt: .asciiz "\nYour turn: "
    resultw: .asciiz "\nResult: "
	ew: .asciiz "\n"
    invalid_multiplication_prompt: .asciiz "\nResult already exists on the board. Go again"

	board: .word 1, 2, 3, 4, 5, 6,

            7, 8, 9, 10, 12,14

            15, 16, 18, 20, 21,24

            25, 27, 28, 30, 32, 35,

            36, 40, 42, 45, 48, 49,

            54, 56, 63, 64, 72, 81 		#6x6 board

# text segment

.text

.globl main

main:
  # print board game
	jal gameboard
	
	li $v0, 4
	la $a0, sysmove_prompt
	syscall 
	
	li $v0, 42       # syscall code for generating a random integer
	li $a0, 1        # set lower bound (1 in this case)
	li $a1, 9        # set upper bound (9 in this case)
	syscall

	li $t0, 9      # Load 10 into temporary register $t0
	div $a0, $t0     # Divide the random number in $v0 by 10
	mfhi $a0      
	mfhi $a1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	
	li $v0, 1
	syscall 
Loop:

redoinput:	
	li $v0, 4
	la $a0, init_prompt
	syscall
	
	li $v0, 5
	syscall
	
	bgt $v0, 9, redoinput   # Branch if value is greater than or equal to 10
	blt $v0, 1, redoinput
	
	move $a2, $v0
	
	mul $t2, $a2, $a1
###
	li $v0, 4
	la $a0, resultw
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, ew
	syscall
	
	find_index:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	
	find_index_Loop:
		beq $a3, 36, redoinput
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, board($s3)
		beq $t8, $t9 store
		addi $a3, $a3, 1
		j find_index_Loop

	store:
	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	sw $zero, board($s3)
	
	jal winconPlayer
	jal gameboardp
	

	redoinputc: 
	li $v0, 4
	la $a0, sysmove_prompt
	syscall 
	
	li $v0, 42       # syscall code for generating a random integer
	li $a0, 1        # set lower bound (1 in this case)
	li $a1, 9        # set upper bound (9 in this case)
	syscall

	li $t0, 9      # Load 10 into temporary register $t0
	div $a0, $t0     # Divide the random number in $v0 by 10
	mfhi $a0      
	mfhi $a1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	
	li $v0, 1
	syscall 
	
	mul $t2, $a2, $a1
	
	
	li $v0, 4
	la $a0, resultw
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, ew
	syscall
	
	find_index1:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	
	find_index_Loop1:
		beq $a3, 36, redoinputc
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, board($s3)
		beq $t8, $t9 store1
		addi $a3, $a3, 1
		j find_index_Loop1

	store1:
	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	sw $zero, board($s3)
	
	
	
	jal winconComputer
	jal gameboardc
	
j Loop

	


	