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

    constructor(
        address ccoinAddress,
        uint256 supply,
        uint256 price
    ) ERC20('CTicket Dev', 'CTicketDev') {
        initialSupply = supply;
        ticketPrice = price;
        ccoin = CCoin(ccoinAddress);

        _mint(msg.sender, initialSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return super.totalSupply();
    }

    function getInitialSupply() external view returns (uint256) {
        return initialSupply;
    }

    function getTicketPrice() external view returns (uint256) {
        return ticketPrice;
    }

    function setTicketPrice(uint256 price) external onlyOwner {
        ticketPrice = price;
    }

    function mint(address to, uint256 amount) public onlyOwner nonReentrant {
        require(to != address(0), 'CTicket: mint to the zero address');
        _mint(to, amount);
    }

    function burn(uint256 amount) public nonReentrant {
        require(
            balanceOf(msg.sender) >= amount,
            'CTicket: insufficient balance'
        );
        _burn(msg.sender, amount);
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
            require(
                recipients[i] != address(0),
                'CTicket: mint to the zero address'
            );
            _mint(recipients[i], amounts[i]);
        }
    }

    function buyTickets(uint256 amount) external nonReentrant {
        uint256 totalCost = amount * ticketPrice;

        require(amount > 0, 'CTicket: amount must be greater than zero');

        require(
            ccoin.allowance(msg.sender, address(this)) >= totalCost,
            'CTicket: allowance not set'
        );

        ccoin.transferFrom(msg.sender, address(this), totalCost);

        if (totalSupply() >= amount) {
            _transfer(owner(), msg.sender, amount);
        } else {
            _mint(owner(), initialSupply + amount);
            _transfer(owner(), msg.sender, amount);
        }
    }

    function transfer(
        address to,
        uint256 amount
    ) public override nonReentrant returns (bool) {
        require(to != address(0), 'CTicket: transfer to the zero address');
        require(
            amount > 0,
            'CTicket: transfer amount must be greater than zero'
        );
        require(
            balanceOf(msg.sender) >= amount,
            'CTicket: insufficient balance'
        );

        _transfer(_msgSender(), to, amount);
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
        require(to != address(0), 'CTicket: transfer to the zero address');
        require(
            amount > 0,
            'CTicket: transfer amount must be greater than zero'
        );
        require(balanceOf(from) >= amount, 'CTicket: insufficient balance');

        uint256 currentAllowance = allowance(from, msg.sender);
        require(
            currentAllowance >= amount,
            'CTicket: transfer amount exceeds allowance'
        );

        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);
        return true;
    }
}
