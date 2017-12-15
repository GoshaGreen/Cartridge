.def	temp = R16
.def	mode = R17
.def	ChSumm = R18
.def	UartOut = R19
.def	UartIn = R20
.def	Dat0 = R21
.def	Dat1 = R22
.def	Addr0 = R23
.def	Addr1 = R24
.def	Addr2 = R25

.equ	CE = 1
.equ	OE = 2
.equ	WE = 3

.include	"macro.inc"	
;88 RAM ========================================================
.DSEG ; ������� 
;CCNT:	.byte	4
;TCNT:	.byte	4

;88 END RAM / FLASH ============================================
.CSEG ; �������
; Include ======================================================
.include	"interrupts.inc"
.include	"coreinit.inc"	
; END Include / Internal Hardware Init  ========================
; uart
; Internal Hardware Init  ======================================
uart_init:	
	OUTI 	UBRR0L,7
	OUTI 	UBRR0H,0
 
	LDI 	R16,(1<<U2X0)
	UOUT 	UCSR0A, R16
 
; ���������� ���������, �����-�������� ��������.
	LDI 	R16, (1<<RXEN0)|(1<<TXEN0)|(0<<RXCIE0)|(0<<TXCIE0)|(0<<UDRIE0)|(0<<UCSZ02)
	OUT 	UCSR0B, R16	
 
; ������ ����� - 8 ���, ����� � ������� UCSRC, �� ��� �������� ��� ��������
	LDI 	R16, (0<<UMSEL0)|(0<<UPM01)|(0<<UPM00)|(0<<USBS0)|(1<<UCSZ00)|(1<<UCSZ01)|(0<<UCPOL0)
	UOUT 	UCSR0C, R16

port_init:	
	LDI		temp,	0xFF
	OUT		DDRA,	temp
	STS		DDRF,	temp
	LDI		temp,	0b11011111
	OUT		DDRC,	temp
	LDI		temp,	0b00001110
	STS		DDRG,	temp

; END Internal Hardware Init / External Hardware Init  =========

; END External Hardware Init / Main ============================
main:
	RCALL	uart_rcv	; �������� �������
	CPI		UartIn, 'F'
	BREQ	fareads
	CPI		UartIn,	'V'
	BREQ	fawriter
	CPI		UartIn, 'R'
	BREQ	readr
	CPI		UartIn, 'W'
	BREQ	writer
	CPI		UartIn, 'S'
	BREQ	settingsr
	CPI		UartIn, 'I'
	BREQ	infor
	CPI		UartIn, 'T'
	BREQ	testr
	CPI		UartIn, 'Q'
	BREQ	quer
	CPI		UartIn, 'E'
	BREQ	eraser
	
	LDI		UartOut, 'e'	; ���� �� ������� ������� ��� ������� �������������� ������� 
	RCALL	uart_snt
	LDI		UartOut, 'c'	; ������� ������ "������������ �������"
	RCALL	uart_snt
	JMP		main
; ==================================================================
writer:
	JMP		write
settingsr:
	JMP		settings
testr:
	JMP		test
infor:
	JMP		info
quer:
	JMP		que
eraser:
	JMP		erase
readr:
	JMP		read
fawriter:
	JMP		fawrite
; ==================================================================
fareads:
	LDI		temp,	Low(RAMEND)	; ������������� �����
	OUT		SPL,	temp		
	LDI		temp,	High(RAMEND)
	OUT		SPH,	temp
faread:
	UARTOSRECIEVTOS
	CPI		UartIn, 'A'		; ���� �������� "�", �������� �����
	BREQ	freadaddr
	CPI		UartIn, 'E'		; ���� �������� "E", ������ ������
	BREQ	freadend

	LDI		UartOut, 'e'	; ������ ����� �� ������ ����� - ������, � ������ �����
	RCALL	uart_snt
	IN		UartOut, SPL
	RCALL	uart_snt
	IN		UartOut, SPH
	RCALL	uart_snt
	LDI		temp,	Low(RAMEND)	; ����� ������������� �����
	OUT		SPL,	temp		
	LDI		temp,	High(RAMEND)
	OUT		SPH,	temp
	JMP		main
