.386P					;���������� ���������� ���� ������ Pentium

;��������� ��� �������� ������������ ���������
descr	struc			;������ ���������� ���������
		lim		dw 0	;������� (���� 0...15)
		base_l	dw 0	;����, ���� 0...15
		base_m	db 0	;����, ���� 1..23
		attr_1	db 0	;���� ��������� 1
		attr_2	db 0	;������� (���� 16...19) � �������� 2
		base_h	db 0	;����, ���� 24...31
descr	ends			;����� ���������� ���������

;��������� ��� �������� ������ �������
trap	struc 
		offs_l	dw 0	;�������� �����������, ���� 0..15
		sel		dw 16	;�������� �������� ������
		cntr	db 0	;�������, �� ������������
		dtype	db 8Fh	;��� ����� - ������� 80386 � ����
		offs_h	dw 0	;�������� �����������, ���� 16..31
trap	ends

;������� ������
data	segment use16										;16-��������� �������
; ���������� ������� ������������ GDT
		gdt_null	descr <0, 0, 0, 0, 0, 0>				;�������� 0, ������� ����������
		gdt_data	descr <data_size - 1, 0, 0, 92h, 0, 0>	;�������� 8, ������� ������
		gdt_code	descr <code_size - 1, 0, 0, 98h, 0, 0>	;�������� 16, ������� ������
		gdt_stack	descr <255, 0, 0, 92h, 0, 0>			;�������� 24 ������� �����
		gdt_screen	descr <3999, 8000h, 0Bh, 92h, 0, 0>		;�������� 32, �����������
		gdt_count	descr <0FFFFh, 0, 0, 92h, 11001111b, 0>	;�������� 40, ������� ������ � ����� 0
		gdt_size=$-gdt_null									;������ GDT
;��������� ������ ���������
		pdescr		df 0									;���������������� ��� ������� lgdt
		IDT			label byte								;������� ������������ ���������� IDT
		trap		32 dup (<catch, 16,0, 8Eh, 0>)			;������ 32 �������� ������� (� ��������� �� ������������)
		int08		trap <0, 16, 0, 8Eh, 0>					;���������� ���������� �� �������
		int09		trap <0, 16, 0, 8Eh, 0>					;���������� ���������� �� ����������
		idt_size=$-IDT
		idtr		df 0									;���������������� ��� ������� lidt
		idtr_real	dw 3FFh, 0, 0							;���������� �������� IDTR � �������� ������
		master		db 0									;����� ���������� �������� �����������
		slave		db 0									;����� ���������� �������� �����������
		timer		dd 0h									;������� �����
		escape		db 0									;���� �������� � �������� �����
		ASCII_table	db 0, 0, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 45, 61, 0, 0
					db 81, 87, 69, 82, 84, 89, 85, 73, 79, 80, 91, 93, 0, 0, 65, 83
					db 68, 70, 71, 72, 74, 75, 76, 59, 39, 96, 0, 92, 90, 88, 67
					db 86, 66, 78, 77, 44, 46, 47
		print_pos	dd 100 ; ������� ������ ��������� ������
		data_size=$-gdt_null								;������ �������� ������
data	ends

;������� ������
text	segment use16						;16-��������� �������
		assume CS:text, DS:data
main	proc
		mov		AX, 3
		int		10h

		xor		EAX, EAX					;������� EAX
		mov		AX, data					;�������� � DS ����������
		mov		DS, AX						;����� �������� ������
;�������� 32-������� �������� ����� �������� ������ � �������� ���
;� ���������� �������� ������ � ��������� ������� ������������ GDT
		shl		EAX, 4						;EAX=�������� ������� �����
		mov		EBP, EAX					;�������� ��� � EBP ��� ��������
		mov		BX, offset gdt_data			;BX=�������� �����������
		mov		[BX].base_l,AX				;�������� ������� ����� ����
		shr		EAX, 16						;������� �������� EAX � AX
		mov		[BX].base_m, AL				;�������� ������� ����� ����
;�������� � �������� � GDT �������� ����� �������� ������
		xor		EAX, EAX					;������� EAX
		mov		AX, CS						;���������� ����� �������� ������
		shl		EAX, 4
		mov		BX, offset gdt_code
		mov		[BX].base_l,AX
		shr		EAX, 16
		mov		[BX].base_m,AL
;�������� � �������� � GDT �������� ����� �������� �����
		xor		EAX, EAX					;������� EAX
		mov		AX, SS						;���������� ����� �������� �����
		shl		EAX, 4
		mov		BX, offset gdt_stack
		mov		[BX].base_l, AX
		shr		EAX, 16
		mov		[BX].base_m, AL
