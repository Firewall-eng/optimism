// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// Testing
import { CommonTest } from "test/setup/CommonTest.sol";

// Contracts
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ConfigType } from "src/L2/L1BlockInterop.sol";

// Libraries
import { Constants } from "src/libraries/Constants.sol";
import { StaticConfig } from "src/libraries/StaticConfig.sol";

// Interfaces
import { ISystemConfig } from "src/L1/interfaces/ISystemConfig.sol";
import { ISystemConfigInterop } from "src/L1/interfaces/ISystemConfigInterop.sol";
import { IOptimismPortalInterop } from "src/L1/interfaces/IOptimismPortalInterop.sol";

contract SystemConfigInterop_Test is CommonTest {
    /// @notice Marked virtual to be overridden in
    ///         test/kontrol/deployment/DeploymentSummary.t.sol
    function setUp() public virtual override {
        super.enableInterop();
        super.setUp();
    }

    /// @notice Tests that the version function returns a valid string. We avoid testing the
    ///         specific value of the string as it changes frequently.
    function test_version_succeeds() external view {
        assert(bytes(_systemConfigInterop().version()).length > 0);
    }

    /// @dev Tests that a dependency can be added.
    function testFuzz_addDependency_succeeds(uint256 _chainId) public {
        vm.expectCall(
            address(optimismPortal),
            abi.encodeCall(
                IOptimismPortalInterop.setConfig,
                (ConfigType.ADD_DEPENDENCY, StaticConfig.encodeAddDependency(_chainId))
            )
        );

        vm.prank(_systemConfigInterop().dependencyManager());
        _systemConfigInterop().addDependency(_chainId);
    }

    /// @dev Tests that adding a dependency as not the dependency manager reverts.
    function testFuzz_addDependency_notDependencyManager_reverts(uint256 _chainId) public {
        require(alice != _systemConfigInterop().dependencyManager(), "SystemConfigInterop_Test: 100");
        vm.expectRevert("SystemConfig: caller is not the dependency manager");
        vm.prank(alice);
        _systemConfigInterop().addDependency(_chainId);
    }

    /// @dev Tests that a dependency can be removed.
    function testFuzz_removeDependency_succeeds(uint256 _chainId) public {
        vm.expectCall(
            address(optimismPortal),
            abi.encodeCall(
                IOptimismPortalInterop.setConfig,
                (ConfigType.REMOVE_DEPENDENCY, StaticConfig.encodeRemoveDependency(_chainId))
            )
        );

        vm.prank(_systemConfigInterop().dependencyManager());
        _systemConfigInterop().removeDependency(_chainId);
    }

    /// @dev Tests that removing a dependency as not the dependency manager reverts.
    function testFuzz_removeDependency_notDependencyManager_reverts(uint256 _chainId) public {
        require(alice != _systemConfigInterop().dependencyManager(), "SystemConfigInterop_Test: 100");
        vm.expectRevert("SystemConfig: caller is not the dependency manager");
        vm.prank(alice);
        _systemConfigInterop().removeDependency(_chainId);
    }

    /// @dev Returns the SystemConfigInterop instance.
    function _systemConfigInterop() internal view returns (ISystemConfigInterop) {
        return ISystemConfigInterop(address(systemConfig));
    }
}
