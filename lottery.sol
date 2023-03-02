// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value== 1 ether);
        players.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }
    function Winner() public {
        require(msg.sender==manager);
        require(players.length>=3);
        uint r = random();
        address payable winner;
        uint i = r % players.length;
        winner = players[i];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}