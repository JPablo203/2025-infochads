Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'spaceShips',
		'diceSet',
		'nextSpaceShipToMove',
		'numberOfSpaceShips',
		'laps',
		'board',
		'spaceShipPositions',
		'deck',
		'lastCardEffect'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Game class >> lapsMustBePositive: aNumberOfLaps [

	(aNumberOfLaps isInteger and: [ aNumberOfLaps > 0 ]) ifFalse: [
		self error: 'Laps must be a positive integer.' ]
]

{ #category : 'as yet unclassified' }
Game class >> numberOfSpaceShipsMustBeAtLeastOne: aNumberOfSpaceShips [

	aNumberOfSpaceShips <= 0 ifTrue: [
		Error signal: 'The number of space ships must be at least 1.' ]
]

{ #category : 'as yet unclassified' }
Game class >> numberOfSpaceShipsMustBePositive: aNumberOfSpaceShips [

	(aNumberOfSpaceShips isInteger not or: [
		 aNumberOfSpaceShips negative ]) ifTrue: [
		Error signal:
			'The number of space ships should be a positive integer.' ]
]

{ #category : 'as yet unclassified' }
Game class >> playedIn: aBoard by: aNumberOfSpaceShips throwing: aDiceSet wonAfter: aNumberOfLaps withDeck: aDeck [

	self numberOfSpaceShipsMustBePositive: aNumberOfSpaceShips.
	self numberOfSpaceShipsMustBeAtLeastOne: aNumberOfSpaceShips.
	self lapsMustBePositive: aNumberOfLaps.

	^ self new
		  initializeWithBoardSize: aBoard
		  by: aNumberOfSpaceShips
		  thorwing: aDiceSet
		  wonAfter: aNumberOfLaps
		  withDeck: aDeck 
		
]

{ #category : 'adding' }
Game >> addPermanentEffect: anEffect to: anAffectedShip [

	| targetShips |
	
	targetShips :=self getTarget: anAffectedShip.
	targetShips do: [ :ship | ship apply: anEffect ].
	
	lastCardEffect:= anEffect.
	
]

{ #category : 'as yet unclassified' }
Game >> affectedRoll: aDiceRoll of:aSpaceShip [

	| extraPositionsByEffect |
	extraPositionsByEffect := aSpaceShip searchForIncrementalEffect.
	^aDiceRoll + extraPositionsByEffect
]

{ #category : 'as yet unclassified' }
Game >> applyBattleResultWithLoser: aLoser [

	self lostBattle: aLoser.
	aLoser hasMercenary ifTrue: [
		aLoser getMercenary do: [ :mercenaryShip |
			self lostBattle: mercenaryShip getAlly ] ]
]

{ #category : 'as yet unclassified' }
Game >> applyEffect: aCardEffect to: anAffectedShip [

	| effectiveCard targetShips |
	self validateRedo: aCardEffect.

	effectiveCard := aCardEffect resolveCardWith: lastCardEffect.

	self applyRepeat: anAffectedShip to: aCardEffect.

	targetShips := self getTarget: anAffectedShip.

	targetShips do: [ :ship | ship apply: effectiveCard ].

	lastCardEffect := self updateLastCarEffect: aCardEffect
]

{ #category : 'as yet unclassified' }
Game >> applyLastCardEffectFrom: aShip to: anAffectedShip [

	lastCardEffect isBlankCard ifTrue: [
		Error signal:
			'Redo Card not Used. No Card Effect Has Been Used Before Redo.' ].
	lastCardEffect class new applyTo: self from: aShip applyTo: anAffectedShip
]

{ #category : 'as yet unclassified' }
Game >> applyRepeat: anAffectedShip to: aCardEffect [

	aCardEffect isRepeat ifTrue: [
		board
			applyLastEffectPowerUpUponA: (spaceShips at: anAffectedShip)
			andAll: spaceShips
			andIts: spaceShipPositions ]
]

{ #category : 'as yet unclassified' }
Game >> applyReversePolarityOfCell: aCellIndex [
	
	board reversePolarityAt: aCellIndex.
	
	
	
	
]

{ #category : 'as yet unclassified' }
Game >> battleBetween: aSpaceShip1 and: aSpaceShip2 [

	| throwSpaceShip1 throwSpaceShip2 winner loser  throwMercenary2 throwMercenary1|
	[
	throwSpaceShip2 := diceSet toss.
	throwSpaceShip1 := diceSet toss.
	throwSpaceShip1 = throwSpaceShip2 ] whileTrue: [  ].

	(aSpaceShip1 hasMercenary or: aSpaceShip2 hasMercenary) ifTrue: [
		throwMercenary2 := self mercenaryThrowsFor: aSpaceShip2 .
		throwMercenary1 := self mercenaryThrowsFor: aSpaceShip1.
		
		throwSpaceShip2 :=  throwMercenary2 + throwSpaceShip2.
		throwSpaceShip1 := throwMercenary1 + throwSpaceShip1 ].

	

	throwSpaceShip1 < throwSpaceShip2
		ifTrue: [
			winner := aSpaceShip2.
			loser := aSpaceShip1 ]
		ifFalse: [
			winner := aSpaceShip1.
			loser := aSpaceShip2 ].

	self applyBattleResultWithLoser: loser
]

{ #category : 'as yet unclassified' }
Game >> chooseMercenary: aMercenarySpaceShip for: aSpaceShip [
	
	| employerShip mercShip |
	employerShip := spaceShips at: aSpaceShip.
	mercShip := spaceShips at: aMercenarySpaceShip.
	(spaceShips  anySatisfy: [ :ship | ship getMercenary anySatisfy:[:contract | contract getAlly = mercShip] ]).
	employerShip setMercenary: mercShip .
]

{ #category : 'whats left of race positions' }
Game >> create: aNumberOfSpaceShips [

	| aPosition aShield |
	aPosition := Position at: 1 withLaps: 0.
	aShield := 3.

	spaceShips := OrderedCollection new.
	spaceShipPositions := OrderedDictionary new.

	1 to: aNumberOfSpaceShips do: [ :id |
		spaceShips add:
			(SpaceShip with: id andStartingWith: aShield).
		spaceShipPositions at: id put: aPosition ]
]

{ #category : 'as yet unclassified' }
Game >> drawCardFor: aSpaceShip [

	(spaceShips at: aSpaceShip) drawCard: deck drawRandomCard.
]

{ #category : 'as yet unclassified' }
Game >> getCardDeckSizeOf: aShip [

	^ (spaceShips at: aShip) getShipDeck 
]

{ #category : 'informationTest' }
Game >> getRanking [

	| ranking |
	self isOver ifFalse: [ ^ #(  ) ].

	ranking := spaceShips sorted: [ :ship1 :ship2 |
		           (spaceShipPositions at: ship1 id) lap
		           -> (spaceShipPositions at: ship1 id) position
		           > ((spaceShipPositions at: ship2 id) lap
			            -> (spaceShipPositions at: ship2 id) position) ].

	^ (ranking collect: [ :each | each id ]) asArray
]

{ #category : 'as yet unclassified' }
Game >> getShipHands [

	^(spaceShips allSatisfy: [ :ship | ship getShipDeck = 2 ])
]

{ #category : 'as yet unclassified' }
Game >> getTarget: anAffectedShip [

	^ anAffectedShip = 0
		  ifTrue: [ spaceShips ]
		  ifFalse: [ Array with: (spaceShips at: anAffectedShip) ]
]

{ #category : 'as yet unclassified' }
Game >> giveInitialCardsToShips [

	spaceShips do: [ :ship |
		2 timesRepeat: [ ship drawCard: deck drawRandomCard ] ]
]

{ #category : 'initialization' }
Game >> initializeWithBoardSize: aBoard by: aNumberOfSpaceShips thorwing: aDiceSet wonAfter: aNumberOfLaps withDeck: aDeck [

	board := aBoard.

	spaceShipPositions := OrderedDictionary new.
	self create: aNumberOfSpaceShips.

	diceSet := aDiceSet.
	nextSpaceShipToMove := 1.
	numberOfSpaceShips := aNumberOfSpaceShips.
	laps := aNumberOfLaps.
	deck := aDeck isCollection
		        ifTrue: [ CardDeck withCards: aDeck ]
		        ifFalse: [ aDeck ].
	lastCardEffect := BlankCard new.
	self giveInitialCardsToShips.
	^ self
]

{ #category : 'whats left of race positions' }
Game >> isGameOver [

	^ spaceShips anySatisfy: [ :aShip |
		  (spaceShipPositions at: aShip id) isEqualTo:
			  (Position at: board boardSize withLaps: laps) ]
]

{ #category : 'informationTest' }
Game >> isOver [

	^ self isGameOver
]

{ #category : 'informationTest' }
Game >> lapOf: aSpaceShipID [

	^ (spaceShipPositions at: aSpaceShipID) lap
]

{ #category : 'as yet unclassified' }
Game >> lookForBattle: aSpaceShip [

	| opponentShip |
	((spaceShipPositions at: aSpaceShip id) isPositionEqualTo:
		 (Position at: 1 withLaps: 0)) ifTrue: [ ^ self ].

	opponentShip := self obtainOponentShip: aSpaceShip.

	opponentShip == aSpaceShip ifFalse: [
		self battleBetween: aSpaceShip and: opponentShip ]
]

{ #category : 'as yet unclassified' }
Game >> lostBattle: aSpaceShip [

	spaceShipPositions
		at: aSpaceShip id
		put: ((spaceShipPositions at: aSpaceShip id) sumTo: (Position
					  at: (spaceShipPositions at: aSpaceShip id) position negated + 1
					  withLaps: 0)).
	aSpaceShip loseShield
]

{ #category : 'as yet unclassified' }
Game >> mercenaryThrowsFor: aSpaceShip [

	| totalThrow |
	totalThrow := 0.
	aSpaceShip getMercenary do: [ :mercenary |
		totalThrow := totalThrow + diceSet toss ].
	^ totalThrow
]

{ #category : 'as yet unclassified' }
Game >> move: aSpaceShip after: aDiceRoll [

	| aDiceRollWithEffect |
	(self skippingTurn: aSpaceShip after: aDiceRoll) ifTrue: [ ^ self ].
	
	aDiceRollWithEffect:=self affectedRoll:aDiceRoll of:aSpaceShip.
	self sumTo: aSpaceShip the: (Position at: aDiceRollWithEffect withLaps: 0).

	self sumTo: aSpaceShip the: (board
			 limitAdjustmentAt: (spaceShipPositions at: aSpaceShip id)
			 with: laps).

	board
		applyEffecOfPowerUpUponA: aSpaceShip
		andAll: spaceShips
		andIts: spaceShipPositions.

	self
		replacePositionOf: aSpaceShip
		with:
		(board positionAfterWormHole: (spaceShipPositions at: aSpaceShip id)).

	spaceShips do: [ :ship |
		self sumTo: ship the: (board
				 limitAdjustmentAt: (spaceShipPositions at: ship id)
				 with: laps) ].

	self lookForBattle: aSpaceShip
]

{ #category : 'as yet unclassified' }
Game >> obtainOponentShip: aSpaceShip [

	| otherShips |
	otherShips := spaceShips reject: [ :ship | ship = aSpaceShip ].

	otherShips ifEmpty: [ ^ aSpaceShip ].

	^ otherShips
		  detect: [ :ship |
			  ((spaceShipPositions at: ship id) isPositionEqualTo:
				   (spaceShipPositions at: aSpaceShip id)) and: ship canBattle ]
		  ifNone: [ aSpaceShip ]
]

{ #category : 'informationTest' }
Game >> positionOf: aSpaceShipID [

	^ (spaceShipPositions at: aSpaceShipID) position
]

{ #category : 'removing' }
Game >> removePermanentEffect: anEffect [

	spaceShips do: [ :ship | ship removeEffect: anEffect ].
]

{ #category : 'as yet unclassified' }
Game >> repeatLastCellEffectOn: anAffectedShip [

	board
		applyLastEffectPowerUpUponA: (spaceShips at: anAffectedShip)
		andAll: spaceShips
		andIts: spaceShipPositions
]

{ #category : 'as yet unclassified' }
Game >> replacePositionOf: aSpaceShip with: aPosition [

	spaceShipPositions
		at: aSpaceShip id
		put:
		((spaceShipPositions at: aSpaceShip id) replacePositionWith:
			 aPosition)
]

{ #category : 'informationTest' }
Game >> shieldOf: aSpaceShipID [

	^ (spaceShips at: aSpaceShipID) getShield
]

{ #category : 'as yet unclassified' }
Game >> skippingTurn: aSpaceShip after: aDiceRoll [

	^ aSpaceShip skipTurns or: (aSpaceShip skipATurn: aDiceRoll)
]

{ #category : 'accessing' }
Game >> start [

	| aDiceRoll spaceShip |
	aDiceRoll := diceSet toss.
	"-1 allows to stop the rigged dice"
	[ self isGameOver or: aDiceRoll = -1 ] whileFalse: [
		spaceShip := spaceShips at: nextSpaceShipToMove.

		self move: spaceShip after: aDiceRoll.

		self updateNextShipToMove: nextSpaceShipToMove.
		aDiceRoll := diceSet toss ]
]

{ #category : 'as yet unclassified' }
Game >> sumTo: aSpaceShip the: aPosition [

	spaceShipPositions
		at: aSpaceShip id
		put: ((spaceShipPositions at: aSpaceShip id) sumTo: aPosition)
]

{ #category : 'as yet unclassified' }
Game >> updateLastCarEffect: aCardEffect [

	^ aCardEffect isRedo
		  ifFalse: [ aCardEffect ]
		  ifTrue: [ lastCardEffect ]
]

{ #category : 'as yet unclassified' }
Game >> updateNextShipToMove: spaceShipID [

	nextSpaceShipToMove := spaceShipID + 1.
	nextSpaceShipToMove > numberOfSpaceShips ifTrue: [
		nextSpaceShipToMove := 1 ]
]

{ #category : 'as yet unclassified' }
Game >> useCard: aCardEffect from: aShip applyTo: affectedShipOrCellIndex [

	((spaceShips at: aShip) checkForCard: aCardEffect) ifFalse: [
		Error signal: 'Card is not in ship hand' ].

	aCardEffect applyTo: self from: aShip  applyTo: affectedShipOrCellIndex .

	aCardEffect isApplicable ifTrue: [
		(spaceShips at: aShip) removeCardFromDeck: aCardEffect ]
]

{ #category : 'as yet unclassified' }
Game >> validateRedo: aCardEffect [

	(lastCardEffect isBlankCard and: aCardEffect isRedo) ifFalse: [ ^ self ].
	aCardEffect isApplicable: false.
	Error signal:
		'Redo Card not Used. No Card Effect Has Been Used Before Redo.'
]
