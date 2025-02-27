Class {
	#name : #ToSegmentedNodeHolder,
	#superclass : #ToBarNodeHolder,
	#category : #'Toplo-Widget-Segmented'
}

{ #category : #'t - checkable - accessing' }
ToSegmentedNodeHolder >> checked [

	^ self contentElement checked
]

{ #category : #'t - checkable - accessing' }
ToSegmentedNodeHolder >> checked: aBoolean [

	self contentElement checked: aBoolean.
	self updateSelection
]

{ #category : #accessing }
ToSegmentedNodeHolder >> contentElement [

	^ self dataItem
]

{ #category : #'t - checkable - accessing' }
ToSegmentedNodeHolder >> isChecked [ 

	^ self checked
]

{ #category : #accessing }
ToSegmentedNodeHolder >> segmentedBarElement [

	^ self barElement
]

{ #category : #'t - checkable - accessing' }
ToSegmentedNodeHolder >> updateSelection [

	self contentElement checked ifTrue: [
		self selecter selectIndex: self position.
		^ self ].
	self selecter deselectIndex: self position
]
