Class {
	#name : #ToListNodeManager,
	#superclass : #ToAbstractListNodeManager,
	#category : #'Toplo-Widget-List-Core-ListElement'
}

{ #category : #initialization }
ToListNodeManager >> defaultNodeBuilder [

	^ [ :node :dataItem :holder |
	  node addChild: (ToLabel text: dataItem asString) hMatchParent ]
]

{ #category : #initialization }
ToListNodeManager >> defaultNodeHolderClass [

	^ ToListNodeHolder
]
