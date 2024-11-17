// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/DiscountNFT.sol";
import "../src/Token.sol";
import "../src/SwapHook.sol";

contract SwapDeploy is Script {
    function run() external {
        // Load deployer, buyer, and seller accounts from private keys
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        uint256 buyerPrivateKey = vm.envUint("BUYER_PRIVATE_KEY");
        uint256 sellerPrivateKey = vm.envUint("SELLER_PRIVATE_KEY");

        address deployer = vm.addr(deployerPrivateKey);
        address buyer = vm.addr(buyerPrivateKey);
        address seller = vm.addr(sellerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy DiscountNFT contract
        DiscountNFT discountNFT = new DiscountNFT();

        // Deploy TokenA and TokenB contracts
        Token tokenA = new Token("AC/DC", "ACDC", 1_000 ether);
        Token tokenB = new Token("Slayer", "SLYR", 1_000 ether);

        // Deploy SwapHook contract
        SwapHook swapHook = new SwapHook(address(discountNFT), address(tokenA), address(tokenB));

        // Transfer initial balances to buyer and seller
        tokenA.transfer(buyer, 300 ether);
        tokenB.transfer(seller, 500 ether);

        // Mint an NFT to the buyer with a 15% discount
        discountNFT.mint(buyer, 1, 15);

        vm.stopBroadcast();

        // Log deployed contract addresses
        console.log("DiscountNFT deployed at:", address(discountNFT));
        console.log("TokenA deployed at:", address(tokenA));
        console.log("TokenB deployed at:", address(tokenB));
        console.log("SwapHook deployed at:", address(swapHook));

        // Log account details
        console.log("Deployer address:", deployer);
        console.log("Buyer address:", buyer);
        console.log("Seller address:", seller);
    }
}
