(import (oleg ssax)
        (scheme base)
        (scheme write))

;; XSLT helpers
(define (value-of path)
  `(xsl:value-of
    (@ (select ,path))
    ()))

(define (apply-templates name)
  `(xsl:apply-templates
    (@ (select ,name))
    ()))

(define (template name body)
  `(xsl:template (@ (match ,name)) ,body))

(define <> string-append)

(define (symbol-append a b)
  (string->symbol (string-append (symbol->string a) (symbol->string b))))

; load from file?
(define posts
  '((post ((title "example post")
           (date "April 5, 2015")
           (body "This is an example post")))
    (post ((title "example post 2")
           (date "April 5, 2015")
           (body
            "this is another post")))))


(define full-name "William Casarin")

(define data:website
  `(website
    (title "jb55.com")
    (description ,(<> full-name "'s personal webpage"))
    (posts ,posts)))

(define template:post
  (template
   "post"
   `(h1 ,(value-of "title"))))

(define template:posts
  (template
   "posts"
   `(li
     ,(apply-templates "post"))))

(define template:page
  (template
   "/website"
   `(html
     (head
      (title ,(value-of "title"))
      (description ,(value-of "description")))
     (body
      (ul
       ,(apply-templates "posts"))))))

(define xsl-stylesheet
  `((xsl:output
     (@ (method "xml")
        (indent "yes")
        (encoding "UTF-8"))
     ())
    ,template:page
    ,template:posts
    ,template:post))

(define (build-page stylesheet xml)
  `(*?* xml (@ (version "1.0"))
        (*?* xml-stylesheet (@ (type "text/xsl"))
             ,stylesheet)
        ,xml))

(define (sxml->xml tree)
  (send-reply
   (pre-post-order
    tree
    `((@ ((*default* . ,(lambda (attr-key . value) (enattr attr-key value))))
         . ,(lambda (trigger . value) (cons '@ value)))
      (html:begin
       . ,(lambda (tag title . elems)
            (list
             "Content-type: text/html"         ; HTTP headers
             nl nl                            ; two nl end the headers
             "<HTML><HEAD><TITLE>" title "</TITLE></HEAD>"
             elems
             "</HTML>")))))))

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
 (send-reply
   (pre-post-order tree
    `((@
      ((*default*
        . ,(lambda (attr-key . value) (enattr attr-key value))))
      . ,(lambda (trigger . value) (cons '@ value)))
     (*default* . ,(lambda (tag . elems) (entag tag elems)))
     (*?* . ,(lambda (pi tag . elems) (pi-entag tag elems)))
     (*text* . ,(lambda (trigger str)
		  (if (string? str) (string->goodHTML str) str)))
     ))))

(begin
 (let ((page (build-page xsl-stylesheet data:website)))
   (sxml->xml page)
   "\n"))
