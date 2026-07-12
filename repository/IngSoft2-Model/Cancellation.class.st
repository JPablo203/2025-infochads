Class {
	#name : 'Cancellation',
	#superclass : 'Card',
	#instVars : [
		'removedEffect'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Cancellation >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame removePermanentEffect: removedEffect
]

{ #category : 'testing' }
Cancellation >> canBePlayedAtAnyMoment [

	^ true
]

{ #category : 'as yet unclassified' }
Cancellation >> effectTypeToCancel: effectToRemove [

	removedEffect := effectToRemove
]

{ #category : 'as yet unclassified' }
Cancellation >> getEffect [

	^ removedEffect
]

{ #category : 'testing' }
Cancellation >> isCancellation [

	^ true
]
