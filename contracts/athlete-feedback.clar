;; Athlete Feedback Contract
;; Collects and manages athlete equipment feedback

(define-constant ERR_INVALID_RATING (err u500))
(define-constant ERR_NOT_FOUND (err u501))

;; Data structure for athlete feedback
(define-map athlete-feedback
  { feedback-id: uint }
  {
    athlete: principal,
    equipment-type: (string-ascii 50),
    manufacturer-id: uint,
    rating: uint,
    comfort-rating: uint,
    performance-rating: uint,
    durability-rating: uint,
    feedback-text: (string-ascii 500),
    submission-date: uint,
    verified-athlete: bool
  }
)

(define-map verified-athletes
  { athlete: principal }
  { verified: bool, sport: (string-ascii 50) }
)

(define-data-var next-feedback-id uint u1)

;; Verify athlete
(define-public (verify-athlete (athlete principal) (sport (string-ascii 50)))
  (begin
    (map-set verified-athletes
      { athlete: athlete }
      { verified: true, sport: sport }
    )
    (ok true)
  )
)

;; Submit athlete feedback
(define-public (submit-feedback
  (equipment-type (string-ascii 50))
  (manufacturer-id uint)
  (rating uint)
  (comfort-rating uint)
  (performance-rating uint)
  (durability-rating uint)
  (feedback-text (string-ascii 500)))
  (let ((feedback-id (var-get next-feedback-id)))
    ;; Validate ratings (1-10 scale)
    (asserts! (and (>= rating u1) (<= rating u10)) ERR_INVALID_RATING)
    (asserts! (and (>= comfort-rating u1) (<= comfort-rating u10)) ERR_INVALID_RATING)
    (asserts! (and (>= performance-rating u1) (<= performance-rating u10)) ERR_INVALID_RATING)
    (asserts! (and (>= durability-rating u1) (<= durability-rating u10)) ERR_INVALID_RATING)

    (let ((is-verified (match (map-get? verified-athletes { athlete: tx-sender })
                        athlete-data (get verified athlete-data)
                        false)))
      (map-set athlete-feedback
        { feedback-id: feedback-id }
        {
          athlete: tx-sender,
          equipment-type: equipment-type,
          manufacturer-id: manufacturer-id,
          rating: rating,
          comfort-rating: comfort-rating,
          performance-rating: performance-rating,
          durability-rating: durability-rating,
          feedback-text: feedback-text,
          submission-date: block-height,
          verified-athlete: is-verified
        }
      )
      (var-set next-feedback-id (+ feedback-id u1))
      (ok feedback-id)
    )
  )
)

;; Get feedback details
(define-read-only (get-feedback (feedback-id uint))
  (map-get? athlete-feedback { feedback-id: feedback-id })
)

;; Get average rating for manufacturer (simplified)
(define-read-only (get-manufacturer-average-rating (manufacturer-id uint))
  ;; In a real implementation, this would calculate across all feedback
  ;; For simplicity, returning a placeholder
  (some u7)
)

;; Check if athlete is verified
(define-read-only (is-athlete-verified (athlete principal))
  (match (map-get? verified-athletes { athlete: athlete })
    athlete-data (get verified athlete-data)
    false
  )
)
