Class {
	#name : 'CardDeck',
	#superclass : 'Object',
	#instVars : [
		'fixedDeck'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
CardDeck class >> new [

	^ super new initialize
]

{ #category : 'as yet unclassified' }
CardDeck class >> withCards: fixedCards [

^self new initializeWith: fixedCards.
]

{ #category : 'as yet unclassified' }
CardDeck >> availableCards [

	^ {
		  Speed new.
		  Acceleration new.
		  Cancellation new.
		  Redo new.
		  Repeat new.
		  Mercenary new }
]

{ #category : 'as yet unclassified' }
CardDeck >> drawRandomCard [
	
	fixedDeck notEmpty ifTrue: [^fixedDeck removeFirst ].
	^self availableCards atRandom
]

{ #category : 'initialization' }
CardDeck >> initialize [

	fixedDeck := OrderedCollection new
]

{ #category : 'initialization' }
CardDeck >> initializeWith: fixedCards [

	fixedDeck := fixedCards asOrderedCollection.
]
