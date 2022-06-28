// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

//import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./ERC721PlayableBase.sol";

contract ERC721PlayableUpgradeable is ERC721PlayableBase, ERC721Upgradeable {
  using AddressUpgradeable for address;

  // solhint-disable-next-line
  function __ERC721Playable_init(string memory name_, string memory symbol_) internal initializer {
    __ERC721_init(name_, symbol_);
  }

  function _beforeTokenTransfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal virtual override(ERC721Upgradeable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable) returns (bool) {
    return interfaceId == type(IERC721Playable).interfaceId || super.supportsInterface(interfaceId);
  }

  function initAttributes(uint256 _tokenId, address _player) external override returns (bool) {
    // called by the nft's owner
    require(ownerOf(_tokenId) == _msgSender(), "ERC721Playable: not the token owner");
    return _initEmptyAttributes(_tokenId, _player);
  }

  function updateAttributes(
    uint256 _tokenId,
    uint8 _newVersion,
    uint256[] memory _indexes,
    uint8[] memory _values
  ) public override returns (bool) {
    return _updateAttributes(_msgSender(), _tokenId, _newVersion, _indexes, _values);
  }

  // these internal functions can be called to pre-initialize a token before minting it

  function _initAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player,
    uint8[31] memory _initialAttributes
  ) internal {
    _safeMint(_to, _tokenId);
    _initPrefilledAttributes(_tokenId, _player, _initialAttributes);
  }

  function _initEmptyAttributesAndSafeMint(
    address _to,
    uint256 _tokenId,
    address _player
  ) internal {
    _safeMint(_to, _tokenId);
    _initEmptyAttributes(_tokenId, _player);
  }
}
