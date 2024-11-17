// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract DiscountNFT is ERC721Enumerable {
    struct Metadata {
        uint8 discount; // Discount from 0 to 20
    }

    mapping(uint256 => Metadata) private _tokenMetadata;

    constructor() ERC721("DiscountNFT", "DNFT") {}

    function mint(address to, uint256 tokenId, uint8 discount) external {
        require(discount <= 20, "Discount cannot exceed 20%");
        require(ownerOf(tokenId) == address(0), "Token already minted");
        _mint(to, tokenId);
        _tokenMetadata[tokenId] = Metadata(discount);
    }

    function getDiscount(uint256 tokenId) external view returns (uint8) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        return _tokenMetadata[tokenId].discount;
    }
}
