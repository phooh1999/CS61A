(define (curry-cook formals body)
    (if (Pair? (cdr formals)) `(lambda (,(car formals)) ,(curry-cook (cdr formals) body))
        `(lambda ,formals ,body))
)

(define (curry-consume curry args)
    (if (Pair? args)
        (curry-consume (curry (car args)) (cdr args))
        curry
    )
)

(define-macro (switch expr options)
    (switch-to-cond (list 'switch expr options))
)

(define (switch-to-cond switch-expr)
  (cons 'cond
    (map
      (lambda (option) (cons (append `(equal? ,(car (cdr switch-expr))) (list (car option))) (cdr option)))
      (car (cdr (cdr switch-expr))))))
