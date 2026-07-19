Class {
	#name : 'SpecialCards_V2Tests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
SpecialCards_V2Tests >> should: anErrorBlock raise: anErrorClass withMessageText: anErrorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedButNoPermanentCardHasBeenUsed [

	| aGame aDiceSet aBoard speedCard reversalCard |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	reversalCard := Reversal reversing: speedCard. "Antes de activar el juego pregunta que efecto de los permanentes disponibles quiere revertir (Siempre una instancia de este Efecto)"
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         speedCard.
				         speedCard.
				         reversalCard }.

	self
		should: [ aGame useCard: reversalCard from: 2 applyTo: 1 ]
		raise: Error
		withMessageText:
		'Cannot use Reversal: The targeted permanent effect is not active on the selected Ship/s.'
	
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToASpeedCardThenCancellationIsAppliedToThatReversedCardButThereIsTwoOfTheSameCardOneReversedAndOneNormal [

	| aGame aDiceSet aBoard speedCard reversalCard cancellationCard |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	reversalCard := Reversal reversing: speedCard.
	cancellationCard := Cancellation new.
	cancellationCard effectTypeToCancel: speedCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         speedCard.
				         cancellationCard.
				         reversalCard }.

	aGame useCard: speedCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo: 1.
	aGame useCard: cancellationCard from: 1 applyTo: 1.

	aGame start.

	self assert: (aGame positionOf: 1) equals: 3
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToASpeedCardThenCancellationIsAppliedToThatReversedCardThenShipMovesNormal [

	| aGame aDiceSet aBoard speedCard reversalCard cancellationCard speedCard2 |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	speedCard2 := Speed new.
	"Creo 2 Speed para que sean distintos en memoria talque al momento de querer revertir y cancelar el que tiene el efecto revertido pueda ser eliminado y no el que tiene efecto normal"
	reversalCard := Reversal reversing: speedCard2.
	cancellationCard := Cancellation new.
	cancellationCard effectTypeToCancel: reversalCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         speedCard.
				         speedCard2.
				         reversalCard.
				         Acceleration new.
				         cancellationCard }.

	aGame useCard: speedCard from: 1 applyTo: 1.
	aGame useCard: speedCard2 from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo: 1.
	aGame drawCardFor: 1.
	aGame useCard: cancellationCard from: 1 applyTo: 1.

	aGame start.

	self assert: (aGame positionOf: 1) equals: 4
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToAccelerationCardAffectedByReversalThenShipsMovesWithAccelerationIncrement [

	| aGame aDiceSet aBoard reversalCard accelerationCard |
	aDiceSet := RiggedDice new initializeWith: { 2. 5 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	accelerationCard := Acceleration new.
	reversalCard := Reversal reversing: accelerationCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         accelerationCard.
				         reversalCard .
				         reversalCard }.

	aGame useCard: accelerationCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo: 1.
	aGame useCard: reversalCard from: 1 applyTo: 1.

	aGame start.

	self assert: (aGame positionOf: 1) equals: 4.
	self assert: (aGame positionOf: 2) equals: 7.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToAccelerationCardThenShipsGoesoneCellLessThanExpected [

	| aGame aDiceSet aBoard reversalCard accelerationCard |
	aDiceSet := RiggedDice new initializeWith: { 2. 5 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	accelerationCard := Acceleration new.
	reversalCard := Reversal reversing: accelerationCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         accelerationCard.
				         accelerationCard.
				         reversalCard }.

	aGame useCard: accelerationCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo: 1.

	aGame start.

	self assert: (aGame positionOf: 1) equals: 2.
	self assert: (aGame positionOf: 2) equals: 5
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToSpeedCardAffectedByReversalThenShipMovesWithSpeedIncrement [

	| aGame aDiceSet aBoard speedCard reversalCard |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	reversalCard := Reversal reversing: speedCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { speedCard. reversalCard .reversalCard }.

	aGame useCard: speedCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo:1.
	aGame useCard: reversalCard from: 1 applyTo:1.	
	
	aGame start.

	self assert: (aGame positionOf: 1) equals: 4
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToSpeedCardThenRedoIsAppliedAndShipMovesWithSpeedBonus [

	| aGame aDiceSet aBoard speedCard reversalCard redoCard |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	reversalCard := Reversal reversing: speedCard.
	redoCard := Redo new.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { speedCard. redoCard .reversalCard }.

	aGame useCard: speedCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo:1.
	aGame useCard: redoCard from: 1 applyTo: 1.
	
	aGame start.

	self assert: (aGame positionOf: 1) equals: 4
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversalCardIsAppliedToSpeedCardThenShipGoesoneCellLessThanExpected [

	| aGame aDiceSet aBoard speedCard reversalCard |
	aDiceSet := RiggedDice new initializeWith: { 2 }.
	aBoard := Board
		          withSize: 100
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: {  }.
	speedCard := Speed new.
	reversalCard := Reversal reversing: speedCard.
	aGame := Game
		         playedIn: aBoard
		         by: 2
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: { speedCard. speedCard .reversalCard }.

	aGame useCard: speedCard from: 1 applyTo: 1.
	aGame useCard: reversalCard from: 2 applyTo:1.
	
	aGame start.

	self assert: (aGame positionOf: 1) equals: 2
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectAtomicBombCell [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 4 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 100. 0. 0. 100. 0. 3. 30. 20. 10.
		                     6. 4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         ReversePolarity new.
				         ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 5. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 5.
	aGame start.

	self assert: (aGame shieldOf: 1) equals: 2.
	self assert: (aGame shieldOf: 2) equals: 2.
	self assert: (aGame shieldOf: 3) equals: 2.
	self assert: (aGame positionOf: 1) equals: 1.
	self assert: (aGame positionOf: 2) equals: 1.
	self assert: (aGame positionOf: 3) equals: 1
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectBlackHole [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 100. 0. 0. 0. 0. 0. 100. 0. 3. 30. 20. 10.
		                     6. 4. 2. 5. 7 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         ReversePolarity new.
				         ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 10. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 10.
	aGame start.

	self assert: (aGame positionOf: 1) equals: 7.
	self assert: (aGame positionOf: 2) equals: 1.
	self assert: (aGame positionOf: 3) equals: 1
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectCardGiver [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10 }.
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
		         withDeck: { ReversePolarity new.  ReversePolarity new}.

	aGame useCard: ReversePolarity new from: 1 applyTo: 10. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 10.
	aGame start.

	self assert: (aGame getCardDeckSizeOf: 1) equals: 1.
	
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectHyperJump [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10 }.
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
		         withDeck: { ReversePolarity new.  ReversePolarity new}.

	aGame useCard: ReversePolarity new from: 1 applyTo: 11. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 11.
	aGame start.

	self assert: (aGame positionOf: 1) equals: 41.	
	self assert: (aGame positionOf: 2) equals:1.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectHyperSpaceJump [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10 }.
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
		         withDeck: {
				         ReversePolarity new.
				         ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 11. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 11.
	aGame start.

	self assert: (aGame positionOf: 1) equals: 15.
	self assert: (aGame shieldOf: 1) equals: 2.
	self assert: (aGame positionOf: 2) equals: 1.
	self assert: (aGame shieldOf: 2) equals: 3.
]

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReverseCardDobleAppliedOnTheSameCellThenEffectIsTheOrginalAndNotReversedEffectMoonWalk [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 10. 11. 5}.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 0. 0. 0. 0. 0. 100. 0. 100. 0. 3. 30. 20. 10.
		                     4. 4. 4. 4. 4. 0 }.
	aBoard := Board
		          withSize: 50
		          composedOf: (WormHole startingAt: 1 endingAt: 1)
		          andACellConfiguration: aConfigureDiceSet.
	aGame := Game
		         playedIn: aBoard
		         by: 3
		         throwing: aDiceSet
		         wonAfter: 1
		         withDeck: {
				         ReversePolarity new.
				         ReversePolarity new }.

	aGame useCard: ReversePolarity new from: 1 applyTo: 6. "En el apply el num representa el numero de casillero"
	aGame useCard: ReversePolarity new from: 1 applyTo: 6.
	aGame start.

	self assert: (aGame positionOf: 1) equals: 3.
	self assert: (aGame positionOf: 2) equals: 8.
	self assert: (aGame positionOf: 3) equals: 6
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
SpecialCards_V2Tests >> testWhenReversePolarityCardIsAppliedOnANoEffectCellThenNothingHappens [

	| aGame aDiceSet aBoard aConfigureDiceSet |
	aDiceSet := RiggedDice new initializeWith: { 40. 10. 5 }.
	aConfigureDiceSet := RiggedDice new initializeWith:
		                     { 100. 0. 0. 0. 0. 0. 0. 100. 0. 3. 30. 20. 10.
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
	self assert: (aGame positionOf: 2) equals: 11.
	self assert: (aGame positionOf: 3) equals: 6. 
	self assert: (aGame getCardDeckSizeOf: 1) equals:1.
	"Dejo que la carta se pueda aplicar en una posible Interacion del proyecto las celdas puedan mutar y el jugador quiere plantar el reverse para afectar a los demas o beneficiarse"
	

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

{ #category : 'tests' }
SpecialCards_V2Tests >> testWhenReversePolarityCardIsApplyToAtomicBombCellThenShiledsNotDamagedShip1IsNotAtBegining [

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
