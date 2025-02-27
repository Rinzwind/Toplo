"
A ToTooltipWindowTest is a test class for testing the behavior of ToTooltipWindow
"
Class {
	#name : #ToTooltipWindowTest,
	#superclass : #ToParameterizedHostTest,
	#category : #'Toplo-Tests-Core-Tooltip'
}

{ #category : #tests }
ToTooltipWindowTest >> testContent [

	| e windowHandler |

	e := ToElement new  size: 100@100.
	e tooltipContent: (ToLabel text: 'Tooltip content').
	windowHandler := e tooltipWindowManager.
	self assert: (windowHandler isKindOf: ToTooltipWindowManager).
	space root addChild: e.
	"self waitTestingSpaces."

	BlSpace simulateMouseMoveInside: e.
	self waitTestingSpaces.
	(windowHandler popupDelay + 100 milliSecond ) wait.
	self waitTestingSpaces.

	self assert: (windowHandler currentWindow root firstChild isKindOf: ToLabel) .
	self assert: windowHandler currentWindow root firstChild text asString equals: 'Tooltip content' .
	^  windowHandler currentWindow
]

{ #category : #tests }
ToTooltipWindowTest >> testCurrentWindow [

	| window |
	
	window := self testContent.
	self assert: window isOpened.
	self assert: window notNil.
	self assert: window isOpened.

]

{ #category : #tests }
ToTooltipWindowTest >> testDefaultElevation [

	| window |
	window := self testContent.
	self
		assert: window  elevation elevation
		equals: window  defaultElevation elevation
]

{ #category : #tests }
ToTooltipWindowTest >> testInitialize [

	| w |
	w := ToTooltipWindow new.
	self assert: w element isNil.
	self assert: (w eventDispatcher hasEventHandlerSuchThat: [ :eh |
			 eh isKindOf: ToTooltipWindowEventHandler ])
]
