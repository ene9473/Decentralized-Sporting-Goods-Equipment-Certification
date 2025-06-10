# Decentralized Sporting Goods Equipment Certification

A blockchain-based system for certifying and validating sporting goods equipment using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a transparent, decentralized platform for:
- Manufacturer verification and registration
- Safety certification of sporting equipment
- Performance testing and validation
- League approval management
- Athlete feedback collection

## Smart Contracts

### 1. Manufacturer Verification (`manufacturer-verification.clar`)
Manages the registration and verification of sporting goods manufacturers.

**Key Functions:**
- \`register-manufacturer\`: Register a new manufacturer
- \`verify-manufacturer\`: Verify a manufacturer (owner only)
- \`get-manufacturer\`: Retrieve manufacturer details
- \`is-manufacturer-verified\`: Check verification status

### 2. Safety Certification (`safety-certification.clar`)
Handles safety certifications for sporting equipment.

**Key Functions:**
- \`issue-safety-certification\`: Issue new safety certification
- \`revoke-certification\`: Revoke existing certification
- \`get-certification\`: Get certification details
- \`is-certification-valid\`: Check if certification is valid and not expired

### 3. Performance Testing (`performance-testing.clar`)
Manages performance test results for sporting equipment.

**Key Functions:**
- \`record-performance-test\`: Record new performance test results
- \`get-performance-test\`: Retrieve test details
- \`get-performance-percentage\`: Calculate performance percentage

### 4. League Approval (`league-approval.clar`)
Manages sports league equipment approvals.

**Key Functions:**
- \`register-league-official\`: Register authorized league officials
- \`approve-equipment\`: Approve equipment for league use
- \`revoke-approval\`: Revoke equipment approval
- \`is-equipment-approved\`: Check approval status

### 5. Athlete Feedback (`athlete-feedback.clar`)
Collects and manages athlete equipment feedback.

**Key Functions:**
- \`verify-athlete\`: Verify athlete status
- \`submit-feedback\`: Submit equipment feedback with ratings
- \`get-feedback\`: Retrieve feedback details
- \`is-athlete-verified\`: Check athlete verification status

## Features

### Transparency
- All certifications and approvals are recorded on-chain
- Public verification of manufacturer credentials
- Transparent performance testing results

### Trust & Verification
- Multi-level verification system
- Verified athlete feedback system
- League official authorization

### Comprehensive Rating System
- Overall equipment rating (1-10 scale)
- Comfort, performance, and durability sub-ratings
- Detailed feedback text from athletes

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for running tests

### Installation

1. Clone the repository
2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks blockchain:
\`\`\`bash
clarinet deploy
\`\`\`

## Usage Examples

### Register a Manufacturer
\`\`\`clarity
(contract-call? .manufacturer-verification register-manufacturer "SportsCorp Inc" "123 Sports Ave")
\`\`\`

### Issue Safety Certification
\`\`\`clarity
(contract-call? .safety-certification issue-safety-certification "helmet" u1 "ANSI Z90.1" u1000000)
\`\`\`

### Submit Athlete Feedback
\`\`\`clarity
(contract-call? .athlete-feedback submit-feedback "basketball" u1 u8 u7 u9 u8 "Excellent grip and bounce")
\`\`\`

## Testing

The project includes comprehensive tests using Vitest:

- \`manufacturer-verification.test.js\`: Tests manufacturer registration and verification
- \`safety-certification.test.js\`: Tests safety certification issuance and validation
- \`athlete-feedback.test.js\`: Tests athlete feedback submission and verification

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Contract Architecture

The system uses a modular approach with separate contracts for each major function:

1. **Manufacturer Verification**: Foundation layer for manufacturer trust
2. **Safety Certification**: Ensures equipment meets safety standards
3. **Performance Testing**: Validates equipment performance metrics
4. **League Approval**: Manages official league endorsements
5. **Athlete Feedback**: Collects real-world usage data

## Security Considerations

- Owner-only functions for critical operations
- Input validation for all user-submitted data
- Expiration dates for time-sensitive certifications
- Verification requirements for sensitive operations

## Future Enhancements

- Integration with IoT devices for automated testing
- Multi-signature approvals for high-value certifications
- Reputation scoring system for manufacturers
- Integration with supply chain tracking
- Mobile app for athlete feedback submission

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
