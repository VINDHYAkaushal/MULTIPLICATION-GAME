.data
    horiSep: .asciiz "---------------------------\n" # horizontal separator
    vertiSep: .asciiz " | " # vertical separator
    newline:  .asciiz "\n" # newline character
    xChar: .asciiz " X" # X character to print
    spaceChar: .asciiz " " # Space character to print
    
    testArr: .word 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 12,14
            15, 16, 18, 20, 21,24
            25, 27, 28, 30, 32, 35,
            36, 40, 42, 45, 48, 49,
            54, 56, 63, 64, 72, 81 # statically declared array for testing purposes
     .extern board 144
     
     arrayTemp1:  .word 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 12,14
            15, 16, 18, 20, 21,24
            25, 27, 28, 30, 32, 35,
            36, 40, 42, 45, 48, 49,
            54, 56, 63, 64, 72, 81
.text
.globl gameboardp

gameboardp:

find_index2:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	beqz $t9, gameboard
	find_index_Loop2:	
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, arrayTemp1($s3)
		beq $t8, $t9 gameboardplayer
		addi $a3, $a3, 1
		j find_index_Loop2

gameboardplayer:
	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	sw $zero, testArr($s3)

	j gameboard
	
	




.globl gameboardc
gameboardc:

find_index3:
	
	#t9 current number;
	#a3 will be current index
	move $t9, $t2
	add $a3,$zero, $zero
	beqz $t9, gameboard
	find_index_Loop3:	
		addi $s3, $zero, 4
		mul $s3, $s3, $a3
		lw $t8, arrayTemp1($s3)
		beq $t8, $t9 gameboardcomputer
		addi $a3, $a3, 1
		j find_index_Loop3

gameboardcomputer:
	addi $s3, $zero, 4
	mul $s3, $s3, $a3
	li $v0, -1
	sw $v0, testArr($s3)

	j gameboard
	

.globl gameboard
gameboard: 

    li $t1, 0 # row counter
    li $t2, 0 # index for accessing testArr
    
    # Loop for printing the board
    boardLoop:
        # Check if all rows are printed
        bge $t1, 6, endPrinting
        
        # Print horizontal separator
        li $v0, 4
        la $a0, horiSep
        syscall
        
        # Print elements for a row
        li $t3, 0 # column counter
        
        rowLoop:
            # Check if all columns are printed
            bge $t3, 6, endRowPrint
            
            lw $t4, testArr($t2) # load value from testArr
            
            # Check if value is -1, print 'X' instead
            beq $t4, -1, printX
            
            # Check if value is single digit, print space before it
            li $t5, 10
            blt $t4, $t5, printSpace
            j afterPrint
            
            printSpace:
                li $v0, 4
                la $a0, spaceChar # print a space
                syscall
                j afterPrint
            
            afterPrint:
                li $v0, 1
                move $a0, $t4
                syscall
                j continuePrint
                
            printX:
                li $v0, 4
                la $a0, xChar # print 'X'
                syscall
                
            continuePrint:
            # Print vertical separator if not the last column
            blt $t3, 5, printVertiSep
            
            endRowPrint:
                li $v0, 4
                la $a0, newline
                syscall
                
                # Increment row and reset column count
                addi $t1, $t1, 1
                li $t3, 0
                
                # Move to the next row in the array
                addi $t2, $t2, 4 # Move to the next row (6 elements per row, 6 * 4 bytes = 24)
                j boardLoop
                
            printVertiSep:
                li $v0, 4
                la $a0, vertiSep
                syscall
            
            # Move to the next element in testArr
            addi $t2, $t2, 4
            addi $t3, $t3, 1
            j rowLoop
        
    endPrinting:
    	
    	# Print horizontal separator
        li $v0, 4
        la $a0, horiSep
        syscall
    	
        jr $ra # return
