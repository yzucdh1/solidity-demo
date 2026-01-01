// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VoteSystem {
    struct Proposal {
        string description;
        uint256 deadline;
        uint256 voteCount;
        mapping(address=>bool) voters;
    }

    address public immutable owner;
    uint256 public proposalCount;
    mapping(uint256=>Proposal) public proposals;

    constructor() {
        owner = msg.sender;
    }

    modifier validProposalId(uint256 proposalId) {
        require(proposalId < proposalCount, "Invalid proposalId");
        _;
    }

    event CreateProposal(string _description, uint256 _duration);
    event Vote(uint256 indexed proposalId, address indexed voter);

    function createProposal(string memory _description, uint256 _duration) public returns(uint256) {
        require(msg.sender == owner, "only owner can create proposal");
        require(_duration > 0, "duration must be greater than 0");
        require(bytes(_description).length > 0, "description must not be empty");
        uint256 proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.description = _description;
        proposal.deadline = block.timestamp + _duration;
        proposal.voteCount = 0;
        emit CreateProposal(_description, _duration);
        return proposalId;
    }

    function vote(uint256 proposalId) public validProposalId(proposalId) {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp <= proposal.deadline, "proposal has deadlined");
        require(!proposal.voters[msg.sender], "you have voted");
        proposal.voteCount++;
        proposal.voters[msg.sender] = true;
        emit Vote(proposalId, msg.sender);
    }

    function queryProposalInfo(uint256 proposalId) public validProposalId(proposalId) view returns (string memory, uint256, uint256) {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.description, proposal.deadline, proposal.voteCount);
    }

    function queryWinProposal() public view returns(uint256, uint256) {
        uint256 winProposalId = 0;
        uint256 maxVoteCount = 0;
        for (uint i = 0; i < proposalCount; i++) {
            Proposal storage proposal = proposals[i];
            if (block.timestamp <= proposal.deadline) {
                revert("proposal has not deadlined");
            }
            if (proposal.voteCount > maxVoteCount) {
                maxVoteCount = proposal.voteCount;
                winProposalId = i;
            }
        }
        return (winProposalId, maxVoteCount);
    }

}