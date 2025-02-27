"
A ToElementWithPopupEventHandlerTest is a test class for testing the behavior of ToElementWithPopupEventHandler
"
Class {
	#name : #ToElementWithPopupEventHandlerTest,
	#superclass : #ToParameterizedHostTest,
	#category : #'Toplo-Tests-Core-Window'
}

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testElementPositionInSpaceChangedEvent [

	| win e windowManager |
	e := ToElement new.
	space root addChild: e.
	e position: 10 asPoint.
	e size: 10 asPoint.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.
	windowManager onInstalledIn: e.
	win := windowManager newWindowEvent: nil.
	win popup.
	self waitTestingSpaces.
	self assert: win isOpened.
	e position: 20 asPoint.
	self waitTestingSpaces.
	self assert: win isOpened
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseDownEvent [

	| e windowManager position event |
	e := ToElement new.
	e size: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.

	windowManager onInstalledIn: e.
	position := e bounds inSpace center.
	event := BlMouseDownEvent primary position: position.
	e dispatchEvent: event.
	self assert: windowManager currentWindow notNil.
	self waitTestingSpaces.
	self assert: windowManager currentWindow isOpened
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseDownOutsideEvent [

	| e windowManager closed event |
	e := ToElement new.
	e size: 100 asPoint.
	e position: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.
	windowManager autoClosePickOutsideEventClass: BlMouseDownOutsideEvent.

	windowManager onInstalledIn: e.
	BlSpace simulateMouseDownOn: e.
	self waitTestingSpaces.
	self assert: windowManager currentWindow notNil.
	self assert: windowManager currentWindow isOpened.
	closed := false.
	windowManager currentWindow addEventHandler: (BlEventHandler
			 on: ToAnchoredWindowClosedEvent
			 do: [ closed := true ]).
	(windowManager autoCloseOnMouseUpDelay + 1 milliSecond) wait.
	event := BlMouseDownEvent primary position: 0 @ 0.
	e dispatchEvent: event asMouseOutsideEvent.
	self assert: windowManager autoClosePickOutsideEventClass identicalTo: BlMouseDownOutsideEvent.
	self waitTestingSpaces.

	" window is closed on mouse-up "
	self assert: windowManager currentWindow isNil.
	self assert: closed
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseDownOutsideEventWithAutoCloseWithUpOutside [

	| e windowManager closed event |
	e := ToElement new.
	e size: 100 asPoint.
	e position: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.
	windowManager autoClosePickOutsideEventClass: BlMouseUpOutsideEvent.

	windowManager onInstalledIn: e.
	BlSpace simulateMouseDownOn: e.
	self waitTestingSpaces.
	self assert: windowManager currentWindow notNil.
	self assert: windowManager currentWindow isOpened.
	closed := false.
	windowManager currentWindow addEventHandler: (BlEventHandler
			 on: ToAnchoredWindowClosedEvent
			 do: [ closed := true ]).
	(windowManager autoCloseOnMouseUpDelay + 1 milliSecond) wait.
	event := BlMouseDownEvent primary position: 0 @ 0.
	e dispatchEvent: event asMouseOutsideEvent.
	self assert: windowManager autoClosePickOutsideEventClass identicalTo: BlMouseUpOutsideEvent.
	self waitTestingSpaces.

	" window is not closed on mouse-down outside here because autoClosePickOutsideEventClass is for mouse-up"
	self assert: windowManager currentWindow notNil.
	self assert: closed not
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseUpEvent [

	| e windowManager closed position event |
	e := ToElement new.
	e size: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.

	windowManager onInstalledIn: e.
	BlSpace simulateMouseDownOn: e.
	self waitTestingSpaces.
	self assert: windowManager currentWindow notNil.
	self assert: windowManager currentWindow isOpened.
	closed := false.
	windowManager currentWindow addEventHandler: (BlEventHandler
			 on: ToAnchoredWindowClosedEvent
			 do: [ closed := true ]).
	(windowManager autoCloseOnMouseUpDelay + 1 milliSecond) wait.
	position := e bounds inSpace center.
	event := BlMouseUpEvent primary position: position.
	event timestamp: e space time now.
	e dispatchEvent: event.
	self waitTestingSpaces.

	" window is closed on mouse-up "
	self assert: windowManager currentWindow isNil.
	self assert: closed
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseUpOutsideEvent [

	| e windowManager closed event |
	e := ToElement new.
	e size: 100 asPoint.
	e position: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.

	windowManager onInstalledIn: e.
	BlSpace simulateMouseDownOn: e.
	self waitTestingSpaces.
	self assert: windowManager currentWindow notNil.
	self assert: windowManager currentWindow isOpened.
	closed := false.
	windowManager currentWindow addEventHandler: (BlEventHandler
			 on: ToAnchoredWindowClosedEvent
			 do: [ closed := true ]).
	(windowManager autoCloseOnMouseUpDelay + 1 milliSecond) wait.
	event := BlMouseUpEvent primary position: 0 @ 0.
	e dispatchEvent: event asMouseOutsideEvent.
	self assert: windowManager autoClosePickOutsideEventClass identicalTo: BlMouseUpOutsideEvent.
	self waitTestingSpaces.

	" window is closed on mouse-up "
	self assert: windowManager currentWindow isNil.
	self assert: closed
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testMouseUpOutsideEventWithAutoCloseWithDownOutside [

	| e windowManager closed event |
	e := ToElement new.
	e size: 100 asPoint.
	e position: 100 asPoint.
	space root addChild: e.
	self waitTestingSpaces.

	windowManager := ToPopupWindowManager new.
	windowManager autoClosePickOutsideEventClass: BlMouseDownOutsideEvent.

	windowManager onInstalledIn: e.
	BlSpace simulateMouseDownOn: e.
	self waitTestingSpaces.
	self assert: windowManager currentWindow notNil.
	self assert: windowManager currentWindow isOpened.
	closed := false.
	windowManager currentWindow addEventHandler: (BlEventHandler
			 on: ToAnchoredWindowClosedEvent
			 do: [ closed := true ]).
	(windowManager autoCloseOnMouseUpDelay + 1 milliSecond) wait.
	event := BlMouseUpEvent primary position: 0 @ 0.
	e dispatchEvent: event asMouseOutsideEvent.
	self assert: windowManager autoClosePickOutsideEventClass identicalTo: BlMouseDownOutsideEvent.
	self waitTestingSpaces.

	" window is not closed on mouse-up outside here because autoClosePickOutsideEventClass is for mouse-down"
	self assert: windowManager currentWindow notNil.
	self assert: closed not
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testOnInstalledIn [

	| e windowManager handler |
	e := ToElement new.
	windowManager := ToPopupWindowManager new.
	windowManager onInstalledIn: e.
	handler := e eventDispatcher handlers
		           detect: [ :h |
		           h isKindOf: ToElementWithPopupEventHandler ]
		           ifNone: [  ].
	self assert: handler notNil.
	self assert: handler target identicalTo: e.
	self assert: e shouldHandleMousePickOutsideEvent
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testOnUninstalledIn [

	| e windowManager handler |
	e := ToElement new.
	windowManager := ToPopupWindowManager new.
	windowManager onInstalledIn: e.
	handler := e eventDispatcher handlers
		           detect: [ :h |
		           h isKindOf: ToElementWithPopupEventHandler ]
		           ifNone: [  ].
	self assert: handler target identicalTo: e.
	handler onUninstalledIn: e.
	self assert: handler target isNil
]

{ #category : #tests }
ToElementWithPopupEventHandlerTest >> testTarget [

	| e windowManager handler |
	e := ToElement new.
	windowManager := ToPopupWindowManager new.
	windowManager onInstalledIn: e.
	handler := e eventDispatcher handlers
		           detect: [ :h |
		           h isKindOf: ToElementWithPopupEventHandler ]
		           ifNone: [  ].
	self assert: handler target identicalTo: e
]
