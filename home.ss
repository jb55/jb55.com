(import (scheme base)
        (scheme write))

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

(define (template name body)
  `(xsl:template
    (@ (match name))
    (body))

  (define full-name "William Casarin"))

(define (data:website name)
  `(website
    (title "jb55.com")
    (description ,(<> name "'s personal webpage"))
    (posts ,posts)))

(define (page contents)
  (lambda (get)
    `(html
      (head
       (title ,(get "/website/title"))
       (description ,(get "/website/description")))
      (body
       ,(contents)))))

(display posts)
