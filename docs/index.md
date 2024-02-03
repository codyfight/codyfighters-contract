# Solidity API

## CCoin

ERC20 token representing CCoin, the official currency of Codyfight.

### CCoinMinted

```solidity
event CCoinMinted(address owner, uint256 amount)
```

_Emitted when a new amount of CCoin tokens is minted._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address to which the minted tokens will be assigned. |
| amount | uint256 | The amount of CCoin tokens minted. |

### CCoinBurned

```solidity
event CCoinBurned(address owner, uint256 amount)
```

_Emitted when a new amount of CCoin tokens is burned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address from which the burned tokens will be removed. |
| amount | uint256 | The amount of CCoin tokens burned. |

### CCoinTransferred

```solidity
event CCoinTransferred(address from, address to, uint256 amount)
```

_Emitted when a new amount of CCoin tokens is transferred._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address from which the tokens will be transferred. |
| to | address | The address to which the tokens will be transferred. |
| amount | uint256 | The amount of CCoin tokens transferred. |

### constructor

```solidity
constructor(uint256 supply, uint256 max) public
```

The maximum supply can be updated by the owner of the contract.

_Constructor to initialize the CCoin token with initial supply and maximum supply. The initial supply is minted to the deployer's address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| supply | uint256 | The initial supply of CCoin tokens. |
| max | uint256 | The maximum supply of CCoin tokens. |

### getInitialSupply

```solidity
function getInitialSupply() external view returns (uint256)
```

This is a public getter method for the initialSupply state variable.

_Returns the initial supply of CCoin tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The initial supply of CCoin tokens. |

### getMaxSupply

```solidity
function getMaxSupply() external view returns (uint256)
```

This is a public getter method for the maxSupply state variable.

_Returns the maximum supply of CCoin tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The maximum supply of CCoin tokens. |

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

This is a public method that can be called by anyone to get the total supply of CCoin tokens.

_Returns the total supply of CCoin tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The total supply of CCoin tokens. |

### setMaxSupply

```solidity
function setMaxSupply(uint256 supply) external
```

This is a restricted function that can only be called by the owner of the contract.

_Sets the maximum supply of CCoin tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| supply | uint256 | The new maximum supply of CCoin tokens. |

### mint

```solidity
function mint(address to, uint256 amount) public
```

This is a restricted function that can only be called by the owner of the contract, since the mint already happens in the contract constructor.

_Mints new CCoin tokens and assigns them to the specified address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to which the minted tokens will be assigned. |
| amount | uint256 | The amount of CCoin tokens to mint. |

### batchMint

```solidity
function batchMint(address[] recipients, uint256[] amounts) public
```

This is a restricted function that can only be called by the owner of the contract.

_Mints new CCoin tokens and assigns them to multiple addresses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipients | address[] | The addresses to which the minted tokens will be assigned. |
| amounts | uint256[] | The amounts of CCoin tokens to mint for each address. |

### burn

```solidity
function burn(uint256 amount) public
```

This is a public method that can be called by anyone to burn their own tokens.

_Burns a specified amount of CCoin tokens from the caller's balance._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The amount of CCoin tokens to burn. |

### transfer

```solidity
function transfer(address to, uint256 amount) public returns (bool)
```

This is a public method that can be called by anyone to transfer their own tokens.

_Transfers tokens from the caller's account to another account._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to which tokens will be transferred. |
| amount | uint256 | The amount of tokens to be transferred. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean value indicating whether the transfer was successful. |

### approve

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

This is a public method that can be called by anyone to approve the spending of their own tokens.

