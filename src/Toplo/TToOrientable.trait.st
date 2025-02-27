Trait {
	#name : #TToOrientable,
	#category : #'Toplo-Core'
}

{ #category : #'t - orientable - orientation' }
TToOrientable >> beHorizontal [

	self horizontal: true
]

{ #category : #'t - orientable - direction' }
TToOrientable >> beLeftToRight [

	self isLeftToRight ifTrue: [ ^ self ].
	self direction: BlLayoutDirection leftToRight
]

{ #category : #'t - orientable - direction' }
TToOrientable >> beRightToLeft [

	self isRightToLeft ifTrue: [ ^ self ].
	self direction: BlLayoutDirection rightToLeft
]

{ #category : #'t - orientable - orientation' }
TToOrientable >> beVertical [

	self vertical: true
]

{ #category : #'t - orientable - accessing' }
TToOrientable >> direction [

	^ self layoutStrategy direction
]

{ #category : #'t - orientable - accessing' }
TToOrientable >> direction: aDirection [

	(self layoutStrategy direction isLeftToRight and: [
		 aDirection isLeftToRight ]) ifTrue: [ ^ self ].
	(self layoutStrategy direction isRightToLeft and: [
		 aDirection isRightToLeft ]) ifTrue: [ ^ self ].
	self layoutStrategy direction: aDirection.
	self dispatchEvent: ToLayoutDirectionChangedEvent new.
	self requestLayout
]

{ #category : #'t - orientable - orientation' }
TToOrientable >> horizontal: aBoolean [

	aBoolean
		ifTrue: [
			self isHorizontal ifTrue: [ ^ self ].
			self layoutStrategy beHorizontal ]
		ifFalse: [
			self isVertical ifTrue: [ ^ self ].
			self layoutStrategy beVertical ].
	self dispatchEvent: ToLayoutOrientationChangedEvent new.
	self requestLayout
]

{ #category : #'t - orientable - orientation' }
TToOrientable >> isHorizontal [

	^ self layoutStrategy isHorizontal
]

{ #category : #'t - orientable - direction' }
TToOrientable >> isLeftToRight [

	^ self direction isLeftToRight
]

{ #category : #'t - orientable - direction' }
TToOrientable >> isRightToLeft [

	^ self direction isRightToLeft
]

{ #category : #'t - orientable - orientation' }
TToOrientable >> isVertical [

	^ self isHorizontal not
]

{ #category : #'t - orientable - accessing' }
TToOrientable >> layoutStrategy [

	^ self explicitRequirement 

	
]

{ #category : #'t - orientable - direction' }
TToOrientable >> leftToRight: aBoolean [

	aBoolean = self isLeftToRight ifTrue: [ ^ self ].
	aBoolean ifTrue: [ self beLeftToRight ] ifFalse: [ self beRightToLeft ]
]

{ #category : #'t - orientable - accessing' }
TToOrientable >> orientation [

	^ self layoutStrategy orientation
]

{ #category : #'t - orientable - accessing' }
TToOrientable >> orientation: aBlLayoutOrientation [

	(self layoutStrategy orientation isHorizontal and: [
		 aBlLayoutOrientation isHorizontal ]) ifTrue: [ ^ self ].
	(self layoutStrategy orientation isVertical and: [
		 aBlLayoutOrientation isVertical ]) ifTrue: [ ^ self ].
	self layoutStrategy orientation: aBlLayoutOrientation.
	self dispatchEvent: ToLayoutOrientationChangedEvent new.
	self requestLayout
]

{ #category : #'t - orientable - direction' }
TToOrientable >> rightToLeft: aBoolean [

	aBoolean = self isRightToLeft ifTrue: [ ^ self ].
	aBoolean ifTrue: [ self beRightToLeft ] ifFalse: [ self beLeftToRight ]
]

{ #category : #'t - orientable - orientation' }
TToOrientable >> vertical: aBoolean [

	self horizontal: aBoolean not
]
