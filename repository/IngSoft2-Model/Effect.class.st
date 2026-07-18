Class {
	#name : 'Effect',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Effect >> applyToAllSpaceShips: aPosition [

	^ Position at: aPosition withLaps: 0
]

{ #category : 'as yet unclassified' }
Effect >> applyToSpaceShip: aPosition [

	^ Position at: aPosition withLaps: 0
]

{ #category : 'as yet unclassified' }
Effect >> damageAllShields [

	^ false
]

{ #category : 'as yet unclassified' }
Effect >> damageShield [

	^ false
]

{ #category : 'as yet unclassified' }
Effect >> giveCardToShip [

	^ self
]
