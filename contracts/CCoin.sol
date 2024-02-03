// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

/**
 * @title Codyfight - CCoin Token
 * @author Codyfight
 * @notice ERC20 token representing CCoin, the official currency of Codyfight.
 */
contract CCoin is ERC20, Ownable, ReentrancyGuard {
  // *** State variables ***
  uint256 private initialSupply;
  uint256 private maxSupply;

  // *** Events ***

  /**
   * @dev Emitted when a new amount of CCoin tokens is minted.
   * @param owner The address to which the minted tokens will be assigned.
   * @param amount The amount of CCoin tokens minted.
   */
  event CCoinMinted(address indexed owner, uint256 indexed amount);

  /**
   * @dev Emitted when a new amount of CCoin tokens is burned.
   * @param owner The address from which the burned tokens will be removed.
   * @param amount The amount of CCoin tokens burned.
   */
  event CCoinBurned(address indexed owner, uint256 indexed amount);

  /**
   * @dev Emitted when a new amount of CCoin tokens is transferred.
   * @param from The address from which the tokens will be transferred.
   * @param to The address to which the tokens will be transferred.
   * @param amount The amount of CCoin tokens transferred.
   */
  event CCoinTransferred(
    address indexed from,
    address indexed to,
    uint256 indexed amount
  );

  /**
   * @dev Constructor to initialize the CCoin token with initial supply and maximum supply. The initial supply is minted to the deployer's address.
   * @notice The maximum supply can be updated by the owner of the contract.
   * @param supply The initial supply of CCoin tokens.
   * @param max The maximum supply of CCoin tokens.
   */
  constructor(uint256 supply, uint256 max) ERC20('CCoin', 'CCoin') {
    initialSupply = supply;
    maxSupply = max;

    _mint(msg.sender, initialSupply);
  }

  // *** Public getter methods ***

  /**
   * @dev Returns the initial supply of CCoin tokens.
   * @notice This is a public getter method for the initialSupply state variable.
   * @return uint256 The initial supply of CCoin tokens.
   */
  function getInitialSupply() external view returns (uint256) {
    return initialSupply;
  }

  /**
   * @dev Returns the maximum supply of CCoin tokens.
   * @notice This is a public getter method for the maxSupply state variable.
   * @return uint256 The maximum supply of CCoin tokens.
   */
  function getMaxSupply() external view returns (uint256) {
    return maxSupply;
  }

  /**
   * @dev Returns the total supply of CCoin tokens.
   * @notice This is a public method that can be called by anyone to get the total supply of CCoin tokens.
   * @return uint256 The total supply of CCoin tokens.
   */
  function totalSupply() public view override returns (uint256) {
    return super.totalSupply();
  }

  // *** Control methods ***

  /**
   * @dev Sets the maximum supply of CCoin tokens.
   * @notice This is a restricted function that can only be called by the owner of the contract.
   * @param supply The new maximum supply of CCoin tokens.
   */
  function setMaxSupply(uint256 supply) external onlyOwner {
    maxSupply = supply;
  }

  // *** Transaction methods ***

  /**
   * @dev Mints new CCoin tokens and assigns them to the specified address.
   * @notice This is a restricted function that can only be called by the owner of the contract, since the mint already happens in the contract constructor.
   * @param to The address to which the minted tokens will be assigned.
   * @param amount The amount of CCoin tokens to mint.
   */
  function mint(address to, uint256 amount) public onlyOwner nonReentrant {
    require(to != address(0), 'CCoin: mint to the zero address');
    require(amount > 0, 'CCoin: amount must be greater than zero');
    require(
      totalSupply() + amount <= maxSupply,
      'CCoin: total supply exceeds max supply'
    );

    _mint(to, amount);

    emit CCoinMinted(to, amount);
  }

  /**
   * @dev Mints new CCoin tokens and assigns them to multiple addresses.
   * @notice This is a restricted function that can only be called by the owner of the contract.
   * @param recipients The addresses to which the minted tokens will be assigned.
   * @param amounts The amounts of CCoin tokens to mint for each address.
   */
  function batchMint(
    address[] memory recipients,
    uint256[] memory amounts
  ) public onlyOwner nonReentrant {
    require(
      recipients.length == amounts.length,
      'CCoin: arrays length mismatch'
    );

    for (uint256 i = 0; i < recipients.length; i++) {
      require(recipients[i] != address(0), 'CCoin: mint to the zero address');
      require(amounts[i] > 0, 'CCoin: amount must be greater than zero');
      require(
        totalSupply() + amounts[i] <= maxSupply,
        'CCoin: total supply exceeds max supply'
      );

      _mint(recipients[i], amounts[i]);

      emit CCoinMinted(recipients[i], amounts[i]);
    }
  }

  /**
   * @dev Burns a specified amount of CCoin tokens from the caller's balance.
   * @notice This is a public method that can be called by anyone to burn their own tokens.
   * @param amount The amount of CCoin tokens to burn.
   */
  function burn(uint256 amount) public nonReentrant {
    require(balanceOf(msg.sender) >= amount, 'CCoin: insufficient balance');
    _burn(msg.sender, amount);

    emit CCoinBurned(msg.sender, amount);
  }

  /**
   * @dev Transfers tokens from the caller's account to another account.
   * @notice This is a public method that can be called by anyone to transfer their own tokens.
   * @param to The address to which tokens will be transferred.
   * @param amount The amount of tokens to be transferred.
   * @return bool A boolean value indicating whether the transfer was successful.
   */
  function transfer(
    address to,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(to != address(0), 'CCoin: transfer to the zero address');
    require(amount > 0, 'CCoin: transfer amount must be greater than zero');
    require(balanceOf(msg.sender) >= amount, 'CCoin: insufficient balance');

    _transfer(_msgSender(), to, amount);

    emit CCoinTransferred(_msgSender(), to, amount);

    return true;
  }

  /**
   * @dev Approves the specified address to spend the caller's tokens.
   * @notice This is a public method that can be called by anyone to approve the spending of their own tokens.
   * @param spender The address to which the approval is granted.
   * @param amount The amount of tokens to approve for spending.
   * @return bool A boolean value indicating whether the approval was successful.
   */
  function approve(
    address spender,
    uint256 amount
  ) public override nonReentrant returns (bool) {
    require(spender != address(0), 'CCoin: approve to the zero address');

    _approve(_msgSender(), spender, amount);

    return true;
  }

  /**
   * @dev Transfers tokens from one address to another.
   * @notice This is a public method that can be called by anyone to transfer tokens from one address to another.
   * @param from The address from which tokens will be transferred.
   * @param to The address to which tokens will be transferred.
   * @param amount The amount of tokens to be transferred.
   * @return bool A boolean value indicating whether the transfer was successful.
   */
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

    emit CCoinTransferred(from, to, amount);

    return true;
  }
}
