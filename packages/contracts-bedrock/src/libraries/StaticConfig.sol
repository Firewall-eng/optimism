// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title StaticConfig
/// @notice Library for encoding and decoding static configuration data.
library StaticConfig {
    /// @notice Encodes the static configuration data for adding a dependency.
    /// @param _chainId Chain ID of the dependency to add.
    /// @return Encoded static configuration data.
    function encodeAddDependency(uint256 _chainId) internal pure returns (bytes memory) {
        return abi.encode(_chainId);
    }

    /// @notice Decodes the static configuration data for adding a dependency.
    /// @param _data Encoded static configuration data.
    /// @return Decoded chain ID of the dependency to add.
    function decodeAddDependency(bytes memory _data) internal pure returns (uint256) {
        return abi.decode(_data, (uint256));
    }

    /// @notice Encodes the static configuration data for removing a dependency.
    /// @param _chainId Chain ID of the dependency to remove.
    /// @return Encoded static configuration data.
    function encodeRemoveDependency(uint256 _chainId) internal pure returns (bytes memory) {
        return abi.encode(_chainId);
    }

    /// @notice Decodes the static configuration data for removing a dependency.
    /// @param _data Encoded static configuration data.
    /// @return Decoded chain ID of the dependency to remove.
    function decodeRemoveDependency(bytes memory _data) internal pure returns (uint256) {
        return abi.decode(_data, (uint256));
    }
}
