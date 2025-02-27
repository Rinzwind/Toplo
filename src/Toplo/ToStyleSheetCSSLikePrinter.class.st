Class {
	#name : #ToStyleSheetCSSLikePrinter,
	#superclass : #Object,
	#instVars : [
		'styleSheet',
		'toElement'
	],
	#category : #'Toplo-Core-StyleSheet'
}

{ #category : #accessing }
ToStyleSheetCSSLikePrinter class >> styleRules: aStyleRuleList [
	"Initialize the printer with a style rules list to print"

	^ self new styleSheet: (ToStyleSheet new addAllStyleRules: aStyleRuleList)
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter class >> styleSheet: aToStyleSheet [
	"Initialize the printer with a style sheet to print"

	^ self new styleSheet: aToStyleSheet
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter class >> toElement: aToElement [
	"Initialize the printer with a ToElement"

	^ self new toElement: aToElement
]

{ #category : #private }
ToStyleSheetCSSLikePrinter >> getSelectorCSS: aToElementSelector hangSelector: aSelector [
	"https://www.w3schools.com/cssref/css_selectors.php"

	| stream |
	stream := ReadWriteStream on: String new.
	aSelector ifNotNil: [ stream nextPutAll: aSelector ].

	"Stamp selector => .class"
	aToElementSelector class = ToStampSelector ifTrue: [
		aSelector ifNotNil: [ stream space ].
		aToElementSelector allStamps do: [ :s |
			stream
				nextPutAll: '.';
				nextPutAll: s asString ].
		^ stream contents ].

	"Id selector => #id"
	aToElementSelector class = ToIdSelector ifTrue: [
		stream nextPutAll: aToElementSelector id asSymbol printString.
		^ stream contents ].

	"Universal selector => *"
	aToElementSelector class = ToUniversalSelector ifTrue: [
		aSelector ifNotNil: [ stream space ].
		stream nextPutAll: '*'.
		^ stream contents ].

	"Type selector => element, can be inherit with element(inherit)"
	aToElementSelector class = ToTypeSelector ifTrue: [
		aSelector ifNotNil: [ stream space ].
		stream nextPutAll: aToElementSelector type asString.
		aToElementSelector exact ifFalse: [ stream nextPutAll: '(inherit)' ].
		^ stream contents ].

	"Not selector => :not(selector)"
	aToElementSelector class = ToNotSelector ifTrue: [
		| selector |
		stream nextPutAll: ':not('.
		selector := self
			            getSelectorCSS: aToElementSelector left
			            hangSelector: nil.
		stream nextPutAll: selector.
		stream nextPutAll: ')'.
		^ stream contents ].

	"Action selector => [attribute]"
	aToElementSelector class = ToActionSelector ifTrue: [
		stream nextPutAll: aToElementSelector action asString.
		^ stream contents ].

	"Parent selector => parent > child, width depth=2 : parent > * > child"
	"Parent selector => parent > child, width depth=nil : parent >> * "
	aToElementSelector class = ToParentSelector ifTrue: [
		| parentSelector childSelector |
		parentSelector := self
			                  getSelectorCSS: aToElementSelector right
			                  hangSelector: nil.
		childSelector := self
			                 getSelectorCSS: aToElementSelector left
			                 hangSelector: nil.
		stream nextPutAll: parentSelector.
		aToElementSelector depth
			ifNil: [ stream nextPutAll: ' >> * ' ]
			ifNotNil: [ :depth |
				(1 to: depth)
					do: [ :i | stream nextPutAll: ' > ' ]
					separatedBy: [ stream nextPutAll: ' * ' ] ].
		stream nextPutAll: childSelector.
		^ stream contents ].

	"Sibling selector => child + child"
	aToElementSelector class = ToSiblingSelector ifTrue: [
		| brotherSelector selector |
		brotherSelector := self
			                   getSelectorCSS: aToElementSelector right
			                   hangSelector: nil.
		selector := self
			            getSelectorCSS: aToElementSelector left
			            hangSelector: nil.
		stream nextPutAll: brotherSelector.
		stream nextPutAll: ' + '.
		stream nextPutAll: selector.
		^ stream contents ].

	"And selector => .class1.class2 or element1,element2"
	aToElementSelector class = ToAndSelector ifTrue: [
		stream nextPutAll:
			(self getSelectorCSS: aToElementSelector left hangSelector: nil).
		"Write a coma with all selectors except stam"
		(aToElementSelector right isKindOf: ToStampSelector) ifFalse: [
			stream nextPutAll: ',' ].
		stream nextPutAll:
			(self getSelectorCSS: aToElementSelector right hangSelector: nil).
		^ stream contents ].

	stream nextPutAll: '[Not supported Selector]'.
	^ stream contents
]

{ #category : #printing }
ToStyleSheetCSSLikePrinter >> printOn: aStream [

	self toElement
		ifNil: [
			self styleSheet ifNil: [
				^ aStream nextPutAll: 'an empty StyleSheet ccs like printer' ].
			aStream nextPutAll: 'a Stylesheet printer on '.
			self styleSheet printOn: aStream ]
		ifNotNil: [ :e |
			aStream nextPutAll: 'a Stylesheet css like printer on '.
			self toElement printOn: aStream ]
]

{ #category : #private }
ToStyleSheetCSSLikePrinter >> printStyleRuleCSS: aStyleRule on: aStream hangSelector: aSelector [
		
	"print selector"
	| selector |
	selector := self getSelectorCSS: aStyleRule selector hangSelector: aSelector.
	aStream nextPutAll: selector.
	
	"print begin of body"
	aStream space; nextPutAll: '{'; cr.

	"print body"
	aStyleRule skinEventListeners do:[ :w | 
		aStream tab.
		w printOn: aStream.
		aStream cr.
	].
 
	"print end of body"
	aStream cr; nextPutAll: '}'; cr.
	
	"print sub rules"
	aStyleRule styleRules do:[ :rule | 
		self printStyleRuleCSS: rule on: aStream hangSelector: selector.
	].
]

{ #category : #printing }
ToStyleSheetCSSLikePrinter >> printStyleSheetCSSLikeOn: aStream [

	self styleRules do: [ :rule |
		self printStyleRuleCSS: rule on: aStream hangSelector: nil ]
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter >> styleRules [

	^ self styleSheet ifNotNil: [ :e | e styleRules ] ifNil: [
		  self toElement
			  ifNotNil: [ :e |
				  | theme |
				  theme := self toElement lookupTheme.
				  (theme notNil and: [ theme styleSheet notNil ])
					  ifFalse: [ nil ]
					  ifTrue: [ theme applicableRulesFor: self toElement ] ]
			  ifNil: [ #(  ) ] ]
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter >> styleSheet [

	^ styleSheet
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter >> styleSheet: anObject [

	styleSheet := anObject
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter >> toElement [

	^ toElement ifNotNil: [ :e | e first ]
]

{ #category : #accessing }
ToStyleSheetCSSLikePrinter >> toElement: aToElement [

	aToElement ~= toElement ifFalse: [ ^ self ].
	aToElement
		ifNil: [ toElement := nil ]
		ifNotNil: [ toElement := aToElement asWeakReference ].
]