_Approves the specified address to spend the caller's tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| spender | address | The address to which the approval is granted. |
| amount | uint256 | The amount of tokens to approve for spending. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean value indicating whether the approval was successful. |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool)
```

This is a public method that can be called by anyone to transfer tokens from one address to another.

_Transfers tokens from one address to another._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address from which tokens will be transferred. |
| to | address | The address to which tokens will be transferred. |
| amount | uint256 | The amount of tokens to be transferred. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean value indicating whether the transfer was successful. |

## CTicket

ERC20 token representing CTicket, the official in-game competitive arena entry fee of Codyfight matches.
CTickets tokens can be purchased using CCoin tokens.

### ccoin

```solidity
contract CCoin ccoin
```

_The CCoin token contract._

### ticketPrice

```solidity
uint256 ticketPrice
```

### initialSupply

```solidity
uint256 initialSupply
```

### CTicketMinted

```solidity
event CTicketMinted(address owner, uint256 amount)
```

_Emitted when a new amount of CTicket tokens is minted._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address to which the minted tokens will be assigned. |
| amount | uint256 | The amount of CTicket tokens minted. |

### CTicketBurned

```solidity
event CTicketBurned(address owner, uint256 amount)
```

_Emitted when a new amount of CTicket tokens is burned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address from which the burned tokens will be removed. |
| amount | uint256 | The amount of CTicket tokens burned. |

### CTicketTransferred

```solidity
event CTicketTransferred(address from, address to, uint256 amount)
```

_Emitted when a new amount of CTicket tokens is transferred._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address from which the tokens will be transferred. |
| to | address | The address to which the tokens will be transferred. |
| amount | uint256 | The amount of CTicket tokens transferred. |

### constructor

```solidity
constructor(address ccoinAddress, uint256 supply, uint256 price) public
```

The price of each token can be updated by the owner of the contract.

_Constructor to initialize the CTicket contract. It initializes the initial supply of CTicket tokens and the price of each token. The initial supply is minted to the deployer's address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| ccoinAddress | address | The address of the CCoin contract. |
| supply | uint256 | The initial supply of CTicket tokens. |
| price | uint256 | The initial price of each CTicket token. |

### getTicketPrice

```solidity
function getTicketPrice() external view returns (uint256)
```

The price of each token can change over time. The currency used to buy CTicket tokens is CCoin.

_Returns the price of each CTicket token._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The price of each CTicket token. |

### getInitialSupply

```solidity
function getInitialSupply() external view returns (uint256)
```

The initial supply is the amount of CTicket tokens minted when the contract is deployed.

_Returns the initial supply of CTicket tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The initial supply of CTicket tokens. |

### setTicketPrice

```solidity
function setTicketPrice(uint256 price) public
```

The ticket price can change over time. This function allows the owner of the contract to update the ticket price.
This function can only be called by the owner of the contract.

_Sets the ticket price._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| price | uint256 | The new ticket price. |

### mint

```solidity
function mint(address to, uint256 amount) public
```

This function allows the owner of the contract to mint new CTicket tokens and assign them to a recipient.
This function can only be called by the owner of the contract.

_Mints CTicket tokens and assigns them to the specified recipient._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to which the CTicket tokens will be minted. |
| amount | uint256 | The amount of CTicket tokens to mint. |

### burn

```solidity
function burn(uint256 amount) public
```

This function allows users to burn their CTicket tokens.

_Burns CTicket tokens from the caller's balance._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The amount of CTicket tokens to burn. |

### batchMint

```solidity
function batchMint(address[] recipients, uint256[] amounts) public
```

This function allows the owner of the contract to mint new CTicket tokens and assign them to multiple recipients.
This function can only be called by the owner of the contract.

_Mints CTicket tokens to multiple recipients._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipients | address[] | The addresses to which the CTicket tokens will be minted. |
| amounts | uint256[] | The amounts of CTicket tokens to mint for each recipient. |

### buyTickets

```solidity
function buyTickets(uint256 amount) public
```

This function allows users to buy CTicket tokens by transferring CCoin tokens to the contract.

_Allows users to buy CTicket tokens by transferring CCoin tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The amount of CTicket tokens to buy. |

### approve

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

This function allows users to approve the spending of their CTicket tokens by another address.

_Overrides ERC20 approve function to enforce specific conditions._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| spender | address | The address to which the approval is granted. |
| amount | uint256 | The amount of CTicket tokens to approve for spending. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool Returns true if the approval was successful. |

### transfer

```solidity
function transfer(address to, uint256 amount) public returns (bool)
```

This function allows users to transfer their CTicket tokens to another address.

_Overrides ERC20 transfer function to enforce specific conditions._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to which the CTicket tokens will be transferred. |
| amount | uint256 | The amount of CTicket tokens to transfer. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool Returns true if the transfer was successful. |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool)
```

