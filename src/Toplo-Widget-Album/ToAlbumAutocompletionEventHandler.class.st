Class {
	#name : #ToAlbumAutocompletionEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'windowManager',
		'windowPosition',
		'queryRunner',
		'listElement',
		'currentPattern',
		'moveCount'
	],
	#category : #'Toplo-Widget-Album-Incubator-Autocompletion'
}

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> closeWindow [

	windowManager closeWindow
]

{ #category : #accessing }
ToAlbumAutocompletionEventHandler >> currentPattern [

	^ currentPattern 
]

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> cursorElementMovedEvent: anEvent [

	| cursorElement bnds album |
	album := anEvent currentTarget.
	cursorElement := anEvent currentTarget cursorElement.
	bnds := cursorElement bounds inSpace bounds.
	bnds height isZero ifTrue: [ ^ self ].
	moveCount := moveCount + 1.
	moveCount > 2 ifTrue: [ self closeWindow ].
	windowPosition := bnds bottomRight.
	self refreshWindowFromEvent: anEvent.
	self queryFromIndex: album cursor position in: album
]

{ #category : #accessing }
ToAlbumAutocompletionEventHandler >> dataAccessor [ 

	^ self listElement dataAccessor 
]

{ #category : #initialization }
ToAlbumAutocompletionEventHandler >> defaultFontSize [

	^ 13
]

{ #category : #initialization }
ToAlbumAutocompletionEventHandler >> defaultMaxHeight [

	^ 200
]

{ #category : #initialization }
ToAlbumAutocompletionEventHandler >> defaultMinHeight [

	^ 0
]

{ #category : #initialization }
ToAlbumAutocompletionEventHandler >> defaultNodeBuilder [

	^ [ :node :dataItem :holder |
	  | text |
	  text := dataItem asString asRopedText.
	  text fontName: holder listElement fontName.
	  text fontSize: holder listElement fontSize.
	(text from: 1 to: (currentPattern size min: text size)) bold.
	  node addChild: ((ToLabel text: text)
			   withNullSkin;
			   yourself) hMatchParent ]
]

{ #category : #'api - accessing' }
ToAlbumAutocompletionEventHandler >> eventsToHandle [

	^ {
		  AlbCursorElementMovedEvent.
		  ToItemsQueryResultEvent }
]

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> itemsQueryResultEvent: anItemsQueryResultEvent [

	moveCount := 0.

	" if not for right pattern "
	anItemsQueryResultEvent queryRunner pattern = currentPattern
		ifFalse: [
			self closeWindow.
			^ self ].
	" if a result size > 0 "
	anItemsQueryResultEvent items ifNotEmpty: [
		self listElement currentPattern: currentPattern ].	
	
	anItemsQueryResultEvent items ifEmpty: [
		self closeWindow.
		^ self ].

	" update the list and popup "
	self dataAccessor filterResult: anItemsQueryResultEvent items.
	self openWindowFromEvent: anItemsQueryResultEvent
]

{ #category : #accessing }
ToAlbumAutocompletionEventHandler >> listElement [ 

	^ listElement 
]

{ #category : #initialization }
ToAlbumAutocompletionEventHandler >> newListElement [
 
	| newListElement |
	newListElement := ToAlbumAutocompletionListElement new.
	"newListElement withDecoration: ToAutocompleteListSideBackgroundDecoration."
	newListElement nodeBuilder: self defaultNodeBuilder.
	newListElement fontSize: self defaultFontSize.
	newListElement innerContainer maxHeight: self defaultMaxHeight.
	newListElement innerContainer minHeight: self defaultMinHeight.
	newListElement innerContainer vFitContent.
	newListElement vFitContent.
	newListElement hMatchParent.
	^ newListElement
]

{ #category : #'api - hooks' }
ToAlbumAutocompletionEventHandler >> onInstalledIn: anElement [

	| selectors |
	super onInstalledIn: anElement.
	selectors := (SystemNavigation default allMethods collect: [ :m |
		              m selector ]) asSet asArray sort.
	moveCount := 0.
	listElement := self newListElement.

	queryRunner := ToItemsQueryRunner new.
	queryRunner onInstalledIn: anElement.
	queryRunner fetcher: [ :theTextField :thePattern |
		selectors select: [ :m |
			m beginsWith: thePattern caseSensitive: true ] ].

	windowManager := ToPopupWindowManager new.
	windowManager onInstalledIn: anElement.
	windowManager builder: [ :anchWin :element |
		anchWin root hMatchParent.
		anchWin root vFitContent.
		anchWin root addChild: self listElement ].

	windowManager sizeHook: [ :theWindow :theElement :event |
		theWindow width: 200 ].
	windowManager positionHook: [ :theWindow :theElement :event |
		theWindow position: self windowPosition ]
]

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> openWindowFromEvent: anEvent [

	windowManager currentWindow ifNil: [
		windowManager popupWindowEvent: anEvent ]
]

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> queryFromIndex: anIndex in: anAlbum [

	| selecter wordStart sub |
	selecter := anAlbum selecter.
	wordStart := selecter findWordStartBefore: anIndex.
	sub := anAlbum text copyFrom: wordStart to: anIndex.
	currentPattern := sub asString.
	currentPattern
		ifEmpty: [self closeWindow ]
		ifNotEmpty: [ :pat | queryRunner processPattern: pat for: anAlbum ]
]

{ #category : #'event handling' }
ToAlbumAutocompletionEventHandler >> refreshWindowFromEvent: anEvent [

	windowManager currentWindow ifNotNil: [
		windowManager applyPositionAnsSizeHooksFromEvent: anEvent ].

]

{ #category : #accessing }
ToAlbumAutocompletionEventHandler >> windowPosition [ 

	^ windowPosition 
]
