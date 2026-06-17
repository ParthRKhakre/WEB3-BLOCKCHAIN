// SPDX-License-Identifier : GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TokenMarketplace{

    uint public constant TOKEN_PRICE = 1 ether;
    uint private reservedOrderedTokens;
    IERC20 public RAT_Token;

    constructor(address _RAT_Token){
        RAT_Token = IERC20(_RAT_Token);
    }


    error TokenMarketplace_ZeroNumberOfTokens(uint numberOfTokens);
    error TokenMarketplace_InsufficientEthPayment(uint expectedPayment,uint actualPayment);

    function _isNumberOfTokensZero(uint numberOfTokens)internal pure{
        if(numberOfTokens == 0){
            revert TokenMarketplace_ZeroNumberOfTokens(numberOfTokens);
        }
    }

    function _checkEthPayment(uint numberOfTokens)internal view{
        if(numberOfTokens * TOKEN_PRICE > msg.value){
            revert TokenMarketplace_InsufficientEthPayment(numberOfTokens * TOKEN_PRICE,msg.value);
        }  
    }

    function _getRAT_TokenTokenBalance() internal view returns(uint256){
        return RAT_Token.balanceOf(address(this));
    }

    function buyTokensFromMarketplace(uint256 numberOfTokens) external payable{
        _isNumberOfTokensZero(numberOfTokens);
        _checkEthPayment(numberOfTokens);

    }


}                                                                                                                           /*


Avoid using global data if require make global data constant 
Always write constant variable in Capital letters.

By default undefined variable are assigned with default value.
By default variable are internal in nature in solidity.
Variable declared with public keyword automatically creates a getter function.

We can decide the capacity of variable meaning what range of value it can store.
e.g. uint8,uint16,uint24,...,uint256.
As capacity of variable increases the GAS required also increases.

KEYWORD(access modifiers) - public,private,external,internal.

solidity bydefault used "wei" as its unit

variable : 
1.state are stored in storage area 
      they are declared outside the functions
      gas is required
      Permenently stored over blockchain
2.local are declared inside the functions

External function visibility type that forms part of the smart contract's 
interface, meaning it can only be called from outside the contract

Internal function that can only be called from within the current contract 
or any contracts that inherit from it

payable keyword is used to indicate that an address or a function 
can receive and handle Ether (the native currency)

anything that changing the state of blockchain is called transaction

revert() is an error-handling mechanism that aborts the current 
transaction execution, undoes all state changes (restoring the 
contract's state to how it was before the call), and refunds all 
unused gas to the transaction sender

msg.value is a global variable that represents the amount of Wei 
(the smallest denomination of Ether) sent to a smart contract along 
with a function call.

public function change more. below is the charge chart : 
public > external > internal > private

view - read state variable then function is view 
pure - no read no write from the function
payable - when function perform eth transaction
If write then we dont use any of the above

constructor - special function that is the first function to be 
called automatically when we deploy contract used to initialize 
value 

import in solidity 
import {name_of_library} from "source";

interface is a blueprint that defines the function signatures (name, parameters, and return types) 
of a smart contract without implementing the code itself. interface can be modified according to requirement.

OpenZeppelin is the gold standard, open-source library for building secure smart contracts in Solidity

*/