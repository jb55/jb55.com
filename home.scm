(import (oleg ssax)
        (scheme base)
        (scheme file)
        (scheme write))

(include "misc.scm")
(include "xslt.scm")

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
  `(,xml-header
    (xsl:stylesheet (@ (version "1.0")
                       (xmlns:xsl "http://www.w3.org/1999/XSL/Transform"))
                    ,template:page
                    ,template:posts
                    ,template:post)))

(define (build-page stylesheet-uri xml)
  `(,xml-header
    (*?* xml-stylesheet (@ (type "text/xsl")
                           (href ,stylesheet-uri)))
    ,xml))

(begin
  (let* ((xsl-uri "style.xsl")
         (page (sxml->xml (build-page xsl-uri data:website)))
         (xsl-page (sxml->xml xsl-stylesheet)))
    (call-with-output-file xsl-uri
      (lambda (out)
        (send-reply out xsl-page)))
    (send-reply (current-output-port) page)))
