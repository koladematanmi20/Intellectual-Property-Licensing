;; Fractional Ownership Contract

(define-fungible-token fraction-token)

(define-map token-fractions
  { token-id: uint }
  { total-fractions: uint }
)

(define-map fraction-owners
  { token-id: uint, owner: principal }
  { fraction-amount: uint }
)

(define-public (create-fractions (token-id uint) (total-fractions uint))
  (let
    (
      (existing-fractions (default-to { total-fractions: u0 } (map-get? token-fractions { token-id: token-id })))
    )
    (asserts! (is-eq (get total-fractions existing-fractions) u0) (err u403))
    (try! (ft-mint? fraction-token total-fractions tx-sender))
    (map-set token-fractions
      { token-id: token-id }
      { total-fractions: total-fractions }
    )
    (map-set fraction-owners
      { token-id: token-id, owner: tx-sender }
      { fraction-amount: total-fractions }
    )
    (ok true)
  )
)

(define-public (transfer-fractions (token-id uint) (amount uint) (recipient principal))
  (let
    (
      (sender-balance (default-to { fraction-amount: u0 } (map-get? fraction-owners { token-id: token-id, owner: tx-sender })))
      (recipient-balance (default-to { fraction-amount: u0 } (map-get? fraction-owners { token-id: token-id, owner: recipient })))
    )
    (asserts! (>= (get fraction-amount sender-balance) amount) (err u401))
    (try! (ft-transfer? fraction-token amount tx-sender recipient))
    (map-set fraction-owners
      { token-id: token-id, owner: tx-sender }
      { fraction-amount: (- (get fraction-amount sender-balance) amount) }
    )
    (map-set fraction-owners
      { token-id: token-id, owner: recipient }
      { fraction-amount: (+ (get fraction-amount recipient-balance) amount) }
    )
    (ok true)
  )
)

(define-read-only (get-fraction-balance (token-id uint) (owner principal))
  (default-to { fraction-amount: u0 } (map-get? fraction-owners { token-id: token-id, owner: owner }))
)

(define-read-only (get-total-fractions (token-id uint))
  (default-to { total-fractions: u0 } (map-get? token-fractions { token-id: token-id }))
)

