// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract StateMachine {
    enum State {Fundraising, Success, Failed, PaidOut}

    State public currentState = State.Fundraising;

    modifier inState(State _state) {
        require(currentState == _state, "current state can not do this");
        _;
    }

    function deposit() public inState(State.Fundraising) payable {
        currentState = State.Success;
    }

    function paidOut() public inState(State.Success) {
        currentState = State.PaidOut;
    }
}