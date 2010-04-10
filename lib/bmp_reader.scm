(load "list_utils.scm")
(load "binary_utils.scm")
(load "image_utils.scm")

(set! data (load-bmp "example.bmp"))

;(print data)
(set! *offset* (nth data 10))
(set! *width* (nth data 18))
(set! *height* (nth data 22))

(print (string-append "example.bmp" " is "
                      (number->string *width*) "x"
                      (number->string *height*) ", and bmp data starts at "
                      (number->string *offset*)))

(do ((i *offset* (+ i 4)))
    ((> i (+ *offset* (* *width* *height*))))
  (print (string-append (number->string i) " -> "
                        (reduce string-append "" (map (lambda (x) (string-append (number->string x) ", ")) (read-color-at data i))))))
(exit)
