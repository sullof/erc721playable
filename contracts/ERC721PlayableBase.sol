// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors:
// Francesco Sullo <francesco@sullo.co>
// 'ndujaLabs, https://ndujalabs.com

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./IERC721Playable.sol";

abstract contract ERC721PlayableBase is IERC721Playable{
  using Address for address;
  mapping(uint256 => mapping(address => Attributes)) internal _attributes;

  function attributesOf(uint256 _tokenId, address _player) public view override returns (Attributes memory) {
    return _attributes[_tokenId][_player];
  }

  function _emptyAttributesArray() internal pure returns (uint8[31] memory) {
    uint8[31] memory arr;
    return arr;
  }

  function _initEmptyAttributes(uint256 _tokenId, address _player) internal returns (bool) {
    require(_player.isContract(), "ERC721PlayableBase: _player not a contract");
    require(_attributes[_tokenId][_player].version == 0, "ERC721PlayableBase: player already initialized");
    _attributes[_tokenId][_player].version = 1;
    return true;
  }

  function _initPrefilledAttributes(
    uint256 _tokenId,
    address _player,
    uint8[31] memory _initialAttributes
  ) internal virtual returns (bool) {
    require(_player.isContract(), "ERC721PlayableBase: player not a contract");
    require(_attributes[_tokenId][_player].version == 0, "ERC721PlayableBase: player already initialized");
    _attributes[_tokenId][_player] = Attributes({version: 1, attributes: _initialAttributes});
    return true;
  }

  function _updateAttributes(
    address _owner,
    uint256 _tokenId,
    uint8 _newVersion,
    uint256[] memory _indexes,
    uint8[] memory _values
  ) internal returns (bool) {
    // called by a previously initiated player
    require(_indexes.length == _values.length, "ERC721PlayableBase: inconsistent lengths");
    require(_attributes[_tokenId][_owner].version > 0, "ERC721PlayableBase: player not initialized");
    if (_newVersion > _attributes[_tokenId][_owner].version) {
      _attributes[_tokenId][_owner].version = _newVersion;
    }
    for (uint256 i = 0; i < _indexes.length; i++) {
      if (_attributes[_tokenId][_owner].attributes[_indexes[i]] != _values[i]) {
        _attributes[_tokenId][_owner].attributes[_indexes[i]] = _values[i];
      }
    }
    return true;
  }

}
