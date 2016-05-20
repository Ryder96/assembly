.data
list: .space 1000
listsz: .word 10 # using as array of integers
.text
main:
  lw $s0, listsz # $s0 = array dimension
  la $s1, list # $s1 = array address
  li $t0, 0 # $t0 = # elems init'd
  li $t2, 10
initlp:
  beq $t0, $s0, initdn
  sw $t2, ($s1) # list[i] = addr of list[i]
  addi $s1, $s1, 4 # step to next array cell
  addi $t2,$t2,10
  addi $t0, $t0, 1 # count elem just init'd
  move $v0, $t0
  b initlp
initdn:
  la $s1,list
  li $t3,0
  li $v0,1
while:
  beq $t3,$t0,end
  li $v0,1
  lw $a0, ($s1)
  syscall
  li $v0,11
  li $a0, 44
  syscall
  addi $s1,$s1,4
  addi $t3,$t3,1
  j while
end:
  li $v0, 10
  syscall
