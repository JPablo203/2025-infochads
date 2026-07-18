Class {
	#name : 'ReversePolarity',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
ReversePolarity >> applyTo: aGame from: aShip applyTo: aTargetedCell [

	aGame applyReversePolarityOfCell: aTargetedCell 
]
