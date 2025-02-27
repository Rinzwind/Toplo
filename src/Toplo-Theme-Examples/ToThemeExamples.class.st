Class {
	#name : #ToThemeExamples,
	#superclass : #Object,
	#classInstVars : [
		'primaryButton1'
	],
	#category : #'Toplo-Theme-Examples'
}

{ #category : #private }
ToThemeExamples class >> createThemeMenuBar: aSpace [

	| bar themeMenu inspectMenu beeMenu rawMenu |
	bar := ToMenuBar new
		       hMatchParent;
		       vFitContent.
	bar addMenu: (themeMenu := ToMenu new labelText: 'Theme').
	bar addMenu: (inspectMenu := ToMenu new labelText: 'Tools').

	"Theme menu"
	"Button to switch between light and dark theme"
	themeMenu addItem: (beeMenu := ToMenu new labelText: 'Bee').

	beeMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Switch to Light');
			 whenClickedDo: [ self switchTheme: ToBeeTheme new for: aSpace ]).
	beeMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Switch to Dark');
			 whenClickedDo: [ self switchTheme: ToBeeDarkTheme new for: aSpace ]).

	themeMenu addItem: (rawMenu := ToMenu new labelText: 'Raw theme').
	rawMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Switch to Light');
			 whenClickedDo: [ self switchTheme: ToRawTheme new for: aSpace ]).
	rawMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Switch to Dark');
			 whenClickedDo: [ self switchTheme: ToRawDarkTheme new for: aSpace ]).
			
	themeMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Randomize color');
			 whenClickedDo: [ self randomizePrimaryColorFor: aSpace ]).

	"Inspect menu"
	inspectMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Inspect Space');
			 tooltipText: 'Inspect the BlSpace';
			 whenClickedDo: [ self inspectSpace: aSpace ]).
	inspectMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Inspect Theme');
			 tooltipText: 'Inspect the current theme';
			 whenClickedDo: [ self inspectSpaceToTheme: aSpace ]).
	inspectMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'CSS like Style Sheet');
			 tooltipText: 'Show the current style sheet source code';
			 whenClickedDo: [ self displaySpaceCSSLikeStyleSheet: aSpace ]).
	inspectMenu addItem: (ToMenuItem new
			 label: (ToLabel text: 'Style Sheet');
			 tooltipText: 'Show the current style sheet source code';
			 whenClickedDo: [ self displaySpaceStyleSheet: aSpace ]).

	^ bar
]

