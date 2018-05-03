
            
            ;-------------------------------------------------------------------;
            ;   AUTHOR	:	Suryavanshi Virendrasingh	        ;
   	;   ROLL NO	:	B16037		                    ;  
            ;   Objective : To find average marks in each Subject of Students   ;
            ;   Input     : Total students and Total subjects                   ;
            ;              Marks for each students in each subjects             ;
            ;   OutPut    : Put average mark in each subject                    ;
            ;   Precision : 0.001                                               ;
            ;-------------------------------------------------------------------;

%include "io.mac"                               ; Include Input / Output function

.DATA                                           ; Define data here
    prompt_msg    db     "Please Enter number of students : ",0
    prompt_msg1   db     "Please Enter number of subjects : ",0
    prompt_msg2   db     "Average marks in  subject ",0
    prompt_msg3   db     "   Subject : ",0
    prompt_msg4   db     "Student ",0
    prompt_msg5   db     " mark : ",0
    prompt_msg6   db     "Student are less",0
    prompt_msg7   db     "Subject are less",0
    prompt_msg8   db     " : ",0
    prompt_msg9   db     ".",0
    prompt_msg10  db     "  Sorry , you enter negative mark which is invalid ",0AH
                  db     "  Please , Re-enter mark ",0
    prompt_msg11  db     "  Sorry , The sum of marks is out of range ",0AH
                  db     "  (-2,147,483,648 to +2,147,483,647) ",0AH
                  db     "  Please , Re-enter mark for subject  ",0 

.UDATA                                           ; Define user data here
    student_no    resd    1                      ; store total students
    subject_no    resd    1                      ; store total subjects

.CODE                                            ; Write Instruction which is execute
    .STARTUP                                     ; Start main function
    PutStr        prompt_msg                     ; request number of students from user
    GetLInt       [student_no]                   ; get number of students
    PutStr        prompt_msg1                    ; request number of subject from user
    GetLInt       [subject_no]                   ; get number of subjects from user 

    cmp           dword [student_no] , 1         ; students are less than one
    jl            less_student                   ; if so, terminate to exit program
    cmp           dword [subject_no] , 1         ; subjects are less than one
    jl            less_subject                   ; if so, terminate to exit program
    xor           ESI,ESI                        ; clear ESI register for count the number of subjects
    mov           ESI,1                          ; set ESI = 1


reading_marks:
    nwln                                         ; put new line
    PutStr        prompt_msg3                    ; display subject
    PutLInt       ESI                            ; put subject id
    xor           ECX,ECX                        ; clear ECX register for count the number of students
    mov           ECX,1                          ; set ECX = 1
    xor           EAX,EAX                        ; clear EAX register for store the sum of total
                                                 ; marks for a sunject
    xor           EDX,EDX	                     ; clear EDX register for  store the remainder
    nwln                                         ; put new line


start_read:
    nwln                                         ; put new line
    PutStr        prompt_msg4                    ; request for mark of a subject from user
    PutLInt       ECX                            ; put studnet id
    PutStr        prompt_msg5                    ; put colon with marks
    GetLInt       EBX                            ; get mark from user
    cmp           EBX,0                          ; mark is less than zero
    jl            negative_marks                 ; if so, go back to read further 
    add           EAX,EBX                        ; add mark in EAX register
    jo            overflow_marks                 ; mark is out of range
    cmp           ECX,dword [student_no]         ; we have read all students marks of a subject
    je            subject_done                   ; if so, go for calculate average marks
    inc           ECX                            ; otherwise, increment count of students
    jmp           start_read                     ; repeat the loop for getting another student mark


negative_marks:
    nwln                                         ; put new line
    PutStr        prompt_msg10                   ; put error message
    nwln                                         ; put new line
    jmp           start_read                     ; repeat the loop for getting same student's mark


overflow_marks:
    nwln                                         ; put new line
    PutStr        prompt_msg11                   ; put error , out of range
    nwln                                         ; put new line 
    sub           EAX,EBX                        ; restore previous sum                               
    jmp           start_read                     ; repeat the loop for getting same subject's mark


less_student:
    PutStr        prompt_msg6                    ; put , students are less than one
    nwln                                         ; put new line
    jmp           done                           ; jump for exit to pragram


less_subject:     
    PutStr        prompt_msg7                    ; put , subjects are less than one 
    nwln                                         ; put new line 
    jmp           done                           ; jump for exit to program


subject_done:
    nwln                                         ; put new line
    PutStr       prompt_msg2                     ; display average marks of a particular subject
    PutLInt      ESI                             ; put subject id
    PutStr       prompt_msg8                     ; put colon ':' to separate the id and average marks 
    div          dword [student_no]              ; apply division rule to calculated
                                                 ; it store quotient in EAX register and
                                                 ; store remainder in EDX register
    PutLInt      EAX                             ; put quotient part
    cmp          EDX,0                           ; remainder in non zero
    jne          precision                       ; if so, go for find the 0.001 precision


continue:  
    nwln                                         ; put new line
    cmp          ESI,dword [subject_no]          ; we have read all subjects marks
    je           done                            ; if so, go for terminate the program
    inc          ESI                             ; otherwise, increment the ESI for subject id
    jmp          reading_marks                   ; go back, for read another subject's marks


precision:
    push         ESI                             ; save  ESI register
    xor          ESI,ESI                         ; clear ESI register to count the precision
    mov          ESI,0                           ; set ESI = 0 , first decimal point
    PutStr       prompt_msg9                     ; put decimal point


precision_process:
    mov          EAX,EDX                         ; move remainder from EDX to EAX register
                                                 ; let y = EAX , and multiply by 10
    add          EAX,EAX                         ; EAX = 2y
    mov          EDX,EAX                         ; EDX = 2y
    add          EAX,EAX                         ; EAX = 4y
    add          EAX,EAX                         ; EAX = 8y
    add          EAX,EDX                         ; EAX = 10y
    xor          EDX,EDX                         ; clear EDX register for  store the remainder
    div          dword [student_no]              ; apply division rule for unsigned number
                                                 ; it store quotient in EAX register and
                                                 ; store remainder in EDX register
    PutLInt      EAX                             ; put first decimal point
    cmp          EDX,0                           ; remainder is zero
    je           go                              ; if so, go back for another subjects marks
    inc          ESI                             ; increment ESI 
    cmp          ESI,3                           ; if we have put all three decimal point
    jne          precision_process               ; if not so, go back for another decmial point
go :
   pop          ESI                             ; otherwise, restore ESI register
    jmp          continue                        ; go back for another subjects marks


done:
    nwln                                         ; put new line
    .EXIT                                        ; exit to program
       
