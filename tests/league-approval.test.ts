import { describe, it, expect, beforeEach } from "vitest"

// Mock contract state
const mockContract = {
  feedback: new Map(),
  verifiedAthletes: new Map(),
  nextFeedbackId: 1,
}

function verifyAthlete(athlete, sport) {
  mockContract.verifiedAthletes.set(athlete, { verified: true, sport })
  return { ok: true }
}

function submitFeedback(
    equipmentType,
    manufacturerId,
    rating,
    comfortRating,
    performanceRating,
    durabilityRating,
    feedbackText,
    sender,
) {
  // Validate ratings (1-10 scale)
  const ratings = [rating, comfortRating, performanceRating, durabilityRating]
  for (const r of ratings) {
    if (r < 1 || r > 10) {
      return { err: 500 } // ERR_INVALID_RATING
    }
  }
  
  const feedbackId = mockContract.nextFeedbackId
  const athleteData = mockContract.verifiedAthletes.get(sender)
  const isVerified = athleteData ? athleteData.verified : false
  
  const feedback = {
    athlete: sender,
    equipmentType,
    manufacturerId,
    rating,
    comfortRating,
    performanceRating,
    durabilityRating,
    feedbackText,
    submissionDate: Date.now(),
    verifiedAthlete: isVerified,
  }
  
  mockContract.feedback.set(feedbackId, feedback)
  mockContract.nextFeedbackId++
  
  return { ok: feedbackId }
}

function getFeedback(feedbackId) {
  return mockContract.feedback.get(feedbackId) || null
}

function isAthleteVerified(athlete) {
  const athleteData = mockContract.verifiedAthletes.get(athlete)
  return athleteData ? athleteData.verified : false
}

describe("Athlete Feedback Contract", () => {
  beforeEach(() => {
    mockContract.feedback.clear()
    mockContract.verifiedAthletes.clear()
    mockContract.nextFeedbackId = 1
  })
  
  it("should verify an athlete", () => {
    const result = verifyAthlete("ST1ATHLETE", "basketball")
    expect(result.ok).toBe(true)
    
    const isVerified = isAthleteVerified("ST1ATHLETE")
    expect(isVerified).toBe(true)
  })
  
  it("should submit valid feedback", () => {
    const result = submitFeedback("basketball", 1, 8, 7, 9, 8, "Great performance, very comfortable", "ST1ATHLETE")
    
    expect(result.ok).toBe(1)
    
    const feedback = getFeedback(1)
    expect(feedback.rating).toBe(8)
    expect(feedback.equipmentType).toBe("basketball")
  })
  
  it("should reject invalid ratings", () => {
    const result = submitFeedback(
        "basketball",
        1,
        11, // Invalid rating > 10
        7,
        9,
        8,
        "Great performance",
        "ST1ATHLETE",
    )
    
    expect(result.err).toBe(500) // ERR_INVALID_RATING
  })
  
  it("should mark feedback from verified athletes", () => {
    verifyAthlete("ST1ATHLETE", "basketball")
    
    submitFeedback("basketball", 1, 8, 7, 9, 8, "Great performance", "ST1ATHLETE")
    
    const feedback = getFeedback(1)
    expect(feedback.verifiedAthlete).toBe(true)
  })
  
  it("should mark feedback from unverified athletes", () => {
    submitFeedback("basketball", 1, 8, 7, 9, 8, "Great performance", "ST1UNVERIFIED")
    
    const feedback = getFeedback(1)
    expect(feedback.verifiedAthlete).toBe(false)
  })
})
