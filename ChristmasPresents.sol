pragma solidity ^0.4.16;

import "./StandardToken.sol";

contract ChristmasPresents {

  // Timestamp of the moment when lottery ends
  uint public timestamp;
  // Total amount of collected fee
  uint public totalFee;
  // Remembers whether an address is an admin
  mapping (address => bool) public admins;
  // List of available ERC20 tokens
  address[] public availableTokens;
  // Remembers the maximum amount of each token
  mapping (address => uint) public maxAmountsOfTokens;

  // Maps contenstant's address to the list of his tickets' ids
  // Tickets' ids start from 0 !!!
  // For front-end purposes
  mapping (address => uint[]) public tickets;
  // Maps each id to a contestant
  mapping (uint => address) public contestants;

  // Number of tickets
  uint public numOfTickets;
  // Nonce for random generator
  uint nonce;

  // Total loterry summ
  uint public totalLoterrySumm;

  // For front-end purposes
  // Will change after loterry executes
  address public winner1;
  address public winner2;
  address public winner3;


  // After deployment, tokens must actually be sent to the contract
  function ChristmasPresents(
    uint _timestamp,
    address[] _admins,
    address[] _availableTokens,
    uint[] _maxAmountsOfTokens
  ) public {
    require(_availableTokens.length == _maxAmountsOfTokens.length);
    require(now < _timestamp);
    timestamp = _timestamp;
    for(uint i = 0; i < _admins.length; i++) {
      admins[_admins[i]] = true;
    }
    availableTokens = _availableTokens;
    for(uint j = 0; j < _maxAmountsOfTokens.length; j++) {
      maxAmountsOfTokens[_availableTokens[j]] = _maxAmountsOfTokens[j];
    }
  }

  function random(uint _interval) internal returns(uint) {
    return uint(keccak256(now, msg.sender, nonce)) % _interval;
  }

  function () public payable {
    // Can be called only during loterry period
    require(now < timestamp);
    // Must be greater than 0.1 ETH
    require(msg.value >= 100000000000000000);
    totalLoterrySumm += 90000000000000000;
    totalFee += msg.value - 90000000000000000;

    for(uint i = 0; i < availableTokens.length; i++) {
      uint rand = random(maxAmountsOfTokens[availableTokens[i]]);
      nonce += 1;
      if (TokenERC20(availableTokens[i]).balanceOf(this) > rand) {
        TokenERC20(availableTokens[i]).transfer(msg.sender, rand);
      }
    }

    tickets[msg.sender].push(numOfTickets);
    contestants[numOfTickets] = msg.sender;
    numOfTickets += 1;
  }


  // Changes the list of available tokens and maximum amounts
  function changeAvailableTokensAndMaxAmounts(
    address[] _availableTokens,
    uint[] _maxAmountsOfTokens
  ) public {
    require(admins[msg.sender]);
    require(_availableTokens.length == _maxAmountsOfTokens.length);
    availableTokens = _availableTokens;
    for(uint i = 0; i < _availableTokens.length; i++) {
      maxAmountsOfTokens[_availableTokens[i]] = _maxAmountsOfTokens[i];
    }
  }

  // Transfers fee to admin's address
  function collectFee() public payable {
    require(admins[msg.sender]);
    msg.sender.transfer(totalFee);
    totalFee = 0;
  }

  // Loterry execution
  function executeLoterry() public payable {
    require(now > timestamp);
    // Fee must be collected before function call
    require(totalFee == 0);
    require(admins[msg.sender]);
    // Number of tickets must be greater than 3! Make sure of it!
    require(numOfTickets > 3);
    uint randId1 = random(numOfTickets);
    nonce += 1;
    uint randId2 = random(numOfTickets);
    nonce += 1;
    uint randId3 = random(numOfTickets);
    nonce += 1;
    
    winner1 = contestants[randId1];
    winner2 = contestants[randId2];
    winner3 = contestants[randId3];

    uint prize1 = (this.balance * 6) / 10;
    uint prize2 = (this.balance * 3) / 10;
    winner1.transfer(prize1);
    winner2.transfer(prize2);
    // Transfers the remaining ETH, equals 10% of initial balance
    winner3.transfer(this.balance);
  }

  function withdrawTokens(address _tokenAddress) public {
    require(admins[msg.sender]);
    uint toSend = TokenERC20(_tokenAddress).balanceOf(this);
    TokenERC20(_tokenAddress).transfer(msg.sender, toSend);
  }

  function getNumberOfTickets(address _owner) constant returns (uint) {
    return tickets[_owner].length;
  }

}
