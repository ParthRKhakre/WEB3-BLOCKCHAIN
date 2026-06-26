//SPDX-License-Identifier : GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {OrderInfo} from "./types/Trade.sol";

contract TokenMarketplace{

    uint public constant TOKEN_PRICE = 1 ether;
    uint private reservedOrderedTokens;
    IERC20 public RAT_Token;

    mapping(uint256 => OrderInfo) private orders;
    uint256 private nextOrderId;

    constructor(address _RAT_Token){
        RAT_Token = IERC20(_RAT_Token);
    }

    error TokenMarketplace_ZeroNumberOfTokens(uint numberOfTokens);
    error TokenMarketplace_InsufficientEthPayment(uint expectedPayment,uint actualPayment);
    error TokenMarketplace_InsufficientTokenBalance(uint expectedToken,uint actualToken);

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
        if(_getRAT_TokenTokenBalance() < numberOfTokens){
            uint balance = _getRAT_TokenTokenBalance();
            revert TokenMarketplace_InsufficientTokenBalance(numberOfTokens,balance);
        }

        RAT_Token.transfer(msg.sender,numberOfTokens);
    }

    function createSellOrder(uint256 numberOfTokensToSell) external{
            OrderInfo memory order = OrderInfo({
                orderId: nextOrderId,
                seller: msg.sender,
                numberOfTokens:numberOfTokensToSell,
                isActive:true
            });

            orders[nextOrderId] = order;
            nextOrderId++;
    }
}