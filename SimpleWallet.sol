// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./Allowance.sol";

contract SimpleWallet is Allowance {
    constructor(address initialOwner) Allowance(initialOwner) {}

    event MoneySent(address _beneficiary, uint _amount);
    event MoneyRecived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint256 _amount) public ownerOrAlowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(msg.sender != owner()){
            reduceAllowance(msg.sender, _amount);
        }

        emit MoneySent(_to, _amount);

        _to.transfer(_amount);
    }

    function renounceOwnership() public override(Ownable) onlyOwner{
        revert("Cant renouce ownership here");
    }

    // To accept plain Ether transfers (no data)
    receive() external payable {
        emit MoneyRecived(msg.sender, msg.value);
    }
 
    // To handle calls with data that don’t match any function
    // fallback() external payable {}
}

