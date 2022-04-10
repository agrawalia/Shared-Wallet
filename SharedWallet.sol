pragma solidity ^0.5.13;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";

contract Allowance is Ownable{

    mapping(address => uint) public allowance;
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    function reduceAllowance(uint _amount, address _who) public internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] -  _amount);
        allowance[_who] -= _amount;
    }

    function addAllowance( address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowance[_who],  _amount);
        allowance[_who] = _amount;
    }
}

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

    function() external payable   {
       emit MoneyReceived(msg.sender, msg.value);
    }
} 