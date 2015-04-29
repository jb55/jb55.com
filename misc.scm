
(define (pi-entag tag elems)
  (if (and (pair? elems)
           (pair? (car elems))
           (eq? '@ (caar elems)))
      (list #\newline #\< '? tag (cdar elems) '? #\>
            (and (pair? (cdr elems))
                 (list (cdr elems) "</" tag #\>)))
      (list #\newline #\< '? tag '? #\>
            (and (pair? elems)
                 (list elems "</" tag #\>)))))

(define (sxml->xml tree)
  (pre-post-order
   tree
   `((@
      ((*default*
        . ,(lambda (attr-key . value) (enattr attr-key value))))
      . ,(lambda (trigger . value) (cons '@ value)))
     (*default* . ,(lambda (tag . elems) (entag tag elems)))
     (*?* . ,(lambda (pi tag . elems) (pi-entag tag elems)))
     (*text* . ,(lambda (trigger str)
                  (if (string? str) (string->goodHTML str) str)))
     )))

(define <> string-append)

(define (symbol-append a b)
  (string->symbol (string-append (symbol->string a) (symbol->string b))))

(define (@. v)
  `(@ (class ,v)))

(define xml-header
  `(*?* xml (@ (version "1.0"))))

(define (val? val defv)
  (cond
   ((null? val) defv)
   (else val)))

(define (dl-elem title contents)
  `((dt ,(@. title) ,title)
    (dd ,contents)))

(define (make-link prefix field)
  `(a ,(attribute "href" `((*text* ,prefix)
                           ,(value-of field)))
      ,(value-of field)))
