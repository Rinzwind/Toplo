Trait {
	#name : #TToClickable,
	#category : #'Toplo-Widget-Button-Core'
}

{ #category : #'t - clickable' }
TToClickable >> clickEvent: anEvent [
]

{ #category : #'t - clickable' }
TToClickable >> clickEventClass [

	^ self rawClickEventClass ifNil: [ BlPrimaryClickEvent ]
]

{ #category : #'t - clickable' }
TToClickable >> clickEventClass: anEventClass [

	self rawClickEventClass: anEventClass 
]

{ #category : #'t - clickable' }
TToClickable >> clickHandler [

	^ self explicitRequirement 
]

{ #category : #'t - clickable' }
TToClickable >> clickHandler: anEventHandler [

	self explicitRequirement 
]

{ #category : #'t - clickable' }
TToClickable >> newClickHandlerWith: aBlock [

	^ ToClickableActionEventHandler action: aBlock
]

{ #category : #'t - clickable' }
TToClickable >> rawClickEventClass [

	^ self explicitRequirement 
]

{ #category : #'t - clickable' }
TToClickable >> rawClickEventClass: anEventClass [

	self explicitRequirement 
]

{ #category : #'t - clickable' }
TToClickable >> removeClickHandler [
	"remove the click action"

	self clickHandler ifNotNil: [ :ch |
		self removeEventHandler: ch.
		self clickHandler: nil ]
]

{ #category : #'t - clickable' }
TToClickable >> whenClickedDo: aBlock [
	"Inform that the widget has been clicked."

	" only one official handler "
	self removeClickHandler.
	self clickHandler: (self newClickHandlerWith: aBlock).
	self addEventHandler: self clickHandler
]