This function allows users to transfer CTicket tokens from one address to another.

_Overrides ERC20 transferFrom function to enforce specific conditions._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address from which the CTicket tokens will be transferred. |
| to | address | The address to which the CTicket tokens will be transferred. |
| amount | uint256 | The amount of CTicket tokens to transfer. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool Returns true if the transfer was successful. |

## CKey

Ckey is an ERC721 standard compliant NFT, used to start battles and to hold CCoin and CTicket tokens in-game.

### CKeyType

Native CKeys are earn for free on registration, they do not expire. Cannot be traded.
Permanent CKeys are minted on purchase, they do not expire. Can be traded.
Flexible CKeys can be subscribed, they expire after a certain time. Can be traded if not expired.

_Enum defining the types of CKeys._

```solidity
enum CKeyType {
  Native,
  Permanent,
  Flexible
}
```

### DepositType

CCoin deposits, in-game currency.
CTicket deposits, competitive match entry tickets.

_Enum defining the types of asset deposits._

```solidity
enum DepositType {
  CCoin,
  CTicket
}
```

### TokenData

_Struct defining the data associated with a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct TokenData {
  uint256 tokenId;
  address owner;
  string tokenURI;
  enum CKey.CKeyType cKeyType;
  uint32 expirationTimestamp;
}
```

### _cCoinToken

```solidity
contract IERC20 _cCoinToken
```

_The CCoin token contract._

### _cTicketToken

```solidity
contract IERC20 _cTicketToken
```

_The CTicket token contract._

### CCoinDeposited

```solidity
event CCoinDeposited(address owner, uint256 tokenId, uint256 amount)
```

_Emitted when CCoin tokens are deposited into a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |
| amount | uint256 | The amount of CCoin tokens deposited. |

### CCoinWithdrawn

```solidity
event CCoinWithdrawn(address owner, uint256 tokenId, uint256 amount)
```

_Emitted when CCoin tokens are withdrawn from a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |
| amount | uint256 | The amount of CCoin tokens withdrawn. |

### CTicketDeposited

```solidity
event CTicketDeposited(address owner, uint256 tokenId, uint256 amount)
```

_Emitted when CTicket tokens are deposited into a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |
| amount | uint256 | The amount of CTicket tokens deposited. |

### CTicketWithdrawn

```solidity
event CTicketWithdrawn(address owner, uint256 tokenId, uint256 amount)
```

_Emitted when CTicket tokens are withdrawn from a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |
| amount | uint256 | The amount of CTicket tokens withdrawn. |

### CKeyMinted

```solidity
event CKeyMinted(address owner, uint256 tokenId)
```

_Emitted when a CKey token is minted._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |

### CKeyBurned

```solidity
event CKeyBurned(address owner, uint256 tokenId)
```

_Emitted when a CKey token is burned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |

### CKeyTransferred

```solidity
event CKeyTransferred(address from, address to, uint256 tokenId)
```

_Emitted when a CKey token is transferred._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address the token is transferred from. |
| to | address | The address the token is transferred to. |
| tokenId | uint256 | The ID of the token. |

### constructor

```solidity
constructor(address cCoinAddress, address cTicketAddress, uint256 maxSupply) public
```

_CKey constructor. Sets the base URI for token metadata and initializes the CCoin and CTicket token contracts, along with the maximum token supply._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| cCoinAddress | address | The address of the CCoin token contract. |
| cTicketAddress | address | The address of the CTicket token contract. |
| maxSupply | uint256 | The maximum token supply. |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.

_Returns the token URI for the given token ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to retrieve the URI for. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | uint256 The token URI. |

### getTokenData

```solidity
function getTokenData(uint256 tokenId) public view returns (struct CKey.TokenData)
```

The token data contains information about the token, such as its owner, type, and expiration timestamp.

_Returns the data associated with the given token ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to retrieve the data for. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct CKey.TokenData | uint256 The token data. |

### getAllTokens

```solidity
function getAllTokens() public view returns (struct CKey.TokenData[])
```

The token data contains information about the token, such as its owner, type, and expiration timestamp.

_Returns an array containing data for all tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct CKey.TokenData[] | array An array of token data. |

### getBalance

```solidity
function getBalance(uint256 tokenId, enum CKey.DepositType depositType) public view returns (uint256)
```

_Returns the balance of the given deposit type for the given token ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to retrieve the balance for. |
| depositType | enum CKey.DepositType | The type of the deposit to retrieve the balance for. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The balance of the deposit type for the token. |

### getMaxTokenSupply

```solidity
function getMaxTokenSupply() public view returns (uint256)
```

The maximum token supply is the maximum number of tokens that can be minted.

_Returns the maximum token supply._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The maximum token supply. |

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

The total number of tokens minted is the total number of tokens that have been minted.

_Returns the total number of tokens minted._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The total number of tokens minted. |

### isTradable

```solidity
function isTradable(uint256 tokenId) public view returns (bool)
```

A token is tradable if it is a permanent CKey or a flexible CKey that has not expired.

_Checks if the token with the given ID is tradable._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the token is tradable. |

### pause

```solidity
function pause() public
```

While the contract is paused, no new tokens can be minted.
Only the contract owner can pause the contract.

_Pauses the contract._

### unpause

```solidity
function unpause() public
```

While the contract is unpaused, new tokens can be minted.
Only the contract owner can unpause the contract.

_Unpauses the contract._

### setBaseURI

```solidity
function setBaseURI(string baseURI) public
```

The base URI is the base URL for the token metadata. It is used to construct the full token URI.
Only the contract owner can set the base URI.

_Sets the base URI for token metadata._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| baseURI | string | The base URI to set. |

### setMaxTokenSupply

```solidity
function setMaxTokenSupply(uint256 maxSupply) public
```

The maximum token supply is the maximum number of tokens that can be minted.
Only the contract owner can set the maximum token supply.

_Sets the maximum token supply._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| maxSupply | uint256 | The maximum token supply to set. |

### updateTokenURIs

```solidity
function updateTokenURIs() public
```

The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
Only the contract owner can update the token URIs.

_Updates the token URIs for all tokens. This is useful when the base URI is changed._

### safeMint

```solidity
function safeMint(address to, uint256 tokenId, enum CKey.CKeyType cKeyType, uint32 expirationTimestamp) public
```

Only the contract owner can mint new tokens, since this is a in-game asset, its controlled by the game server.

_Mints a new CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to mint the token to. |
| tokenId | uint256 | The ID of the token to mint. |
| cKeyType | enum CKey.CKeyType | The type of the CKey. |
| expirationTimestamp | uint32 | The expiration timestamp for flexible CKeys. |

### burn

```solidity
function burn(uint256 tokenId) public
```

Only the token owner or an approved address can burn a token.

_Burns the specified CKey token. Calls the overridden internal _burn method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) public virtual
```

