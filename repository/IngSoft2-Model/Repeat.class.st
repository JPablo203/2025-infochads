Class {
	#name : 'Repeat',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Repeat >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame repeatLastCellEffectOn: aTarget
]
