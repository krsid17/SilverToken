// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SilverToken is ERC20 {
    // In reality these events are not needed as the same information is included
    // in the default ERC20 Transfer event, but they serve as demonstrators
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
   
    // Initialises smart contract with supply of tokens going to the address that
    // deployed the contract.
    constructor(uint256 _initialSupply) public ERC20("SilverToken", "SLVR") {
        _mint(msg.sender, _initialSupply);
        owner = msg.sender;
    }

    // A wallet sends Eth and receives SLVR in return
    function buyToken(uint256 _amount) external payable {
        // Ensures that correct amount of Eth sent for SLVR
        // 1 ETH is set equal to 1 SLVR
        require(_amount == ((msg.value / 1 ether)), "Incorrect amount of Eth.");
        transferFrom(owner, msg.sender, _amount);
        emit SLVRBuyEvent(owner, msg.sender, _amount);
    }
    
    // A wallet sends SLVR and receives Eth in return
    function sellToken(uint256 _amount) public {
        pendingWithdrawals[msg.sender] = _amount;
        transfer(owner, _amount);
        withdrawEth();
        emit SLVRSellEvent(msg.sender, owner, _amount);
    }

    // Using the Withdraw Pattern to remove Eth from contract account when user
    // wants to return SLVR
    // https://solidity.readthedocs.io/en/latest/common-patterns.html#withdrawal-from-contracts
     function withdrawEth() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        // Pending refund zerod before to prevent re-entrancy attacks
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount * 1 ether);
    }
}