Only the token owner or an approved address can transfer a token.

_Transfers a CKey token from one address to another._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address to transfer the token from. |
| to | address | The address to transfer the token to. |
| tokenId | uint256 | The ID of the token to transfer. |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public virtual
```

Only the token owner or an approved address can transfer a token.

_Safely transfers a CKey token from one address to another._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address to transfer the token from. |
| to | address | The address to transfer the token to. |
| tokenId | uint256 | The ID of the token to transfer. |
| _data | bytes | Additional data with no specified format. |

### depositCCoin

```solidity
function depositCCoin(uint256 tokenId, uint256 amount) public
```

The caller must have approved the contract to transfer the specified amount of CCoin tokens.

_Deposits CCoin tokens into a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to deposit into. |
| amount | uint256 | The amount of CCoin tokens to deposit. |

### withdrawCCoin

```solidity
function withdrawCCoin(uint256 tokenId, uint256 amount) public
```

The caller must have a sufficient balance of CCoin tokens in the CKey token.

_Withdraws CCoin tokens from a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to withdraw from. |
| amount | uint256 | The amount of CCoin tokens to withdraw. |

### depositCTicket

```solidity
function depositCTicket(uint256 tokenId, uint256 amount) public
```

The caller must have approved the contract to transfer the specified amount of CTicket tokens.

_Deposits CTicket tokens into a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to deposit into. |
| amount | uint256 | The amount of CTicket tokens to deposit. |

### withdrawCTicket

```solidity
function withdrawCTicket(uint256 tokenId, uint256 amount) public
```

The caller must have a sufficient balance of CTicket tokens in the CKey token.

_Withdraws CTicket tokens from a CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to withdraw from. |
| amount | uint256 | The amount of CTicket tokens to withdraw. |

### _burn

```solidity
function _burn(uint256 tokenId) internal
```

Only the token owner or an approved address can burn a token.

_Burns the specified CKey token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |

### _baseURI

```solidity
function _baseURI() internal view returns (string)
```

The base URI is the base URL for the token metadata. It is used to construct the full token URI.

_Returns the base URI for token metadata._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | string The base URI. |

### _isTokenIdUsed

```solidity
function _isTokenIdUsed(uint256 tokenId) internal view returns (bool)
```

A token ID is already used if it is already minted.

_Checks if the given token ID is already used._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the token ID is already used. |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

The contract supports the ERC721 and ERC721URIStorage interfaces.

_Checks if the contract supports the given interface._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceId | bytes4 | The interface identifier. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the contract supports the interface. |

## Codyfighter

Genesis Codyfighter NFT collection contract compliant with the ERC721 standard.

### TokenData

_The TokenData struct for storing token data._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct TokenData {
  uint256 tokenId;
  address owner;
  string tokenURI;
}
```

