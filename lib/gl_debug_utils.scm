(require-extension srfi-1)

;; hijack old functions
(define-syntax wrap-in-debugger
  (lambda (form rename compare)
    (let* ((function (car (cdr form)))
           (function-string (symbol->string function))
           (fname (string-append "debug-" (symbol->string function))))
      `(begin
         (define ,(string->symbol fname) ,function)
         (define (,function . args)
           (print (string-append ,function-string " (" (string-append (fold (lambda (x b) (string-append b ", " (number->string x))) "" args) ")")))
           (apply ,(string->symbol fname) args))))))

(wrap-in-debugger gl:Translated)
(wrap-in-debugger gl:Rotated)
(wrap-in-debugger gl:Translatef)
(wrap-in-debugger gl:Rotatef)
