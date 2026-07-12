Class {
	#name : 'Redo',
	#superclass : 'Card',
	#instVars : [
		'lastCardEffect'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Redo >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame applyLastCardEffectFrom: aShip to: aTarget
]

{ #category : 'testing' }
Redo >> canBePlayedAtAnyMoment [

	^ true
]

{ #category : 'accessing' }
Redo >> getLastCardEffect [

	^ lastCardEffect
]