### AllowedList

_The AllowedList struct for storing allowed addresses and their associated token IDs._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct AllowedList {
  address addr;
  uint256[] id;
}
```

### CFighterMinted

```solidity
event CFighterMinted(address owner, uint256 tokenId)
```

_Emitted when a new Codyfighter token is minted._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |

### CFighterBurned

```solidity
event CFighterBurned(address owner, uint256 tokenId)
```

_Emitted when a Codyfighter token is burned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The address of the token owner. |
| tokenId | uint256 | The ID of the token. |

### CFighterTransferred

```solidity
event CFighterTransferred(address from, address to, uint256 tokenId)
```

_Emitted when a Codyfighter token is transferred._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address to transfer the token from. |
| to | address | The address to transfer the token to. |
| tokenId | uint256 | The ID of the token. |

### constructor

```solidity
constructor(uint256 max) public
```

_Constructs the Codyfighter contract._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| max | uint256 | The maximum token supply allowed. |

### isContractOwner

```solidity
function isContractOwner(address addr) public view returns (bool)
```

A contract owner is the address that deployed the contract.
This method is public and can be called by any address.

_Checks if the given address is the contract owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| addr | address | The address to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the address is the contract owner. |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
This method is public and can be called by any address.

_Returns the URI for a given token ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | string The URI string of the token. |

### getAllTokens

```solidity
function getAllTokens() public view returns (struct Codyfighter.TokenData[])
```

Returns a list of all tokens and their associated data.
This method is public and can be called by any address.

_Returns an array of TokenData for all tokens._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Codyfighter.TokenData[] | array An array of TokenData. |

### getTokenData

```solidity
function getTokenData(uint256 tokenId) public view returns (struct Codyfighter.TokenData)
```

The TokenData contains information about the token, such as its ID, owner, and metadata URI.
This method is public and can be called by any address.

_Returns the TokenData for a given token ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Codyfighter.TokenData | array The TokenData of the token. |

### getMaxTokenSupply

```solidity
function getMaxTokenSupply() public view returns (uint256)
```

The maximum token supply is the maximum number of tokens that can be minted.
This method is public and can be called by any address.

_Returns the maximum token supply allowed._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The maximum token supply. |

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

The current token supply is the number of tokens that have been minted.
This method is public and can be called by any address.

_Returns the current token supply._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | uint256 The current token supply. |

### getAllowedAddresses

```solidity
function getAllowedAddresses() public view returns (struct Codyfighter.AllowedList[])
```

Returns a list of all allowed addresses and their associated token IDs, previously added by the contract owner.
This method is public and can be called by any address.

_Returns an array of allowed addresses and their associated token IDs._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct Codyfighter.AllowedList[] | array An array of AllowedList structs. |

### isAllowedToMint

```solidity
function isAllowedToMint(address addr) public view returns (bool)
```

If an address is allowed to mint tokens, it means that the address is included in the allowed list.
This method is public and can be called by any address.

_Checks if an address is allowed to mint tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| addr | address | The address to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the address is allowed to mint tokens. |

### pause

```solidity
function pause() public
```

While the contract is paused, no new tokens can be minted.
This method is public but can only be called by the contract owner.

_Pauses token minting._

### unpause

```solidity
function unpause() public
```

While the contract is unpaused, new tokens can be minted.
This method is public but can only be called by the contract owner.

_Unpauses token minting._

### setBaseURI

```solidity
function setBaseURI(string baseURI) public
```

This method is public but can only be called by the contract owner.

_Sets the base URI for token metadata._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| baseURI | string | The base URI to set. |

### setMaxTokenSupply

```solidity
function setMaxTokenSupply(uint256 maxSupply) public
```

This method is public but can only be called by the contract owner.

_Sets the maximum token supply allowed._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| maxSupply | uint256 | The maximum token supply to set. |

### updateTokenURIs

```solidity
function updateTokenURIs() public
```

The token URI is the metadata URI for the token. It contains information about the token, such as its name, image, and other attributes.
This method is public but can only be called by the contract owner.

_Updates the token URIs for all tokens. This is useful when the base URI is changed._

### addAllowedAddress

```solidity
function addAllowedAddress(struct Codyfighter.AllowedList[] newAllowedList) public
```

The allowed list is a list of addresses that are allowed to mint tokens.
Each address can have a list of token IDs that it is allowed to mint (Codyfighters owned by the address in-game).
This method is public but can only be called by the contract owner.

_Adds a list of addresses to the allowed list. This does not override the existing list._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newAllowedList | struct Codyfighter.AllowedList[] | The list of addresses and their associated permited token IDs to add. |

### addIdToAllowedAddress

```solidity
function addIdToAllowedAddress(address addr, uint256[] newIds) public
```

This method is public but can only be called by the contract owner.

_Adds token IDs to the allowed list for a specific address that was previously added._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| addr | address | The address to add token IDs to. |
| newIds | uint256[] | The token IDs to add. |

### safeMint

```solidity
function safeMint(address to, uint256 tokenId) public
```

This method is public and can be called by any address that is included in the allowed list.

_Mints a new Codyfighter token for a allowed address, and removes the address from the allowed list._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to mint the token to. |
| tokenId | uint256 | The ID of the token to mint. |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) public virtual
```

