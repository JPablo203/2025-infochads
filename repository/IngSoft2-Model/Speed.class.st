Class {
	#name : 'Speed',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Speed >> affectsMovement [

	^ 1
]

{ #category : 'as yet unclassified' }
Speed >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame addPermanentEffect: self to: aTarget
]
