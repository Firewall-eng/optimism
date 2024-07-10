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

/// @title ForceReplayL1L2Messages
/// @notice Handles reading and writing the force replay boolean value to storage.
library ForceReplayL1L2Messages {
    /// @notice The storage slot that contains the boolean for forceReplayL1L2Messages
    bytes32 internal constant FORCE_REPLAY_L1_L2_MESSAGES =
        bytes32(uint256(keccak256("opstack.forceReplayL1L2Messages")) - 1);

    /// @notice Reads the FORCE_REPLAY_L1_L2_MESSAGES from the magic storage slot.
    function getForceReplayL1L2Messages() internal view returns (bool) {
        return Storage.getBool(FORCE_REPLAY_L1_L2_MESSAGES);
    }

    /// @notice Internal setter for the force replay boolean value.
    function set(bool _forceReplay) internal {
        Storage.setBool(FORCE_REPLAY_L1_L2_MESSAGES, _forceReplay);
    }
}
