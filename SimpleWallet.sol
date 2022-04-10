pragma solidity ^0.5.13;
import "./Allowance.sol";

contract SimpleWallet is Allowance{

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    modifier OwnerOrAllowed(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed" );
        _;
    }

    function withdrawMoney(address payable _to, uint _amount) OwnerOrAllowed(_amount) public{
        require(_amount <= address(this).balance , "There are not enough funds stored in smart contract" );
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public onlyOwner{
        revert("Can't renounce ownership here");
    }

    function() external payable   {
       emit MoneyReceived(msg.sender, msg.value);
    }
} 