// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

contract CKey is ERC721, ERC721URIStorage, Pausable, Ownable {
  using Strings for uint256;

  enum CKeyType {
    Native,
    Temporary,
    Permanent
  }

  enum DepositType {
    CCoin,
    CTicket
  }

  struct TokenData {
    uint256 tokenId;
    address owner;
    string tokenURI;
    CKeyType cKeyType;
    uint32 expirationTimestamp;
  }

  IERC20 public _cCoinToken;
  IERC20 public _cTicketToken;

  string private _baseTokenURI;
  uint256 private _maxTokenSupply;
  uint256 private _currentTokenSupply;
  uint256[] private _tokenIds;

  mapping(uint256 => TokenData) private _tokenData;
  mapping(uint256 => CKeyType) private _cKeyTypes;
  mapping(uint256 => uint256) private _cCoinBalances;
  mapping(uint256 => uint256) private _cTicketBalances;
  mapping(uint256 => string) private _tokenURIs;

  event CCoinDeposited(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );
  event CCoinWithdrawn(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );
  event CTicketDeposited(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );
  event CTicketWithdrawn(
    address indexed owner,
    uint256 indexed tokenId,
    uint256 amount
  );

  event CKeyMinted(address indexed owner, uint256 indexed tokenId);
  event CKeyBurned(address indexed owner, uint256 indexed tokenId);
  event CKeyTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  constructor(
    address cCoinAddress,
    address cTicketAddress
  ) ERC721('CKey', 'CKey') {
    _maxTokenSupply = 10000;
    _cCoinToken = IERC20(cCoinAddress);
    _cTicketToken = IERC20(cTicketAddress);

    setBaseURI('https://blockchain.codyfight.com/ckey/metadata/');
  }

  // Metadata and Information functions

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

  function getTokenData(
    uint256 tokenId
  ) public view returns (TokenData memory) {
    require(_exists(tokenId), 'CKey: token does not exist');
    return _tokenData[tokenId];
  }

  function getAllTokens() public view returns (TokenData[] memory) {
    TokenData[] memory tokens = new TokenData[](_tokenIds.length);

    for (uint256 i = 0; i < _tokenIds.length; i++) {
      uint256 tokenId = _tokenIds[i];
      tokens[i] = _tokenData[tokenId];
    }

    return tokens;
  }

  function getBalance(
    uint256 tokenId,
    DepositType depositType
  ) public view returns (uint256 balance) {
    require(_exists(tokenId), 'CKey: tokenId does not exist');

    return
      depositType == DepositType.CCoin
        ? _cCoinBalances[tokenId]
        : _cTicketBalances[tokenId];
  }

  function getMaxTokenSupply() public view returns (uint256) {
    return _maxTokenSupply;
  }

  function totalSupply() public view returns (uint256) {
    return _currentTokenSupply;
  }

  function isTradable(uint256 tokenId) public view returns (bool) {
    CKeyType keyType = _tokenData[tokenId].cKeyType;

    if (keyType == CKeyType.Native) {
      return false;
    } else if (keyType == CKeyType.Temporary) {
      return block.timestamp < _tokenData[tokenId].expirationTimestamp;
    } else if (keyType == CKeyType.Permanent) {
      return true;
    }

    return false;
  }

  // Control functions

  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    _baseTokenURI = baseURI;
  }

  function setMaxTokenSupply(uint256 maxSupply) public onlyOwner {
    _maxTokenSupply = maxSupply;
  }

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

  // Minting and Burning functions

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

  function burn(uint256 tokenId) public {
    require(_exists(tokenId), 'CKey: token does not exist');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: caller is not owner nor approved'
    );

    _burn(tokenId);

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

  function transfer(address from, address to, uint256 tokenId) public {
    require(to != address(0), 'CKey: transfer to the zero address');
    require(_exists(tokenId), 'CKey: transfer nonexistent token');
    require(isTradable(tokenId), 'CKey: token type can not be traded');
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      'CKey: transfer caller is not owner nor approved'
    );

    _tokenData[tokenId].owner = to;
    _transfer(from, to, tokenId);

    emit CKeyTransferred(ownerOf(tokenId), to, tokenId);
  }

  function depositCCoin(uint256 tokenId, uint256 amount) external {
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

  function withdrawCCoin(uint256 tokenId, uint256 amount) external {
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

  function depositCTicket(uint256 tokenId, uint256 amount) external {
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

  function withdrawCTicket(uint256 tokenId, uint256 amount) external {
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

  // Internal functions

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function _baseURI() internal view override returns (string memory) {
    return _baseTokenURI;
  }

  function _isTokenIdUsed(uint256 tokenId) internal view returns (bool) {
    for (uint256 i = 0; i < _tokenIds.length; i++) {
      if (_tokenIds[i] == tokenId) {
        return true;
      }
    }
    return false;
  }

  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public virtual override(ERC721, IERC721) {
    transfer(from, to, tokenId);
  }
}
