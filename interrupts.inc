.ORG 0x0000	JMP RESET ; Reset Handler
.ORG 0x0002	JMP EXT_INT0 ; IRQ0 Handler
.ORG 0x0004	JMP EXT_INT1 ; IRQ1 Handler
.ORG 0x0006	JMP EXT_INT2 ; IRQ2 Handler
.ORG 0x0008	JMP EXT_INT3 ; IRQ3 Handler
.ORG 0x000A	JMP EXT_INT4 ; IRQ4 Handler
.ORG 0x000C	JMP EXT_INT5 ; IRQ5 Handler
.ORG 0x000E	JMP EXT_INT6 ; IRQ6 Handler
.ORG 0x0010	JMP EXT_INT7 ; IRQ7 Handler
.ORG 0x0012	JMP TIM2_COMP ; Timer2 Compare Handler
.ORG 0x0014	JMP TIM2_OVF ; Timer2 Overflow Handler
.ORG 0x0016	JMP TIM1_CAPT ; Timer1 Capture Handler
.ORG 0x0018	JMP TIM1_COMPA; Timer1 CompareA Handler
.ORG 0x001A	JMP TIM1_COMPB; Timer1 CompareB Handler
.ORG 0x001C	JMP TIM1_OVF ; Timer1 Overflow Handler
.ORG 0x001E	JMP TIM0_COMP ; Timer0 Compare Handler
.ORG 0x0020	JMP TIM0_OVF ; Timer0 Overflow Handler
.ORG 0x0022	JMP SPI_STC ; SPI Transfer Complete Handler
.ORG 0x0024	JMP USART0_RXC; USART0 RX Complete Handler
.ORG 0x0026	JMP	USART0_DRE ; USART0,UDR Empty Handler
.ORG 0x0028	JMP USART0_TXC; USART0 TX Complete Handler
.ORG 0x002A	JMP ADCHand ; ADC Conversion Complete Handler
.ORG 0x002C	JMP EE_RDY ; EEPROM Ready Handler
.ORG 0x002E	JMP ANA_COMP ; Analog Comparator Handler
.ORG 0x0030	JMP TIM1_COMPC; Timer1 CompareC Handler
.ORG 0x0032	JMP TIM3_CAPT ; Timer3 Capture Handler
.ORG 0x0034	JMP TIM3_COMPA; Timer3 CompareA Handler
.ORG 0x0036	JMP TIM3_COMPB; Timer3 CompareB Handler
.ORG 0x0038	JMP TIM3_COMPC; Timer3 CompareC Handler
.ORG 0x003A	JMP TIM3_OVF ; Timer3 Overflow Handler
.ORG 0x003C	JMP USART1_RXC; USART1 RX Complete Handler
.ORG 0x003E	JMP USART1_DRE; USART1,UDR Empty Handler
.ORG 0x0040	JMP USART1_TXC; USART1 TX Complete Handler
.ORG 0x0042	JMP TWI ; Two-wire Serial Interface Interrupt Handler
.ORG 0x0044	JMP SPM_RDY ; SPM Ready Handler
.ORG 0x0046
EXT_INT0: ; IRQ0 Handler
			RETI
EXT_INT1: ; IRQ1 Handler	
			RETI
EXT_INT2: ; IRQ2 Handler	
			RETI
EXT_INT3: ; IRQ3 Handler	
			RETI
EXT_INT4: ; IRQ4 Handler	
			RETI
EXT_INT5: ; IRQ5 Handler	
			RETI
EXT_INT6: ; IRQ6 Handler	
			RETI
EXT_INT7: ; IRQ7 Handler	
			RETI
TIM2_COMP: ; Timer2 Compare Handler	
			RETI
TIM2_OVF: ; Timer2 Overflow Handler	
			RETI
TIM1_CAPT: ; Timer1 Capture Handler	
			RETI
TIM1_COMPA:; Timer1 CompareA Handler	
			RETI
TIM1_COMPB:; Timer1 CompareB Handler	
			RETI
TIM1_OVF: ; Timer1 Overflow Handler	
			RETI
TIM0_COMP: ; Timer0 Compare Handler	
			RETI
TIM0_OVF: ; Timer0 Overflow Handler	
			RETI
SPI_STC: ; SPI Transfer Complete Handler	
			RETI
USART0_RXC:; USART0 RX Complete Handler	
			RETI
USART0_DRE:; USART0,UDR Empty Handler	
			RETI
USART0_TXC:; USART0 TX Complete Handler	
			RETI
ADCHand: ; ADC Conversion Complete Handler	
			RETI
EE_RDY: ; EEPROM Ready Handler	
			RETI
ANA_COMP: ; Analog Comparator Handler	
			RETI
TIM1_COMPC:; Timer1 CompareC Handler	
			RETI
TIM3_CAPT: ; Timer3 Capture Handler	
			RETI
TIM3_COMPA:; Timer3 CompareA Handler	
			RETI
TIM3_COMPB:; Timer3 CompareB Handler	
			RETI
TIM3_COMPC:; Timer3 CompareC Handler	
			RETI
TIM3_OVF: ; Timer3 Overflow Handler	
			RETI
USART1_RXC:; USART1 RX Complete Handler	
			RETI
USART1_DRE:; USART1,UDR Empty Handler	
			RETI
USART1_TXC:; USART1 TX Complete Handler	
			RETI
TWI: ; Two-wire Serial Interface Interrupt Handler	
			RETI
SPM_RDY: ; SPM Ready Handler	
			RETI
; end interrupt table

RESET:

