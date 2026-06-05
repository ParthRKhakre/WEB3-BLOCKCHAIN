// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tea{                                                        /* 
        
        variables : 
        1.local
        2.state                                                     */

    constructor(uint _age){
        age = _age;
    }

    uint public age = 10; //state variables(Permenently Stored)

    
    // NO READ , WRITE Hence pure  
    function demo() public pure returns (uint256) {
        uint256 rate = 9; // local variable 
        return rate ; 
    }

    // we are updating the state variable age hence no mutability used.
    // Read and Write function -> 
    function rateUpdate() public {
        age += 10;
    }

    // READ BUT NOT WRITE 
    function returnLocalVariable()public view returns(uint){
        uint year = age;
        return year;
    } 
}