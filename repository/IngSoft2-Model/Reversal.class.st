Class {
	#name : 'Reversal',
	#superclass : 'Card',
	#instVars : [
		'targetEffect'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Reversal class >> reversing: aCardEffect [

	^ self new initializeWith: aCardEffect
]

{ #category : 'comparing' }
Reversal >> = anObject [

	self == anObject ifTrue: [ ^ true ].

	targetEffect = anObject ifTrue: [ ^ true ].

	(anObject isReverse ) ifTrue: [
		^ targetEffect == anObject reversedEffect ].

	^ false
]

{ #category : 'as yet unclassified' }
Reversal >> affectsMovement [

	^ (targetEffect affectsMovement) *(-1)
]

{ #category : 'as yet unclassified' }
Reversal >> applyTo: aGame from: aShip applyTo: aTarget [

	| trueTarget |
	trueTarget := targetEffect targetIndexBasedOn: aTarget.
	aGame reversePermanentEffect: targetEffect from: trueTarget
]

{ #category : 'initialization' }
Reversal >> initializeWith: aCardEffect [

	targetEffect := aCardEffect
]

{ #category : 'testing' }
Reversal >> isReverse [

	^ true
]

{ #category : 'as yet unclassified' }
Reversal >> originalCard [

	^ targetEffect originalCard
]

{ #category : 'converting' }
Reversal >> reversed [

	^ targetEffect
]

{ #category : 'as yet unclassified' }
Reversal >> reversedEffect [

	^ targetEffect
]
