// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

/// @title Contract to allow for bypassing of force replay enforcement.
interface IForceReplayController {
    /// @notice Returns a boolean indicating if the transaction should be force included.
    /// @param _from Msg.sender of the L1 -> L2 message. This address is NOT aliased yet.
    /// @param _to   The L1 -> L2 "to" field.
    /// @param _mint The L1 -> L2 "_mint" field.
    /// @param _value   The L1 -> L2 "_value" field.
    /// @param _gasLimit   The L1 -> L2 "_gasLimit" field.
    /// @param _isCreation   The L1 -> L2 "_isCreation" field.
    /// @param _data   The L1 -> L2 "_data" field.
    /// @return bool
    function forceInclude(
        address _from,
        address _to,
        uint256 _mint,
        uint256 _value,
        uint64 _gasLimit,
        bool _isCreation,
        bytes memory _data
    )
        external
        view
        returns (bool);
}
