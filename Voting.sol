// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Vote {
        address voter;
        bool choice;
    }

    struct Poll {
        string question;
        Vote[] votes;
        mapping(address => bool) hasVoted;
    }

    Poll[] public polls;

    function createPoll(string memory _question) public {
        polls.push(Poll({
            question: _question,
            votes: new Vote 
        }));
    }

    function vote(uint _pollIndex, bool _choice) public {
        Poll storage poll = polls[_pollIndex];

        require(!poll.hasVoted[msg.sender], "You have already voted.");
        
        poll.votes.push(Vote({
            voter: msg.sender,
            choice: _choice
        }));
        poll.hasVoted[msg.sender] = true;
    }

    function getPoll(uint _pollIndex) public view returns (string memory question, uint yes, uint no) {
        Poll storage poll = polls[_pollIndex];
        uint yesCount = 0;
        uint noCount = 0;

        for (uint i = 0; i < poll.votes.length; i++) {
            if (poll.votes[i].choice) {
                yesCount++;
            } else {
                noCount++;
            }
        }
        return (poll.question, yesCount, noCount);
    }
}
