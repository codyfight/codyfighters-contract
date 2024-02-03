// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './CCoin.sol';

/**
 * @title Codyfight - CTicket Token
 * @author Codyfight
 * @notice ERC20 token representing CTicket, the official in-game competitive arena entry fee of Codyfight matches.
 * @notice CTickets tokens can be purchased using CCoin tokens.
 */
contract CTicket is ERC20, Ownable, ReentrancyGuard {
  // *** State variables ***

  /**
   * @dev The CCoin token contract.
   */
  CCoin public ccoin;

  uint256 public ticketPrice;
  uint256 public initialSupply;

  // *** Events ***

  /**
   * @dev Emitted when a new amount of CTicket tokens is minted.
   * @param owner The address to which the minted tokens will be assigned.
   * @param amount The amount of CTicket tokens minted.
   */
  event CTicketMinted(address indexed owner, uint256 indexed amount);

  /**
   * @dev Emitted when a new amount of CTicket tokens is burned.
   * @param owner The address from which the burned tokens will be removed.
   * @param amount The amount of CTicket tokens burned.
   */
  event CTicketBurned(address indexed owner, uint256 indexed amount);

  /**
   * @dev Emitted when a new amount of CTicket tokens is transferred.
   * @param from The address from which the tokens will be transferred.
   * @param to The address to which the tokens will be transferred.
   * @param amount The amount of CTicket tokens transferred.
   */
  event CTicketTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed amount
  );

  /**
   * @dev Constructor to initialize the CTicket contract. It initializes the initial supply of CTicket tokens and the price of each token. The initial supply is minted to the deployer's address.
   * @notice The price of each token can be updated by the owner of the contract.
   * @param ccoinAddress The address of the CCoin contract.
   * @param supply The initial supply of CTicket tokens.
   * @param price The initial price of each CTicket token.
   */
  constructor(
    address ccoinAddress,
    uint256 supply,
    uint256 price
  ) ERC20('CTicket', 'CTicket') {
    initialSupply = supply;
    ticketPrice = price;
    ccoin = CCoin(ccoinAddress);

    _mint(msg.sender, initialSupply);
  }

  // *** Public getter methods ***

  /**
   * @dev Returns the price of each CTicket token.
   * @notice The price of each token can change over time. The currency used to buy CTicket tokens is CCoin.
   * @return uint256 The price of each CTicket token.
   */
  function getTicketPrice() external view returns (uint256) {
    return ticketPrice;
  }

  /**
   * @dev Returns the initial supply of CTicket tokens.
   * @notice The initial supply is the amount of CTicket tokens minted when the contract is deployed.
   * @return uint256 The initial supply of CTicket tokens.
   */
  function getInitialSupply() external view returns (uint256) {
    return initialSupply;
  }

  // *** Control methods ***

  /**
   * @dev Sets the ticket price.
   * @notice The ticket price can change over time. This function allows the owner of the contract to update the ticket price.
   * @notice This function can only be called by the owner of the contract.
   * @param price The new ticket price.
   */
  function setTicketPrice(uint256 price) public onlyOwner {
    ticketPrice = price;
  }

  // *** Transaction methods ***

  /**
   * @dev Mints CTicket tokens and assigns them to the specified recipient.
   * @notice This function allows the owner of the contract to mint new CTicket tokens and assign them to a recipient.
   * @notice This function can only be called by the owner of the contract.
   * @param to The address to which the CTicket tokens will be minted.
   * @param amount The amount of CTicket tokens to mint.
   */
  function mint(address to, uint256 amount) public onlyOwner nonReentrant {
    require(to != address(0), 'CTicket: mint to the zero address');
    _mint(to, amount);

    emit CTicketMinted(to, amount);
  }

  /**
   * @dev Burns CTicket tokens from the caller's balance.
   * @notice This function allows users to burn their CTicket tokens.
   * @param amount The amount of CTicket tokens to burn.
   */
  function burn(uint256 amount) public nonReentrant {
    require(balanceOf(msg.sender) >= amount, 'CTicket: insufficient balance');
    _burn(msg.sender, amount);

    emit CTicketBurned(msg.sender, amount);
  }

  /**
   * @dev Mints CTicket tokens to multiple recipients.
   * @notice This function allows the owner of the contract to mint new CTicket tokens and assign them to multiple recipients.
   * @notice This function can only be called by the owner of the contract.
   * @param recipients The addresses to which the CTicket tokens will be minted.
   * @param amounts The amounts of CTicket tokens to mint for each recipient.
   */
  function batchMint(
    address[] memory recipients,
    uint256[] memory amounts
  ) public onlyOwner nonReentrant {
    require(
      recipients.length == amounts.length,
      'CTicket: arrays length mismatch'
    );

    for (uint256 i = 0; i < recipients.length; i++) {
      require(recipients[i] != address(0), 'CTicket: mint to the zero address');
      _mint(recipients[i], amounts[i]);

      emit CTicketMinted(recipients[i], amounts[i]);
    }
  }

  /**
   * @dev Allows users to buy CTicket tokens by transferring CCoin tokens.
   * @notice This function allows users to buy CTicket tokens by transferring CCoin tokens to the contract.
   * @param amount The amount of CTicket tokens to buy.
   */
  function buyTickets(uint256 amount) public nonReentrant {
    uint256 totalCost = amount * ticketPrice;
    uint256 boughtTicketsAmount = amount * 10 ** 18;

    require(
      amount >= 1,
      'CTicket: transfer amount must be greater or equal to 1'
    );
    require(amount % 1 == 0, 'CTicket: floating point numbers not allowed');
    require(
      ccoin.allowance(msg.sender, address(this)) >= totalCost,
      'CTicket: allowance not set'
    );

    ccoin.transferFrom(msg.sender, address(this), totalCost);
    _transfer(owner(), msg.sender, boughtTicketsAmount);

    emit CTicketTransferred(owner(), msg.sender, boughtTicketsAmount);
  }

  /**
   * @dev Overrides ERC20 approve function to enforce specific conditions.
   * @notice This function allows users to approve the spending of their CTicket tokens by another address.
   * @param spender The address to which the approval is granted.
   * @param amount The amount of CTicket tokens to approve for spending.
   * @return bool Returns true if the approval was successful.
   */
  function approve(
    address spender,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(spender != address(0), 'CTicket: approve to the zero address');

    _approve(_msgSender(), spender, amount);

    return true;
  }

  /**
   * @dev Overrides ERC20 transfer function to enforce specific conditions.
   * @notice This function allows users to transfer their CTicket tokens to another address.
   * @param to The address to which the CTicket tokens will be transferred.
   * @param amount The amount of CTicket tokens to transfer.
   * @return bool Returns true if the transfer was successful.
   */
  function transfer(
    address to,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(
      amount >= 1,
      'CTicket: transfer amount must be greater or equal to 1'
    );
    require(to != address(0), 'CTicket: transfer to the zero address');
    require(balanceOf(msg.sender) >= amount, 'CTicket: insufficient balance');

    _transfer(_msgSender(), to, amount);

    emit CTicketTransferred(_msgSender(), to, amount);

    return true;
  }

  /**
   * @dev Overrides ERC20 transferFrom function to enforce specific conditions.
   * @notice This function allows users to transfer CTicket tokens from one address to another.
   * @param from The address from which the CTicket tokens will be transferred.
   * @param to The address to which the CTicket tokens will be transferred.
   * @param amount The amount of CTicket tokens to transfer.
   * @return bool Returns true if the transfer was successful.
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(
      amount >= 1,
      'CTicket: transfer amount must be greater or equal to 1'
    );
    require(to != address(0), 'CTicket: transfer to the zero address');
    require(balanceOf(from) >= amount, 'CTicket: insufficient balance');

    uint256 currentAllowance = allowance(from, msg.sender);

    require(
      currentAllowance >= amount,
      'CTicket: transfer amount exceeds allowance'
    );

    _transfer(from, to, amount);
    _approve(from, msg.sender, currentAllowance - amount);

    emit CTicketTransferred(from, to, amount);

    return true;
  }
}
