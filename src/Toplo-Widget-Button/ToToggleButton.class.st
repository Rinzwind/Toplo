Class {
	#name : #ToToggleButton,
	#superclass : #ToButton,
	#category : #'Toplo-Widget-Button-Checkable'
}

{ #category : #configuration }
ToToggleButton >> checkable: aBoolean [

	self shouldNotImplement 
]

{ #category : #initialization }
ToToggleButton >> initialize [ 

	super initialize.
	self initializeCheckable 
]

{ #category : #skin }
ToToggleButton >> newRawSkin [ 

	^ ToToggleButtonSkin new
]
