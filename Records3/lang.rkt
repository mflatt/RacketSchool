#lang racket

(provide
 (rename-out
  [top-interaction #%top-interaction]
  [module-begin    #%module-begin]))

;; ---------------------------------------------------------------------------------------------------
;; dependencies

(require "../private/mystery.rkt"
         (for-syntax "lang/reader.rkt")
         (for-syntax syntax/parse)
         redex/reduction-semantics)

;; ---------------------------------------------------------------------------------------------------
;; implmenetation

(define-syntax (top-interaction stx)
  (syntax-case stx ()
    [(_ . e)
     #`(#%top-interaction . (run records3 (prog ,@ #,dw e)))]))

(define-syntax (module-begin stx)
  (syntax-parse stx
    [(_ id:id e ...) ;; the id is added by the reader (see reader.rkt) 
     #`(#%module-begin
        (define id
          (filter (redex-match? record-lang-3 (defun (x_1 x_2) e_1)) (term (e ...))))
        (run records3 (prog e ...)))]))

