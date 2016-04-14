
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
include 'emu8086.inc'

.data
; variabila pentru a detecta daca jucatorul l-a ajutat pe tanar
ajutat db 0
; variabila ce contorizeaza numarul de probe/pasi
contor_pasi dw 0
; variabila ce contorizeaza numarul de incercari de terminare a jocului
incercari dw 0

w equ 50 ; dimensiune dreptunghi
h equ 50

.code
call meniu_principal

hlt

; procedura meniului principal
meniu_principal proc
    ; curatam ecranul
    ; rol estetic
    ; fix pentru call din alte proceduri
    call curatare_ecran
    
    ; resetam numarul de pasi efectuati
    mov contor_pasi, 0
    ; fix: resetam variabila pentru 
    mov ajutat, 0
    
    printn "Vital Answers"
    putc 13
    putc 10
    putc 13
    printn "Acesta este un joc bazat pe intrebari, raspunsuri si decizii."
    putc 13
    printn "In functie de deciziile luate, poti termina jocul mai repede, mai greu, sau poti chiar sa mori."
    putc 13
    printn "Inainte de a face o alegere, gandeste-te bine!" 
    putc 13
    putc 10
    putc 13
    ; afisam numarul de incercari
    print "Incercari: "
    mov ax, incercari
    call print_num
    putc 13
    putc 10
    putc 13
    printn "Apasa orice tasta pentru a incepe un joc nou."
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    call primul_ecran  
ret
meniu_principal endp

; primul ecran din joc
; inceputul povestii
primul_ecran proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    printn "Inceputul - Actiune plasata undeva in Evul Mediu"
    putc 10
    putc 13
    printn "Incepe o noua zi, soarele rasare incet si lin."
    printn "Totul este monoton si pare o zi ca oricare alta."
    printn "Te pregatesti sa pleci catre locul tau de munca, fieraria satului."
    printn "Castigi foarte putini bani si abia reusesti sa iti duci traiul de pe o zi pe alta."
    printn "Pe drum intalnesti oameni din toate clasele sociale, insa remarci un tanar caruia ii este foame si nu are niciun ban."
    printn "Te uiti in buzunar si observi ca ai doar trei galbeni, bani cu care ar trebui sa traiesti urmatoarele doua zile."
    printn "O paine costa exact 3 galbeni."
    printn "Ce o sa faci?"
    putc 10
    putc 13
    printn "1) Il ajuti pe tanar chiar daca ramai fara bani"
    printn "2) Il ignori si pleci mai departe" 
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    ; prima optiune aleasa, schimbam valoare variabilei
    cmp al, "1"
    je tanar_ajutat
    ; a doua optiune aleasa, trecem la urmatorul ecran
    cmp al, "2"
    je ecran_2
    ; fix pentru orice caracter introdus in afara de 1 si 2
    ; se va reafisa ecranul
    cmp al, "2"
    jg primul_ecran
    cmp al, "1"
    jmp primul_ecran
ret
primul_ecran endp

; procedura - tanar ajutat
; schimbam valoarea variabilei ajutat in 1
tanar_ajutat proc
    inc ajutat
    call ecran_2
ret
tanar_ajutat endp

; ecranul al doilea
; continuarea jocului
ecran_2 proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    ; jucatorul a trecut de prima proba
    ; incrementam numarul de mutari/pasi
    call incrementare_pasi
    
    printn "A doua zi - Boala"
    putc 10
    putc 13
    printn "Te trezesti insa nu te simti bine, iar starea ta incepe sa se deterioreze."
    printn "Nu ai bani pentru a merge la doctor."
    printn "Leacurile pe care le stii te pot vindeca insa nu stii in ce proportii sa adaugi plantele."
    printn "Ce o sa faci?"
    putc 10
    putc 13
    printn "1) Pregatesti un leac experimental"
    printn "2) Ceri ajutor pe strada"
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    ; prima optiune aleasa, este fatala
    cmp al, "1"
    je leac_fatal
    ; a doua optiune aleasa, verificam daca tanarul a fost ajutat
    cmp al, "2"
    je verificare_tanar
    ; fix pentru orice caracter introdus in afara de 1 si 2
    ; se va reafisa ecranul
    cmp al, "2"
    jg primul_ecran
    cmp al, "1"
    jmp primul_ecran
ret
ecran_2 endp 

; procedura pentru leacul fatal
leac_fatal proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    printn "Ai gresit proportiile plantelor medicinale si ai obtinut un leac fatal."
    call moarte
ret
leac_fatal endp

; procedura pentru a verifica daca tanarul a fost ajutat
; daca a fost ajutat, acesta te va duce la doctor
; daca nu, esti mort
verificare_tanar proc
    cmp ajutat, 1
    je ecran_3
    cmp ajutat, 1
    jmp ignorat
ret
verificare_tanar endp

; procedura pentru moarte datorata ignorantei
ignorat proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    printn "Iesi pe strada cerand ajutor insa lumea te ignora."
    call moarte
ret
ignorat endp

; procedura pentru vindecare
ecran_3 proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    ; jucatorul a trecut de a doua proba
    ; incrementam numarul de mutari/pasi
    call incrementare_pasi
    
    printn "Iesi pe strada cerand ajutor iar tanarul pe care l-ai ajutat ieri te remarca si te duce la un doctor, prieten apropiat de-al lui."
    printn "Acesta reuseste sa te vindece."
    putc 10
    putc 13
    printn "Apasa orice tasta pentru a continua..."
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    call revenirea
ret
ecran_3 endp

