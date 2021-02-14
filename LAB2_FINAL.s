; Archvo:	Lab2
; Dispositivo:	PIC16F887
; Autor:	Brayan Girón 
; Carnet:	15807
; Compilador:	pic-as (v2.30), MPLABX v5.40
;    
; Programa:	contador en el puerto A
; Hardware:	LEDs en el puerto b, puerto c y puerto d 
;
; Creado:	2 feb, 2021
; Ultima modificación: 2 feb, 2021
;-------------------------------------------------------------------------------
    
PROCESSOR 16F887
#include <xc.inc>

;configuration word 1
 CONFIG FOSC=XT     // Oscillador o Cristal Externo..
 CONFIG WDTE=OFF   // WDT disabled (reinicio repetitivo del pic)
 CONFIG PWRTE=ON   // PWRT enabled (espera de 72ms al iniciar)
 CONFIG MCLRE=OFF  // el pin de MCLR se utiliza como I/O
 CONFIG CP=OFF     // Sin protección de código
 CONFIG CPD=OFF    // Sin protección de datos
 
 CONFIG BOREN=OFF  // Sin reinicio cuándo el voltaje de alimentación baja de 4v 
 CONFIG IESO=OFF   // Reinicio sin cambio de reloj de interno a externo 
 CONFIG FCMEN=OFF  // Cambio de reloj externo a interno en caso de fallo 
 CONFIG LVP=ON     // Programación en bajo voltaje permitida 
 
;configuración word2
  CONFIG WRT=OFF	//Protección de autoescritura 
  CONFIG BOR4V=BOR40V	//Reinicio abajo de 4V 

;------------------------------
  PSECT udata_bank0 ;common memory
    cont:	DS  2 ;1 byte apartado
    ;cont_big:	DS  1;1 byte apartado
  
  PSECT resVect, class=CODE, abs, delta=2
  ;----------------------vector reset------------------------
  ORG 00h	;posición 000h para el reset
  resetVec:
    PAGESEL main
    goto main
  
  PSECT code, delta=2, abs
  ORG 100h	;Posición para el código
  
  
  
 ;----------------------------------------------------------------------------- 
 ;-------------------------------- MAIN ---------------------------------------
 main:
    bsf  STATUS, 5 ; banco 11
    bsf  STATUS, 6
    clrf ANSEL     ; pines digitales 
    clrf ANSELH
    
    bsf  STATUS, 5 ; banco 01
    bcf  STATUS, 6
    
    movlw 0xFF ;PORTA COMO ENTRADAS
    movwf TRISA     ;MOVER   
    movlw 11110000B    
    movwf TRISB 
    movlw 11110000B
    movwf TRISC 
    movlw 11100000B
    movwf TRISD 
    
    bcf  STATUS, 5 ; banco 00
    bcf  STATUS, 6

    ;movlw 0x00   ; COLOCAR EL VALOR INICIAL DEL PORTB EN "0x00"
    ;movwf PORTA
    movlw 0x00   ; COLOCAR EL VALOR INICIAL DEL PORTB EN "0x00"
    movwf PORTB
    movlw 0x00   ; COLOCAR EL VALOR INICIAL DEL PORTC EN "0x00"
    movwf PORTC
    movlw 0x00   ; COLOCAR EL VALOR INICIAL DEL PORTD EN "0x00"
    movwf PORTD
    
 ;------------------------------------------------------------------------------   
 ;------------------------------Loop--------------------------------------------
 Loop: 
    btfsc   PORTA, 0	; Verifica si el boton esta presionado
    call    Inc_B       ; Llama a la sub-rutina Inc_A
    btfsc   PORTA, 1	; Revisar si no esta presionado 
    call    Dec_B       ; Llama a la sub-rutina Dec_A
    
    btfsc   PORTA, 2	; Verifica si el boton esta presionado
    call    Inc_C       ; Llama a la sub-rutina Inc_B
    btfsc   PORTA, 3	; Verifica si el boton esta presionado
    call    Dec_C       ; Llama a la sub-rutina Dec_A
    
    btfsc   PORTA, 4    ; Verifica si el boton de SUMA esta presionado 
    call    SUMA 
    
    btfsc   STATUS, 1	; Carry 
    bsf	    PORTD, 4
    btfss   STATUS, 1	; Carry 
    bcf	    PORTD, 4
  
    goto    Loop        ; Regresa al inicioo de la etiqueta Loop.
    
    
 ;-----------------------------sub rutinas--------------------------------------
 Inc_B:
    call    Delay	;Llamamos a la sub-rutina Delay ->  
    btfsc   PORTA, 0	;Revisa de nuevo si no esta presionado
    goto    $-1		;ejecuta una linea atrás	        
    incf    PORTB
    return
    
 Dec_B:
    call    Delay
    btfsc   PORTA, 1	;Revisa de nuevo si no esta presionado
    goto    $-1		;ejecuta una linea atrás	        
    decf    PORTB
    return
    
 Inc_C:
    call    Delay
    btfsc   PORTA, 2	;Revisa de nuevo si no esta presionado
    goto    $-1		;ejecuta una linea atrás	        
    incf    PORTC
    return
    
 Dec_C: 
    call    Delay
    btfsc   PORTA, 3	;Revisa de nuevo si no esta presionado
    goto    $-1		;ejecuta una linea atrás	        
    decf    PORTC
    return
    
    
;--------------------------------- SUMA ----------------------------------------
SUMA:
    btfsc   PORTA, 4
    goto    SUMA 
    call    OPERACION
    return
    
OPERACION:
    movf    PORTB, w
    addwf   PORTC, w
    movwf   PORTD
    return 
    
 ;--------------------------------- Delay --------------------------------------
 ; Esta sirve para evitar el ruido al momento de presionar los botones.   
 
 Delay:
    movlw	150		;valor incial
    movwf	cont
    decfsz	cont, 1	        ;decrementar
    goto	$-1		;ejecutar línea anterior
    return
end





