// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {GrinderGame} from "./GrinderGame.sol";

contract GrinderResources is ERC1155 {

    error NotAllowed();

    using Strings for uint256;

    GrinderGame grinderGame;

    constructor(address _grinderGameAddress, string memory _uri) ERC1155(_uri) {
        grinderGame = GrinderGame(_grinderGameAddress);
    }

    function uri(uint256 id) public view virtual override returns (string memory) {
        return string(abi.encodePacked(super.uri(id), id.toString()));
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) public {
        if (msg.sender != address(grinderGame)) revert NotAllowed();
        _mint(to, id, amount, data);
    }

}