Class {
	#name : 'SpecialCards_V2Tests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenCardReversePolarityIsApplyToAtomicBombCellThenShiledsNotDamagedShip1IsNotAtBegining [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 100. 0. 0. 100. 0. 3. 30. 20. 10. 6. 4. 2. 5. 7 }.
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
		                     { 0. 100. 0. 0. 0. 0. 0. 100. 0. 3. 30. 20. 10. 6.
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
SpecialCards_V2Tests >> testWhenReversePolarityCardAppliedToHyperSpaceJumpOtherShipsMoveAndLoseShield [
| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 40 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 100. 0. 0. 0. 0. 100. 0. 3. 30. 20. 10.
		                     6. 4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 41. "En el apply el num representa el numero de casillero"

	aGame start.

	self assert: (aGame positionOf: 1) equals: 41.
	self assert: (aGame positionOf: 2) equals: 5.
	self assert: (aGame positionOf: 3) equals: 5.
	self assert: (aGame shieldOf: 2) equals: 2.
	self assert: (aGame shieldOf: 3) equals: 2.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardIsAppliedOnACardGiverCellThenSpaceShipDoesntRecieveCard [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 0. 0. 100. 100. 0. 3. 30. 20. 10. 6.
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
	self assert: (aGame getCardDeckSizeOf: 2) equals:3.
	self assert: (aGame getCardDeckSizeOf: 3) equals:3.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardIsAppliedOnAHyperJumpCellThenShipOnReversedCellDoesntMoveWhileOtherMoveWithHyperJump [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 40 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 100. 0. 0. 0. 100. 0. 3. 30. 20. 10.
		                     6. 4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 41. "En el apply el num representa el numero de casillero"

	aGame start.

	self assert: (aGame positionOf: 1) equals: 41.
	self assert: (aGame positionOf: 2) equals: 31.
	self assert: (aGame positionOf: 3) equals: 21.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardIsAppliedOnMoonwalkCellThenNoShipsMoveBackWards [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10. 11. 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 0. 100. 0. 100. 0. 3. 30. 20. 10.
		                     4. 4. 4. 4. 4. 0 }.
	aBoard := Board
		          withSize: 100
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

	self assert: (aGame positionOf: 1) equals: 7.
	self assert: (aGame positionOf: 2) equals: 12.
	self assert: (aGame positionOf: 3) equals: 5
]
