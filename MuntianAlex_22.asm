format PE console

include 'win32a.inc'

entry Start

section 'text' code executable readable

Start:
        call Input
        call CreateArr2
        call Output
        call Waiting
        ret


Input:         ;Считывание массива A
        invoke printf,strInput
        add esp,4
        invoke scanf,integer,lengthA
        add esp,8
        call AllocationMemory
        mov edx,[arrA]
        mov ecx,[lengthA]
        lop:
                pusha
                invoke scanf,integer,edx
                add esp,8
                popa
        add edx,4
        dec ecx
        jnz lop
        ret

AllocationMemory:   ;Выделение памяти под массив
        mov eax,[lengthA]
        shl eax,2
        invoke malloc,eax
        add esp,4
        mov [arrA],eax
        shl eax,2
        sub eax,8
        invoke malloc,eax
        add esp,4
        mov [arrB],eax
        ret

CreateArr2:   ;Формирование массива B из элементов A, значение которых не совпадает с первым и последним элементамиA
        mov eax,[arrA]
        mov ebx,[eax]
        mov [first],ebx
        mov ebx,[lengthA]
        dec ebx
        shl ebx,2
        add eax,ebx
        mov ebx,[eax]
        mov [last],ebx
        mov eax,[arrA]
        mov ebx,[first]
        mov edx,[last]
        mov ecx,[lengthA]
        mov edi,[arrB]

        add eax,4
        sub ecx,2

        lop2:
                mov esi,[eax]
                cmp esi,ebx
                je skip
                cmp esi,edx
                je skip
                        mov [edi],esi
                        add edi,4
                        inc [lengthB]
                skip:
        add eax,4
        dec ecx
        jnz lop2
        ret

Output:          ;Вывод массива
        invoke printf,strOutput
        add esp,4
        mov eax,[arrB]
        mov ecx,[lengthB]
        lop3:
                pusha
                invoke printf,integer2,[eax]
                add esp,8
                popa
        add eax,4
        dec ecx
        jnz lop3
        ret

Waiting:        ;Ожидание, пока пользователь прочитает результат
        invoke scanf
        add esp,8
        ret



section 'data' data readable writeable

first dd ?
last dd ?
lengthA dd ?
lengthB dd ?
arrA dd ?
arrB dd ?
strInput db 'Please enter the array length and elements:',13,10,0
strOutput db 'Result:',13,10,0
integer db '%d',0
integer2 db ' %d',0

section 'imp' import readable

library msvcrt,'msvcrt.dll'

import msvcrt,\             ; в ней нам нужны функции...   (все это стандартные функции Си(Чистый си сам пользуется этой либой))
       printf,'printf',\   ; для вывода
       scanf,'scanf',\      ;для ввода
       malloc,'malloc',\   ;для выделения памяти
       free,'free'          ;для освобождения памяти


