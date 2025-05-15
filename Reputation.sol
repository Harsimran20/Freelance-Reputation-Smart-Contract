// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ReputationSystem {
    address public owner;

    struct User {
        string name;
        bool isFreelancer;
        bool registered;
    }

    struct Review {
        address client;
        uint8 rating;  // 1 to 5
        string comment;
        uint256 timestamp;
        bool flagged; // for moderation
    }

    // Mapping of users
    mapping(address => User) public users;

    // Mapping freelancer address => list of reviews
    mapping(address => Review[]) private reviews;

    // Mapping freelancer => reputation score (sum of ratings)
    mapping(address => uint256) public reputationScores;

    // Admins for moderation
    mapping(address => bool) public admins;

    // Track which client worked with which freelancer
    mapping(address => mapping(address => bool)) public workedWith;

    // Events
    event UserRegistered(address indexed user, string name, bool isFreelancer);
    event WorkConfirmed(address indexed client, address indexed freelancer);
    event ReviewSubmitted(address indexed client, address indexed freelancer, uint8 rating);
    event ReviewFlagged(address indexed admin, address indexed freelancer, uint256 reviewIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Not admin");
        _;
    }

    modifier onlyRegistered() {
        require(users[msg.sender].registered, "Not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    // Register user as freelancer or client
    function registerUser(string calldata _name, bool _isFreelancer) external {
        require(!users[msg.sender].registered, "Already registered");
        users[msg.sender] = User(_name, _isFreelancer, true);
        emit UserRegistered(msg.sender, _name, _isFreelancer);
    }

    // Confirm that a client worked with a freelancer (admin only)
    function confirmWork(address _client, address _freelancer) external onlyAdmin {
        require(users[_client].registered && !users[_client].isFreelancer, "Invalid client");
        require(users[_freelancer].registered && users[_freelancer].isFreelancer, "Invalid freelancer");
        workedWith[_client][_freelancer] = true;
        emit WorkConfirmed(_client, _freelancer);
    }

    // Submit review (only clients who worked with freelancer)
    function submitReview(address _freelancer, uint8 _rating, string calldata _comment) external onlyRegistered {
        require(!users[msg.sender].isFreelancer, "Freelancers cannot review");
        require(users[_freelancer].isFreelancer, "Invalid freelancer");
        require(workedWith[msg.sender][_freelancer], "No work relationship");
        require(_rating >= 1 && _rating <= 5, "Rating must be 1-5");

        reviews[_freelancer].push(Review(msg.sender, _rating, _comment, block.timestamp, false));
        reputationScores[_freelancer] += _rating;

        emit ReviewSubmitted(msg.sender, _freelancer, _rating);
    }

    // Admin flags a review as inappropriate
    function flagReview(address _freelancer, uint256 _reviewIndex) external onlyAdmin {
        require(_reviewIndex < reviews[_freelancer].length, "Invalid review index");
        reviews[_freelancer][_reviewIndex].flagged = true;
        emit ReviewFlagged(msg.sender, _freelancer, _reviewIndex);
    }

    // Get number of reviews for a freelancer
    function getReviewCount(address _freelancer) external view returns (uint256) {
        return reviews[_freelancer].length;
    }

    // Get a specific review for a freelancer
    function getReview(address _freelancer, uint256 _index) external view returns (
        address client,
        uint8 rating,
        string memory comment,
        uint256 timestamp,
        bool flagged
    ) {
        require(_index < reviews[_freelancer].length, "Invalid index");
        Review storage r = reviews[_freelancer][_index];
        return (r.client, r.rating, r.comment, r.timestamp, r.flagged);
    }

    // Get average reputation score of a freelancer
    function getAverageReputation(address _freelancer) external view returns (uint256) {
        uint256 count = reviews[_freelancer].length;
        if (count == 0) return 0;
        return reputationScores[_freelancer] / count;
    }

    // Owner can add or remove admins
    function setAdmin(address _admin, bool _enabled) external onlyOwner {
        admins[_admin] = _enabled;
    }
}
