// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

contract Codyfighter is ERC721, ERC721URIStorage, Pausable, Ownable {
    struct TokenData {
        uint256 tokenId;
        address owner;
        string tokenURI;
    }

    mapping(uint256 => TokenData) private _tokenData;

    string private _baseTokenURI;
    uint256 private _maxTokenSupply;
    uint256 private _currentTokenSupply;
    uint256[] private _tokenIds;

    event TokenMinted(address indexed owner, uint256 indexed tokenId);
    event TokenBurned(address indexed owner, uint256 indexed tokenId);
    event TokenTransferred(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    constructor() ERC721('Codyfighter Dev', 'CFighterDev') {
        _maxTokenSupply = 10000;
        setBaseURI('https://blockchain.codyfight.com/codyfighter/metadata/');
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
        require(_exists(tokenId), 'Codyfighter: token does not exist');
        return _tokenData[tokenId].tokenURI;
    }

    function getAllTokens() public view returns (TokenData[] memory) {
        TokenData[] memory tokens = new TokenData[](_tokenIds.length);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            tokens[i] = _tokenData[tokenId];
        }

        return tokens;
    }

    function getTokenData(
        uint256 tokenId
    ) public view returns (TokenData memory) {
        require(_exists(tokenId), 'Codyfighter: token does not exist');
        return _tokenData[tokenId];
    }

    function getMaxTokenSupply() public view returns (uint256) {
        return _maxTokenSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _currentTokenSupply;
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

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        require(!_exists(tokenId), 'Codyfighter: token already exists');
        require(!_isTokenIdUsed(tokenId), 'Codyfighter: token ID already used');
        require(!paused(), 'Codyfighter: token mint paused');
        require(
            _currentTokenSupply <= _maxTokenSupply,
            'Codyfighter: maximum token supply reached'
        );

        string memory uri = string(
            abi.encodePacked(_baseTokenURI, Strings.toString(tokenId))
        );

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        _tokenData[tokenId] = TokenData(tokenId, to, uri);
        _tokenIds.push(tokenId);
        _currentTokenSupply++;

        emit TokenMinted(to, tokenId);
    }

    function burn(uint256 tokenId) public {
        require(_exists(tokenId), 'Codyfighter: token does not exist');
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            'Codyfighter: caller is not owner nor approved'
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

        emit TokenBurned(_msgSender(), tokenId);
    }

    function transfer(address from, address to, uint256 tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            'Codyfighter: transfer caller is not owner nor approved'
        );
        require(to != address(0), 'Codyfighter: transfer to the zero address');
        require(_exists(tokenId), 'Codyfighter: transfer nonexistent token');

        _tokenData[tokenId].owner = to;
        _transfer(from, to, tokenId);

        emit TokenTransferred(ownerOf(tokenId), to, tokenId);
    }

    // Internal functions

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
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
}
