(define (ascending? s) 
    (cond ((null? s) #t)
          ((null? (cdr s)) #t)
          ((> (car s) (car (cdr s))) #f)
          (else (ascending? (cdr s))))
    )

(define (my-filter pred s) 
    (cond ((null? s) nil)
          ((pred (car s)) (cons (car s) (my-filter pred (cdr s))))
          (else (my-filter pred (cdr s))))
    )

(define (interleave lst1 lst2) 
    (cond ((null? lst1) lst2)
          ((null? lst2) lst1)
          (else (cons (car lst1) (interleave lst2 (cdr lst1)))))
    )

(define (no-repeats s) 
    (cond ((null? s) nil)
          (else (cons (car s) (no-repeats(my-filter (lambda (x) (not (= x (car s)))) (cdr s))))))
    )


; just for tracing test
(define fact (lambda (n)
    (if (zero? n) 1 (* n (fact (- n 1))))))

(define-macro (trace expr)
    (define operator (car expr))
`(begin
    (define original ,operator)
    (define ,operator (lambda (n)
                        (print (list (quote ,operator) n))
                        (original n)))
    (define result ,expr)
    (define ,operator original)
    result)
)

(trace (fact 5))