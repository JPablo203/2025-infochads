Class {
	#name : 'Mercenary',
	#superclass : 'Card',
	#instVars : [
		'ally'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Mercenary >> applyTo: aGame from: aShip applyTo: aTarget [

	aGame addPermanentEffect: self to: aTarget
]

{ #category : 'as yet unclassified' }
Mercenary >> getAlly [

	^ ally
]

{ #category : 'testing' }
Mercenary >> hasNoMercenary [

	^ ally isNil
]

{ #category : 'testing' }
Mercenary >> isMercenary [

	^ true
]

{ #category : 'as yet unclassified' }
Mercenary >> modifyThrow: aTotalThrow using: aDiceSet [

	^ aTotalThrow + aDiceSet toss
]

{ #category : 'as yet unclassified' }
Mercenary >> signContract: aMercenarySpaceShip [

	ally := aMercenarySpaceShip
]
