// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DiscountNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapHook {
    DiscountNFT public nft;
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _nft, address _tokenA, address _tokenB) {
        nft = DiscountNFT(_nft);
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function beforeSwap (
        address buyer,
        uint256 tokenId,
        uint256 amount
    )  public view returns (uint256 discountedAmount) {
        require(nft.ownerOf(tokenId) == buyer, "Buyer does not own the required NFT");

        uint8 discount = nft.getDiscount(tokenId);
        uint256 discountAmount = (amount * discount) / 100;

        discountedAmount = amount - discountAmount;
        return discountedAmount;
    }

    function swap(address buyer, uint256 tokenId, uint256 amount) public {
        uint256 discountedAmount = beforeSwap(buyer, tokenId, amount);

        // Transfer tokens with the discounted amount
        require(tokenA.transferFrom(buyer, address(this), discountedAmount), "Token A transfer failed");
        require(tokenB.transferFrom(address(this), buyer, amount), "Token B transfer failed");
    }
}