freadaddr:
	UARTOSRECIEVTOS		; �������� �����
	MOV		Addr0,	UartIn
	UARTOSRECIEVTOS
	MOV		Addr1,	UartIn
	UARTOSRECIEVTOS
	MOV		Addr2,	UartIn
	PUSHA					; ���������� ��� � ����
	JMP		faread
	
freadend:
	// ��������� ������ ������������� �������
	POPA
	OUT		PORTA, Addr0
	OUT		PORTC, Addr1
	STS		PORTF, Addr2
	NOP						; �������� ������ � ����� ������ �� � ����
	NOP
	IN		UartOut, PINB
	UARTOSSENTOS
	IN		UartOut, PIND
	UARTOSSENTOS

	IN		temp, SPL
	CPI		temp, Low(RAMEND)		; ����� �� �� ��� �����?
	BRNE	freadend				; ���� �� - ����� �� ����	
	IN		temp, SPH				; ���� ��� - ���� ����
	CPI		temp, High(RAMEND)
	BRNE	freadend
	JMP		main
; ==================================================================
fawrite:
	UARTOSRECIEVTOS
	CPI		UartIn, 'D'		; ���� �������� "�", �������� �����
	BREQ	fwritedata
	CPI		UartIn, 'E'		; ���� �������� "E", ������ ������
	BREQ	fwriteend

	LDI		UartOut, 'e'	; ������ ����� �� ������ ����� - ������, � ������ �����
	RCALL	uart_snt
	IN		UartOut, SPL
	RCALL	uart_snt
	IN		UartOut, SPH
	RCALL	uart_snt
	LDI		temp,	Low(RAMEND)	; ����� ������������� �����
	OUT		SPL,	temp		
	LDI		temp,	High(RAMEND)
	OUT		SPH,	temp
	JMP		main

fwritedata:
	UARTOSRECIEVTOS
	MOV		Addr0,	UartIn
	UARTOSRECIEVTOS
	MOV		Addr1,	UartIn
	UARTOSRECIEVTOS
	MOV		Addr2,	UartIn
	UARTOSRECIEVTOS
	MOV		Dat0,	UartIn
	UARTOSRECIEVTOS
	MOV		Dat1,	UartIn
	PUSHAD
	RJMP	fawrite
	
fwriteend:
	/*PINIOUT
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x40,0x00		; 555h,	20h
	FWRITE*/
fwriteend1:
/*	LADDRDATI	0x20, 0x11,0x2C,0x40,0x80		; 555h,	A0h
	FWRITE 
	POPAD
	FWRITE ; addr, dat*/
	PINIOUT
	//���� ������
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x40,0x80		; 555h,	A0h
	FWRITE
	POPAD
	FWRITE		
	
	NOP

	LDI		temp, 0b00100000
	OUT		PORTC, temp

	SBIC	PINC,5 
	RJMP	PC-0x01

	SBIS	PINC,5 
	RJMP	PC-0x01

	IN		temp, SPL
	CPI		temp, Low(RAMEND)		; ����� �� �� ��� �����?
	BRNE	fwriteend2				; ���� �� - ����� �� ����	
	IN		temp, SPH				; ���� ��� - ���� ����
	CPI		temp, High(RAMEND)
	BRNE	fwriteend2

	LADDRDATI	0x20, 0x11,0x2C,0x08,0x80		; 555h,	90h ����� ������� ������
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x00,0x00		; 555h,	90h
	FWRITE

	JMP		main
fwriteend2	:
	JMP		fwriteend1
; ==================================================================
read:
	RCALL	uart_rcv
	MOV		Addr0,UartIn
	RCALL	uart_rcv
	MOV		Addr1,UartIn
	RCALL	uart_rcv
	MOV		Addr2,UartIn
	RCALL	uart_rcv
	MOV		ChSumm,UartIn

	SUB		ChSumm, Addr0
	SUB		ChSumm, Addr1
	SUB		ChSumm, Addr2
	BREQ	rSummChed

	LDI		UartOut, 'e'	
	RCALL	uart_snt
	LDI		UartOut, 'c'	
	RCALL	uart_snt
	LDI		UartOut, 'r'	
	RCALL	uart_snt
	JMP		main					; ������ "������������ �������"