This method is public and can be called by the token owner or an approved address.

_Transfers ownership of a token from one address to another._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address to transfer the token from. |
| to | address | The address to transfer the token to. |
| tokenId | uint256 | The ID of the token to transfer. |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public virtual
```

This method is public and can be called by the token owner or an approved address.

_Safely transfers ownership of a token from one address to another._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address to transfer the token from. |
| to | address | The address to transfer the token to. |
| tokenId | uint256 | The ID of the token to transfer. |
| _data | bytes | Additional data with no specified format to include in the call to `to`. |

### burn

```solidity
function burn(uint256 tokenId) public
```

This method is public and can be called by the token owner or an approved address.

_Burns a token. Calls the overridden internal _burn method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |

### _burn

```solidity
function _burn(uint256 tokenId) internal
```

This method is internal and can only be called internally.

_Burns a token. Overrides the ERC721URIStorage _burn method, removing the token from the tokenIds array._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |

### _baseURI

```solidity
function _baseURI() internal view returns (string)
```

This method is internal and can only be called internally.

_Returns the base URI for token metadata._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | string The base URI string. |

### _isTokenIdUsed

```solidity
function _isTokenIdUsed(uint256 tokenId) internal view returns (bool)
```

This method is internal and can only be called internally.

_Checks if a token ID is already used._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool A boolean indicating whether the token ID is already used. |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

This method is public and can be called by any address.

_Returns whether the contract supports the given interface._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceId | bytes4 | The interface identifier. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool True if the contract supports the interface, false otherwise. |

