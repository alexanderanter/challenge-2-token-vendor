pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Vendor is Ownable{
  using SafeMath for uint256;

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

  
  // function sellTokens(uint256 amount) public {
  //   //approve the venodor contracts to spend tokens
  //   console.log(amount, "amount");
  //   console.log(address(this), "address this");
  
  //   yourToken.transferFrom(msg.sender, address(this), amount);

  //   uint256 amountToWithdraw = amount / 100;
  //   console.log(amountToWithdraw);

  //   (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
  //   require( success, "FAILEDD");

  // }


    function sellTokens(uint256 amount) public {
      require(amount > 0, "Specify the amount you want to sell");
      // require(yourToken.balanceOf(msg.sender) >= amount, "You do not have enough tokens to sell");
      
      require(
          yourToken.allowance(msg.sender, address(this)) >= amount,
          "Token allowance too low"
      );
      _safeTransferFrom(yourToken, msg.sender, address(this), amount);
  }

  function _safeTransferFrom(
      IERC20 token,
      address sender,
      address recipient,
      uint amount
  ) private {
      bool sent = token.transferFrom(sender, recipient, amount);
      require(sent, "Token transfer failed");
  }



 
  // function approveTokens(uint256 amount) public {
  //   yourToken.approve(address(this), amount);
  // }
    function withdraw() public onlyOwner {

      (bool success, ) = msg.sender.call{value: address(this).balance}("");
      require( success, "FAILED");

    
  }
}
