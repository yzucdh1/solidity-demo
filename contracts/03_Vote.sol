// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VoteSystem {
    enum Vote{Yes, No, Abstain}

    mapping(address=>Vote) votes;
    mapping(address=>bool) hasVoted;
    uint yesCount;
    uint noCount;
    uint abstainCount;

    event Voted(address indexed voter, Vote vote);

    function vote(Vote _vote) public {
        require(!hasVoted[msg.sender], "You have voted");
        votes[msg.sender] = _vote;
        hasVoted[msg.sender] = true;
        if(Vote.Yes == _vote) {
            yesCount += 1;
        } else if (Vote.No == _vote) {
            noCount += 1;
        } else {
            abstainCount += 1;
        }
        emit Voted(msg.sender, _vote);
    }

    function getMyVote() public view returns (Vote) {
        require(hasVoted[msg.sender], "You have not voted");
        return votes[msg.sender];
    }

    function getCount() public view returns (uint, uint, uint) {
        return (yesCount, noCount, abstainCount);
    }
}