rSummChed:
	CPI		mode, 'R'
	BREQ	good_mode_read

	PINIIN
	LDI		mode, 'R'
		; ������������� ������

good_mode_read:
	LDI		temp, 0b00001000		;(1<<WE)||(0<<OE)||(0<<CE)		
	UOUT	PORTG, temp
	
	FREAD

	LDI		ChSumm, 0
	SUB		ChSumm, Dat0
	SUB		ChSumm, Dat1
	LDI		UartOut, 'd'
	RCALL	uart_snt
	MOV		UartOut, Dat0
	RCALL	uart_snt
	MOV		UartOut, Dat1
	RCALL	uart_snt
	MOV		UartOut, ChSumm
	RCALL	uart_snt

	JMP		main
; ==================================================================
write: 
	RCALL	uart_rcv
	MOV		Addr0,	UartIn
	RCALL	uart_rcv
	MOV		Addr1,	UartIn
	RCALL	uart_rcv
	MOV		Addr2,	UartIn
	RCALL	uart_rcv
	MOV		Dat0,	UartIn
	RCALL	uart_rcv
	MOV		Dat1,	UartIn
	RCALL	uart_rcv
	MOV		ChSumm,	UartIn

	SUB		ChSumm, Addr0
	SUB		ChSumm, Addr1
	SUB		ChSumm, Addr2
	SUB		ChSumm, Dat0
	SUB		ChSumm, Dat1
	BREQ	wSummChed
	
	LDI		UartOut,	'e'	; ���� �� ������� ������� - ������� ������
	RCALL	uart_snt
	LDI		UartOut,	'c'	; ������ "������������ �������"
	RCALL	uart_snt
	LDI		UartOut,	'w'	; ������ "������������ �������"
	RCALL	uart_snt

wSummChed:
	//������������� ������ ������
	LDI		mode,	'W'

	PINIOUT
	PUSHAD
	//���� ������
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x40,0x80		; 555h,	A0h
	FWRITE
	POPAD
	FWRITE		; adrh, dah
	
	PINIIN	; ���������� ����� ������ �� ���� � ���������
	LDI		temp, 0b00100000
	OUT		PORTC, temp
lbl1:
	SBIC	PINC,5 
	RJMP	lbl1

	LDI		UartOut,	'w'	; �������� ������ ������ �������
	RCALL	uart_snt

lbl2:
	IN		Dat0, PINB
	IN		Dat1, PIND
	SBIS	PINC,5 
	RJMP	lbl2
	
	LDI		UartOut,	'g'	
	RCALL	uart_snt
	LDI		UartOut,	'd'	
	RCALL	uart_snt
	
	MOV		UartOut, Dat0
	RCALL	uart_snt
	MOV		UartOut, Dat1
	RCALL	uart_snt

	JMP		main
; ==================================================================
settings: //�����
	JMP		main
; ==================================================================
info:
	LDI		UartOut,	'i'
	RCALL	uart_snt
	LDI		UartOut,	'i'
	RCALL	uart_snt

	LDI		mode,	'I'

	PINIOUT		; ���������� ����� ������, ������ � ������ �� �����
		
	LADDRDATI	0x20, 0x11,0x2C,0x48,0x82		; 555h, F0h reset command
	FWRITE	

	NNOP
	NNOP
	NNOP
	NNOP
	NNOP

	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x08,0x80		; 555h,	90h
	FWRITE

	PINIIN		; ���������� ����� ������ �� ���� � ���������
	
	LADDRI	0x00,0x00,0x00 ;00 - 0x00
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRI	0x00,0x01,0x00 ;01 - 0x01
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRI	0x00,0x04,0x00 ;04
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRI	0x00,0x05,0x00 ;05
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	PINIOUT		; ���������� ����� ������, ������ � ������ �� �����

	LADDRDATI	0x20, 0x11,0x2C,0x48,0x82		; 55h, F0h reset command
	FWRITE	

	JMP		main
; ==================================================================
que:
	RCALL	uart_rcv		; ��������� �����������

	CPI		UartIn, 'Q'
	BREQ	queq_r
	CPI		UartIn, 'A'
	BREQ	que_addr_r
	
	LDI		UartOut, 'e'
	RCALL	uart_snt
	LDI		UartOut, 'c'
	RCALL	uart_snt
	LDI		UartOut, 'q'
	RCALL	uart_snt
	JMP		main

queq_r:
	JMP		queq
que_addr_r:
	JMP		que_addr

	JMP		main
queq:
	LDI		UartOut, 'q'
	RCALL	uart_snt

	LDI		mode,	'Q'

	PINIOUT		; ���������� ����� ������, ������ � ������ �� �����

	LADDRDATI	0x20, 0x11,0x20,0x0A,0x80		; 55h, 98h
	FWRITE

	PINIIN		; ���������� ����� ������ �� ���� � ���������

	LADDRI	0x20, 0x00,0x00
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt
	
	LADDRI	0x20, 0x01,0x00
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRI	0x20, 0x04,0x00
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRDATI	0x20, 0x11,0x20,0x48,0x82		; 55h, F0h reset command
	FWRITE

	JMP		main

que_addr:
	RCALL	uart_rcv		; ��������� �������
	MOV		Addr0,UartIn
	RCALL	uart_rcv
	MOV		Addr1,UartIn
	RCALL	uart_rcv
	MOV		Addr2,UartIn
	PUSHA

	LDI		mode,	'Q'

	LDI		UartOut,	'q'
	RCALL	uart_snt
	LDI		UartOut,	0x20
	RCALL	uart_snt
	LDI		UartOut,	0x02
	RCALL	uart_snt
	LDI		UartOut,	0x00
	RCALL	uart_snt
	LDI		UartOut,	0x22
	RCALL	uart_snt
	PINIOUT		; ���������� ����� ������, ������ � ������ �� �����

	LADDRDATI	0x20, 0x11,0x20,0x0A,0x80		; 55h, 98h
	FWRITE

	PINIIN		; ���������� ����� ������ �� ���� � ���������

	POPA
	FREAD
	MOV		UartOut,	Dat0
	RCALL	uart_snt
	MOV		UartOut,	Dat1
	RCALL	uart_snt

	LADDRDATI	0x20, 0x11,0x20,0x48,0x82		; 55h, F0h reset command
	FWRITE

	JMP		main
; ==================================================================
erase:
	RCALL	uart_rcv

	CPI		UartIn, 'B'
	BREQ	erase_bank
	CPI		UartIn, 'C'
	BREQ	erase_chip_r

	LDI		UartOut,	'e'	; ���� �� ������� ������� - ������� ������
	RCALL	uart_snt
	LDI		UartOut,	'c'	; ������ "������������ �������"
	RCALL	uart_snt
	LDI		UartOut,	'e'	; ������ "������������ �������"
	RCALL	uart_snt

	JMP		main

erase_chip_r:
	JMP		erase_chip

erase_bank:
	RCALL	uart_rcv
	MOV		Addr0,	UartIn
	RCALL	uart_rcv
	MOV		Addr1,	UartIn
	RCALL	uart_rcv
	MOV		Addr2,	UartIn
	RCALL	uart_rcv
	MOV		ChSumm,	UartIn

	SUB		ChSumm, Addr0
	SUB		ChSumm, Addr1
	SUB		ChSumm, Addr2
	BREQ	ebSummChed
	
	LDI		UartOut,	'e'	; ���� �� ������� ������� - ������� ������
	RCALL	uart_snt
	LDI		UartOut,	'c'	; ������ "������������ �������"
	RCALL	uart_snt
	LDI		UartOut,	'b'	; ������ "������������ �������"
	RCALL	uart_snt
	JMP		main

ebSummChed:
	//������������� ������ ������
	LDI		mode,	'E'
	PINIOUT
	PUSHA
	//���� ������
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x00,0x80		; 555h,	A0h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	POPA
	LDI		Dat0, 0x48
	LDI		Dat1, 0x00
	FWRITE	; adrh, 30h
	
	PINIIN	; ���������� ����� ������ �� ���� � ���������
	LDI		temp, 0b00100000
	OUT		PORTC, temp
	
lbl3:
	SBIC	PINC,5 
	RJMP	lbl3

	LDI		UartOut,	'e'	; �������� ������ ������ �������
	RCALL	uart_snt

lbl4:
	IN		Dat0, PINB
	IN		Dat1, PIND
	SBIS	PINC,5 
	RJMP	lbl4
	
	LDI		UartOut,	'g'	
	RCALL	uart_snt
	LDI		UartOut,	'd'	
	RCALL	uart_snt
	
	MOV		UartOut, Dat0
	RCALL	uart_snt
	MOV		UartOut, Dat1
	RCALL	uart_snt
	JMP		main

erase_chip:
	RCALL	uart_rcv
	CPI		UartIn, 'P'
	BREQ	erase_chip_comm
	
	LDI		UartOut,	'e'	; ���� �� ������� ������� - ������� ������
	RCALL	uart_snt
	LDI		UartOut,	'c'	; ������ "������������ �������"
	RCALL	uart_snt
	LDI		UartOut,	'e'	; ������ "������������ �������"
	RCALL	uart_snt
	JMP		main
erase_chip_comm:
	LDI		mode,	'E'
	PINIOUT
	//���� ������
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x00,0x80		; 555h,	A0h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x42,0x81		; 555h, AAh 
	FWRITE	
	LADDRDATI	0x02, 0x84,0x12,0x28,0x22		; 2AAh, 55h
	FWRITE
	LADDRDATI	0x20, 0x11,0x2C,0x08,0x00		; 555h, 10h
	FWRITE	
	JMP		main
; ==================================================================
test:
	LDI		mode, 'T'		
	RCALL	uart_rcv		; ��������� �����������

	CPI		UartIn, 'A'
	BREQ	test_address_r
	CPI		UartIn, 'D'
	BREQ	test_data_r
	CPI		UartIn,	'C'
	BREQ	test_command_r
	CPI		UartIn, 'I'
	BREQ	test_inc_r
	CPI		UartIn, 'T'
	BREQ	test_test_r

	LDI		UartOut, 'e'
	RCALL	uart_snt
	LDI		UartOut, 'c'
	RCALL	uart_snt
	LDI		UartOut, 't'
	RCALL	uart_snt

	JMP		main
test_address_r:
	JMP		test_address
test_data_r:
	JMP		test_data
test_command_r:
	JMP		test_command
test_inc_r:
	JMP		test_inc
test_test_r:
	JMP		test_test

test_address:
	RCALL	uart_rcv		; ��������� �������
	MOV		Addr0,UartIn
	RCALL	uart_rcv
	MOV		Addr1,UartIn
	RCALL	uart_rcv
	MOV		Addr2,UartIn
	PINIOUT					; D���������� �������
	OUT		PORTA, Addr0
	OUT		PORTC, Addr1
	STS		PORTF, Addr2
	LDI		UartOut, 't'	; �����
	RCALL	uart_snt
	LDI		UartOut, 'a'
	RCALL	uart_snt
	JMP		main

test_data:
	RCALL	uart_rcv		; ��������� ������
	MOV		Dat0,UartIn
	RCALL	uart_rcv
	MOV		Dat1,UartIn
	PINIOUT					; ����������� ������
	OUT		PORTB, Dat0
	OUT		PORTD, Dat1
	LDI		UartOut, 't'	; �����
	RCALL	uart_snt
	LDI		UartOut, 'd'
	RCALL	uart_snt
	JMP		main

test_command:				
	RCALL	uart_rcv		; ��������� ������
	STS		PORTG, UartIn
	RCALL	uart_rcv
	STS		DDRG,UartIn
	PINIOUT
	LDI		UartOut, 't'	; �����
	RCALL	uart_snt
	LDI		UartOut, 'c'
	RCALL	uart_snt
	JMP		main

test_inc:
	RCALL	uart_rcv		; ��������� ������
	LDI		UartOut, 't'
	RCALL	uart_snt
	LDI		UartOut, 'i'
	RCALL	uart_snt
	MOV		UartOut, UartIn
	INC		UartOut
	RCALL	uart_snt
	JMP		main

test_test:
	LDI		UartOut, 't'
	RCALL	uart_snt
	LDI		UartOut, 't'
	RCALL	uart_snt
	JMP		main

; END Main / Procedure =========================================
;�������� �����
.include	"procedures.inc"
; END Procedure ================================================
;88 END FLASH / EEPROM =========================================
.ESEG				; ������� EEPROM

;88 End EEPROM =================================================