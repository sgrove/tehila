;; Depends on list_utils for (sublist nth)
(define (read-color-at lst index)
  (sublist lst index 4))

(define (bmp-load file)
  (if (file-exists? file)
      (with-input-from-file file read-binary-file)
      (exception (string-append "File: <" file "> not found"))))

(define (bmp-data-offset data)
  (nth data 10))

(define (bmp-header data)
  (print "File data:")
  (print data)
  (sublist data 0 (bmp-data-offset data)))

(define (bmp-width data)
  (nth data 18))

(define (bmp-height data)
  (nth data 18))

(define (bmp-data data)
  (sublist data (bmp-data-offset data) (length data)))

(define (bmp-bit-depth data)
  (nth data 28))

(define (bmp-bits-per-pixel data)
  (/ (bmp-bit-depth data) 8))

; assumes vector type
(define (bmp-read-red-byte bytes)
  (vector-ref byte 0))

(define (bmp-read-green-byte bytes)
  (vector-ref byte 1))

(define (bmp-read-blue-byte bytes)
  (vector-ref byte 2))

(define (bmp-read-alpha-byte bytes)
  (vector-ref byte 3))

(define (load-bmp-texture file)
  (let* ((bmp (bmp-load file))
         (header (bmp-header bmp))
         (body (list->vector (bmp-data bmp)))
         (width (bmp-width bmp))
         (height (bmp-height bmp))
         (bit-depth (bmp-bit-depth bmp))
         (bpp (bmp-bits-per-pixel bmp))
         (buffer-length (* bpp width height))
         (buffer (make-u8vector buffer-length 0))
         (counter 0))
    ;; (print (string-append "File-length: " (number->string (length bmp))))
    ;; (print (string-append "BPP: " (number->string bit-depth)))
    ;; (print (string-append "body-length: " (number->string (vector-length body))))
    ;; (print (string-append "buffered: " (number->string buffer-length)))
    ;; (print (string-append "WxH: " (number->string width) "x" (number->string height)))
    ;; (print (string-append "Offset: " (number->string (bmp-data-offset bmp))))
    ;(print (string-append "Header: " (list->string header)))
    (do ((row 0 (+ row 1))) ((> row (- height 1)) buffer)
      (print (string-append "New Row: " (number->string row)))
      (do ((column 3 (+ column bpp))) ((> column (* width bpp)))
        (print (string-append "--- (" (number->string row) ", " (number->string column) ") ---"))
        (let* ((position (+ (* row width bpp) column))
               (red   (vector-ref body (- position 3)))
               (green (vector-ref body (- position 2)))
               (blue  (vector-ref body (- position 1))))

          (print (string-append (number->string counter) "-" (number->string position)))
          (u8vector-set! buffer (+ counter 0) red)
          (u8vector-set! buffer (+ counter 1) green)
          (u8vector-set! buffer (+ counter 2) blue)

          (if (equal? bpp 4)
              ;fun test for transparency
              (if (and (equal? red 0) (equal? green 0) (equal? blue 0))
                  (u8vector-set! buffer (+ counter 3) 0)
                  (u8vector-set! buffer (+ counter 3) (vector-ref body (- position 0)))))

          (u8vector-set! buffer counter (vector-ref body counter))
          ;(print (string-append (number->string counter) ". [O->N] [" (number->string (vector-ref body counter)) " -> " (number->string (u8vector-ref buffer counter)) "]"))
          (set! counter (+ counter bpp)))))
    buffer))
    ;(flip-bmp-vertically (* width 4) buffer)))    

(define (load-textures filenames type)
  (if (equal? type 'bmp)
      (begin
        (print (gl:GenTextures (length filenames) texture-handles))
        (for-each (lambda (file) (load-texture file *texture-count*) (add1 *texture-count*)) filenames))))

; works on u8vectors
; TODO: Iron out the alignment bugs
(define (flip-bmp-vertically row-width data)
  (let* ((data-size (u8vector-length data))
         (buffer (make-u8vector data-size 0))
         (height (/ data-size row-width))
         (counter 0))
    ;; (print (string-append (number->string height) " rows tall"))
    (do ((row (- height 1) (- row 1))) ((equal? row -1) buffer)
      (do ((column 0 (+ column 4))) ((equal? column row-width))
        (let ((position (+ (* row row-width) column)))
          ; beware rgb in bmp. Seems more like bgr. Fuckers. Hence the weird offsets
          (u8vector-set! buffer (+ counter 0) (u8vector-ref data (+ position 0)))
          (u8vector-set! buffer (+ counter 1) (u8vector-ref data (+ position 1)))
          (u8vector-set! buffer (+ counter 2) (u8vector-ref data (+ position 2)))
          (u8vector-set! buffer (+ counter 3) (u8vector-ref data (+ position 3))))

          ;; (print (string-append (number->string (+ (* row row-width) column)) " -> " (number->string counter))))
        (set! counter (+ counter 4))))))

; works on u8vectors
; TODO: Iron out the alignment bugs
(define (flip-bmp-horizontally row-width data)
  (let* ((data-size (u8vector-length data))
         (buffer (make-u8vector data-size 255))
         (height (/ data-size row-width))
         (counter 0))
    ;(print (string-append (number->string height) " rows tall"))
    (do ((row 0 (+ row 1))) ((equal? row height))
      (do ((column 1 (+ column 4))) ((> column row-width))
        (let ((position (+ (* row row-width) (- row-width column))))
          ; beware rgb in bmp. Seems more like bgr. Fuckers. Hence the weird offsets
          (u8vector-set! buffer (+ counter 0) (u8vector-ref data (- position 1)))
          (u8vector-set! buffer (+ counter 1) (u8vector-ref data (- position 2)))
          (u8vector-set! buffer (+ counter 2) (u8vector-ref data (- position 3)))
          (u8vector-set! buffer (+ counter 3) (u8vector-ref data (- position 0)))

          ;; (print (string-append (number->string (+ counter 0)) " = " (number->string (u8vector-ref data (- position 3))) ", Actual: [" (number->string (u8vector-ref buffer (+ counter 0)))))
          ;; (print (string-append (number->string (+ counter 1)) " = " (number->string (u8vector-ref data (- position 2))) ", Actual: [" (number->string (u8vector-ref buffer (+ counter 1)))))
          ;; (print (string-append (number->string (+ counter 2)) " = " (number->string (u8vector-ref data (- position 1))) ", Actual: [" (number->string (u8vector-ref buffer (+ counter 2)))))
          ;; (print (string-append (number->string (+ counter 3)) " = " (number->string (u8vector-ref data (- position 0))) ", Actual: [" (number->string (u8vector-ref buffer (+ counter 3)))))
          )
        (set! counter (+ counter 4))))
    buffer))

