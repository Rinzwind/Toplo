Class {
	#name : #ToSegmentedBarElement,
	#superclass : #ToBarElement,
	#traits : 'TToCheckableHolder',
	#classTraits : 'TToCheckableHolder classTrait',
	#instVars : [
		'group'
	],
	#category : #'Toplo-Widget-Segmented'
}

{ #category : #accessing }
ToSegmentedBarElement >> checkableElementAccessor [
	"according to the specific vocabulary - the data items are checkables of the checkable bar element "

	^ self dataAccessor
]

{ #category : #initialization }
ToSegmentedBarElement >> defaultEventHandler [

	^ ToSegmentedBarEventHandler new
]

{ #category : #initialization }
ToSegmentedBarElement >> defaultNodeManagerClass [ 

	^ ToSegmentedNodeManager 
]

{ #category : #initialization }
ToSegmentedBarElement >> defaultPrimarySelectionModeClass [

	^ ToSegmentedSelectionMode
]

{ #category : #initialization }
ToSegmentedBarElement >> initialize [

	super initialize.
	self group
		addEventHandlerOn: ToCheckableGroupChangedEvent
		do: [ :event | self dispatchEvent: event ]
]

{ #category : #skin }
ToSegmentedBarElement >> newRawSkin [ 

	^ ToSegmentedBarElementSkin new
]

{ #category : #'t - checkable holder' }
ToSegmentedBarElement >> rawGroup [

	^ group ifNil: [ group := ToCheckableGroup new ]
]

{ #category : #'t - checkable holder' }
ToSegmentedBarElement >> rawGroup: aGroup [

	self shouldNotImplement 
]

{ #category : #accessing }
ToSegmentedBarElement >> segmentAccessor [
	"according to the specific vocabulary - the data items are checkables of the checkable bar element "

	^ self dataAccessor
]
