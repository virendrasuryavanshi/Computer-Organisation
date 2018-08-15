#include <stdio.h>
extern int testl();
int main()
{
//int x = 32,y;
int value;


 value = testl();
 printf("Carry flag : %d\n",(value%2));
 value /=2;
 printf("Reserved, always 1 in EFLAGS : %d\n",(value%2));
 value /=2;
 printf("Parity flag : %d\n",(value%2));
 value /=2;
 printf("Reserved flag : %d\n",(value%2));
 value /=2;
 printf("Adjust flag : %d\n",(value%2));
 value /=2;
 printf("Reserved flag : %d\n",(value%2));
 value /=2;
 printf("Zero flag : %d\n",(value%2));
 value /=2;
 printf("Sign flag : %d\n",(value%2));
 value /=2;
 printf("Trap flag : %d\n",(value%2));
 value /=2;
 printf("Interrupt enable flag : %d\n",(value%2));
 value /=2;
 printf("Direction flag : %d\n",(value%2));
 value /=2;
 printf("Overflow flag : %d\n",(value%2));
 value /=2;
 printf("I/O privilege level : %d\n",(value%2));
 value /=2;
 printf("I/O privilege level : %d\n",(value%2));
 value /=2;
 printf("Nested task flag : %d\n",(value%2));
 value /=2;
 printf("Reserved  : %d\n",(value%2));
 value /=2;
 printf("Resume flag : %d\n",(value%2));
 value /=2;
 printf("Virtual 8086 mode flag : %d\n",(value%2));
 value /=2;
 printf("Alignment check : %d\n",(value%2));
 value /=2;
 printf("Virtual interrupt flag : %d\n",(value%2));
 value /=2;
 printf("Virtual interrupt pending : %d\n",(value%2));
 value /=2;
 printf("Able to use CPUID instruction : %d\n",(value%2));
 value /=2;
 printf("Able to use CPUID instruction : %d\n",(value%2));
 value /=2;

 for(int i=0;i<9;i++)
 {
 	printf("VAD flag : %d\n",(value%2));
    value /=2;
 }
/*
 while(x--)
 {
    y = value % 2;
 	printf(" %d ", y);
 	value /=2;
 }
 */

return 0 ;

}


