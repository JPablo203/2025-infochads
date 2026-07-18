Class {
	#name : 'SpecialCards_V2Tests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenCardReversePolarityIsApplyToAtomicBombCellThenShiledsNotDamagedAndAllShipsAreNotAtBegining [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 100. 0. 0. 100. 3. 30. 20. 10. 6. 4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { ReversePolarity new }.	

	aGame useCard: ReversePolarity new from: 1 applyTo: 5. "En el apply el num representa el numero de casillero"
	aGame start.

	self assert: (aGame shieldOf: 1) equals: 3.
	self assert: (aGame shieldOf: 2) equals: 3.
	self assert: (aGame positionOf: 1) equals:5.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardAppliedToBlackHoleCellAffectsAllOtherShipsExceptTheOneOnTheBlackHoleCell [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10. 14. 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 100. 0. 0. 0. 0. 0. 100. 3. 30. 20. 10. 6.
		                     4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 5. "En el apply el num representa el numero de casillero"
	aGame start.

	self assert: (aGame positionOf: 1) equals: 3.
	self assert: (aGame positionOf: 2) equals: 7.
	self assert: (aGame positionOf: 3) equals: 5.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardIsAppliedOnACardGiverCellThenSpaceShipDoesntRecieveCard [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 0. 0. 100. 100. 3. 30. 20. 10. 6.
		                     4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { ReversePolarity new }.
	
	aGame useCard: ReversePolarity new from: 1 applyTo: 5. "En el apply el num representa el numero de casillero"
	
	aGame start.
	
	self assert: (aGame getCardDeckSizeOf: 1) equals:1. "No recibe Carta dado al efecto inverso"

]