;���������� ���������������� pdescr � �������� ������� GDTR
		mov		dword ptr pdescr+2, EBP		;���� GDT
		mov		word ptr pdescr, gdt_size-1	;������� GDT
		lgdt	pdescr						;�������� ������� GDTR
;���������� ���������������� ��� ������� lidt
		xor		EAX, EAX
		mov		AX, data
		shl		EAX, 4
		add		EAX, offset IDT
		mov		dword ptr idtr + 2, EAX
		mov		word ptr idtr, idt_size-1
;�������� �������� � ������������ ����������
		mov		EAX, offset int08h			;���������� ���������� �������
		mov		int08.offs_l, AX
		shr		EAX, 16
		mov		int08.offs_h, AX
		mov		EAX, offset int09h			;���������� ����������
		mov		int09.offs_l, AX
		shr		EAX, 16
		mov		int09.offs_h, AX
;�������� ����� ���������� ������������
		in		AL, 21h
		mov		master, AL					;��������
		in		AL, 0A1h
		mov		slave, AL					;��������
;�������������� ������� ���������� (������� ������ ������ 32)
		mov		AL, 11h						;���1: ����� ���3
											;������� "���������������� ������� ����������"
		out		20h, AL						;20h - "���� ���������\����������"
		mov		AL, 20h						;���2: ������� ������
		out		21h, AL						;������� ������ - 20h (���������� ��������������, ������� � 32)
		mov		AL, 4						;���3: ������� ��������� � ������ 2
											;������� ���������� ��������� � IRQ2
		out		21h, AL
		mov		AL, 1						;���4: 80x86, ��������� EOI
											;���������� �������� ������� EOI ���������� ����������� ����������
		out		21h, AL
		mov		AL, 0FCh					;����� ����������
		out		21h, AL
;�������� ��� ���������� � ������� �����������
		mov		AL, 0FFh					;����� ����������
		out		0A1h, AL					;� ����

		cli									;������ ���������� ����������
;�������� IDT
		lidt	fword ptr idtr
;������� ����� �20 ��� ��������� � ����������� ������
		mov		AL, 0D1h
		out		64h, AL
		mov		AL, 0DFh
		out		60h, AL
;��������� � ���������� �����
		mov		EAX, CR0					;������� ���������� �������� CR0
		;or		AL, 1
		or		EAX, 1						;��������� ��� ����������� ������
		mov		CR0, EAX					;������� ����� � CR0
;-----------------------------------------------;
; ������ ��������� �������� � ���������� ������ ;
;-----------------------------------------------;
;��������� � CS:IP ��������:�������� ����� continue
		db		0EAh						;��� ������� far jmp
		dw		offset continue				;��������
		dw		16							;�������� �������� ������
continue:
;������ ���������� ������
		mov		AX,8						;�������� �������� ������
		mov		DS,AX
;������ ���������� ����
		mov		AX,24						;�������� �������� �����
		mov		SS,AX
;�������������� ES
		mov		AX,32						;�������� �������� �����������
		mov		ES,AX						;�������������� ES

		call	 memory_cnt
		sti
work:	test	escape, 1
		jz		work
;������� ����� �20
		mov		AL, 0D1h
		out		64h, AL
		mov		AL, 0DDh
		out		60h, AL
		cli
;������� � �������� �����
;���������� � �������� ����������� ��� ��������� ������
		mov		gdt_data.lim, 0FFFFh		;������� �������� ������
		mov		gdt_code.lim, 0FFFFh		;������� �������� ������
		mov		gdt_stack.lim, 0FFFFh		;������� �������� �����
		mov		gdt_screen.lim, 0FFFFh		;������� ���. ��������
		push	DS							;�������� ������� �������
		pop		DS							;�������� ������
		push	SS							;�������� ������� �������
		pop		SS							;�������� �����
		push	ES							;�������� ������� �������
		pop		ES							;��������������� �������� ������
;�������� ������� ������� ��� ����, ����� ������ ��������� ��������
;� ������� CS � �������������� ��� ������� �������
		db		0EAh						;�������� �������� ��������
		dw		offset go					;�������� ������� �������
		dw		16							;�������� ������
;���������� ����� ����������
go:		mov		EAX, CR0					;������� ���������� �������� CR0
		and		EAX, 0FFFFFFFEh				;������� ��� �����1����� ������
		mov		CR0, EAX					;������� ����� � CR0
		db		0EAh						;��� ������� far jmp
		dw		offset return				;��������
		dw		text						;�������
