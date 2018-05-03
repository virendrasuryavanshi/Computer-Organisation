

            ;-------------------------------------------------------------------
            ;   AUTHOR	:	Suryavanshi Virendrasingh		       ;
   	    ;   ROLL NO	:	B16037					       ;					       
	    ;   Objective : To find average marks in each Subject of Students  ; 
            ;   Input     : String of Digits		                       ; 
            ;   OutPut    : Encryption of String                               ;
            ;                                                                  ;
            ;-------------------------------------------------------------------


%include "io.mac"

.DATA
	msg_ask	db "Enter the string: ",0
	msg_ans	db "Final string is: ",0
	msg_y_n db "Enter another string? (Y/y to continue)",0
	convert db "4695031872"

.UDATA
	inp_str resb 200
	inp_y_n resb 1

.CODE
	.STARTUP
	L1:
		PutStr msg_ask
		GetStr inp_str
		mov EAX,inp_str
		L2:
			mov BL,byte[EAX]
			mov CL,'0'
			mov EDX,0
			L3:	
				cmp CL,BL
				je true
				cmp CL,'9'
				je inpInc
				inc EDX
				inc CL
				jmp L3
				true:
					mov BL,byte[convert+EDX]
					mov byte[EAX],BL
					jmp inpInc
			inpInc:
				inc EAX
				cmp AL,0
				jne L2
		PutStr msg_ans
		PutStr inp_str
		nwln
		PutStr msg_y_n
		GetStr inp_y_n
		cmp byte[inp_y_n],'Y'
		je L1
		cmp byte[inp_y_n],'y'
		je L1
done:
	.EXIT
