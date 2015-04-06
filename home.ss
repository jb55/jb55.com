(import (scheme base)
;        (oleg ssax)
        (scheme write))

;; XSLT helpers
(define (value-of path)
  `(xsl:value-of (@ (select ,path))))

(define (apply-templates name)
  `(xsl:apply-templates
    (@ (select ,name))))

(define (template name body)
  `(xsl:template (@ (match ,name)) ,body))

(define <> string-append)

; load from file?
(define posts
  '(((title "example post")
     (date "April 5, 2015")
     (body
      "This is an example post"))
    ((title "example post 2")
     (date "April 5, 2015")
     (body
      "this is another post"))))

(define full-name "William Casarin")

(define (data:website name)
  `(website
    (title "jb55.com")
    (description ,(<> name "'s personal webpage"))
    (posts ,posts)))

(define template:post
  (template "post"
            `(h1 ,(value-of "title"))))

(define template:posts
  (template "posts"
            `(li
              ,(apply-templates "post"))))

(define template:page
  (template "/website"
            `(html
              (head
               (title ,(value-of "title"))
               (description ,(value-of "description")))
              (body
               (ul
                ,(apply-templates "posts"))))))

(define template:top
  `((xsl:output
     (@ (method "xml")
        (indent "yes")
        (encoding "UTF-8")))
    ,template:page
    ,template:posts
    ,template:post))

(display template:top)
