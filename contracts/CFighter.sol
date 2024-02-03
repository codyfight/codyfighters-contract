// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

/**
 * @title Codyfight - Genenis Codyfighter NFT Collection
 * @author Codyfight
 * @notice Genesis Codyfighter NFT collection contract compliant with the ERC721 standard.
 */
contract Codyfighter is ERC721, ERC721URIStorage, Pausable, Ownable {
  using Strings for uint256;

  // *** Structs ***

  /**
   * @dev The TokenData struct for storing token data.
   * @param tokenId The ID of the token.
   * @param owner The address of the token owner.
   * @param tokenURI The URI of the token metadata.
   */
  struct TokenData {
    uint256 tokenId;
    address owner;
    string tokenURI;
  }

  /**
   * @dev The AllowedList struct for storing allowed addresses and their associated token IDs.
   * @param addr The address to allow.
   * @param id The token IDs allowed for the address.
   */
  struct AllowedList {
    address addr;
    uint256[] id;
  }

  // *** State variables ***
  string private _baseTokenURI;
  uint256 private _maxTokenSupply;
  uint256 private _currentTokenSupply;
  uint256[] private _tokenIds;
  AllowedList[] private _allowedList;

  // *** Mappings ***
  mapping(uint256 => TokenData) private _tokenData;

  // *** Events ***

  /**
   * @dev Emitted when a new Codyfighter token is minted.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   */
  event CFighterMinted(address indexed owner, uint256 indexed tokenId);

  /**
   * @dev Emitted when a Codyfighter token is burned.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   */
  event CFighterBurned(address indexed owner, uint256 indexed tokenId);

  /**
   * @dev Emitted when a Codyfighter token is transferred.
   * @param from The address to transfer the token from.
   * @param to The address to transfer the token to.
   * @param tokenId The ID of the token.
   */
  event CFighterTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  /**
   * @dev Constructs the Codyfighter contract.
   * @param max The maximum token supply allowed.
   */
  constructor(uint256 max) ERC721('Codyfighter Genesis', 'CFighterGenesis') {
    _maxTokenSupply = max;
    _currentTokenSupply = 0;
    _baseTokenURI = 'https://blockchain.codyfight.com/codyfighter/metadata/';
  }

  // *** Public getter methods ***

  /**
   * @dev Checks if the given address is the contract owner.
   * @notice A contract owner is the address that deployed the contract.
   * @notice This method is public and can be called by any address.
   * @param addr The address to check.
   * @return bool A boolean indicating whether the address is the contract owner.
   */
  function isContractOwner(address addr) public view returns (bool) {
    return owner() == addr;
  }

  /**
   * @dev Returns the URI for a given token ID.
   * @notice The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
   * @notice This method is public and can be called by any address.
   * @param tokenId The ID of the token.
   * @return string The URI string of the token.
   */
  function tokenURI(
    uint256 tokenId
  )
    public
    view
    virtual
    override(ERC721URIStorage, ERC721)
    returns (string memory)
  {
    require(_exists(tokenId), 'Codyfighter: token does not exist');
    return _tokenData[tokenId].tokenURI;
  }

  /**
   * @dev Returns an array of TokenData for all tokens.
   * @notice Returns a list of all tokens and their associated data.
   * @notice This method is public and can be called by any address.
   * @return array An array of TokenData.
   */
  function getAllTokens() public view returns (TokenData[] memory) {
    TokenData[] memory tokens = new TokenData[](_tokenIds.length);

    for (uint256 i = 0; i < _tokenIds.length; i++) {
      uint256 tokenId = _tokenIds[i];
      tokens[i] = _tokenData[tokenId];
    }

    return tokens;
  }

  /**
   * @dev Returns the TokenData for a given token ID.
   * @notice The TokenData contains information about the token, such as its ID, owner, and metadata URI.
   * @notice This method is public and can be called by any address.
   * @param tokenId The ID of the token.
   * @return array The TokenData of the token.
   */
  function getTokenData(
    uint256 tokenId
  ) public view returns (TokenData memory) {
    require(_exists(tokenId), 'Codyfighter: token does not exist');
    return _tokenData[tokenId];
  }

  /**
   * @dev Returns the maximum token supply allowed.
   * @notice The maximum token supply is the maximum number of tokens that can be minted.
   * @notice This method is public and can be called by any address.
   * @return uint256 The maximum token supply.
   */
  function getMaxTokenSupply() public view returns (uint256) {
    return _maxTokenSupply;
  }

  /**
   * @dev Returns the current token supply.
   * @notice The current token supply is the number of tokens that have been minted.
   * @notice This method is public and can be called by any address.
   * @return uint256 The current token supply.
   */
  function totalSupply() public view returns (uint256) {
    return _currentTokenSupply;
  }

  /**
   * @dev Returns an array of allowed addresses and their associated token IDs.
   * @notice Returns a list of all allowed addresses and their associated token IDs, previously added by the contract owner.
   * @notice This method is public and can be called by any address.
   * @return array An array of AllowedList structs.
   */
  function getAllowedAddresses() public view returns (AllowedList[] memory) {
    return _allowedList;
  }

  /**
   * @dev Checks if an address is allowed to mint tokens.
   * @notice If an address is allowed to mint tokens, it means that the address is included in the allowed list.
   * @notice This method is public and can be called by any address.
   * @param addr The address to check.
   * @return bool A boolean indicating whether the address is allowed to mint tokens.
   */
  function isAllowedToMint(address addr) public view returns (bool) {
    return getAllowedAddressIndex(addr, _allowedList) != type(uint256).max;
  }

  // *** Control methods ***

  /**
   * @dev Pauses token minting.
   * @notice While the contract is paused, no new tokens can be minted.
   * @notice This method is public but can only be called by the contract owner.
   */
  function pause() public onlyOwner {
    _pause();
  }

  /**
   * @dev Unpauses token minting.
   * @notice While the contract is unpaused, new tokens can be minted.
   * @notice This method is public but can only be called by the contract owner.
   */
  function unpause() public onlyOwner {
    _unpause();
  }

  /**
   * @dev Sets the base URI for token metadata.
   * @notice This method is public but can only be called by the contract owner.
   * @param baseURI The base URI to set.
   */
  function setBaseURI(string memory baseURI) public onlyOwner {
    _baseTokenURI = baseURI;
  }

  /**
   * @dev Sets the maximum token supply allowed.
   * @notice This method is public but can only be called by the contract owner.
   * @param maxSupply The maximum token supply to set.
   */
  function setMaxTokenSupply(uint256 maxSupply) public onlyOwner {
    _maxTokenSupply = maxSupply;
  }

  /**
   * @dev Updates the token URIs for all tokens. This is useful when the base URI is changed.
   * @notice The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
   * @notice This method is public but can only be called by the contract owner.
   */
  function updateTokenURIs() public onlyOwner {
    for (uint256 i = 0; i < _tokenIds.length; i++) {
      uint256 tokenId = _tokenIds[i];
      string memory uri = string(
        abi.encodePacked(_baseTokenURI, Strings.toString(tokenId))
      );
      _setTokenURI(tokenId, uri);
      _tokenData[tokenId].tokenURI = uri;
    }
  }

  // *** Allow list methods ***

  /**
   * @dev Adds a list of addresses to the allowed list. This does not override the existing list.
   * @notice The allowed list is a list of addresses that are allowed to mint tokens.
   * @notice Each address can have a list of token IDs that it is allowed to mint (Codyfighters owned by the address in-game).
   * @notice This method is public but can only be called by the contract owner.
   * @param newAllowedList The list of addresses and their associated permited token IDs to add.
   */
  function addAllowedAddress(
    AllowedList[] memory newAllowedList
  ) public onlyOwner {
    for (uint256 i = 0; i < newAllowedList.length; i++) {
      require(
        !isAllowedToMint(newAllowedList[i].addr),
        'Codyfighter: address already allowed'
      );
      _allowedList.push(newAllowedList[i]);
    }
  }

  /**
   * @dev Adds token IDs to the allowed list for a specific address that was previously added.
   * @notice This method is public but can only be called by the contract owner.
   * @param addr The address to add token IDs to.
   * @param newIds The token IDs to add.
   */
  function addIdToAllowedAddress(
    address addr,
    uint256[] memory newIds
  ) public onlyOwner {
    uint256 index = getAllowedAddressIndex(addr, _allowedList);
    require(
      index != type(uint256).max,
      'Codyfighter: address not allowed to mint'
    );

    for (uint256 i = 0; i < newIds.length; i++) {
      _allowedList[index].id.push(newIds[i]);
    }
  }

  /**
   * @dev Removes an address from the allowed list. It is only called internaly when an address mints a token.
   * @notice No one can remove an addres from the list, not even the contract owner.
   * @notice This method is private, can not be called by the owner or any other address.
   * @param index The index of the address to remove.
   */
  function removeAllowedAddress(uint256 index) private {
    require(
      index >= 0 && index < _allowedList.length,
      'Codyfighter: index out of bounds'
    );

    for (uint256 i = index; i < _allowedList.length - 1; i++) {
      _allowedList[i] = _allowedList[i + 1];
    }

    _allowedList.pop();
  }

  /**
   * @dev Returns the index of an address in the allowed list. Internal method.
   * @notice This method is private and can only be called internally.
   * @param addr The address to search for.
   * @param list The list to search in.
   * @return array The index of the address in the list.
   */
  function getAllowedAddressIndex(
    address addr,
    AllowedList[] memory list
  ) private pure returns (uint256) {
    for (uint256 i = 0; i < list.length; i++) {
      if (list[i].addr == addr) {
        return i;
      }
    }

    return type(uint256).max;
  }

  /**
   * @dev Checks if an address is allowed to mint a specific token. Internal method.
   * @notice This method is private and can only be called internally.
   * @param index The index of the address in the allowed list.
   * @param tokenId The ID of the token to check.
   * @return bool A boolean indicating whether the address is allowed to mint the token.
   */
  function isAllowedToMintCFighter(
    uint256 index,
    uint256 tokenId
  ) private view returns (bool) {
    if (index != type(uint256).max) {
      for (uint256 i = 0; i < _allowedList[index].id.length; i++) {
        if (_allowedList[index].id[i] == tokenId) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  // *** Transaction methods ***

  /**
   * @dev Mints a new Codyfighter token for a allowed address, and removes the address from the allowed list.
   * @notice This method is public and can be called by any address that is included in the allowed list.
   * @param to The address to mint the token to.
   * @param tokenId The ID of the token to mint.
   */
  function safeMint(address to, uint256 tokenId) public {
    require(!paused(), 'Codyfighter: token mint paused');
    require(!_exists(tokenId), 'Codyfighter: token already exists');
    require(!_isTokenIdUsed(tokenId), 'Codyfighter: token ID already used');
    require(
      _currentTokenSupply <= _maxTokenSupply,
      'Codyfighter: maximum token supply reached'
    );

    uint256 allowedIndex = getAllowedAddressIndex(_msgSender(), _allowedList);

    if (!isContractOwner(_msgSender())) {
      require(
        isAllowedToMintCFighter(allowedIndex, tokenId),
        'Codyfighter: address not allowed to mint this token'
      );
    }

    string memory uri = string(
      abi.encodePacked(_baseTokenURI, Strings.toString(tokenId))
    );

    _safeMint(to, tokenId);
    _setTokenURI(tokenId, uri);

    _tokenData[tokenId] = TokenData(tokenId, to, uri);
    _tokenIds.push(tokenId);
    _currentTokenSupply++;

    if (!isContractOwner(_msgSender())) {
      removeAllowedAddress(allowedIndex);
    }

    emit CFighterMinted(to, tokenId);
  }

  /**
   * @dev Transfers ownership of a token from one address to another.
   * @notice This method is public and can be called by the token owner or an approved address.
   * @param from The address to transfer the token from.
   * @param to The address to transfer the token to.
   * @param tokenId The ID of the token to transfer.
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public virtual override(ERC721, IERC721) {
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'Codyfighter: transfer caller is not owner nor approved'
    );
    require(to != address(0), 'Codyfighter: transfer to the zero address');
    require(_exists(tokenId), 'Codyfighter: transfer nonexistent token');

    super.transferFrom(from, to, tokenId);
    _tokenData[tokenId].owner = to;

    emit CFighterTransferred(from, to, tokenId);
  }

  /**
   * @dev Safely transfers ownership of a token from one address to another.
   * @notice This method is public and can be called by the token owner or an approved address.
   * @param from The address to transfer the token from.
   * @param to The address to transfer the token to.
   * @param tokenId The ID of the token to transfer.
   * @param _data Additional data with no specified format to include in the call to `to`.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public virtual override(ERC721, IERC721) {
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'Codyfighter: transfer caller is not owner nor approved'
    );
    require(to != address(0), 'Codyfighter: transfer to the zero address');
    require(_exists(tokenId), 'Codyfighter: transfer nonexistent token');

    _safeTransfer(from, to, tokenId, _data);
    _tokenData[tokenId].owner = to;

    emit CFighterTransferred(from, to, tokenId);
  }

  /**
   * @dev Burns a token. Calls the overridden internal _burn method.
   * @notice This method is public and can be called by the token owner or an approved address.
   * @param tokenId The ID of the token to burn.
   */
  function burn(uint256 tokenId) public {
    _burn(tokenId);
  }

  // *** Internal methods ***

  /**
   * @dev Burns a token. Overrides the ERC721URIStorage _burn method, removing the token from the tokenIds array.
   * @notice This method is internal and can only be called internally.
   * @param tokenId The ID of the token to burn.
   */
  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    require(_exists(tokenId), 'Codyfighter: token does not exist');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'Codyfighter: caller is not owner nor approved'
    );

    super._burn(tokenId);

    for (uint256 i = 0; i < _tokenIds.length; i++) {
      if (_tokenIds[i] == tokenId) {
        _tokenIds[i] = _tokenIds[_tokenIds.length - 1];
        _tokenIds.pop();
        break;
      }
    }

    _currentTokenSupply--;

    emit CFighterBurned(_msgSender(), tokenId);
  }

  /**
   * @dev Returns the base URI for token metadata.
   * @notice This method is internal and can only be called internally.
   * @return string The base URI string.
   */
  function _baseURI() internal view override returns (string memory) {
    return _baseTokenURI;
  }

  /**
   * @dev Checks if a token ID is already used.
   * @notice This method is internal and can only be called internally.
   * @param tokenId The ID of the token to check.
   * @return bool A boolean indicating whether the token ID is already used.
   */
  function _isTokenIdUsed(uint256 tokenId) internal view returns (bool) {
    for (uint256 i = 0; i < _tokenIds.length; i++) {
      if (_tokenIds[i] == tokenId) {
        return true;
      }
    }
    return false;
  }

  /**
   * @dev Returns whether the contract supports the given interface.
   * @notice This method is public and can be called by any address.
   * @param interfaceId The interface identifier.
   * @return bool True if the contract supports the interface, false otherwise.
   */
  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
