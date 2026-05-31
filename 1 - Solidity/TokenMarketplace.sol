// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0; 

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";                                          /* 


Solidity is statically typed OOPS programming langauge  
hence data type must be mentioned which creation of variable 

Datatype are :
1) uint(unsigned Integer) - Positive Integer value
2) int(Integer value) - Both Positive and Negative values
3) address

uint is alias to uint256
but we can decide the range of values in uint256 we can store 0 to 2^256
we can make uint of uint8,16,24,32,40,...,256.
If we increase capacity of variable the gas required increases.
In production level code size is always mentioned.

"ether" is keyword for ethereum currency.
Generally variable are mutable in solidity. 
In order to avoid this we have a keyword "constant".
constant variable must be written in CAPITAL.

We also need to make sure that there is no global data
Uninitial variable are by default zero
There is no - None or Null in solidity

By default variable are internal in nature, but we can do access modification
failed transaction are stored in the transaction logs 
                                                                                                    */
contract TokenMarketplace{

    uint public constant TOKEN_PRICE = 1 ether;
    uint private reservedOrderedTokens;
    IERC20 public slvToken;                                                                         /*
    
    Using the slvToken variable we can access the functions and event 
    inside the IERC20 interface                                                                     */

    error TokenMarketplace_ZeroNumberOfTokens(uint256 numberOfTokens);
    error TokenMarketplace_InsufficientEthPayment(uint256 expectedPayment,uint256 actualPayment);
    error TokenMarketplace_TokenBalance(uint256 expectedToken,uint256 actualToken);

//  error nameOfContract_Error() this is required for production ready code

    constructor(address _slvToken){
        slvToken = IERC20(_slvToken);

    }

// A constructor is a special function in Solidity that automatically executes once during contract deployment and is used to initialize the contract.

    function _getBalance()internal view returns(uint){
        return slvToken.balanceOf(address(this));                                                   /*      
           Here we will pass the address of the account of which 
           we want to know balance of 
           if we want the balance of the current contract use address(this)                         */
    }

                                                                                                 /*

INTERNAL FUNCTION : 
internal function named using _nameOfFunction internal
function are the functions that are called only inside 
the contract are not accessible in contract

pure and view keyword
"pure" keyword are the function are the function that dont 
read or write
"view" keyword are the function that read the state but dont

Functions that make changes inside the state hence we dont 
use view or pure with it .

payable have priority over the view , pure
                                                                                                    */
    function _checkEthPayment(uint256 numberOfTokens) internal view{
        if(numberOfTokens * TOKEN_PRICE > msg.value){                                                               /*        
                msg.value is a global variable provided by the solidity 
                represents the amount of Ether the user sent to the contract 
                during that specific function call                                                                      */
                revert TokenMarketplace_InsufficientEthPayment(numberOfTokens * TOKEN_PRICE,msg.value);
            }
    }

    function _isNumberOfTokensZero(uint256 numberOfTokens) internal  pure{
          if(numberOfTokens == 0){
                revert TokenMarketplace_ZeroNumberOfTokens(numberOfTokens);
                // revert is used to immediately stop execution and undo all state changes while returning an error.
            }

    }        



    function buyTokensFromMarketplace(uint256 numberOfTokens) external payable{
            _isNumberOfTokensZero(numberOfTokens);
            _checkEthPayment(numberOfTokens);
            if(_getBalance() < numberOfTokens){
                revert TokenMarketplace_TokenBalance(numberOfTokens,_getBalance());
            }
    }  
                                                                                                                        /*
    What is EXTERNAL FUNCTION ? 
    functions with keyword external are the function that are availble in 
    external environment and are non callable within contract

    What is public function ?
    Public function are availble inside and outside the contract environment

    Transaction is any function that changes the state of contract.

    Payable 
    payable is a modifier applied to functions, constructors, or addresses to 
    indicate that they can receive and process Ether (native cryptocurrency) 
    during a transaction.
                                                                                                                        */
}                                                                                                                       /*

Why do we need Token? 
Suppose we are opening a company what will we offer ICO 
we need to offer token as a assurance to the investor.

interface
An interface in Solidity is a blueprint of a contract that contains 
only function declarations without implementation and is used to interact 
with other contracts.
An interface in Solidity is a collection of function declarations and event 
declarations that defines how another contract can interact with it.

interface name{
    // code
}

Interfaces can contain:
1.function declarations
2.event declarations
3.enum declarations
4.struct declarations

Interfaces cannot contain:
1.function implementations
2.constructors
3.state variables

OpenZeppelin is a blockchain security company that provides 
secure, reusable, and audited smart contract libraries for 
Solidity development. 

*/