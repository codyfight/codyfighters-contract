// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './CCoin.sol';

contract CTicket is ERC20, Ownable, ReentrancyGuard {
  CCoin public ccoin;
  uint256 public ticketPrice;
  uint256 public initialSupply;

  event CTicketMinted(address indexed owner, uint256 indexed amount);
  event CTicketBurned(address indexed owner, uint256 indexed amount);
  event CTicketTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed amount
  );

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

  function setTicketPrice(uint256 price) external onlyOwner {
    ticketPrice = price;
  }

  function mint(address to, uint256 amount) public onlyOwner nonReentrant {
    require(to != address(0), 'CTicket: mint to the zero address');
    _mint(to, amount);

    emit CTicketMinted(to, amount);
  }

  function burn(uint256 amount) public nonReentrant {
    require(balanceOf(msg.sender) >= amount, 'CTicket: insufficient balance');
    _burn(msg.sender, amount);

    emit CTicketBurned(msg.sender, amount);
  }

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

  function buyTickets(uint256 amount) external nonReentrant {
    uint256 totalCost = amount * ticketPrice;
    uint256 buyedTicketsAmount = amount * 10 ** 18;

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
    _transfer(owner(), msg.sender, buyedTicketsAmount);

    emit CTicketTransferred(owner(), msg.sender, buyedTicketsAmount);
  }

  function transfer(
    address to,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(
      amount >= 1,
      'CTicket: transfer amount must be greater or equal to 1'
    );
    require(amount % 1 == 0, 'CTicket: floating point numbers not allowed');
    require(to != address(0), 'CTicket: transfer to the zero address');
    require(balanceOf(msg.sender) >= amount, 'CTicket: insufficient balance');

    _transfer(_msgSender(), to, amount);

    emit CTicketTransferred(_msgSender(), to, amount);

    return true;
  }

  function approve(
    address spender,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(spender != address(0), 'CTicket: approve to the zero address');

    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(
      amount >= 1,
      'CTicket: transfer amount must be greater or equal to 1'
    );
    require(amount % 1 == 0, 'CTicket: floating point numbers not allowed');
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
