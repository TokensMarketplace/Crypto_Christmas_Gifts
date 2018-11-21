# README v1.0 * 2018.10.20.

# ChristmasPresents.sol V1.0

# Introduction
ChristmasPresents.sol is a smart-contract that anables loterry competition on Ethereum blockhain. Competitors send their ETH in order to compete and contract sends them 
a package of random amounts of ERC20 tokens as a reward. They also get their unique ticket ID which makes them eligible for one of the three main prizes. 
After compentition ends, on 24th of Dec.2018., the contract generates three random IDs that correspond to competitors' addresses and choses the winners. 
Total amount of fee equals to 10% of collected ETH, third winner gets 10% of the rest, second gets 30% and the main winner gets 60% of ETH.  

## Table of Contents (TOC) 
* Usage
* Requirements (prerequest)
* Configuration
* Deployment
* Running the tests

# Usage
There are 4 public functions and a constructor within the contract. All functions are used for interaction with the contract.  
Non-constant functions are:  
* `changeAvailableTokensAndAmounts` - can be called only by admins and is used to allow specified token to be an award. Parameters are: 1. list of tokens' addresses, 2. list of amounts for each token.
* `collectFee` - can be called only by admins and is used to transfer fees from the contract to caller's address. There are no parameters for this function.
* `executeLoterry` - can be called only by admins. Draws the winners of the loterry and sends them awards in ETH. There are no parameters for this function.
* `fallback` - triggered when someone sends ETH to contract's address. Can be called by anyone and registers the sender for the loterry, and sends him automatically the gift of random amount of ERC20 tokens.  


# Requirements (prerequest)
In order to deploy the contract, one must have the other one - StandardToken.sol within the same location, as ChristmasPresents.sol uses the previous one's interface.

# Configuration
Configuration consists of admins changing the list of tokens and their amounts that are to be awarded for every ticket made. That is done by `changeAvailableTokensAndAmunts` function call, as many times as wished.

# Deployment
While deploying the contract, one must specify the list of ethereum addresses that will have admin authorization. Timestamp of loterry end must also be specified together with the list of tokens and their maximum amounts available for awards. Other than that, there are no paramteres. 
Admins' addresses are set just once during deployment, and cannot be changed afterward.

### Running the tests
All functions can be tested on Kovan test network properly.

### Credits (authors)
GVISP1 Team

### Contact
office@gvisp.com

# License
This project is licensed under GPL3, https://www.gnu.org/licenses/gpl-3.0.en.html The license should be in a separate file called LICENSE.
