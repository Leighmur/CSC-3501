.data
s: .asciiz "Leigh Wright"
t: .word 0:256	
justWorkPlease: .asciiz "\n"

.text
main:
	
la $s0, s               #s0 = Leigh Wright
la $s1, t               #s1=t
li $t0, 256 		#t0=256
li $t1, 0               #variable i

Loop0:
beq $t1, $t0, Exit0   #for(int=i; i<256;) then exits Loop0
addi $t1, $t1, 4     #i+4; makes the i go onto the next index in the array ###
li $t3, 8            #t3=8
li $t4, 0            #counter1
j Loop0              #jumps to the beginning of the loop

Loop1:

beq $t4, $t3, Exit1     	#for(int j=0; j<8), then goes to Exit1
andi  $t8, $t2, 1       	#temp and 1
beq $t8, $zero, Else        #if(temp&1);if not then go to Else
srl $t9, $t2, 1         	#(temp shr 1)
xori $t2, $t9, 0xEDB88320       #temp = (temp shr 1) xor 0xEDB88320 (from starter code)
j Loop1            		 #jumps to the beginning of Loop1
	Else:
srl $t2, $t2, 1 	   #t2 shr 1
Exit1:              	     #exits Loop1

mul $t5, $t1, 4 	#t5=i*4; gives bit address
add $t5, $t5, $s1 	#set t5 to t, not s
sw  $t2, 0($t5)		#t[i] is the temp
addi $t1, $t1, 1 	#i++
j Loop0			#jump back to top of Loop1
Exit0:	             #exits Loop0

addi $t7, $zero, 0xFFFFFFFF 	#crc32=0xFFFFFFFF  (from starter code)
li $t8, 13			#bit length of s
li $t9, 0 			#t9 is counter2

Loop2:

beq $t9, $t8, Exit2	#if(t4=256) Exit2
add $t6, $t9, $s0 	#t6 to s, not t
lb $t2, 0($t6) 		#t2 = s[i]
xor $t3, $t7, $t2 	#t3 = crc32 xor s[i]
andi $t5, $t3, 0xFF 	#t5 = (crc32 xor s[i]) and 0xFF
srl $t1, $t7, 8 	#t1 = crc32 shr 8
mul $t2, $t5, 4 	#t2 = k*4 to get actual bit address
add $t2, $t2, $s1  	#set t2 to t; not s
lw $t3, 0($t2) 		#t3=t[k]
xor $t7, $t1, $t3 	#crc32=(crc32 shr 8) xor t[k]
addi $t9, $t9, 1 	#k++

Exit2:

xori $t7, $t7, 0xFFFFFFFF #crc32=crc32 xor 0xFFFFFFFF (from starter code)
li $v0, 4
la $a0, s
syscall

li $v0, 4  
la $a0 justWorkPlease
syscall

li $v0, 34
add $a0, $t7, $zero
syscall




