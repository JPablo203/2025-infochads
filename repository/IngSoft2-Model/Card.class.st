Class {
	#name : 'Card',
	#superclass : 'Object',
	#instVars : [
		'isApplicable'
	],
	#classInstVars : [
		'isApplicable'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Card >> affectsMovement [

	^ false
]

{ #category : 'as yet unclassified' }
Card >> applyTo: aGame from: aShip applyTo: aTarget [

	self subclassResponsibility
]

{ #category : 'testing' }
Card >> canBeRecordedAsLastEffect [

	^ true
]

{ #category : 'accessing' }
Card >> isApplicable [

	^ isApplicable ifNil: [ true ]
]

{ #category : 'testing' }
Card >> isBlankCard [

	^ false
]
