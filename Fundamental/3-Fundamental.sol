// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Modifier{

    modifier onlyTrue(){
        require(true == false,"condition");
        _;
    }

    function check1() public pure onlyTrue returns(uint){
        return 1;
    }   
}