; urmatoarea proba
; continuarea jocului
revenirea proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    
    printn "Cati banuti aveai la prima proba?"
    putc 10
    putc 13
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    
    ; daca jucatorul raspunde cu 3, jocul se termina
    cmp al, "3"
    je sfarsit_joc
    ; daca jucatorul raspunde cu orice alta tasta, jocul se termina insa o sa creasca si numarul de pasi efectuati
    cmp al, "3"
    jg raspuns_gresit
    cmp al, "3"
    jmp raspuns_gresit
ret
revenirea endp

; procedura pentru sfarsitul jocului
sfarsit_joc proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    call incrementare_pasi
    call sunet
    
    printn "Ai terminat jocul efectuand numarul minim de pasi posibili."
    
    ; afisam numarul de incercari
    print "Incercari: "
    mov ax, incercari
    call print_num
    putc 10
    putc 13
    printn "Felicitari!" 
    putc 10
    putc 13
    
    ; resetam numarul de incercari
    mov incercari, 0
    
    printn "Apasa orice tasta pentru a desena o casa."
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    call casa
ret
ret
sfarsit_joc endp

; procedura pentru raspuns gresit
raspuns_gresit proc
    ; curatam ecranul
    ; rol estetic
    call curatare_ecran
    ; incrementam de 2 ori numarul de pasi drept pedeapsa
    call incrementare_pasi
    call incrementare_pasi
    call sunet
    
    ; afisam numarul de incercari
    printn "Ai terminat jocul efectuand urmatorul numar de pasi:"
    mov ax, contor_pasi
    call print_num
    
    putc 10
    putc 13
    ; afisam numarul de incercari
    print "Incercari: "
    mov ax, incercari
    call print_num
    putc 10
    putc 13
    printn "Felicitari!"
    
    ; resetam numarul de incercari
    mov incercari, 0
    
    putc 10
    putc 13
    printn "Apasa orice tasta pentru reveni la meniu."
    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    call meniu_principal 
ret
raspuns_gresit endp

; procedura pentru incrementarea numarului de pasi
incrementare_pasi proc
    inc contor_pasi
ret
incrementare_pasi endp

; procedura pentru golirea ecranului
; rol estetic
curatare_ecran proc
    mov ah, 0
    mov al, 3
    int 10h
ret
curatare_ecran endp

; procedura pentru moarte
; cu revenire la meniul principal
moarte proc
    ; incrementam contorul pentru incercari
    inc incercari
    
    call sunet
    
    printn "Din pacate, ai murit!"
    putc 10
    putc 13
    printn "Apasa orice tasta pentru reveni la meniu."   

    ; asteptam optiunea introdusa de catre jucator
    mov ah, 1
    int 21h
    call meniu_principal 
ret
moarte endp 

; procedura pentru sunet
sunet proc
    ; cod pentru sunet - beep
    ; sursa: https://www.programmersheaven.com/discussion/212349/beep-sound
    mov dl, 07h
    mov ah, 2
    int 21h
ret
sunet endp

; procedura pentru desenarea casei
casa proc
    mov ah, 0
    mov al, 13h
    int 10h
        
    ; latura triunghi jos
    mov cx, 150
    mov dx, 120
    mov al, 15
    lat1: mov ah, 0ch
    int 10h
    dec cx
    cmp cx, 100
    ja lat1       
    
    
    ; latura triunghi stanga
    mov cx, 100
    mov dx, 120
    mov al, 15
    lat2: mov ah, 0ch
    int 10h
    dec dx 
    dec dx
    inc cx
    cmp dx, 70 
    ja lat2
    
    ; latura triunghi dreapta
    mov cx, 150
    mov dx, 120
    mov al, 15 
    lat3: mov ah, 0ch
    int 10h
    dec dx
    dec dx 
    dec cx
    cmp dx, 70
    ja lat3           
    
    ; latura dreptunghi stanga
    mov cx, 100
    mov dx, 120
    mov al, 15
    lat4: mov ah, 0ch
    int 10h
    inc dx
    cmp dx, 160
    jb lat4
                
    ; latura dreptunghi dreapta
    mov cx, 150
    mov dx, 120
    mov al, 15       
    lat5: mov ah, 0ch
    int 10h
    inc dx
    cmp dx, 160
    jb lat5    
    
    ; latura dreptunghi jos 
    mov cx, 150
    mov dx, 160
    mov al, 15
    lat6: mov ah, 0ch
    int 10h
    dec cx
    cmp cx, 100
    ja lat6
    
    ; lateral sus orizontala
    mov cx, 150
    mov dx, 120
    mov al, 15
    lat7: mov ah, 0ch
    int 10h
    dec dx 
    inc cx
    inc cx
    cmp dx, 80 
    ja lat7
    
    
    ; lateral jos orizontala
    mov cx, 150
    mov dx, 160
    mov al, 15
    lat8: mov ah, 0ch
    int 10h
    dec dx 
    inc cx
    inc cx
    cmp dx, 120
    ja lat8
    
    ; lateral dreapta verticala
    mov cx, 230
    mov dx, 80
    mov al, 15       
    lat9: mov ah, 0ch
    int 10h
    inc dx
    cmp dx, 120
    jb lat9
    
    ; latura acoperis dreapta
    mov cx, 230
    mov dx, 77
    mov al, 15 
    lat10: mov ah, 0ch
    int 10h
    dec dx
    dec dx 
    dec cx
    cmp dx, 30
    ja lat10
    
    ; latura acoperis sus
    mov cx, 125
    mov dx, 70
    mov al, 15
    lat11: mov ah, 0ch
    int 10h
    dec dx 
    inc cx
    inc cx
    cmp dx, 30
    ja lat11
ret
casa endp


DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS