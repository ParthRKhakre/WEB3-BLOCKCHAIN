// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0; 

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";                               
import {OrderInfo} from "TokenMarketplace/types/Trade.sol";

contract TokenMarketplace{

    uint public constant TOKEN_PRICE = 1 ether;
    uint private reservedOrderedTokens;
    IERC20 public slvToken;  

    mapping(uint => OrderInfo) private orders;       
    uint256 private nextOrderId;  

    error TokenMarketplace_ZeroNumberOfTokens(uint256 numberOfTokens);
    error TokenMarketplace_InsufficientEthPayment(uint256 expectedPayment,uint256 actualPayment);
    error TokenMarketplace_TokenBalance(uint256 expectedToken,uint256 actualToken);
    error TokenMarketplace_InsufficientBalance(uint256 actualToken,uint256 expectedToken);
    error TokenMarketplace_InsufficientAllowance(uint256 allowedTokens,uint256 tokensToTransfer);
    error TokenMarketplace_OrderIsNotActive(uint256 orderId);
    error TokenMarketplace_NotEnoughTokensInOrder(uint256 tokensToSell,uint256 actualToken);
    error TokenMarketplace_EthTransferFailed();

    constructor(address _slvToken){
        slvToken = IERC20(_slvToken);
    }

    function _getSlvTokenBalanceOfMarketplace()internal view returns(uint){
        return slvToken.balanceOf(address(this));                                             
    }                                                                                                
                                                                                                    
    function _checkEthPayment(uint256 numberOfTokens) internal view{
        if(numberOfTokens * TOKEN_PRICE > msg.value){                                                              
            revert TokenMarketplace_InsufficientEthPayment(numberOfTokens * TOKEN_PRICE,msg.value);
        }
    }

    function _isNumberOfTokensZero(uint256 numberOfTokens) internal  pure{
        if(numberOfTokens == 0){
            revert TokenMarketplace_ZeroNumberOfTokens(numberOfTokens);
        }
    }        

    function buyTokensFromMarketplace(uint256 numberOfTokens) external payable{
        _isNumberOfTokensZero(numberOfTokens);
        _checkEthPayment(numberOfTokens);

        if(_getSlvTokenBalanceOfMarketplace() < numberOfTokens){
            revert TokenMarketplace_TokenBalance(numberOfTokens,_getSlvTokenBalanceOfMarketplace());
        }

        slvToken.transfer(msg.sender, numberOfTokens);
    }

    function _checkSellerSlvTokenBalance(address account,uint256 numberOfTokens) internal view {
        
        uint256 balance = slvToken.balanceOf(account);
        if (numberOfTokens > balance) {
            revert TokenMarketplace_InsufficientBalance(balance,numberOfTokens);
       }
    }  

    function createSellOrder(uint256 numberOfTokensToSell) external {
        
        _isNumberOfTokensZero(numberOfTokensToSell);
        _checkSellerSlvTokenBalance(msg.sender,numberOfTokensToSell);

        uint256 allowance = slvToken.allowance(msg.sender, address(this));

        if(allowance < numberOfTokensToSell){
            revert TokenMarketplace_InsufficientAllowance(allowance,numberOfTokensToSell);
        } 

        OrderInfo memory order  = OrderInfo({
             orderId : nextOrderId,
             seller : msg.sender,
             numberOfTokensToSell : numberOfTokensToSell,
             isActive :true
        });
        orders[nextOrderId] = order;
        nextOrderId++;

        slvToken.transferFrom(msg.sender, address(this), numberOfTokensToSell);
        reservedOrderedTokens += numberOfTokensToSell;
    }

    function buyTokensFromSellOrderCreated(uint256 orderId,uint256 numberOfTokensToBuy) external payable {
        
        _isNumberOfTokensZero(numberOfTokensToBuy);
        _checkEthPayment(numberOfTokensToBuy);

        OrderInfo storage order = orders[orderId];

        if(order.isActive == false){
            revert TokenMarketplace_OrderIsNotActive(orderId);
        }

        if(order.numberOfTokensToSell < numberOfTokensToBuy){
            revert TokenMarketplace_NotEnoughTokensInOrder(order.numberOfTokensToSell,numberOfTokensToBuy);
        }

        order.numberOfTokensToSell -= numberOfTokensToBuy;
        if(order.numberOfTokensToSell == 0){
            order.isActive = false;
        }

        // Token transfer from contract to the buyer account
        slvToken.transfer(msg.sender, numberOfTokensToBuy);

        // Transfer eth from contract to seller account
        (bool success,) = order.seller.call{value: msg.value}("");
         if(!success){
            revert TokenMarketplace_EthTransferFailed();
         }
    }
}  

