// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SilverToken is ERC20 {
    event SLVRBuyEvent (
        address from,
        address to,
        uint256 amount
    );
    
    event SLVRSellEvent (
        address from,
        address to,
        uint256 amount
    );

    address private owner;
    mapping (address => uint256) pendingWithdrawals;
   
    constructor(uint256 _initialSupply) public ERC20("SilverToken", "SLVR") {
        _mint(msg.sender, _initialSupply);
        owner = msg.sender;
    }
    function buyToken(uint256 _amount) external payable {
        require(_amount == ((msg.value / 1 ether)), "Incorrect amount of Eth.");
        transferFrom(owner, msg.sender, _amount);
        emit SLVRBuyEvent(owner, msg.sender, _amount);
    }

    function sellToken(uint256 _amount) public {
        pendingWithdrawals[msg.sender] = _amount;
        transfer(owner, _amount);
        withdrawEth();
        emit SLVRSellEvent(msg.sender, owner, _amount);
    }

     function withdrawEth() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount * 1 ether);
    }
}