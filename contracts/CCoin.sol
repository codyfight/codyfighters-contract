// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract CCoin is ERC20, Ownable, ReentrancyGuard {
    uint256 public initialSupply;
    uint256 public maxSupply;

    constructor(uint256 supply, uint256 max) ERC20('CCoin Dev', 'CCoinDev') {
        initialSupply = supply;
        maxSupply = max;

        _mint(msg.sender, initialSupply);
    }

    function getInitialSupply() external view returns (uint256) {
        return initialSupply;
    }

    function getMaxSupply() external view returns (uint256) {
        return maxSupply;
    }

    function setMaxSupply(uint256 supply) external onlyOwner {
        maxSupply = supply;
    }

    function mint(address to, uint256 amount) public onlyOwner nonReentrant {
        require(to != address(0), 'CCoin: mint to the zero address');
        require(amount > 0, 'CCoin: amount must be greater than zero');
        require(
            totalSupply() + amount <= maxSupply,
            'CCoin: total supply exceeds max supply'
        );

        _mint(to, amount);
    }

    function batchMint(
        address[] memory recipients,
        uint256[] memory amounts
    ) public onlyOwner nonReentrant {
        require(
            recipients.length == amounts.length,
            'CCoin: arrays length mismatch'
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            require(
                recipients[i] != address(0),
                'CCoin: mint to the zero address'
            );

            require(amounts[i] > 0, 'CCoin: amount must be greater than zero');

            require(
                totalSupply() + amounts[i] <= maxSupply,
                'CCoin: total supply exceeds max supply'
            );

            _mint(recipients[i], amounts[i]);
        }
    }

    function burn(uint256 amount) public nonReentrant {
        require(balanceOf(msg.sender) >= amount, 'CCoin: insufficient balance');
        _burn(msg.sender, amount);
    }

    function transfer(
        address to,
        uint256 amount
    ) public override nonReentrant returns (bool) {
        require(to != address(0), 'CCoin: transfer to the zero address');
        require(amount > 0, 'CCoin: transfer amount must be greater than zero');
        require(balanceOf(msg.sender) >= amount, 'CCoin: insufficient balance');

        _transfer(_msgSender(), to, amount);
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override nonReentrant returns (bool) {
        require(spender != address(0), 'CCoin: approve to the zero address');

        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override nonReentrant returns (bool) {
        require(to != address(0), 'CCoin: transfer to the zero address');
        require(amount > 0, 'CCoin: transfer amount must be greater than zero');
        require(balanceOf(from) >= amount, 'CCoin: insufficient balance');

        uint256 currentAllowance = allowance(from, msg.sender);
        require(
            currentAllowance >= amount,
            'CCoin: transfer amount exceeds allowance'
        );

        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);
        return true;
    }

    function totalSupply() public view override returns (uint256) {
        return super.totalSupply();
    }
}
