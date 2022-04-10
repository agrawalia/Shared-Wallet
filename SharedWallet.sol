pragma solidity ^0.5.13;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
contract SimpleWallet is Ownable{

    mapping(address => uint) public allowance;

    modifier OwnerOrAllowed(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed" );
        _;
    }

    function reduceAllowance(uint _amount, address _who) public internal {
        allowance[_who] -= _amount;
    }


    function addAllowance( address _who, uint _amount) public onlyOwner{
        allowance[_who] = _amount;
    }

    function withdrawMoney(address payable _to, uint _amount) OwnerOrAllowed(_amount) public{
        require(_amount <= address(this).balance , "There are not enough funds stored in smart contract" );
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }

    function() external payable   {}
       
} 