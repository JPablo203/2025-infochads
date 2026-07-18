Class {
	#name : 'Acceleration',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Acceleration >> affectsMovement [

	^ true
]

{ #category : 'as yet unclassified' }
Acceleration >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame addPermanentEffect: self to: 0
]
