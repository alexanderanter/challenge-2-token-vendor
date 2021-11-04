pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable{

  YourToken yourToken;

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable {
    uint tokensPurchased = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, tokensPurchased);

    emit BuyTokens(msg.sender, msg.value, tokensPurchased);

  }

  
  function sellTokens(uint256 amount) public {
    //approve the venodor contracts to spend tokens
    console.log(amount, "amount");
    console.log(address(this), "address this");
    yourToken.approve(address(this), amount);
    yourToken.transfer(address(this), amount);

    uint256 amountToWithdraw = amount / 100;
    console.log(amountToWithdraw);

    (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
    require( success, "FAILEDD");

  }
 
  function withdraw() public onlyOwner {

    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require( success, "FAILED");

  
}
}
