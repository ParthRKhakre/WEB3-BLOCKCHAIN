// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Second{
    
    uint public a; 

    constructor(){
        a = 10;
    }

    function conditionals(uint b) public returns (string memory) {
         a = 101;
        if(b > 0){
            a = b;
            return "Value Updated";
        }else{
            return "Negative Value!";
        }
    }

    function RequiredStatement(uint b) public {
        a = 100;
        require(b > 0,"Negative Value!");
    }
}