// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DiscountNFT.sol";
import "../src/Token.sol";
import "../src/SwapHook.sol";

contract SwapHookTest is Test {
    DiscountNFT nft;
    Token tokenA;
    Token tokenB;
    SwapHook swapHook;

    address buyer = address(0x1);
    address seller = address(0x2);

    function setUp() public {
        nft = new DiscountNFT();
        tokenA = new Token("AC/DC", "ACDC", 1000 * 10**18);
        tokenB = new Token("Slayer", "SLYR", 1000 * 10**18);

        // Mint tokens to buyer and seller
        tokenA.transfer(buyer, 300 * 10**18);
        tokenB.transfer(seller, 500 * 10**18);

        // Mint NFT to buyer with 15% discount
        vm.startPrank(buyer);
        nft.mint(buyer, 1, 15);
        vm.stopPrank();
    }

    function testSwapWithDiscount() public {
        uint256 swapAmount = 100 * 10**18;
        swapHook = new SwapHook(address(nft), address(tokenA), address(tokenB));

        vm.startPrank(buyer);
        tokenA.approve(address(swapHook), swapAmount);
        vm.stopPrank();

        vm.startPrank(seller);
        tokenB.approve(address(swapHook), swapAmount);
        vm.stopPrank();

        vm.startPrank(buyer);
        swapHook.swap(buyer, 1, swapAmount);
        vm.stopPrank();

        // Validate balances
        assertEq(tokenA.balanceOf(address(swapHook)), 85 * 10**18); // After 15% discount
        assertEq(tokenB.balanceOf(buyer), 100 * 10**18);
    }
}
