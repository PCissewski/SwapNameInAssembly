.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC    
public _main

.data
        ; U+1F408 cat => UTF-16 = D8 3D DC 08
titlee dw 'T','i','t','l','e', 0
teext dw 'T','T', 0
soviet dw 262DH
       dw 0D83DH, 0DC08H
count dd 2

magazyn db 80 dup (?)
magazyn2 db 80 dup (?)
.code
_utf16 PROC
    push 0 ; MB_OK
    push OFFSET titlee
    push OFFSET soviet
    push 0
    call _MessageBoxW@16
_utf16 ENDP

_swap PROC
    push 80 ; maks liczba znakow
    push OFFSET magazyn 
    push 0
    call __read
    add esp, 12
    ; w eax jest liczba wpisanych znakow

    push eax ; odkladanie liczby znakow na stosie do funkcji write
    mov ebx, OFFSET magazyn ; adres pierwszego elementu w magazynie
    mov edi, ebx ; adres piewrszego elementu w magazynie
    mov ecx, eax ; liczba znakow do ecx aby potem uzywac komendy loop

    add ebx, ecx ; przejscie na koniec nazwiska i tam poczatek wpisywania imienia
    mov byte ptr [ebx - 1], 20h ; wpisywanie spacji na koniec nazwiska

begin:
    mov al, byte ptr [edi] ; wpisywanie znaku do al
    cmp al, 20h ; sprawdzanie kiedy jest spacja
    je print ; jak jest spacja to oznacza ze przepisalismy imie i idziemy drukowac
    mov byte ptr [ebx], al ; przepisywanie znaku na koniec po nazwisku
    inc edi ; inkrementacja wskaznika na kolejny znak imienia
    inc ebx ; inkrementacja wskaznika na docelowe miejscie znaku imienia
    loop begin

print:
    inc edi ; pominiecie spacji na poczatku nazwiska
    push edi
    push 1
    call __write
    add esp, 12

    ret
_swap ENDP

_main PROC
    
    call _swap

    push dword PTR 0
    call _ExitProcess@4
_main ENDP
END