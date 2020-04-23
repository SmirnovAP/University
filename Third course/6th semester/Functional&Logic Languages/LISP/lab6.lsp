;1.	��� ����� ����������� (mapcar #'������ '(570-40-8))? 
;	������. ������� "������" �� ����������.



;2.	�������� �������, ������� ��������� �� 10 ��� ����� �� ������-
;��������� ���� �������.
(defun all_minus_10 (lst);							(����������)
	(mapcar	#'(lambda (x)
					(cond	((numberp x) (- x 10))
							((listp x) (all_minus_10 x))
							(t		x)
					)
				)
			lst
	)
)



;3.	�������� �������, ������� ���������� ������ �������� ������-
;���������, ������� ��� �������� �������� �������. 
(defun get_first_element (lst)
	(if	(and	(listp (car lst))
				(not (null (car lst)))
		)
		(car lst)
		(get_first_element (cdr lst))
	)
)



;4.	�������� �������, ������� �������� �� ��������� ������ ������
;����� ����� ����� ��������� ���������.
(defun select_between_inner (lst left right result)
	(mapcar	#'(lambda (x)
					(cond	((listp x) (select_between_inner x left right result))
							((and	(numberp x) (> x left) (< x right))
								(nconc result (cons x nil))
							)
					)
				)
			lst
	)
	(cdr result)
)
(defun select_between (lst left right);						(����������)
	(select_between_inner lst left right (cons nil nil))
)



;5.	�������� �������, ����������� ��������� ������������ ���� �����
;�������-����������.
(defun decart (a b)
	(mapcan	#'(lambda (x) (mapcar	#'(lambda (y) (list x y))
									b
							)
			)
			a
	)
)



;6	������ ��� ����������� reduce, � ��� �������? 
;(reduce #'+ ()) -> 0
;(reduce #'* ()) -> 1
;	������� ������� ��������� ������-��������. ���� �� ����, ������������ �������� ������� ��� ���������� ����������.
;����� reduce ���������� �������� :initial-value. ���� �������� ���������� ��������, � �������� ����� ��������� ������� ��� ��������� ������� �������� ������-���������. ���� ������-�������� ����, �� ����� ���������� �������� initial-value.



;7	����� list-of-lists ������, ��������� �� �������. ��������
;�������, ������� ��������� ����� ���� ���� ��������� list-of-lists,
;�.�. �������� ��� ��������� ((1 2) (3 4)) -> 4. 
(defun sum_lengths (list-of-lists);						(����������)
	(reduce #'+
			(mapcar	(lambda	(x)
						(if (listp x) (sum_lengths x) 1)
					)
					list-of-lists
			)
	)
)



;8	�������� ����������� ������ (� ������ rec-add) ���������� �����
;����� ��������� ������.
(defun rec_add_inner (lst sum)
	(let (	(head (car lst))
			(tail (cdr lst))
		)
		(cond	((null lst) sum)
				((listp head) (rec_add_inner tail (rec_add_inner head sum)) )
				((numberp head) (rec_add_inner	tail (+ sum head)) )
				(t (rec_add_inner tail sum))
		)
	)
)
(defun rec_add (lst)
	(if (eq lst nil)
		nil 
		(rec_add_inner lst 0)
	)
)



;9	�������� ����������� ������ � ������ rec-nth ������� nth. 
(defun rec_nth_inner (lst curr target)
	(cond	((null lst) nil)
			((= curr target) (car lst))
			(t (rec_nth_inner (cdr lst) (+ curr 1) target))
	)
)

(defun rec_nth (num lst)
	(rec_nth_inner lst 0 num)
)



;10	�������� ����������� ������� alloddr, ������� ����������
;t , ����� ��� �������� ������ �������� 
(defun alloddr (lst);						(����������)
	(let	((head (car lst))
			 (tail (cdr lst))
			)
		(cond	((null lst) t)
				((listp head)
					(and (alloddr head) (alloddr tail))
				)
				((not (numberp head)) nil)
				((evenp head) nil)
				(t (alloddr tail))
		)
	)
)



;11	�������� ����������� �������, ����������� � ��������� �������� �
;����� ������ ����������, ������� ���������� ��������� �������
;������-���������.
(defun mylast (curr)
	(if	(eq (cdr curr) nil)
		(car curr)
		(mylast (cdr curr))
	)
)



;12	�������� ����������� �������, ����������� � ����������� ��������
;� ����� ������ ����������, ������� ��������� ����� ���� �����
;�� 0 �� n-��������� �������. 
(defun get_n_sum (curr n)
	(if	(or (eq curr nil) (= n 0))
		0
		(+ (car curr) (get_n_sum (cdr curr) (- n 1)))
	)
)



;13	�������� ����������� �������, ������� ���������� ���������
;�������� ����� �� ��������� ������, �������� �������� ���������
;��������������� �������.
(defun get_last_odd_inner (curr value)
	(cond	((eq curr nil) value)
			((oddp (car curr)) (get_last_odd_inner (cdr curr) (car curr)))
			(t (get_last_odd_inner (cdr curr) value))
	)
)
(defun get_last_odd (lst)
	(get_last_odd_inner lst nil)
)



;14	��������� cons-����������� �������� � ����� ������ ����������,
;�������� ������� ������� �������� ��� �������� ������ �����,
;� ���������� ������ ��������� ���� ����� � ��� �� �������. 
(defun square_all (lst);						(����������)
	(mapcar	#'(lambda (x)
					(cond	((numberp x) (* x x))
							((listp x) (square_all x))
							(t		x)
					)
				)
			lst
	)
)



;15	�������� ������� � ������ select-odd, ������� �� ���������
;������ �������� ��� �������� �����.
(defun select_odd_inner (lst result)		(����������)
	(mapcar	#'(lambda (x)
					(cond	((listp x) (select_odd_inner x result))
							((and	(numberp x) (oddp x))
								(nconc result (cons x nil))
							)
					)
				)
			lst
	)
	(cdr result)
)
(defun select_odd (lst);
	(select_odd_inner lst (cons nil nil))
)