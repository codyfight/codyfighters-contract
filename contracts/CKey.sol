// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

/**
 * @title Codyfight - CKey Token
 * @author Codyfight
 * @notice Ckey is an ERC721 standard compliant NFT, used to start battles and to hold CCoin and CTicket tokens in-game.
 */
contract CKey is ERC721, ERC721URIStorage, Pausable, Ownable {
  using Strings for uint256;

  // *** Enums and structs ***

  /**
   * @dev Enum defining the types of CKeys.
   * @notice Native CKeys are earn for free on registration, they do not expire. Cannot be traded.
   * @notice Permanent CKeys are minted on purchase, they do not expire. Can be traded.
   * @notice Flexible CKeys can be subscribed, they expire after a certain time. Can be traded if not expired.
   */
  enum CKeyType {
    Native,
    Permanent,
    Flexible
  }

  /**
   * @dev Enum defining the types of asset deposits.
   * @notice CCoin deposits, in-game currency.
   * @notice CTicket deposits, competitive match entry tickets.
   */
  enum DepositType {
    CCoin,
    CTicket
  }

  /**
   * @dev Struct defining the data associated with a CKey token.
   * @param tokenId The ID of the token.
   * @param owner The address of the token owner.
   * @param tokenURI The URI of the token metadata.
   * @param cKeyType The type of the CKey, as defined in the CKeyType enum.
   * @param expirationTimestamp The expiration timestamp for flexible CKeys, its on the format of a Unix timestamp.
   */
  struct TokenData {
    uint256 tokenId;
    address owner;
    string tokenURI;
    CKeyType cKeyType;
    uint32 expirationTimestamp;
  }

  // *** State variables ***

  /**
   * @dev The CCoin token contract.
   */
  IERC20 public _cCoinToken;

  /**
   * @dev The CTicket token contract.
   */
  IERC20 public _cTicketToken;

  string private _baseTokenURI;
  uint256 private _maxTokenSupply;
  uint256 private _currentTokenSupply;
  uint256[] private _tokenIds;

  // *** Mappings ***

  mapping(uint256 => TokenData) private _tokenData;
  mapping(uint256 => CKeyType) private _cKeyTypes;
  mapping(uint256 => uint256) private _cCoinBalances;
  mapping(uint256 => uint256) private _cTicketBalances;
  mapping(uint256 => string) private _tokenURIs;

  // *** Events ***

  /**
   * @dev Emitted when CCoin tokens are deposited into a CKey token.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   * @param amount The amount of CCoin tokens deposited.
   */
  event CCoinDeposited(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );

  /**
   * @dev Emitted when CCoin tokens are withdrawn from a CKey token.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   * @param amount The amount of CCoin tokens withdrawn.
   */
  event CCoinWithdrawn(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );

  /**
   * @dev Emitted when CTicket tokens are deposited into a CKey token.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   * @param amount The amount of CTicket tokens deposited.
   */
  event CTicketDeposited(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );

  /**
   * @dev Emitted when CTicket tokens are withdrawn from a CKey token.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   * @param amount The amount of CTicket tokens withdrawn.
   */
  event CTicketWithdrawn(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );

  /**
   * @dev Emitted when a CKey token is minted.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   */
  event CKeyMinted(address indexed owner, uint256 indexed tokenId);

  /**
   * @dev Emitted when a CKey token is burned.
   * @param owner The address of the token owner.
   * @param tokenId The ID of the token.
   */
  event CKeyBurned(address indexed owner, uint256 indexed tokenId);

  /**
   * @dev Emitted when a CKey token is transferred.
   * @param from The address the token is transferred from.
   * @param to The address the token is transferred to.
   * @param tokenId The ID of the token.
   */
  event CKeyTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  /**
   * @dev CKey constructor. Sets the base URI for token metadata and initializes the CCoin and CTicket token contracts, along with the maximum token supply.
   * @param cCoinAddress The address of the CCoin token contract.
   * @param cTicketAddress The address of the CTicket token contract.
   * @param maxSupply The maximum token supply.
   */
  constructor(
    address cCoinAddress,
    address cTicketAddress,
    uint256 maxSupply
  ) ERC721('CKey', 'CKey') {
    _maxTokenSupply = maxSupply;
    _cCoinToken = IERC20(cCoinAddress);
    _cTicketToken = IERC20(cTicketAddress);

    setBaseURI('https://blockchain.codyfight.com/ckey/metadata/');
  }

  // *** Public getter methods ***

  /**
   * @dev Returns the token URI for the given token ID.
   * @notice The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
   * @param tokenId The ID of the token to retrieve the URI for.
   * @return uint256 The token URI.
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
    require(_exists(tokenId), 'CKey: token does not exist');
    return _tokenData[tokenId].tokenURI;
  }

  /**
   * @dev Returns the data associated with the given token ID.
   * @notice The token data contains information about the token, such as its owner, type, and expiration timestamp.
   * @param tokenId The ID of the token to retrieve the data for.
   * @return uint256 The token data.
   */
  function getTokenData(
    uint256 tokenId
  ) public view returns (TokenData memory) {
    require(_exists(tokenId), 'CKey: token does not exist');
    return _tokenData[tokenId];
  }

  /**
   * @dev Returns an array containing data for all tokens.
   * @notice The token data contains information about the token, such as its owner, type, and expiration timestamp.
   * @return array An array of token data.
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
   * @dev Returns the balance of the given deposit type for the given token ID.
   * @param tokenId The ID of the token to retrieve the balance for.
   * @param depositType The type of the deposit to retrieve the balance for.
   * @return uint256 The balance of the deposit type for the token.
   */
  function getBalance(
    uint256 tokenId,
    DepositType depositType
  ) public view returns (uint256) {
    require(_exists(tokenId), 'CKey: token does not exist');

    return
      depositType == DepositType.CCoin
        ? _cCoinBalances[tokenId]
        : _cTicketBalances[tokenId];
  }

  /**
   * @dev Returns the maximum token supply.
   * @notice The maximum token supply is the maximum number of tokens that can be minted.
   * @return uint256 The maximum token supply.
   */
  function getMaxTokenSupply() public view returns (uint256) {
    return _maxTokenSupply;
  }

  /**
   * @dev Returns the total number of tokens minted.
   * @notice The total number of tokens minted is the total number of tokens that have been minted.
   * @return uint256 The total number of tokens minted.
   */
  function totalSupply() public view returns (uint256) {
    return _currentTokenSupply;
  }

  /**
   * @dev Checks if the token with the given ID is tradable.
   * @notice A token is tradable if it is a permanent CKey or a flexible CKey that has not expired.
   * @param tokenId The ID of the token to check.
   * @return bool A boolean indicating whether the token is tradable.
   */
  function isTradable(uint256 tokenId) public view returns (bool) {
    CKeyType keyType = _tokenData[tokenId].cKeyType;

    if (keyType == CKeyType.Native) {
      return false;
    } else if (keyType == CKeyType.Flexible) {
      return block.timestamp < _tokenData[tokenId].expirationTimestamp;
    } else if (keyType == CKeyType.Permanent) {
      return true;
    }

    return false;
  }

  // *** Control methods ***

  /**
   * @dev Pauses the contract.
   * @notice While the contract is paused, no new tokens can be minted.
   * @notice Only the contract owner can pause the contract.
   */
  function pause() public onlyOwner {
    _pause();
  }

  /**
   * @dev Unpauses the contract.
   * @notice While the contract is unpaused, new tokens can be minted.
   * @notice Only the contract owner can unpause the contract.
   */
  function unpause() public onlyOwner {
    _unpause();
  }

  /**
   * @dev Sets the base URI for token metadata.
   * @notice The base URI is the base URL for the token metadata. It is used to construct the full token URI.
   * @notice Only the contract owner can set the base URI.
   * @param baseURI The base URI to set.
   */
  function setBaseURI(string memory baseURI) public onlyOwner {
    _baseTokenURI = baseURI;
  }

  /**
   * @dev Sets the maximum token supply.
   * @notice The maximum token supply is the maximum number of tokens that can be minted.
   * @notice Only the contract owner can set the maximum token supply.
   * @param maxSupply The maximum token supply to set.
   */
  function setMaxTokenSupply(uint256 maxSupply) public onlyOwner {
    _maxTokenSupply = maxSupply;
  }

  /**
   * @dev Updates the token URIs for all tokens. This is useful when the base URI is changed.
   * @notice The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
   * @notice Only the contract owner can update the token URIs.
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

  // *** Transaction methods ***

  /**
   * @dev Mints a new CKey token.
   * @notice Only the contract owner can mint new tokens, since this is a in-game asset, its controlled by the game server.
   * @param to The address to mint the token to.
   * @param tokenId The ID of the token to mint.
   * @param cKeyType The type of the CKey.
   * @param expirationTimestamp The expiration timestamp for flexible CKeys.
   */
  function safeMint(
    address to,
    uint256 tokenId,
    CKeyType cKeyType,
    uint32 expirationTimestamp
  ) public onlyOwner {
    require(!_exists(tokenId), 'CKey: token already exists');
    require(!_isTokenIdUsed(tokenId), 'CKey: token ID already used');
    require(!paused(), 'CKey: token mint paused');
    require(
      _currentTokenSupply <= _maxTokenSupply,
      'CKey: maximum token supply reached'
    );

    string memory uri = string(
      abi.encodePacked(_baseTokenURI, Strings.toString(tokenId))
    );

    _safeMint(to, tokenId);
    _setTokenURI(tokenId, uri);

    _tokenData[tokenId] = TokenData(
      tokenId,
      to,
      uri,
      cKeyType,
      expirationTimestamp
    );
    _tokenIds.push(tokenId);
    _currentTokenSupply++;

    emit CKeyMinted(to, tokenId);
  }

  /**
   * @dev Burns the specified CKey token. Calls the overridden internal _burn method.
   * @notice Only the token owner or an approved address can burn a token.
   * @param tokenId The ID of the token to burn.
   */
  function burn(uint256 tokenId) public {
    _burn(tokenId);
  }

  /**
   * @dev Transfers a CKey token from one address to another.
   * @notice Only the token owner or an approved address can transfer a token.
   * @param from The address to transfer the token from.
   * @param to The address to transfer the token to.
   * @param tokenId The ID of the token to transfer.
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public virtual override(ERC721, IERC721) {
    require(to != address(0), 'CKey: transfer to the zero address');
    require(_exists(tokenId), 'CKey: transfer nonexistent token');
    require(isTradable(tokenId), 'CKey: token type can not be traded');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );

    super.transferFrom(from, to, tokenId);
    _tokenData[tokenId].owner = to;

    emit CKeyTransferred(ownerOf(tokenId), to, tokenId);
  }

  /**
   * @dev Safely transfers a CKey token from one address to another.
   * @notice Only the token owner or an approved address can transfer a token.
   * @param from The address to transfer the token from.
   * @param to The address to transfer the token to.
   * @param tokenId The ID of the token to transfer.
   * @param _data Additional data with no specified format.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public virtual override(ERC721, IERC721) {
    require(to != address(0), 'CKey: transfer to the zero address');
    require(_exists(tokenId), 'CKey: transfer nonexistent token');
    require(isTradable(tokenId), 'CKey: token type can not be traded');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );

    _safeTransfer(from, to, tokenId, _data);
    _tokenData[tokenId].owner = to;

    emit CKeyTransferred(ownerOf(tokenId), to, tokenId);
  }

  /**
   * @dev Deposits CCoin tokens into a CKey token.
   * @notice The caller must have approved the contract to transfer the specified amount of CCoin tokens.
   * @param tokenId The ID of the token to deposit into.
   * @param amount The amount of CCoin tokens to deposit.
   */
  function depositCCoin(uint256 tokenId, uint256 amount) public {
    require(_exists(tokenId), 'CKey: tokenId does not exist');
    require(amount > 0, 'CKey: deposit amount must be greater than zero');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );
    require(
      _cCoinToken.allowance(msg.sender, address(this)) >= amount,
      'CKey: allowance not set'
    );

    _cCoinToken.transferFrom(msg.sender, address(this), amount);
    _cCoinBalances[tokenId] += amount;

    emit CCoinDeposited(ownerOf(tokenId), tokenId, amount);
  }

  /**
   * @dev Withdraws CCoin tokens from a CKey token.
   * @notice The caller must have a sufficient balance of CCoin tokens in the CKey token.
   * @param tokenId The ID of the token to withdraw from.
   * @param amount The amount of CCoin tokens to withdraw.
   */
  function withdrawCCoin(uint256 tokenId, uint256 amount) public {
    require(_exists(tokenId), 'CKey: tokenId does not exist');
    require(amount > 0, 'CKey: withdraw amount must be greater than zero');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );
    require(
      _cCoinBalances[tokenId] >= amount,
      'CKey: insufficient CCoin balance'
    );

    _cCoinToken.transfer(msg.sender, amount);
    _cCoinBalances[tokenId] -= amount;

    emit CCoinWithdrawn(ownerOf(tokenId), tokenId, amount);
  }

  /**
   * @dev Deposits CTicket tokens into a CKey token.
   * @notice The caller must have approved the contract to transfer the specified amount of CTicket tokens.
   * @param tokenId The ID of the token to deposit into.
   * @param amount The amount of CTicket tokens to deposit.
   */
  function depositCTicket(uint256 tokenId, uint256 amount) public {
    require(_exists(tokenId), 'CKey: tokenId does not exist');
    require(amount > 0, 'CKey: deposit amount must be greater than zero');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );
    require(
      _cTicketToken.allowance(msg.sender, address(this)) >= amount,
      'CKey: allowance not set'
    );

    _cTicketToken.transferFrom(msg.sender, address(this), amount);
    _cTicketBalances[tokenId] += amount;

    emit CTicketDeposited(ownerOf(tokenId), tokenId, amount);
  }

  /**
   * @dev Withdraws CTicket tokens from a CKey token.
   * @notice The caller must have a sufficient balance of CTicket tokens in the CKey token.
   * @param tokenId The ID of the token to withdraw from.
   * @param amount The amount of CTicket tokens to withdraw.
   */
  function withdrawCTicket(uint256 tokenId, uint256 amount) public {
    require(_exists(tokenId), 'CKey: tokenId does not exist');
    require(amount > 0, 'CKey: withdraw amount must be greater than zero');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );
    require(
      _cTicketBalances[tokenId] >= amount,
      'CKey: insufficient CTicket balance'
    );

    _cTicketToken.transfer(msg.sender, amount);
    _cTicketBalances[tokenId] -= amount;

    emit CTicketWithdrawn(ownerOf(tokenId), tokenId, amount);
  }

  /**
   * @dev Burns the specified CKey token.
   * @notice Only the token owner or an approved address can burn a token.
   * @param tokenId The ID of the token to burn.
   */
  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    require(_exists(tokenId), 'CKey: token does not exist');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: caller is not owner nor approved'
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

    emit CKeyBurned(_msgSender(), tokenId);
  }

  /**
   * @dev Returns the base URI for token metadata.
   * @notice The base URI is the base URL for the token metadata. It is used to construct the full token URI.
   * @return string The base URI.
   */
  function _baseURI() internal view override returns (string memory) {
    return _baseTokenURI;
  }

  /**
   * @dev Checks if the given token ID is already used.
   * @notice A token ID is already used if it is already minted.
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
   * @dev Checks if the contract supports the given interface.
   * @notice The contract supports the ERC721 and ERC721URIStorage interfaces.
   * @param interfaceId The interface identifier.
   * @return bool A boolean indicating whether the contract supports the interface.
   */
  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
