pragma solidity ^0.4.18;

contract governed{
  address public governor;
  mapping(address => bool) administrator;

  function governed() public{
    governor = msg.sender;
  }

  function transferGovernship(address _newGovernor) public onlyGovernor{
    governor = _newGovernor;
  }

  function appointAdministrator(address _newAdmin, bool _adminRights) public onlyGovernor{
    administrator[_newAdmin] = _adminRights;
  }

  modifier onlyGovernor{
    require(msg.sender == governor);
    _;
  }

  modifier onlyAdministrator{
    require(administrator[msg.sender] || governor == msg.sender);
    _;
  }
}

contract SimpleVote is governed{
  string public pollQuestion;
  uint256 public totalNumberOfVotes;
  uint256 temporaryPositiveResponse;
  uint256 temporaryNegativeResponse;
  uint256 public finalPositiveResponse;
  uint256 public finalNegativeResponse;
  string public finalResult;
  string public notice;

  mapping(address => bool) public hasVoted;

  function SimpleVote(string _pollQuestion) public{
    pollQuestion = _pollQuestion;
    totalNumberOfVotes = 0;
    temporaryNegativeResponse = 0;
    temporaryPositiveResponse = 0;
    finalNegativeResponse = 0;
    finalPositiveResponse = 0;
  }

  function vote(bool approve) public{
    require(!hasVoted[msg.sender]);
    if(approve){
      temporaryPositiveResponse += 1;
      hasVoted[msg.sender] = true;
      totalNumberOfVotes += 1;
    }
    else if(!approve){
      temporaryNegativeResponse += 1;
      hasVoted[msg.sender] = true;
      totalNumberOfVotes += 1;
    }
    else{
      revert();
        }
  }

  function endVote() public onlyGovernor{
    finalPositiveResponse = temporaryPositiveResponse;
    finalNegativeResponse = temporaryNegativeResponse;
    if(finalNegativeResponse > finalPositiveResponse){
      finalResult = "Denied!";
    }
    else if(finalPositiveResponse > finalNegativeResponse){
      finalResult = "Approved!";
    }
    else if(finalPositiveResponse == finalNegativeResponse){
        finalResult = "Draw!";
    }
  }

  function writeNotice(string _notice) public onlyAdministrator{
    notice = _notice;
  }
}
