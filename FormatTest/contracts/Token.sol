// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./Lib/LibB64.sol";

//-----------------------------------
// トークン
//-----------------------------------
contract Token is Ownable, ERC721 {
    //-----------------------------------------
    // 定数
    //-----------------------------------------
    string constant private TOKEN_NAME = "File Format Test Token";
    string constant private TOKEN_SYMBOL = "FFTT";

    //-----------------------------------------
    // ストレージ
    //-----------------------------------------
    // token
    string[] private _names;
    string[] private _descriptions;
    string[] private _images;
    string[] private _animation_urls;

    //-----------------------------------------
    // コンストラクタ
    //-----------------------------------------
    constructor() Ownable() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
    }

    //-----------------------------------------
    // [external] トークンの発行
    //-----------------------------------------
    function mintToken( string calldata name, string calldata description, string calldata image, string calldata animation_url ) external {
        _safeMint( msg.sender, _names.length );

        _names.push( name );
        _descriptions.push( description );
        _images.push( image );
        _animation_urls.push( animation_url );
    }

    //-----------------------------------------
    // [public] トークンURI
    //-----------------------------------------
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require( _exists(tokenId), "nonexistent token" );

        bytes memory bytesName = abi.encodePacked( '"name":"', _names[tokenId], '",' );
        bytes memory bytesDescription = abi.encodePacked( '"description":"', _descriptions[tokenId], '",' );
        bytes memory bytesImage = abi.encodePacked( '"image":"', _images[tokenId], '",' );
        bytes memory bytesAnimationUrl = abi.encodePacked( '"animation_url":"', _animation_urls[tokenId], '"' );

        bytes memory bytesMeta = abi.encodePacked( '{', bytesName, bytesDescription, bytesImage, bytesAnimationUrl, '}' );
        return( string( abi.encodePacked( 'data:application/json;base64,', LibB64.encode( bytesMeta ) ) ) );
    }

    //-----------------------------------------
    // [external/onlyOwner] データ修復
    //-----------------------------------------
    // name
    function repairName( uint256 tokenId, string calldata name ) external onlyOwner {
        require( _exists(tokenId), "nonexistent token" );
        _names[tokenId] = name;
    }

    // description    
    function repairDescription( uint256 tokenId, string calldata description ) external onlyOwner {
        require( _exists(tokenId), "nonexistent token" );
        _descriptions[tokenId] = description;
    }

    // image
    function repairImage( uint256 tokenId, string calldata image ) external onlyOwner {
        require( _exists(tokenId), "nonexistent token" );
        _images[tokenId] = image;
    }

    // animation_url
    function repairAnimationUrl( uint256 tokenId, string calldata animation_url ) external onlyOwner {
        require( _exists(tokenId), "nonexistent token" );
        _animation_urls[tokenId] = animation_url;
    }
}
