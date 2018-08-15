segment .text

	global palindromes 
palindromes:
	enter 0,0
	push EBX
	push ECX
	push EDX

	mov EBX, [EBP+8]

	xor ECX,ECX
	mov EDX ,EBX
	
	
count:
    cmp byte [EDX] , 0
    je  dones
    inc ECX
    inc EDX
    jmp count

 dones:
     cmp ECX , 0
     je   zeros
     cmp ECX , 1
     je  ones
     mov EAX , ECX
     shr EAX , 1
     dec EDX
   
  
 check:
     mov CL ,  [EDX]
     
     cmp [EBX] , CL
     jne   comeout
     
     inc EBX
     dec EDX
     dec EAX
     cmp EAX , 0
     je  success
     jmp check
 zeros:
      mov EAX , 0
      jmp done
 ones:
      mov EAX , 1
      jmp dones
 comeout:
      mov EAX , 2
      jmp done
 success:
      mov EAX , 1
 done:
    
     pop EDX
     pop ECX
     pop EBX

	
	leave
ret





