# Brando Cuccaro is the leader of this project and will lead Andres and Xhesika to success
# Record { nome[Stringa 8], id [word], priorita'[0-9], cicli [max-> 99] }
# Il programma deve ordinare i vari task per priorita' dal piu' alto al piu' basso, quello con priorita' piu' bassa
# viene eseguito per primo e se sono uguali vanno ordinati in base all'ID in ordine decrescente
# Il secondo metodo ordina i task in ordine crescente secondo i cicli rimanenti se sono uguali guardare sopra
# Fare il menu :
  # inserire un nuovo task chiede il Record
  # eseguire il task che si trova in testa
  # eseguire il task in cui l'id
  # eliminare il task
  # modificare la priorita id
  # cambiare l'ordinamento
  # uscire dal programma
# quando i cicli sono = 1 si eliminano i task
# Al termine di ogni operazione bisogna stampare la coda di scheduling
# sbrk

.data
record: .space 100
welcome_string: .asciiz "Scheduling queque menu\n
                          1) Inserire un nuovo record\n
                          2) Eseguire il task in testa\n
                          3) Eseguire il task con ID in input\n
                          4) Eliminare il task con ID in input\n
                          5) Modificare la priorita' di un task con ID\n
                          6) Cambiare l'ordinamento della queue\n
                          7) Esci dal programma\n
                          Inserire numero operazione: "
record_name: .asciiz "Inserisci nome task: "
record_priority: .asciiz "Inserisci la priorità: "
record_cicles: .asciiz "Inserisci il numero di cicli: "
error: .asciiz "Task Manager vuoto"
idCounter: .word 0
tempName: .space 8
firstNode: .space 4 #space indica il numero di byte riservati nella memoria

topbar: .asciiz "Nome\tId\tProrità\tCicli\n"
tab: .asciiz "\t"

decision_id: .asciiz "Inserisci id"
.text
# Nel main viene visualizzato il menu decisionale
main:
lw $t1, idCounter
addi $t1, $t1, 0
sw $t1, idCounter


  add $sp, $sp, -4
  sw $ra, 0($sp)

loop:
  la $a0, welcome_string
  li $v0, 4
  syscall

  #qui mettiamo la nostra scelta
  li $v0,5
  syscall
  move $a0,$v0
  #Condizione per loop
  li $t1, 7
  beq $a0, $t1, end

  move $a0,$t9
jal  insertRecord
  move $t9,$v0

jal print
j loop

end:
lw $ra, 0($sp)
addi $sp, $sp, 4
li $v0, 10
syscall
jr $ra

spaceAllocation:

li $a0, 22
li $v0, 9
syscall
jr $ra

spaceDeallocation:

li $a0, -22
li $v0, 9
jr $ra

insertRecord:

addi $sp,$sp,-4
sw $ra, 0($sp)

move $t3,$a0          #a0 ha l'indirizzo del precedente record
lw $t1, idCounter
jal spaceAllocation
bne $t1, 0, secondNodeOrMore
sw $v0, firstNode
j firstOnly
secondNodeOrMore:
move $t0,$v0
lw $t0, 16($t3)        #salvo il nodo successivo nel nodo precedente
firstOnly:
move $t0,$v0
addi $t1, $t1, 1
sw $t1, idCounter


la $a0, record_name   #legge il nome del record
li $v0, 4
syscall
la $a0, tempName
li $v0,8
syscall

move $t2,$v0          #$t2 ha il nome del record
sw $a0, 0($t0)

sw $t1, 4($t0)        #si salva l'id

la $a0, record_priority
li $v0, 4
syscall
li $v0, 5
syscall
move $a0, $v0
sw $a0, 8($t0)

la $a0, record_cicles
li $v0, 4
syscall
li $v0, 5
syscall
move $a0, $v0
sw $a0, 12($t0)

move $v0, $t0

move $a0,$v0
li $v0,1
syscall

move $v0, $t0

lw $ra,0($sp)
addi $sp,$sp,4
jal $ra

removeFromRecord:

print:

lw $t0, firstNode
beq $t0, $zero, endPrint
la $a0, topbar
li $v0, 4
syscall

target:
lw $t1, 16($t0)
lw $t2, 0($t0)              #Stampa del nome
move $a0, $t2
li $v0, 4
syscall
move $t0, $t1
bne  $t0, $zero, target  # if  !=  then

endPrint:
la $a0, error
li $v0, 4
syscall
jr $ra

# Algoritmi di ordinamento in base cosa riceve in input ordina in modo diverso
# selection di jessika




#printMain:
