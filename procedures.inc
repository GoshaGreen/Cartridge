/*
 * procedures.inc
 *
 *  Created: 08.04.2017 11:57:32
 *   Author: Gosha
 */ 

 /*port_init_out:
	LDI		temp,	0xFF
	OUT		DDRB,	temp
	OUT		DDRD,	temp
	OUT		PORTB,	temp
	OUT		PORTD,	temp
	RET

port_init_in:
	LDI		temp,	0x00
	OUT		DDRB,	temp
	OUT		DDRD,	temp
	LDI		temp,	0xFF
	OUT		PORTB,	temp
	OUT		PORTD,	temp
	RET

 f_read:
	OUT		PORTA, Addr0	
	OUT		PORTC, Addr1
	UOUT	PORTF, Addr2

	NOP		; ��� qry ������� ���������� �������� ��� ����,
	NOP		; ��� ������� ���������� - ������ ����� ���������.

	IN		Dat0, PINB
	IN		Dat1, PIND
	RET

f_write:
	LDI		R22, 0b00001100		;(1<<WE)||(1<<OE)||(0<<CE)		
	UOUT	PORTG, R22

	OUT		PORTA, Addr0
	OUT		PORTC, R22
	UOUT	PORTF, R22
	
	NOP

	LDI		R22, 0b00000100		;(0<<WE)||(1<<OE)||(0<<CE)		
	UOUT	PORTG, R22

	OUT		PORTB, Dat0
	OUT		PORTD, Dat1

	NOP
	NOP

	LDI		R22, 0b00001100		;(1<<WE)||(1<<OE)||(0<<CE)		
	UOUT	PORTG, R22
	RET*/

 uart_rcv:	
	SBIS	UCSR0A,RXC0	; ���� ����� ������� �����
	RJMP	uart_rcv	; �������� � �����
 
	IN		UartIn,UDR0		; ���� ������ - ��������.
	RET			; �������. ��������� � R20

uart_snt:	
	SBIS 	UCSR0A,UDRE0	; ������� ���� ��� ����� ����������
	RJMP	uart_snt 	; ���� ���������� - ����� UDRE
	OUT		UDR0, UartOut	; ���� ����
	RET			; �������