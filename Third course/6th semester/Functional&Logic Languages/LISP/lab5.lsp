;1. �������� �������, ������� �� ������ ������-��������� lst ����������
;�������� �� �� ����������� (�� ���� ����� �� lst � (reverse lst)).
(defun palindrom (lst) (equal lst (reverse lst)) )

(defun pal (lst rev len)
	(cond	((<= len 0) t)
			(	(and	(equal (car lst) (car rev))
					(pal (cdr lst) (cdr rev) (- len 2))
				)
				t
			)
	)
)
(defun palindrom (lst) (pal lst (reverse lst) (length lst)))



;2. �������� �������� set-equal, ������� ���������� t, ���� ��� ���
;���������-��������� �������� ���� � �� �� ��������, ������� �������
;�� ����� ��������.
(defun set-equal (x y) (and (subsetp x y)  (subsetp y x)))



;3. �������� ����������� �������, ������� ������������ ������� ��
;�������� ��� (������.�������), � ���������� �� ������ - �������,
;� �� ������� - ������.
(defun check (pair val) ;���������� ��������������� ������� �� �������� ���� ���� �������� ����������, ����� - ���
	(cond	((equal (car pair) val) (cdr pair))
			((equal (cdr pair) val) (car pair))
	)
)
(defun generate-check (val) ;���������� �������, ������� ����� ���������� ���� �������� � ���� ����� �����
	(lambda (pair) (check pair val))
)
;������ ������� ��� ������ � ������������ ��� �����; �������� �� �� ���� �������; ����������� ������ ��������� ���������
(defun find-in-table (base val)
	(find-if	#'(lambda (x) (not (eq x Nil)))
				(mapcar (generate-check val) base)
	)
)



;4. �������� ������� swap-first-last, ������� ������������ �
;������-��������� ������ � ��������� ��������.
(defun swap-first-last (lst)
	(append (last lst) (cdr (butlast lst)) (cons (car lst) nil))
)



;5. �������� ������� swap-two-ellement, ������� ������������ �
;������-��������� ��� ��������� ������ ����������� �������� ��������
;� ���� ������.
(defun swap-two-element (lst f s) 
	(let	((temp (nth f lst))) 
			(setf (nth f lst) (nth s lst ))
			(setf (nth s lst) temp))
	lst
)



;6. �������� ��� �������, swap-to-left � swap-to-right, �������
;���������� �������� ������������ � ������-��������� ����� � ������,
;��������������.
(defun swap-to-left (lst)
	(append	(cdr lst)
			(cons (first lst) nil)
	)
)
(defun swap-to-right (lst)
	(append	(last lst)
			(butlast lst)
	)
)



;7. �������� �������, ������� �������� �� �������� �����-�������� ���
;����� �� ��������� ������-���������, �����
;	�) ��� �������� ������ - �����,
(defun multiply-all (lst mul)
	(mapcar #'(lambda (x) (* x mul))
			lst
	)
)
;	�) �������� ������ - ����� �������.
(defun multiply-all (lst mul)
	(mapcar #'(lambda (x)
				(cond	((numbperp x) (* x mul))
						((listp x) (multiply-all x mul))
						(t x)
				)
			)
			lst
	)
)




;8. �������� �������, select-between, ������� �� ������-���������,
;����������� ������ �����, �������� ������ ��, ������� �����������
;����� ����� ���������� ���������-����������� � ���������� �� � ����
;������ (�������������� �� ����������� ������ ����� (+ 2 �����)).
(defun select-between (lst left right)
	(remove-if	#'(lambda (x) (or (< x left) (> x right)))
				lst)
)
