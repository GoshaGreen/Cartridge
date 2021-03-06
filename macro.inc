.macro	UARTOSSENTOS
	SBIS 	UCSR0A,UDRE0	; ������� ���� ��� ����� ����������
	RJMP	PC-0x0001 	; ���� ���������� - ����� UDRE
	OUT		UDR0, UartOut
.endm
.macro	UARTOSRECIEVTOS
	SBIS	UCSR0A,RXC0	; ���� ����� ������� �����
	RJMP	PC-0x0001	; �������� � �����
 	IN		UartIn,UDR0	
.endm
; ����� ������ � ����
; PUSHAD
.macro	PUSHA
	PUSH	Addr0
	PUSH	Addr1
	PUSH	Addr2
.endm

; ������� ������ �� �����
; POPAD
.macro	POPA
	POP		Addr2
	POP		Addr1
	POP		Addr0
.endm

; ����� ������ � ������ � ����
; PUSHAD
.macro	PUSHAD
	PUSH	Addr0
	PUSH	Addr1
	PUSH	Addr2
	PUSH	Dat0
	PUSH	Dat1
.endm

; ������� ������ � ������ �� �����
; POPAD
.macro	POPAD
	POP		Dat1
	POP		Dat0
	POP		Addr2
	POP		Addr1
	POP		Addr0
.endm

; ��������� ��������� � ������
; LADDRI	Addr0, Addr1, Addr2
.macro	LADDRI
	LDI		Addr0,	@0
	LDI		Addr1,	@1
	LDI		Addr2,	@2
.endm

; ��������� ��������� � ������ � ������
; LADDRI	Addr0, Addr1, Addr2
.macro	LADDRDATI
	LDI		Addr0,	@0
	LDI		Addr1,	@1
	LDI		Addr2,	@2
	LDI		Dat0,	@3
	LDI		Dat1,	@4
.endm

; ������ ��������� ������ ������ �� �����
; PINIOUT
.macro	PINIOUT
	LDI		temp, 0b00001100		;(1<<WE)||(1<<OE)||(0<<CE)		
	UOUT	PORTG, temp
	LDI		temp,	0xFF
	OUT		DDRB,	temp
	OUT		DDRD,	temp
	OUT		PORTB,	temp
	OUT		PORTD,	temp
.endm

; ������ ��������� ������ ������ �� ����
; PINIIN
.macro	PINIIN
	LDI		temp, 0b00001000		;(1<<WE)||(0<<OE)||(0<<CE)		
	UOUT	PORTG, temp
	LDI		temp,	0x00
	OUT		DDRB,	temp
	OUT		DDRD,	temp
	LDI		temp,	0xFF
	OUT		PORTB,	temp
	OUT		PORTD,	temp
.endm

; ������ ������ �� ���� � Dat0 Dat1
; FREAD 
.macro	FREAD
	OUT		PORTA, Addr0	
	OUT		PORTC, Addr1
	STS		PORTF, Addr2

	NOP		; ��� qry ������� ���������� �������� ��� ����,
	NOP		; ��� ������� ���������� - ������ ����� ���������.
	NOP 

	IN		Dat0, PINB
	IN		Dat1, PIND
.endm

; ������ ������ � ���� ��������
; FWRITE 
.macro	FWRITE
	OUT		PORTA, Addr0
	OUT		PORTC, Addr1
	UOUT	PORTF, Addr2
	
	LDI		temp, 0b00000100		;(0<<WE)||(1<<OE)||(1<<CE)		
	UOUT	PORTG, temp
	
	OUT		PORTB, Dat0
	OUT		PORTD, Dat1

	LDI		temp, 0b00001100		;(1<<WE)||(1<<OE)||(0<<CE)		
	UOUT	PORTG, temp
.endm

; ������ �� �������� ������
; NNOP 
.macro NNOP
	NOP
	NOP
	NOP
	NOP
	NOP
.endm

;������� �����
;OUTI ������� ��������
.macro OUTI
	PUSH R16          	
    LDI R16,@1
	.if @0 < 0x40
		OUT @0,R16       
   	.else
		STS @0,R16
   	.endif
	POP R16
.endm

;������������� ����� 
;UOUT ������� ��������
.macro    UOUT      
	.if	@0 < 0x40
		OUT	@0,@1         
	.else
      	STS	@0,@1
   	.endif
.endm
	
;��������� ������� SREG � ����
;PUSHF
.MACRO PUSHF
	PUSH	R16
	IN	R16,SREG
	PUSH	R16
.ENDM
 
;������� ������� SREG �� �����
;POPF
.MACRO POPF
	POP	R16
	OUT	SREG,R16
	POP	R16
.ENDM

;���������� ��� � �������������� �����
;SETBM ������� ���
.MACRO	SETBM 
	.if @0 < 0x20
		SBI	@0,@1
	.else
		.if @0<0x40
			PUSH	R17
			IN	R17,@0
			ORI	R17,1<<@1
			OUT	@0,R17
			POP	R17
		.else
			PUSH	R17
			LDS	R17,@0
			ORI	R17,1<<@1
			STS	@0,R17
			POP	R17
		.endif
	.endif
.ENDM
 
;���������� ��� � �������������� ��������
;SETB ������� ��� �������_�����
.MACRO	SETB
	.if @0 < 0x20			; Low IO
		SBI	@0,@1
	.else
		.if @0<0x40		; High IO
			IN	@2,@0
			ORI	@2,1<<@1
			OUT	@0,@2
		.else			; Memory
			LDS	@2,@0
			ORI	@2,1<<@1
			STS	@0,@2
		.endif
	.endif
.ENDM

;�������� ��� � �������������� ��������
;CLRB ������� ��� �������_�����
.MACRO	CLRB 
	.if @0 < 0x20			; Low IO
		CBI	@0,@1
	.else
		.if @0<0x40		; High IO
			IN	@2,@0
			ANDI @2,~(1<<@1)
			OUT	@0,@2
		.else			; Memory
			LDS	@2,@0
			ANDI @2,~(1<<@1)
			STS	@0,@2
		.endif
	.endif
.ENDM
 
;��������� ��� � �������������� �����
;CLRBM ������� ���
.MACRO	CLRBM 
	.if @0 < 0x20
		CBI	@0,@1
	.else
		.if @0<0x40
			PUSH R17
			IN R17,@0
			ANDI R17,~(1<<@1)
			OUT	@0,R17
			POP	R17
		.else
			PUSH	R17
			LDS	R17,@0
			ANDI	R17,~(1<<@1)
			STS	@0,R17
			POP	R17
		.endif
	.endif
.ENDM

;�������������� ���� � �������������� ���� ���������
;INVB ������� ��� �������_�����_1 �������_�����_2
.MACRO	INVB
	.if	@0 < 0x40
		IN	@2,@0
		LDI	@3,1<<@1
		EOR	@3,@2
		OUT	@0,@3
	.else
		LDS	@2,@0
		LDI	@3,1<<@1
		EOR	@2,@3
		STS	@0,@2
	.endif
.ENDM
 
;�������������� ���� � �������������� �����
;INVBM ������� ���
.MACRO	INVBM
	.if	@0 < 0x40
		PUSH R16
		PUSH R17
		IN	R16,@0
		LDI	R17,1<<@1
		EOR	R17,R16
		OUT	@0,R17
		POP	R17
		POP	R16
	.else
		PUSH R16
		PUSH R17
		LDS	R16,@0
		LDI	R17,1<<@1
		EOR	R17,R16
		STS	@0,R17
		POP	R17
		POP	R16
	.endif
.ENDM
