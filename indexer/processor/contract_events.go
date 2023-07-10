package processor

import (
	"errors"
	"fmt"

	"github.com/ethereum-optimism/optimism/indexer/database"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"

	"github.com/google/uuid"
)

type ProcessedContractEvents struct {
	events            []*database.ContractEvent
	eventsBySignature map[common.Hash][]*database.ContractEvent
	eventByLogIndex   map[uint]*database.ContractEvent
	eventLog          map[uuid.UUID]*types.Log
}

func NewProcessedContractEvents() *ProcessedContractEvents {
	return &ProcessedContractEvents{
		events:            []*database.ContractEvent{},
		eventsBySignature: make(map[common.Hash][]*database.ContractEvent),
		eventByLogIndex:   make(map[uint]*database.ContractEvent),
		eventLog:          make(map[uuid.UUID]*types.Log),
	}
}

func (p *ProcessedContractEvents) AddLog(log *types.Log, time uint64) *database.ContractEvent {
	contractEvent := database.ContractEventFromLog(log, time)

	p.events = append(p.events, &contractEvent)
	p.eventsBySignature[contractEvent.EventSignature] = append(p.eventsBySignature[contractEvent.EventSignature], &contractEvent)
	p.eventByLogIndex[log.Index] = &contractEvent
	p.eventLog[contractEvent.GUID] = log

	return &contractEvent
}

func DecodeFromProcessedEvents[ABI any](p *ProcessedContractEvents, name string, contractAbi *abi.ABI) ([]*ABI, error) {
	eventAbi, ok := contractAbi.Events[name]
	if !ok {
		return nil, errors.New(fmt.Sprintf("event %s not present in supplied ABI", name))
	}

	decodedEvents := []*ABI{}
	for _, event := range p.eventsBySignature[eventAbi.ID] {
		log := p.eventLog[event.GUID]

		var decodedEvent ABI
		err := contractAbi.UnpackIntoInterface(&decodedEvent, name, log.Data)
		if err != nil {
			return nil, err
		}

		// handle topics if present
		if len(log.Topics) > 1 {
			var indexedArgs abi.Arguments
			for _, arg := range eventAbi.Inputs {
				if arg.Indexed {
					indexedArgs = append(indexedArgs, arg)
				}
			}

			// The first topic (event signature) is ommitted
			err := abi.ParseTopics(&decodedEvent, indexedArgs, log.Topics[1:])
			if err != nil {
				return nil, err
			}
		}

		decodedEvents = append(decodedEvents, &decodedEvent)
	}

	return decodedEvents, nil
}

func UnpackLog[EventType any](log *types.Log, name string, contractAbi *abi.ABI) (*EventType, error) {
	eventAbi, ok := contractAbi.Events[name]
	if !ok {
		return nil, errors.New(fmt.Sprintf("event %s not present in supplied ABI", name))
	} else if len(log.Topics) == 0 {
		return nil, errors.New("anonymous events are not supported")
	} else if log.Topics[0] != eventAbi.ID {
		return nil, errors.New("event signature mismatch not present in supplied ABI")
	}

	var event EventType
	err := contractAbi.UnpackIntoInterface(&event, name, log.Data)
	if err != nil {
		return nil, err
	}

	// handle topics if present
	if len(log.Topics) > 1 {
		var indexedArgs abi.Arguments
		for _, arg := range eventAbi.Inputs {
			if arg.Indexed {
				indexedArgs = append(indexedArgs, arg)
			}
		}

		// The first topic (event signature) is ommitted
		err := abi.ParseTopics(&event, indexedArgs, log.Topics[1:])
		if err != nil {
			return nil, err
		}
	}

	return &event, nil
}
