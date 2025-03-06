// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// Testing utilities
import { Test } from "forge-std/Test.sol";
import { FFIInterface } from "test/setup/FFIInterface.sol";

// Target contract
import { StaticConfig } from "src/libraries/StaticConfig.sol";

contract StaticConfig_Test is Test {
    FFIInterface constant ffi = FFIInterface(address(uint160(uint256(keccak256(abi.encode("optimism.ffi"))))));

    function setUp() public {
        vm.etch(address(ffi), vm.getDeployedCode("FFIInterface.sol:FFIInterface"));
        vm.label(address(ffi), "FFIInterface");
    }

    /// @dev Tests add dependency encoding.
    function testDiff_encodeAddDependency_succeeds(uint256 _chainId) external {
        bytes memory encoding = StaticConfig.encodeAddDependency(_chainId);

        bytes memory _encoding = ffi.encodeDependency(_chainId);

        assertEq(encoding, _encoding);
    }

    /// @dev Tests add dependency decoding.
    function test_decodeAddDependency_succeeds(uint256 _chainId) external {
        bytes memory encoding = ffi.encodeDependency(_chainId);

        uint256 chainId = StaticConfig.decodeAddDependency(encoding);

        assertEq(chainId, _chainId);
    }

    /// @dev Tests remove dependency encoding.
    function testDiff_encodeRemoveDependency_succeeds(uint256 _chainId) external {
        bytes memory encoding = StaticConfig.encodeRemoveDependency(_chainId);

        bytes memory _encoding = ffi.encodeDependency(_chainId);

        assertEq(encoding, _encoding);
    }

    /// @dev Tests remove dependency decoding.
    function test_decodeRemoveDependency_succeeds(uint256 _chainId) external {
        bytes memory encoding = ffi.encodeDependency(_chainId);

        uint256 chainId = StaticConfig.decodeRemoveDependency(encoding);

        assertEq(chainId, _chainId);
    }
}
