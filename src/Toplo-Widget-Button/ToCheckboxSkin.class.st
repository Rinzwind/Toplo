Class {
	#name : #ToCheckboxSkin,
	#superclass : #ToButtonSkin,
	#category : #'Toplo-Widget-Button-Checkable'
}

{ #category : #'event handling' }
ToCheckboxSkin >> checkedSkinEvent: anEvent [

	super checkedSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e icon innerImage border: (BlBorder
				 paint: (e valueOfTokenNamed: #'color-primary-checked')
				 width: 5).
		e indeterminateBar background: Color transparent ]
]

{ #category : #'event handling' }
ToCheckboxSkin >> disabledSkinEvent: anEvent [

	super disabledSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e background: Color transparent.
		e icon innerImage border: (e valueOfTokenNamed: #'color-border-disabled').
		e icon border: (e valueOfTokenNamed: #'color-border-disabled').
		e indeterminateBar background: Color transparent ]
]

{ #category : #'event handling' }
ToCheckboxSkin >> enabledSkinEvent: anEvent [

	super enabledSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (e valueOfTokenNamed: #'color-border-checkable').
		e background: (e valueOfTokenNamed: #'color-bg-container').
		e icon border: (e valueOfTokenNamed: #'color-border') ]
]

{ #category : #'event handling' }
ToCheckboxSkin >> hoveredSkinEvent: anEvent [

	super hoveredSkinEvent: anEvent.
	anEvent elementDo: [ :e | 
		e icon border: (BlBorder paint: (e valueOfTokenNamed: #'color-primary') width: 1) ]
]

{ #category : #accessing }
ToCheckboxSkin >> iconGeometryIn: aCheckbox [

	^ BlRoundedRectangleGeometry cornerRadius: 4
]

{ #category : #'event handling' }
ToCheckboxSkin >> indeterminateSkinEvent: anEvent [

	super indeterminateSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e icon innerImage border: (BlBorder paint: (e valueOfTokenNamed: #'color-primary') width: 0).
		e indeterminateBar background: (e valueOfTokenNamed: #'color-primary')]
]

{ #category : #'event handling' }
ToCheckboxSkin >> installSkinEvent: anEvent [

	super installSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e startInterspace: 10.
		e labeledIcon hMatchParent.
		e border: (e valueOfTokenNamed: #'color-border-checkable').
		e iconImage: (e valueOfTokenNamed: #'checkbox-image-builder') value.
		e icon geometry: (self iconGeometryIn: e).
		e icon border: (e valueOfTokenNamed: #'color-border') ]
]

{ #category : #'event handling' }
ToCheckboxSkin >> leavedSkinEvent: anEvent [

	super leavedSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (e valueOfTokenNamed: #'color-border-checkable').
		e icon border: (e valueOfTokenNamed: #'color-border') ]
]

{ #category : #'event handling' }
ToCheckboxSkin >> uncheckedSkinEvent: anEvent [

	super uncheckedSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e icon innerImage border:
			(BlBorder paint: (e valueOfTokenNamed: #'color-primary') width: 0).
		e indeterminateBar background: Color transparent ]
]
