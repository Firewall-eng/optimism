// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Storage } from "src/libraries/Storage.sol";

interface IOtherMessenger {
    /// @notice Getter for the address of the messenger on the other domain.
    function otherMessenger() external view returns (address);
}

/// @title IForceReplayConfig
/// @notice Implemented by contracts that are aware of the force replay config.
interface IForceReplayConfig {
    /// @notice Returns true if the network is forcing L1 -> L2 replay for messages.
    function isForcingReplay() external view returns (bool);
}

/// @title ForceReplay
/// @notice Handles reading and writing the force replay and controller to storage.
library ForceReplay {
    /// @notice The storage slot that contains the boolean for forceReplay
    bytes32 internal constant FORCE_REPLAY =
        bytes32(uint256(keccak256("opstack.forceReplay")) - 1);

    /// @notice The storage slot that contains the address for the forceReplayController
    bytes32 internal constant FORCE_REPLAY_CONTROLLER =
        bytes32(uint256(keccak256("opstack.forceReplayController")) - 1);

    /// @notice Reads the FORCE_REPLAY bool from the magic storage slot.
    function getForceReplay() internal view returns (bool) {
        return Storage.getBool(FORCE_REPLAY);
    }

    /// @notice Reads the FORCE_REPLAY_CONTROLLER address from the magic storage slot.
    function getForceReplayController() internal view returns (address) {
        return Storage.getAddress(FORCE_REPLAY_CONTROLLER);
    }

    /// @notice Internal setter for the force replay boolean value.
    function setForceReplay(bool _forceReplay) internal {
        Storage.setBool(FORCE_REPLAY, _forceReplay);
    }

    /// @notice Internal setter for the force replay controller address value.
    function setForceReplayController(address _forceReplayController) internal {
        Storage.setAddress(FORCE_REPLAY_CONTROLLER, _forceReplayController);
    }
}
