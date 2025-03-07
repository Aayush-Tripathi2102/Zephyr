
pragma solidity ^0.8.20;

contract CreditScoreManager {

    struct CreditProfile {
        uint256 score;
        uint256 totalLoans;
        uint256 successfulLoans;
        uint256 defaultedLoans;
        uint256 lastUpdateTimestamp;
    }


    mapping(address => CreditProfile) public userCreditProfiles;


    uint256 public constant BASE_SCORE = 500;
    uint256 public constant MAX_SCORE = 850;
    uint256 public constant MIN_SCORE = 300;


    event CreditScoreUpdated(address indexed user, uint256 newScore);
    event LoanHistoryRecorded(address indexed user, bool isSuccessful);


    function recordLoanInitiation(address user) external {
        CreditProfile storage profile = userCreditProfiles[user];
        profile.totalLoans++;
        profile.lastUpdateTimestamp = block.timestamp;
    }


    function recordLoanRepayment(
        address user, 
        bool isSuccessful
    ) external {
        CreditProfile storage profile = userCreditProfiles[user];
        
        if (isSuccessful) {
            profile.successfulLoans++;
        
            profile.score = _incrementScore(profile.score);
        } else {
            profile.defaultedLoans++;
        
            profile.score = _decrementScore(profile.score);
        }

        profile.lastUpdateTimestamp = block.timestamp;
        
        emit LoanHistoryRecorded(user, isSuccessful);
        emit CreditScoreUpdated(user, profile.score);
    }


    function calculateInterestRateMultiplier(
        address user
    ) public view returns (uint256) {
        uint256 score = userCreditProfiles[user].score;
        
    
        if (score >= 750) return 100;
        if (score >= 700) return 110;
        if (score >= 650) return 120;
        if (score >= 600) return 130;
        if (score >= 550) return 140;
        
        return 150;
    }


    function _incrementScore(uint256 currentScore) internal pure returns (uint256) {
        return currentScore + 10 > MAX_SCORE ? MAX_SCORE : currentScore + 10;
    }


    function _decrementScore(uint256 currentScore) internal pure returns (uint256) {
        return currentScore - 20 < MIN_SCORE ? MIN_SCORE : currentScore - 20;
    }


    function getUserCreditScore(address user) external view returns (uint256) {
        return userCreditProfiles[user].score;
    }


    function initializeCreditProfile(address user) external {
        require(userCreditProfiles[user].score == 0, "Profile already exists");
        userCreditProfiles[user].score = BASE_SCORE;
        userCreditProfiles[user].lastUpdateTimestamp = block.timestamp;
    }
}