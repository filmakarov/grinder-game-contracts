// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Grinder} from "./Grinder.sol";
import {GrinderResources} from "./GrinderResources.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

contract GrinderGame is IERC1155Receiver {

    error NotAllowedToUseCharacter(uint256 characterId, address player);
    error NotEnoughEnergy();

    Grinder public grinderCharacters;
    GrinderResources public grinderResources;

    constructor (string memory grinderCharImageUri, string memory grinderResourcesMetadataUri) {
        grinderCharacters = new Grinder(address(this), grinderCharImageUri);
        grinderResources = new GrinderResources(address(this), grinderResourcesMetadataUri);
    }

    function grind(uint256 _characterId, uint256 _resourceId) public {
        if(msg.sender != grinderCharacters.ownerOf(_characterId)) revert NotAllowedToUseCharacter(_characterId, msg.sender);
        if(grinderCharacters.energy(_characterId) == 0) revert NotEnoughEnergy();
        grinderCharacters.decreaseEnergy(_characterId);
        grinderCharacters.levelUp(_characterId);
        grinderResources.mint(msg.sender, _resourceId, grinderCharacters.level(_characterId), "");
    }

    function exchange(uint256 _characterId, uint256 _resourceIdIn, uint256 _resourceIdOut) public {
        if(msg.sender != grinderCharacters.ownerOf(_characterId)) revert NotAllowedToUseCharacter(_characterId, msg.sender);
        grinderResources.safeTransferFrom(msg.sender, address(this), _resourceIdIn, 2, "");
        grinderResources.mint(msg.sender, _resourceIdOut, grinderCharacters.level(_characterId), "");
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external pure returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external pure returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external view virtual override returns (bool) {
        return
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
}
