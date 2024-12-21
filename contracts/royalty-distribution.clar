;; Royalty Distribution Contract

(define-map royalty-payments
  { license-id: uint, payment-id: uint }
  {
    amount: uint,
    paid-at: uint,
    recipient: principal
  }
)

(define-data-var payment-id-nonce uint u0)

(define-public (pay-royalty (license-id uint) (amount uint) (recipient principal))
  (let
    ((payment-id (+ (var-get payment-id-nonce) u1)))
    (try! (stx-transfer? amount tx-sender recipient))
    (map-set royalty-payments
      { license-id: license-id, payment-id: payment-id }
      { amount: amount, paid-at: block-height, recipient: recipient }
    )
    (var-set payment-id-nonce payment-id)
    (ok payment-id)
  )
)

(define-read-only (get-royalty-payment (license-id uint) (payment-id uint))
  (ok (unwrap! (map-get? royalty-payments { license-id: license-id, payment-id: payment-id }) (err u404)))
)

(define-read-only (get-total-royalties (license-id uint))
  (ok u0) ;; Placeholder: actual implementation would require iterating over all payments
)