;---------------------------------------------------;
; ������ ��������� ����� �������� � �������� ������ ;
;---------------------------------------------------;
return:
;����������� �������������� ����� ��������� ������
		mov		AX, data					;������� ����������� ������
		mov		DS, AX
		mov		AX, stk						;������� ���������� ����
		mov		SS, AX

;����������������� �����������
		mov		AL, 11h						;�������������
		out		20h, AL
		mov		AL, 8						;�������� ��������
		out		21h, AL
		mov		AL, 4
		out		21h, AL
		mov		AL, 1
		out		21h, AL
;��������������� ����������� ����� ����� ������������
		mov		AL, master
		out		21h, AL
		mov		AL, slave
		out		0A1h, AL
;��������� ������� ������������ ���������� ��������� ������
		lidt	fword ptr idtr_real
;��������� ������� ������������� ����������
		in		AL,70h
		and		AL,07FH
		out		70h,AL

		sti									;�������� ���������� ����������
;�������� � DOS
		;mov	AH, 4Ch
		mov		AX, 4C00h					;�������� ��������� ������� �������
		int		21h
main	endp

catch proc
	db 66h
	iretd
catch endp

int08h proc
	push EAX
	push EDI

	mov EDI, 30
	xor EAX, EAX
	mov EAX, timer

	call print_number_dec

	inc timer

	; ���������� ������� EOI �������� ����������� ����������
	mov	AL, 20h
	out	20h, AL

	pop EDI	
	pop EAX

	db 66h
	iretd
int08h endp

int09h proc
	push EAX
	push EBX
	push EBP
	push EDX

	in AL, 60h ; �������� ����-��� ������� ������� �� ����� ����������

	cmp	AL, 1Ch ; ���������� � ����� ������� enter
	jne	print_key
	mov escape, 1 ; ����� ������ ���� ����������� � �������� �����
	jmp exit
	
print_key:
	cmp AL, 80h ; ����� ��� ������: ������� ��� ���������� �������?
	ja exit ; ���� ����������, �� ������ �� �������
	xor AH, AH ; ���� �������, �� ������� �� �����
	mov BP, AX
	mov DL, ASCII_table[EBP] ; ������� ASCII ��� ������� ������� �� ���� �� �������
	mov EBX, print_pos ; ������� ������� ������ �������
	mov ES:[EBX], DL

	add EBX, 2 ; �������� ������� ������� ������ ������ � �������� ��
	mov print_pos, EBX

exit:
	; ��������� ������������ ����������
	in	AL, 61h
	or	AL, 80h
	out	61h, AL
	and AL, 07Fh
	out 61h, AL

	; �������� ������ EOI
	mov	AL, 20h
	out	20h, AL

	pop EDX
	pop EBP
	pop EBX
	pop	EAX

	; ������� �� ����������
	db 66h
	iretd				
int09h endp

memory_cnt proc
    push DS
    mov AX, 40
    mov DS, AX          ; �������� � DS �������� �������� � ����� 0
    mov EBX, 100001h    ; ������� ������� ���������
    mov DL,  10011001b  ; ���������
    mov ECX, 0FFEFFFFEh ; ������������ ������ ���������� ������
	
memory_cnt_loop:
    mov DH, DS:[EBX]    ; ��������� ���������� ������
    mov DS:[EBX], DL    ; ���������� ���������
    cmp DS:[EBX], DL    ; ���������� ���������� ������ � �������� ����������
    jnz memory_cnt_end
    mov DS:[EBX], DH    ; ��������������� ���������� ������
    inc EBX
	db 67h
    loop memory_cnt_loop
	
memory_cnt_end:
    pop DS          
    xor EDX, EDX
    mov EAX, EBX
    push EDI
    mov EDI, 14
    call print_number_dec            
    pop EDI                         

    ret
memory_cnt endp

print_number_dec proc
	push EAX
	push EBX
	push EDX
	push ECX
	push EDI

	mov EBX, 10

print:
	mov EDX, 0
	div EBX
	add DL, '0'
	
	mov ES:[EDI], DL
	sub EDI, 2
	cmp EAX, 0
 	jne print

	pop EDI
	pop ECX
	pop EDX
	pop EBX
	pop EAX
	ret
print_number_dec endp

code_size=$-main							;������ �������� ������
text	ends

;������� �����
stk		segment stack use16;				;16-��������� �������
		db 256 dup ('^')
stk		ends
		end main