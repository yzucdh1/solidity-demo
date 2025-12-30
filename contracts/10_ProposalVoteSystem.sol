// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ProposalVote {
    struct Proposal {
        string desc;
        uint256 voteCount;
        uint256 deadline;
        bool executed;
        mapping(address=>bool) voters;
    }

    mapping(uint256=>Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter);

    function createProposal(string memory _desc, uint256 _duration) public returns(uint256) {
        require(bytes(_desc).length > 0, "Description cannot be empty");
        require(_duration > 0, "Invalid duration");
        uint256 proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.desc = _desc;
        proposal.voteCount = 0;
        proposal.deadline = block.timestamp + _duration;
        proposal.executed = false;
        emit ProposalCreated(proposalId, _desc);
        
        return proposalId;
    }

    function vote(uint256 proposalId) public {
        require(proposalId < proposalCount, "Invalid proposalId");
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp <= proposal.deadline, "Voting period has ended");
        require(!proposal.voters[msg.sender], "You have already voted");
        proposal.voteCount += 1;
        proposal.voters[msg.sender] = true;
        emit Voted(proposalId, msg.sender);
    }

    function queryProposalInfo(uint256 proposalId) public view returns(string memory desc, uint256 voteCount, uint256 deadline, bool executed) {
        require(proposalId < proposalCount, "Invalid proposalId");
        Proposal storage proposal = proposals[proposalId];
        return (proposal.desc, proposal.voteCount, proposal.deadline, proposal.executed);
    }

    function queryWinProposal() public view returns(uint256) {
        uint256 maxProposalId = 0;
        for (uint i = 0; i < proposalCount; i++) {
            if (proposals[i].voteCount > proposals[maxProposalId].voteCount) {
                maxProposalId = i;
            }
        }
        return maxProposalId;
    }
}