// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title CollaborativeCuration - A system for community-based content evaluation
/// @notice Allows users to submit content, vote on it, and determine acceptance based on voting ratio
contract CollaborativeCuration {
    address public owner;
    uint public itemCount = 0;
    uint public submissionThreshold = 0;
    uint public acceptanceRatio = 60; // e.g., 60% upvotes required for acceptance
    uint public minVotesToEvaluate = 5; // Minimum number of votes before evaluation

    constructor() {
        owner = msg.sender;
    }

    struct Item {
        string content;
        uint upvotes;
        uint downvotes;
        address submitter;
        uint submissionTime;
        bool isAccepted;
    }

    mapping(uint => Item) private items;
    mapping(uint => mapping(address => bool)) private hasVoted;
    mapping(address => uint) public reputation;

    event ItemSubmitted(uint indexed itemId, string content, address indexed submitter);
    event ItemVoted(uint indexed itemId, address indexed voter, bool upvote);
    event ItemAccepted(uint indexed itemId, string content);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized.");
        _;
    }

    modifier meetsReputationThreshold(address _addr) {
        require(reputation[_addr] >= submissionThreshold, "Insufficient reputation to submit.");
        _;
    }

    /// @notice Submit a new item for review
    function submitItem(string memory _content) public meetsReputationThreshold(msg.sender) {
        itemCount++;
        items[itemCount] = Item({
            content: _content,
            upvotes: 0,
            downvotes: 0,
            submitter: msg.sender,
            submissionTime: block.timestamp,
            isAccepted: false
        });

        emit ItemSubmitted(itemCount, _content, msg.sender);
    }

    /// @notice Vote on an item. Each user can vote only once per item.
    function vote(uint _itemId, bool _upvote) public {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID.");
        require(!hasVoted[_itemId][msg.sender], "You have already voted on this item.");

        Item storage item = items[_itemId];
        hasVoted[_itemId][msg.sender] = true;

        if (_upvote) {
            item.upvotes++;
        } else {
            item.downvotes++;
        }

        emit ItemVoted(_itemId, msg.sender, _upvote);

        uint totalVotes = item.upvotes + item.downvotes;
        if (!item.isAccepted && totalVotes >= minVotesToEvaluate) {
            uint voteRatio = (item.upvotes * 100) / totalVotes;
            if (voteRatio >= acceptanceRatio) {
                item.isAccepted = true;
                emit ItemAccepted(_itemId, item.content);
            }
        }
    }

    /// @notice Owner can award reputation points to users
    function awardReputationForSubmission(address _user, uint _amount) public onlyOwner {
        reputation[_user] += _amount;
    }

    /// @notice Owner can update minimum reputation required to submit
    function updateSubmissionThreshold(uint _newThreshold) public onlyOwner {
        submissionThreshold = _newThreshold;
    }

    /// @notice Owner can change the vote ratio required for acceptance
    function updateAcceptanceRatio(uint _newRatio) public onlyOwner {
        require(_newRatio <= 100, "Ratio must be <= 100.");
        acceptanceRatio = _newRatio;
    }

    /// @notice Owner can change the minimum number of votes required before evaluation
    function updateMinVotesToEvaluate(uint _newMinVotes) public onlyOwner {
        minVotesToEvaluate = _newMinVotes;
    }

    /// @notice Returns details of a submitted item
    function getItem(uint _itemId) public view returns (
        string memory content,
        uint upvotes,
        uint downvotes,
        address submitter,
        uint submissionTime,
        bool isAccepted
    ) {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID.");
        Item storage item = items[_itemId];
        return (
            item.content,
            item.upvotes,
            item.downvotes,
            item.submitter,
            item.submissionTime,
            item.isAccepted
        );
    }

    /// @notice Check if a user has voted on a specific item
    function hasUserVoted(uint _itemId, address _user) public view returns (bool) {
        return hasVoted[_itemId][_user];
    }

    /// @notice Returns the reputation score of a given user
    function getUserReputation(address _user) public view returns (uint) {
        return reputation[_user];
    }
}
