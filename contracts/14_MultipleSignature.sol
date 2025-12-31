// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MultipleSignature {
    struct Proposal {
        string description;
        uint256 threshold;
        uint256 confirmCount;
        bool executed;
        mapping(address=>bool) confirmers;
    }

    mapping(uint256=>Proposal) public proposals;
    uint256 public proposalCount;

    event SubmitProposal(string _description, uint256 _threshold);
    event Confirm(address indexed _confirm);

    modifier descNotEmpty(string memory _desc) {
        require(bytes(_desc).length > 0, "description can not empty");
        _;
    }

    modifier thresholdInvalid(uint256 _threshold) {
        require(_threshold > 0, "threshold must greater than zero");
        _;
    }

    function submitProposal(string memory _description, uint256 _threshold) public descNotEmpty(_description) thresholdInvalid(_threshold) returns(uint256) {
        uint256 id = proposalCount++;
        Proposal storage proposal = proposals[id];
        proposal.description = _description;
        proposal.threshold = _threshold;
        proposal.confirmCount = 0;
        proposal.executed = false;
        emit SubmitProposal(_description, _threshold);
        return id;
    }

    function confirm(uint256 _id) public {
        require(_id < proposalCount, "Invalid proposalId");
        Proposal storage proposal = proposals[_id];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.confirmCount < proposal.threshold, "Proposal already confirmed");
        require(!proposal.confirmers[msg.sender], "you have confirmed");
        proposal.confirmCount += 1;
        proposal.confirmers[msg.sender] = true;
        if (proposal.confirmCount >= proposal.threshold) {
            proposal.executed = true;
        }
        emit Confirm(msg.sender);
    }

}