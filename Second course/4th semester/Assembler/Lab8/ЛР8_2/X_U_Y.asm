;��������� ������������ � ������ X_U_Y ����
;   Procedure (var X: LONGWORD; const Y:LONGWORD; L:LONGWORD)
;����������� ����������� ������� ����� X:=X U Y ����� L.

.386
.model FLAT,PASCAL
PUBLIC X_U_Y

.CODE
X_U_Y PROC
X EQU DWORD PTR[EBP+16]           ;������ ������
Y EQU DWORD PTR[EBP+12]           ;������ ������
L EQU DWORD PTR[EBP+8]            ;����� �����

  PUSH EBP                        ;����� ������ ����� EBP
  MOV EBP,ESP                     ;����� � EBP ������� �������� ESP

  PUSH ESI                        ;��������� ��������
  PUSH EDI

  MOV ECX,L                       ;CX = L
  SHR ECX,5                       ;�������� �� 5 �������� ������ (����� ������ �� 32)
;���� ECX ������ ��� ����� 32, �� �� ������ 1, ����� 0
  INC ECX                         ;�������������� ECX, ����� ���� ����� ���������� 2 ����
  MOV EDI,X
  MOV ESI,Y

M1:
  MOV EAX,[ESI]
  OR [EDI],EAX                    ;����������
  ADD EDI,4                       ;�������� ��������� ����� �� 4
  ADD ESI,4
  LOOP M1                         

  POP EDI
  POP ESI
  POP EBP
  RET 12
X_U_Y ENDP
END