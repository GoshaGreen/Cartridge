.include "macro.inc"	
;88 RAM ========================================================
.DSEG ; ������� 
;CCNT:	.byte	4
;TCNT:	.byte	4

;88 END RAM / FLASH ============================================
.CSEG ; �������
; Include ======================================================
	.include "interrupts.inc"
	.include "coreinit.inc"	
; END Include / Internal Hardware Init  ========================

; END Internal Hardware Init / External Hardware Init  =========

; END External Hardware Init / Main ============================

; END Main / Procedure =========================================

; END Procedure ================================================
;88 END FLASH / EEPROM =========================================
.ESEG				; ������� EEPROM

;88 End EEPROM =================================================