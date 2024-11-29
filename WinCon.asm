.data
	playerWinText: .asciiz "CONGRATULATIONS! YOU WON!"
	computerWinText: .asciiz "OUCH! COMPUTER WON"
	arrayTemp:  .word 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 12,14
            15, 16, 18, 20, 21,24
            25, 27, 28, 30, 32, 35,
            36, 40, 42, 45, 48, 49,
            54, 56, 63, 64, 72, 81
           array:  .word 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 12,14
            15, 16, 18, 20, 21,24
            25, 27, 28, 30, 32, 35,
            36, 40, 42, 45, 48, 49,
            54, 56, 63, 64, 72, 81
            
            
.text
.globl winconPlayer

winconPlayer:

find_index:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	
	find_index_Loop:	
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, arrayTemp($s3)
		beq $t8, $t9 check_winnerp
		addi $a3, $a3, 1
		j find_index_Loop

check_winnerp:
	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	sw $zero, array($s3)

	
	
	
	j check_winner



.globl winconComputer

winconComputer:

find_index1:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	
	find_index_Loop1:	
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, arrayTemp($s3)
		beq $t8, $t9 check_winnerc
		addi $a3, $a3, 1
		j find_index_Loop1
		

check_winnerc:

	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	li $v0 -1
	sw $v0, array($s3)

	j check_winner





check_winner:
	 	
	#a3 = index of chosen 
	# $s7 will be my counter variable
	#s6 will be contents of previous
	#s5 equal contents of current
	
	
check_leftright:
	#t8 number will be the starting index we find from
	# we need the number that is left of the index with modulo 0 in respect to 6 since array is 6 by 6
	#so get mudlo and then subtract it from index for starting value
	
	#li $v0,1
	#li $a0,  -11111111
	#syscall 
	
	addi $t8, $zero, 6
	div $a3, $t8
	mfhi $t8
	sub $t8, $a3, $t8
	addi $s4,$t8, 6
	addi $s7, $zero, 1
	addi $s6, $zero, 5000
	addi $s2, $zero, 5
	
	
	
	loop_LR: 
	beq $t8,$s4,check_updown
	
	#load current value
	addi $s3, $zero, 4
	mul $s3, $s3, $t8
	lw $s5, array($s3)
	
	#li $v0,1
	#move $a0,  $s5
	#syscall 
	#branch if current element equal to previoud
	beq $s5, $s6, consecutive1
	
		add $s7, $zero,1
	
		consecutive1:
			addi $s7, $s7, 1
			beq $s7, $s2 VICROY
		
		move $s6, $s5
		addi $t8, $t8, 1
		
		j loop_LR
###########################################################################################################################

check_updown:

	#li $v0,1
	#li $a0,  -1111111222
	#syscall 
	#t8 number will be the starting index we find from
	# we need the number that is left of the index with modulo 0 in respect to 6 since array is 6 by 6
	#so get mudlo and then subtract it from index for starting value
	
	addi $t8, $zero, 6
	div $a3, $t8
	mfhi $t8
	addi $s7, $zero, 1
	addi $s6, $zero, 5000
	addi $s2, $zero, 5
	
	loop_UD: 
	bge $t8,36,check_topleftbotright
	
	#load current value
	addi $s3, $zero, 4
	mul $s3, $s3, $t8
	lw $s5, array($s3)
	#branch if current element equal to previoud
	beq $s5, $s6, consecutive2
	
		add $s7, $zero,1
	
		consecutive2:
			addi $s7, $s7, 1
			beq $s7, $s2 VICROY
		
		move $s6, $s5
		addi $t8, $t8, 6
		
		j loop_UD
###########################################################################################################################

check_topleftbotright:
	move $t8,$a3
	
	loop_sub1:
		ble $t8, 6, continue_TLBR
		addi $s7, $zero, 6
		div $t8, $s7
		mfhi $s7
		beq $s7, 0, continue_TLBR
		addi $t8, $t8, -7
		j loop_sub1
	
	
	continue_TLBR:
	addi $s7, $zero, 1
	addi $s6, $zero, 5000
	addi $s2, $zero, 5
	
	
	loop_TLBR:
		bge $t8,36,check_toprightbotleft
		
		addi $s3, $zero, 4
		mul $s3, $s3, $t8
		lw $s5, array($s3)
		#branch if current element equal to previoud
		beq $s5, $s6, consecutive3
	
		add $s7, $zero,1
	
		consecutive3:
			addi $s7, $s7, 1
			beq $s7, $s2 VICROY
			
		
		addi $s4, $zero, 6
		div $t8, $s4
		mfhi $s4
		beq $s4, 5,check_toprightbotleft
		
		
		
		move $s6, $s5
		
		addi $t8, $t8, 7
		
		j loop_TLBR
###########################################################################################################################
check_toprightbotleft:
	move $t8,$a3
	
	loop_sub2:
		ble $t8, 6, continue_TRBL
		addi $s7, $zero, 6
		div $t8, $s7
		mfhi $s7
		beq $s7, 5, continue_TRBL
		addi $t8, $t8, -5
		j loop_sub2
	
continue_TRBL:
	addi $s7, $zero, 1
	addi $s6, $zero, 5000
	addi $s2, $zero, 5
	
	
	loop_TRBL:
		bge $t8,36, Back_Before
	
		addi $s3, $zero, 4
		mul $s3, $s3, $t8
		lw $s5, array($s3)
		#branch if current element equal to previoud
		beq $s5, $s6, consecutive4
	
		add $s7, $zero,1
	
		consecutive4:
			addi $s7, $s7, 1
			beq $s7, $s2 VICROY
			
		
		addi $s4, $zero, 6
		div $t8, $s4
		mfhi $s4
		beq $s4, 0, Back_Before
		
		
		
		move $s6, $s5
		
		addi $t8, $t8, 5
		
		j loop_TRBL



	
	

###########################################################################################################################

	
		
Back_Before:

	jr $ra
	
	
VICROY:
	
	
	#li $v0,1
	#move $a0,  $s6
	#syscall 
	
	beqz $s6, playerWin
	
	
	li $v0, 4
        la $a0, computerWinText
    	syscall
    	li $v0,10
    	syscall
	
	
	
	#
playerWin: 
	li $v0, 4
        la $a0, playerWinText
    	syscall
    	li $v0,10
    	syscall

	
