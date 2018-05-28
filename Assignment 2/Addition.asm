
 	    ;-----------------------------------------------------------------------;
            ;   AUTHOR	:	Suryavanshi Virendrasingh		            ;
   	    ;   ROLL NO	:	B16037					            ;					       
	    ;   Objective : To read two matrix A and B and display result matrix C  ; 
            ;   Input     : Two Matrices A and B		                    ; 
            ;   OutPut    : Addition Matrix C of A nad B                            ;
            ;                                                                       ;
            ;------------------------------------------------------------------------


 %include "io.mac"
 MAX_Row      EQU    10                                 ; MAXIMUM ROW
 MAX_Col      EQU    10                                 ; MAXIMUM COLUMN


 .DATA                                                  ; Define initialized data here
      input_prompt    db    "Enter number of row : ",0
      input_prompt1   db    "Enter number of column : ",0
      input_prompt2   db    "Sorry, you entered undesired value  ",0AH
                      db    "ReEnter value ...",0
      input_prompt3   db    "Enter elements of matrix in row major order : ",0
      input_prompt4   db    "Row number : ",0
      input_prompt5   db    "Sorry, Out of Range ( > 1000 ) "
      input_prompt6   db    "Enter matrix (Row-major Order) : ",0
      input_prompt7   db    "Matrix : ",0
      input_prompt8   db    "   ",0

 .UDATA                                                 ; Define non - initialized data here
      row             resd  1                           ; Number of row
      col             resd  1                           ; Number of column
      a_matrix        resd  100                         ; Matrix A
      b_matrix        resd  100                         ; Matrix B
      c_matrix        resd  100                         ; Matrix C  =  A + B
 .CODE
      .STARTUP                                          ; start main function
  go_row:                                               ; label for geting row
      PutStr          input_prompt                      ; User request for number of row
      GetLInt         EAX                               ; get row from user
      cmp             EAX,1                             ; row is less than one
      jl              error_row                         ; if so, go error_row
      cmp             EAX,MAX_Row                       ; row is greater than MAX_Row
      jg              error_row                         ; if so, go error_row
      mov             dword [row] , EAX                 ; otherwise, mov EAX value in row variable
  
  go_col:                                               ; label for getting column                   
      PutStr          input_prompt1                     ; User request for number of column
      GetLInt         EAX                               ; get column from user
      cmp             EAX,1                             ; column is less than one
      jl              error_col                         ; if so, go error_col
      cmp             EAX,MAX_Col                       ; column is greater than MAX_Col
      jg              error_col                         ; if so, go error_col
      mov             dword [col] , EAX                 ; otherwise, mov EAX value in col variable
     
      mul             dword [row]                       ; total element in a matrix
      mov             EBX,a_matrix                      ; mov a_matrix pointer in EBX
      push            EBX                               ; push a_matrix pointer
      push            EAX                               ; push total element of matrix
      
      call            read_matrix                       ; call function for read matrix A
     
      mov             EBX ,b_matrix                     ; mov b_matrix pointer in EBX
      push            EBX                               ; push b_matrix pointer
      push            EAX                               ; push total element of matrix
    
      call            read_matrix                       ; call function for read matrix B

      mov             EDX,a_matrix                      ; mov a_matrix pointer in EDX
      mov             ECX ,c_matrix                     ; mov c_matrix pointer in ECX

      push            ECX                               ; push c_matrix pointer
      push            EBX                               ; push b_matrix pointer
      push            EDX                               ; push a_matrix pointer
      push            EAX                               ; push total element of matrix

      call            add_matrix                        ; call function for Add two matrix 

      push            ECX                               ; push c_matrix pointer
      push            dword [row]                       ; push number of row
      push            dword [col]                       ; push number of column

      call            print_matrix                      ; call function for print matrix

      jmp             done                              ; now , we are done

  error_row:                                            ; label for error of row
      PutStr          input_prompt2                     ; show error message
      nwln                                              ; print new line
      jmp             go_row                            ; go back to read row

  error_col:                                            ; label for error of column
      PutStr          input_prompt2                     ; show error message
      nwln                                              ; print new line
      jmp             go_col                            ; go back to read column

  done:                                                 ; label for done
      .EXIT                                             ; EXIT from program
     

  print_matrix:                                         ; function for print a matrix
      enter 0,0                                         ; allocate stack frame with zero local variable
      push  EAX                                         ; save EAX register
      push  EBX                                         ; save EBX register
      push  ECX                                         ; save ECX register
      push  EDX                                         ; save EDX register

      mov   EBX , [EBP+16]                              ; mov matrix pointer in EBX
      mov   ECX , [EBP+12]                              ; mov row in ECX
      mov   EAX , [EBP +8]                              ; mov column in EAX
      
      
      PutStr   input_prompt7                            ; display matrix
      nwln                                              ; print new line

      xor  ESI,ESI                                      ; clear ESI

      print:                                            ; label for print a row
      nwln                                              ; print new line
         push ECX                                       ; save ECX 
         xor ECX , ECX                                  ; clear ECX
       
         print_col:                                     ; lebel for column        
        
           PutLInt  [EBX]                               ; print element
           PutStr   input_prompt8                       ; put space
           add  EBX,4                                   ; add 4 in EBX pointer
           inc ECX                                      ; ECX = ECX + 1
           cmp  EAX,ECX                                 ; compare ECX to column
           jne   print_col                              ; ECX != column , go for print next element
         
         pop ECX                                        ; otherwise, restore ECX                                
         inc   ESI                                      ; ESI = ESI + 1
         cmp   ESI , ECX                                ; compare ESI to row
         jne   print                                    ; ESI != row , go for print next row 
       
     nwln                                               ; otherwise, print new line
     pop EDX                                            ; restore EDX
     pop ECX                                            ; restore ECX
     pop EBX                                            ; restore EBX
     pop EAX                                            ; restore EAX
     nwln                                               ; print new line
     leave                                              ; release procedure entery
     ret   12                                           ; return and remove passing parameters
 
 read_matrix:                                           ; function for read a matrix
     enter 0,0                                          ; allocate stack frame with zero local variable
     push  EAX                                          ; save EAX register
     push  EBX                                          ; save EBX register
     push  ECX                                          ; save ECX register
     push  EDX                                          ; save EDX register

     mov   EBX , [EBP+12]                               ; mov a matrix pointer in EBX
     mov   ECX , [EBP+8]                                ; mov total elements in ECX
      
     
     PutStr   input_prompt6                             ; get matrix in row mazor order
     nwln                                               ; print new line
    
     xor  ESI,ESI                                       ; clear ESI 
     
     read_element:                                      ; label for read element 

          GetLInt  EAX                                  ; get element
          mov [EBX] , EAX                               ; move element in EBX
          inc   ESI                                     ; ESI = ESI + 1
          add  EBX,4                                    ; add 4 in EBX for next element
          cmp   ESI , ECX                               ; ESI != ECX
          jne   read_element                            ; if so, go back for read next element 
       
     pop EDX                                            ; restore EDX
     pop ECX                                            ; restore ECX
     pop EBX                                            ; restore EBX
     pop EAX                                            ; restore EAX
     
     leave                                              ; release procedure entery         
     ret   8                                            ; return and remove passing parameters

 add_matrix:                                            ; function for Add two matrix
     enter 0,0
     push  EAX                                          ; save EAX register
     push  EBX                                          ; save EBX register
     push  ECX                                          ; save ECX register
     push  EDX                                          ; save EDX register

     mov   EBX , [EBP+12]                               ; mov a_matrix pointer in EBX                           
     mov   EDX , [EBP+16]                               ; mov b_matrix pointer in EDX
     mov   EAX , [EBP+20]                               ; mov c_matrix pointer in EAX
     mov   ECX , [EBP+8]                                ; mov total element in ECX
      
    
     nwln                                               ; print new line
     xor  ESI,ESI                                       ; clear ESI
    
     add_e:                                             ; label for add element
 
           push ECX                                     ; save ECX for store [EBX] + [EDX]
           mov  ECX ,[EBX]                              ; mov [EBX] in ECX
           add  ECX ,[EDX]                              ; ECX = [EBX] + [EDX]
           mov  [EAX] ,ECX                              ; mov ECX in [EAX]
           pop  ECX                                     ; restore ECX
           
           inc  ESI                                     ; ESI = ESI + 1
           add  EBX ,4                                  ; add 4 in EBX for next element
           add  EDX ,4                                  ; add 4 in EDX for next element
           add  EAX ,4                                  ; add 4 in EAX for next element
           cmp  ESI ,ECX                                ; ESI != ECX
           jne   add_e                                  ; if so, go back add another element
       
     
     pop EDX                                            ; restore EDX
     pop ECX                                            ; restore ECX
     pop EBX                                            ; resotre EBX
     pop EAX                                            ; restore EAX

     leave                                              ; release procedure entery                                        
     ret   16                                           ; return and remove passing parameters
