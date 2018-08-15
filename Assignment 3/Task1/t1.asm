
%include "io.mac"

.DATA
prompt_msg1  db   "Please enter a string : ",0
prompt_msg2  db   "String is palindrome  ",0
output_msg   db   "String  is not palindrome ",0
prompt_msg3  db   "String is empty",0

.UDATA
   strs      resb   100           ;

.CODE
      .STARTUP
   extern palindromes
      PutStr  prompt_msg1   ; request string
      GetStr strs , 100    ;  
      mov EBX , strs
      
      push EBX

   call palindromes
  
    cmp EAX , 0
    je  empty
    cmp EAX , 1
    je  ispalindrome

    PutStr  output_msg 
    jmp done
  empty:
    PutStr    prompt_msg3
    jmp done

  ispalindrome:
   PutStr    prompt_msg2

      
  
done:
   nwln
      .EXIT







