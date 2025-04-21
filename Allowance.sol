// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol";

contract Allowance is Ownable{
    constructor(address initialOwner) Ownable(initialOwner) {}

    using Math for uint;

    event AllowanceChanged(address indexed  _forWho, address indexed _fromWho, uint _oldAccount, uint _newAccount);

    mapping (address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAlowed(uint _amount) {
        require(msg.sender == owner() || allowance[msg.sender] >= _amount, "You are not allowed") ;
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        (bool success, uint newAmount) = allowance[_who].trySub(_amount);
        require(success, "Allowance underflow");

        emit AllowanceChanged(_who,msg.sender, allowance[_who], newAmount);
        allowance[_who] = newAmount;
    }
}
