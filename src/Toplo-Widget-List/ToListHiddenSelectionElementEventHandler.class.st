Class {
	#name : #ToListHiddenSelectionElementEventHandler,
	#superclass : #ToListSelectionElementEventHandler,
	#instVars : [
		'selectionChangedEventClass'
	],
	#category : #'Toplo-Widget-List-Selection-Element'
}

{ #category : #'api - accessing' }
ToListHiddenSelectionElementEventHandler >> eventsToHandle [

	^ super eventsToHandle , { ToListHiddenSelectionChangedEvent }
]

{ #category : #'element handlers' }
ToListHiddenSelectionElementEventHandler >> listHiddenSelectionChangedEvent: anEvent [

	| touchedIntervals target |
	touchedIntervals := anEvent touchedIntervals.
	target := anEvent currentTarget.

	self refreshSelectionFromEvent: anEvent.

	touchedIntervals do: [ :int |
		target dataSource notifyItemsChanged: int ]
]