{ #category : #'private - actions' }
ToThemeExamples class >> displaySpaceCSSLikeStyleSheet: aSpace [

	| presenter stream printer |
	aSpace ifNil: [ ^ self ].
	aSpace toTheme ifNil: [ ^ self ].

	"Display Theme styleSheet in a text presenter"
	presenter := SpTextPresenter new.
	stream := ReadWriteStream on: String new.

	"Build the style sheet detail"
	aSpace root skinManager styleSheet
		ifNil: [
		stream nextPutAll: 'This theme is not based on style sheets.' ]
		ifNotNil: [ :sheet |
			stream
				nextPutAll: 'CSS Like style sheet with ';
				nextPutAll: sheet styleRules size asString;
				nextPutAll: ' rule(s)';
				cr;
				nextPutAll: '###';
				cr.
			printer := ToStyleSheetCSSLikePrinter styleSheet: sheet.
			printer printStyleSheetCSSLikeOn: stream ].

	"Open the presenter"
	presenter text: stream contents.
	presenter open.
	presenter withWindowDo: [ :w | w title: 'Toplo Style Sheet details' ]
]

{ #category : #'private - actions' }
ToThemeExamples class >> displaySpaceStyleSheet: aSpace [

	| presenter stream printer |
	aSpace ifNil: [ ^ self ].
	aSpace toTheme ifNil: [ ^ self ].

	"Display Theme styleSheet in a text presenter"
	presenter := SpTextPresenter new.
	stream := ReadWriteStream on: String new.

	"Build the style sheet detail"
	aSpace root skinManager styleSheet
		ifNil: [
		stream nextPutAll: 'This theme is not based on style sheets.' ]
		ifNotNil: [ :sheet |
			stream
				nextPutAll: 'CSS Like style sheet with ';
				nextPutAll: sheet styleRules size asString;
				nextPutAll: ' rule(s)';
				cr;
				nextPutAll: '###';
				cr.
			printer := ToStyleSheetPrinter new.
			printer printStyleSheet: sheet on: stream ].

	"Open the presenter"
	presenter text: stream contents.
	presenter open.
	presenter withWindowDo: [ :w | w title: 'Toplo Style Sheet details' ]
]

{ #category : #'private - get' }
ToThemeExamples class >> elementSandBoxFor: aSpace [

	| box |
	aSpace ifNil: [ ^ nil ].
	box := aSpace root childWithId: #themeSandBox.
	"Install default layout"
	box layout: BlFlowLayout vertical; padding: (BlInsets all: 5); constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal fitContent ].
	^ box
]

{ #category : #'examples - labels' }
ToThemeExamples class >> example_BlElementWithTheme [

	| space pn themeSwitcher listElement typeArr headingArr hello pn2 helloWorld |
	ToTheme cleanUp.
	space := BlSpace new.

	pn := BlElement new layout: (BlLinearLayout vertical cellSpacing: 10).
	pn constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	
	pn2 := BlElement new layout: (BlFrameLayout new).
	pn2 constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	pn2 addChild: pn.

	pn background: Color white.
	pn2 ensureCanManageSkin.
	pn2 localTheme: ToBeeTheme new.

	themeSwitcher := ToCheckbox new
		                 labelText: 'Dark Theme';
		                 beEndToStart.
		
	themeSwitcher defaultSkin: ToCheckboxSkin new.
	themeSwitcher addEventHandler: (BlEventHandler
			 on: ToCheckableChangedEvent
			 do: [ :event |
				 pn localTheme: (themeSwitcher isChecked
						  ifTrue: [ ToBeeDarkTheme new ]
						  ifFalse: [ ToBeeTheme new ]).
				 themeSwitcher isChecked
					 ifTrue: [ pn background: Color gray ]
					 ifFalse: [ pn background: Color white ] ]).

	pn addChild: themeSwitcher.
	space root addChild: pn2.
	
	hello := ToLabel new text: 'Hello H1'.
	hello addAllStamps: #(#H1 #success).
	
	helloWorld := ToTextField new text: 'Hello world'.
	helloWorld addStamp: #description.
	helloWorld withLineWrapping; beReadonlyWithoutSelection.
	helloWorld localTheme: ToBeeTheme new.
	pn addChild: hello.
	pn addChild: helloWorld.


	listElement := ToListElement new nodeBuilder: [ :node :dataItem :holder |
		               |  lab |
		               lab := dataItem.
		               lab removeFromParent.
		               lab hMatchParent.
		               node addChild: lab ].

	listElement background: Color transparent.
	typeArr := {
		           ('Default' -> #( #default )).
		           ('Danger' -> #( #danger )).
		           ('Secondary' -> #( #secondary )).
		           ('Success' -> #( #success )).
		           ('Warning' -> #( #warning )) }.
	headingArr := {
		              ('H0' -> #H0).
		              ('H1' -> #H1).
		              ('H2' -> #H2).
		              ('H3' -> #H3).
		              ('H4' -> #H4).
		              ('H5' -> #H5) }.

	typeArr do: [ :typeAssoc |
		headingArr do: [ :headingAssoc |
			| lab |
			lab := ToLabel new.
			lab addAllStamps: typeAssoc value.
			lab addStamp: headingAssoc value.
			lab text: typeAssoc key , ' ' , headingAssoc key.
			listElement dataAccessor add: lab ] ].
	pn addChild: listElement.
	listElement requestNewSkin.
	space show
]

{ #category : #'examples - labels' }
ToThemeExamples class >> example_BlElementWithTheme2 [

	| space pn pn2 lab |
	ToTheme cleanUp.
	space := BlSpace new.
	pn2 := BlElement new layout: (BlFrameLayout new).
	
	pn2 constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	pn := BlElement new layout: (BlLinearLayout vertical cellSpacing: 10).
	pn constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	
	pn2 ensureCanManageSkin.
	pn2 localTheme: ToBeeTheme new.
	
	space root addChild: pn2.
	pn2 addChild: pn.
	lab := ToLabel new text: 'Hello'.
	lab addAllStamps: #(#H1 #success).
	pn2 addChild: lab.
	
	space applyAllSkinPhases.
	space inspect
]

{ #category : #'examples - labels' }
ToThemeExamples class >> example_ToLabelWithHeadingSkin [

	| typeArr headingArr listElement themeSwitcher space |
	ToTheme cleanUp.
	space := BlSpace new.
	space toTheme: ToBeeTheme new.
	space root layout: (BlLinearLayout vertical cellSpacing: 10).
	themeSwitcher := ToCheckbox new
		                 labelText: 'Dark Theme';
		                 beEndToStart.
	themeSwitcher defaultSkin: ToCheckboxSkin new.
	themeSwitcher addEventHandler: (BlEventHandler
			 on: ToCheckableChangedEvent
			 do: [ :event |
				 space toTheme: (themeSwitcher isChecked
						  ifTrue: [ ToBeeDarkTheme new ]
						  ifFalse: [ ToBeeTheme new ]) ]).

	space root addChild: themeSwitcher.

	listElement := ToListElement new nodeBuilder: [ :node :dataItem :holder |
		               | lab |
		               lab := dataItem.
		               lab removeFromParent.
		               lab hMatchParent.
		               node addChild: lab ].
	listElement background: Color transparent.
	typeArr := {
		           ('Default' -> #( #default )).
		           ('Danger' -> #( #danger )).
		           ('Secondary' -> #( #secondary )).
		           ('Success' -> #( #success )).
		           ('Warning' -> #( #warning )) }.
	headingArr := {
		              ('H0' -> #H0).
		              ('H1' -> #H1).
		              ('H2' -> #H2).
		              ('H3' -> #H3).
		              ('H4' -> #H4).
		              ('H5' -> #H5) }.

	typeArr do: [ :typeAssoc |
		headingArr do: [ :headingAssoc |
			| lab |
			lab := ToLabel new.
			lab addAllStamps: typeAssoc value.
			lab addStamp: headingAssoc value.
			lab text: typeAssoc key , ' ' , headingAssoc key.
			listElement dataAccessor add: lab ] ].
	space root addChild: listElement.
	space show
]

{ #category : #'examples - labels' }
ToThemeExamples class >> example_WithLateBoundPropertyWriter [

	| styleSheet lab parent |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	styleSheet addWritableProperty: (ToPseudoProperty new
			 name: #textBuilder;
			 writer: [ :e :v | e text attributes: v attributes ]).
	styleSheet select: ToLabel asTypeSelector style: [ :sr |
		sr
			when: ToInstallSkinEvent
			write: #textBuilder asWritableProperty
			with: [ :e |
				e textAttributesBuilder defaultFontName: 'American Typewriter'.
				e textAttributesBuilder fontSize: 32.
				e textAttributesBuilder foreground:
					(e valueOfTokenNamed: #'my-red-color') ] ].
	lab := ToLabel new.
	lab text: 'Hello My World'.
	parent := ToElement new matchParent.
	parent addEventHandlerOn: ToThemePreInstallEvent do: [ :event |
		event currentTarget lookupTheme addTokenProperty:
			(ToTokenProperty name: #'my-red-color' value: Color red) ].
	parent localTheme: ToBeeTheme new.
	lab styleSheet: styleSheet.

	parent addChild: lab.
	parent openInSpace.
	lab inspect
]

{ #category : #'examples - buttons' }
ToThemeExamples class >> example_beeButtonsInRawPane [

	| space primaryButton2 pane c chb disachb themeSelect themePane mainPane |
	space := BlSpace new.
	space root layout: BlLinearLayout vertical.
	space toTheme: ToBeeDarkTheme new.

	themePane := ToPane horizontal.
	themePane localTheme: ToRawTheme new.
	themePane geometry: (BlRoundedRectangleGeometry cornerRadius: 6).
	themePane padding: (BlInsets all: 5).
	pane := ToPane vertical.

	pane layout cellSpacing: 5.
	pane padding: (BlInsets all: 5).


	themeSelect := ToChoiceMenu new.
	themeSelect dataToTextConverter: [ :assoc | assoc key ].
	themeSelect withStrictCheckingStrategy.
	themeSelect data addAll: {
			('Raw Light Theme' -> ToRawTheme).
			('Raw Dark Theme' -> ToRawDarkTheme).
			('Bee Light Theme' -> ToBeeTheme).
			('Bee Dark Theme' -> ToBeeDarkTheme) }.

	themeSelect addEventHandler: (BlEventHandler
			 on: ToChoiceChangedEvent
			 do: [ space toTheme: themeSelect selectedData value new ]).
	themeSelect selectIndex: 4.

	disachb := ToCheckbox new label:
		           (ToLabel text: 'Disable all buttons').
	pane addChild: disachb.

	disachb defaultSkin: ToCheckboxSkin new.

	chb := ToCheckbox new label: (ToLabel text: 'Swith primary').
	chb defaultSkin: ToCheckboxSkin new.

	"Create some buttons with different skins"
	primaryButton1 := (ToButton id: #buttonA)
		                  labelText: 'Change button 2 primary color';
		                  icon:
			                  (ToImage inner: ToThemeIcons searchOutlined16x16);
		                  tooltipText:
			                  'When clicked, change the theme primary color to a random one';
		                  addStamp: #'large-sizing';
		                  yourself.

	primaryButton2 := (ToButton id: #buttonA) labelText: 'Button 2'.
	primaryButton1 whenClickedDo: [
		c := Color random.
		primaryButton2 addTokenNamed: #'color-primary' withValue: c.
		primaryButton2
			addTokenNamed: #'color-primary-pressed'
			withValue: c twiceDarker.
		primaryButton2
			addTokenNamed: #'color-primary-hover'
			withValue: c twiceLighter ].
	chb addEventHandler: (BlEventHandler
			 on: ToCheckableCheckEvent
			 do: [ :evt |
				 evt current
					 ifTrue: [ primaryButton2 addStamp: #primary ]
					 ifFalse: [ primaryButton2 removeStamp: #primary ] ]).
	chb checked: true.
	disachb addEventHandler: (BlEventHandler
			 on: ToCheckableCheckEvent
			 do: [ :evt |
				 evt current
					 ifTrue: [
						 pane childrenDo: [ :child |
							 child ~= disachb ifTrue: [ child disable ] ] ]
					 ifFalse: [
						 pane childrenDo: [ :child |
							 child ~= disachb ifTrue: [ child enable ] ] ] ]).

	pane addChild: primaryButton1.
	pane addChild: chb.
	pane addChild: primaryButton2.
	themePane addChild: themeSelect.
	mainPane := ToPane vertical.
	mainPane padding: (BlInsets all: 10).
	mainPane addChild: themePane.
	mainPane addChild: pane.
	space root addChild: mainPane.
	space show.
	space inspect
]

{ #category : #'examples - buttons' }
ToThemeExamples class >> example_buttons [

	| space box line1 line2 line3 buttons |
	space := self openThemeExampleSpace.
	box := self elementSandBoxFor: space.

	"Line 1 : -"
	line1 := BlElement new
		         layout: (BlLinearLayout horizontal cellSpacing: 5);
		         padding: (BlInsets all: 5);
		         constraintsDo: [ :c |
			         c vertical fitContent.
			         c horizontal fitContent ].
	box addChild: line1.
	buttons := self makeStandardButtons.
	buttons do: [ :each | line1 addChild: each ].

	"Line 2 : buttons disabled"
	line2 := BlElement new
		         layout: (BlLinearLayout horizontal cellSpacing: 5);
		         padding: (BlInsets all: 5);
		         constraintsDo: [ :c |
			         c vertical fitContent.
			         c horizontal fitContent ].
	box addChild: line2.
	buttons := self makeStandardButtons.
	buttons do: [ :each |
		each disable.
		line2 addChild: each ].

	"Line 3 : buttons danger"
	line3 := BlElement new
		         layout: (BlLinearLayout horizontal cellSpacing: 5);
		         padding: (BlInsets all: 5);
		         constraintsDo: [ :c |
			         c vertical fitContent.
			         c horizontal fitContent ].
	box addChild: line3.
	buttons := self makeStandardButtons.
	buttons do: [ :each |
		each addStamp: #danger.
		line3 addChild: each ]
]

{ #category : #'examples - buttons' }
ToThemeExamples class >> example_oneButton [

	| space defaultButton |
	space := BlSpace new.
	space toTheme: ToBeeTheme new.
	defaultButton := ToButton new.
	"defaultButton when: ToElementSkinEvent do: [ :evt | evt traceCr ]."
	defaultButton addStamp: #'primary'.
	defaultButton labelText: 'Default button'.
	space root addChild: defaultButton.
	space show.
	defaultButton inspect
]

{ #category : #'private - actions' }
ToThemeExamples class >> inspectSpace: aSpace [

	aSpace ifNil:[ ^ self ].
	aSpace inspect
]

{ #category : #'private - actions' }
ToThemeExamples class >> inspectSpaceToTheme: aSpace [

	aSpace ifNil:[ ^ self ].
	aSpace toTheme inspect
]

{ #category : #'examples - buttons' }
ToThemeExamples class >> makeStandardButtons [

	|primaryButton defaultButton dashedButton textButton linkButton |

		primaryButton := (ToButton id: #buttonA)
		                  labelText: 'Primary Button';
		                  tooltipText: 'I''m a button'.
	primaryButton addStamp: #primary.

	defaultButton := (ToButton id: #buttonB)
		                 labelText: 'Default Button';
		                 tooltipText: 'I''m a button'.

	dashedButton := (ToButton id: #buttonC)
		                labelText: 'Dashed Button';
		                tooltipText: 'I''m a button'.
	dashedButton addStamp: #dashed.

	textButton := (ToButton id: #buttonD)
		              labelText: 'Text Button';
		              tooltipText: 'I''m a button'.
	textButton addStamp: #text.

	linkButton := (ToButton id: #buttonE)
		              labelText: 'Link Button';
		              tooltipText: 'I''m a button'.
	linkButton addStamp: #link.
	^ { primaryButton .defaultButton .dashedButton .textButton .linkButton }
]

{ #category : #private }
ToThemeExamples class >> openThemeExampleSpace [
	"Prepare a space to display theme examples"

	| space |
	space := BlSpace new.

	"Configure root layout"
	space root layout: BlFlowLayout vertical.
	space root constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	"Create UI"
	space root addChild: (self createThemeMenuBar: space).
	space root addChild: (ToElement id: #themeSandBox).

	"Configure default Theme"
	space toTheme: ToBeeTheme new.

	space position: 100 @ 100.
	space show.
	^ space
]

{ #category : #'private - actions' }
ToThemeExamples class >> randomizePrimaryColorFor: aSpace [

	| c |
	aSpace ifNil:[ ^ self ].
	c := Color random.
	aSpace root addTokenNamed: #'color-primary' withValue: c.
	aSpace root addTokenNamed: #'color-primary-pressed' withValue: c twiceDarker .
	aSpace root addTokenNamed: #'color-primary-hover' withValue: c twiceLighter
]

{ #category : #'private - actions' }
ToThemeExamples class >> switchTheme: aToTheme for: aSpace [

	aSpace ifNil:[ ^ self ].
	aToTheme ifNil:[ ^ self ].
	aSpace toTheme: aToTheme.
]

{ #category : #'see class side' }
ToThemeExamples >> seeClassSide [ 
]
