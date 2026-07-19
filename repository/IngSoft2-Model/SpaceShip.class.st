Class {
	#name : 'SpaceShip',
	#superclass : 'Object',
	#instVars : [
		'shield',
		'spaceShipID',
		'loseTurn',
		'effects',
		'hand'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
SpaceShip class >> itMustHaveAnID: anId [

	(anId = '') ifTrue: [
		Error signal: 'The ship must be identifiable.' ]
]

{ #category : 'as yet unclassified' }
SpaceShip class >> itMustHaveThree: aShield [

	(aShield isInteger and: [ aShield = 3 ]) ifFalse: [
		Error signal: 'The ship must initialize with 3 shield.' ]
]

{ #category : 'as yet unclassified' }
SpaceShip class >> with: anId andStartingWith: aShield [

	self itMustHaveThree: aShield.
	self itMustHaveAnID: anId.

	^ self new initializeWithShield: aShield and: anId
]

{ #category : 'target resize' }
SpaceShip >> apply: aCardEffect [

	effects add: aCardEffect 
]

{ #category : 'testing' }
SpaceShip >> canBattle [

	^ shield > 0 and: loseTurn = 0
]

{ #category : 'as yet unclassified' }
SpaceShip >> checkForCard: aCardEffect [
	
	
	^hand anySatisfy: [ :effect | effect class = aCardEffect class ].
	
	
]

{ #category : 'as yet unclassified' }
SpaceShip >> drawCard: aCard [

	hand add: aCard
]

{ #category : 'as yet unclassified' }
SpaceShip >> getMercenary [

	
	^ (effects select: [ :effect | effect isMercenary ])  
]

{ #category : 'getters' }
SpaceShip >> getShield [

	^ shield
]

{ #category : 'as yet unclassified' }
SpaceShip >> getShipDeck [

	^ hand size
]

{ #category : 'testing' }
SpaceShip >> hasMercenary [

	^ (self getMercenary) notEmpty
]

{ #category : 'getters' }
SpaceShip >> id [

	^ spaceShipID
]

{ #category : 'initialization' }
SpaceShip >> initializeWithShield: aNumberOfShields and: aSpaceShipID [

	spaceShipID := aSpaceShipID.
	shield := aNumberOfShields.
	loseTurn := 0.
	effects := OrderedCollection new.
	hand := OrderedCollection new.
	^ self
]

{ #category : 'shield' }
SpaceShip >> loseShield [

	shield := shield - 1.
	shield = 0 ifTrue: [ loseTurn := 2 ]
]

{ #category : 'shield' }
SpaceShip >> rechargableShield: aDiceRoll [

	(shield = 3 and: aDiceRoll = 0) ifTrue: [
		Error signal: 
			'The Shield is already full, it cant be recharged.' ]
]

{ #category : 'removing' }
SpaceShip >> removeCardFromDeck: aCardEffect [

	| aCardToRemove |
	aCardToRemove:= hand detect:[:aCard | aCard class = aCardEffect class].
	hand remove:aCardToRemove
]

{ #category : 'target resize' }
SpaceShip >> removeEffect: aCardEffect [

	| effectToRemove |
	effectToRemove := effects
		                  detect: [ :each | each = aCardEffect ]
		                  ifNone: [
			                  Error signal:
				                  'There is no Permanent effect active, Cancelleation Card not Used.' ].

	effects remove: effectToRemove
]

{ #category : 'as yet unclassified' }
SpaceShip >> searchForIncrementalEffect [

	| incrementalEffects |
	incrementalEffects := effects count: [ :anEffect | anEffect affectsMovement  ].

	^ incrementalEffects
]

{ #category : 'initialization' }
SpaceShip >> setMercenary: aMercenarySpaceShip [

	effects do: [ :effect |
		(effect hasNoMercenary) ifTrue: [
			effect signContract: aMercenarySpaceShip.

			^ self ] ]
]

{ #category : 'accessing' }
SpaceShip >> skipATurn: aDiceRoll [

	| doSkip |
	self rechargableShield: aDiceRoll.

	doSkip := false.
	aDiceRoll = 0 ifTrue: [
		shield := 3.
		doSkip := true ].

	^ doSkip
]

{ #category : 'accessing' }
SpaceShip >> skipTurns [

	loseTurn ~= 0
		ifTrue: [
			loseTurn := loseTurn - 1.
			^ true ]
		ifFalse: [ ^ false ]
]
