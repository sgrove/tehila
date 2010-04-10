(define-syntax ez-debug (syntax-rules () ((_ var) (print 'var ": "
           var))))

(define-syntax with-gl
  (lambda (exp rename compare)
    (let ((body (cdr exp)))
      (print "1")
      `(print ,@body)
      (print "2"))))

(with-gl
 (print "body!"))

(print "finish")
(exit)
