Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'boardSize',
		'wormHole',
		'gameBoard',
		'lastEffectApplied'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Board class >> assertIsPositiveOverZero: aBoardSize [

	(aBoardSize isInteger and: [ aBoardSize > 0 ]) ifFalse: [
		Error signal: 'Board Size must be a positive interger.' ]
]

{ #category : 'as yet unclassified' }
Board class >> withSize: aBoardSize composedOf: aWormHole andACellConfiguration: aConfigDiceSet [

	self assertIsPositiveOverZero: aBoardSize.
	^ self new
		  initializeWithSize: aBoardSize
		  composedOf: aWormHole
		  andConfiguration: aConfigDiceSet
]

{ #category : 'as yet unclassified' }
Board >> applyEffecOfPowerUpUponA: aSpaceShip andAll: spaceShips andIts: spaceShipPositions [

	| cell |
	cell := gameBoard at: (spaceShipPositions at: aSpaceShip id) position.
	self lastAppliedEffect: cell.
	cell
		takeActionOver: aSpaceShip
		or: spaceShips
		thatArePlaced: spaceShipPositions
]

{ #category : 'as yet unclassified' }
Board >> applyLastEffectPowerUpUponA: aSpaceShip andAll: spaceShips andIts: spaceShipPositions [

	lastEffectApplied
		takeActionOver: aSpaceShip
		or: spaceShips
		thatArePlaced: spaceShipPositions
]

{ #category : 'accessing' }
Board >> boardSize [

	^ boardSize
]

{ #category : 'initialization' }
Board >> initializeWithSize: aBoardSize composedOf: aWormHole andConfiguration: aConfigDiceSet [

	boardSize := aBoardSize.

	gameBoard := GameMapCreator new
		             createBoardWithCellConfiguration: aConfigDiceSet
		             andSize: boardSize.
	gameBoard := gameBoard isEmpty
		             ifTrue: [
		             (1 to: boardSize) collect: [ :each | NoEffect new ] ]
		             ifFalse: [ gameBoard ].

	wormHole := aWormHole.
	wormHole mustBeWithInLimits: aBoardSize
]

{ #category : 'accessing' }
Board >> lastAppliedEffect: aCellEffect [

	lastEffectApplied := aCellEffect
]

{ #category : 'as yet unclassified' }
Board >> limitAdjustmentAt: aPosition with: totalLaps [

	aPosition position <= 0 ifTrue: [
		^ Position at: ((aPosition position)negated +1) withLaps: 0 ].

	(self the: aPosition hasReached: totalLaps) ifTrue: [
		^ Position
			  at: boardSize - aPosition position
			  withLaps: totalLaps - aPosition lap ].

	aPosition position <= boardSize ifTrue: [
		^ Position at: 0 withLaps: 0 ].

	^ Position
		  at: boardSize * (aPosition position // boardSize) negated
		  withLaps: aPosition position // boardSize
]

{ #category : 'as yet unclassified' }
Board >> positionAfterWormHole: aPosition [

	^ Position at: (wormHole moveifWormHole: aPosition position) withLaps: 0.
]

{ #category : 'accessing' }
Board >> reversePolarityAt: aCellIndex [

	| targetCell updatedCell |
	targetCell := gameBoard at: aCellIndex.
	updatedCell := targetCell reversed.
	gameBoard at:aCellIndex put: updatedCell.
]

{ #category : 'as yet unclassified' }
Board >> the: aPosition hasReached: totalLaps [

	^ aPosition position + (aPosition lap * boardSize)
	  >= (totalLaps * boardSize)
]
