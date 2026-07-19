Class {
	#name : 'Acceleration',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Acceleration >> affectsMovement [

	^ 1
]

{ #category : 'as yet unclassified' }
Acceleration >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame addPermanentEffect: self to: 0
]

{ #category : 'as yet unclassified' }
Acceleration >> targetIndexBasedOn: aTargetIndex [

	^ 0
]
