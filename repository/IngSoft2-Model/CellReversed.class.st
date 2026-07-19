Class {
	#name : 'CellReversed',
	#superclass : 'Object',
	#instVars : [
		'originalCell'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'strings' }
CellReversed class >> wrapping: aCell [

	^ self new initializeWith: aCell
]

{ #category : 'initialization' }
CellReversed >> initializeWith: aCell [

	originalCell := aCell
]

{ #category : 'accessing' }
CellReversed >> originalCell [

	^ originalCell
]

{ #category : 'converting' }
CellReversed >> reversed [

	^ originalCell
]

{ #category : 'as yet unclassified' }
CellReversed >> takeActionOver: aSpaceShip or: spaceShips thatArePlaced: spaceShipPositions [

	originalCell effect isGlobal ifTrue: [ ^ self ].

	spaceShips do: [ :ship |
		ship == aSpaceShip ifFalse: [
			originalCell affectOnly: ship thatIsPlacedIn: spaceShipPositions.
			originalCell giveCardToShip: ship.
			originalCell affectTheShieldOf: ship ] ]
	
]
