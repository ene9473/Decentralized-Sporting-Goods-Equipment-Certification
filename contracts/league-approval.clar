;; League Approval Contract
;; Manages sports league equipment approvals

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_NOT_FOUND (err u401))
(define-constant ERR_ALREADY_APPROVED (err u402))

;; Data structure for league approvals
(define-map league-approvals
  { approval-id: uint }
  {
    league-name: (string-ascii 100),
    equipment-type: (string-ascii 50),
    manufacturer-id: uint,
    certification-id: uint,
    approved: bool,
    approval-date: uint,
    approver: principal,
    season: (string-ascii 20)
  }
)

(define-map league-officials
  { official: principal }
  { league-name: (string-ascii 100), authorized: bool }
)

(define-data-var next-approval-id uint u1)

;; Register league official
(define-public (register-league-official (official principal) (league-name (string-ascii 100)))
  (begin
    (map-set league-officials
      { official: official }
      { league-name: league-name, authorized: true }
    )
    (ok true)
  )
)

;; Approve equipment for league use
(define-public (approve-equipment
  (league-name (string-ascii 100))
  (equipment-type (string-ascii 50))
  (manufacturer-id uint)
  (certification-id uint)
  (season (string-ascii 20)))
  (let ((approval-id (var-get next-approval-id)))
    ;; Check if sender is authorized league official
    (match (map-get? league-officials { official: tx-sender })
      official-data
      (begin
        (asserts! (get authorized official-data) ERR_UNAUTHORIZED)
        (map-set league-approvals
          { approval-id: approval-id }
          {
            league-name: league-name,
            equipment-type: equipment-type,
            manufacturer-id: manufacturer-id,
            certification-id: certification-id,
            approved: true,
            approval-date: block-height,
            approver: tx-sender,
            season: season
          }
        )
        (var-set next-approval-id (+ approval-id u1))
        (ok approval-id)
      )
      ERR_UNAUTHORIZED
    )
  )
)

;; Revoke equipment approval
(define-public (revoke-approval (approval-id uint))
  (match (map-get? league-approvals { approval-id: approval-id })
    approval-data
    (begin
      ;; Check if sender is the original approver or authorized official
      (match (map-get? league-officials { official: tx-sender })
        official-data
        (begin
          (asserts! (get authorized official-data) ERR_UNAUTHORIZED)
          (map-set league-approvals
            { approval-id: approval-id }
            (merge approval-data { approved: false })
          )
          (ok true)
        )
        ERR_UNAUTHORIZED
      )
    )
    ERR_NOT_FOUND
  )
)

;; Get approval details
(define-read-only (get-approval (approval-id uint))
  (map-get? league-approvals { approval-id: approval-id })
)

;; Check if equipment is approved for league
(define-read-only (is-equipment-approved (approval-id uint))
  (match (map-get? league-approvals { approval-id: approval-id })
    approval-data (get approved approval-data)
    false
  )
)
