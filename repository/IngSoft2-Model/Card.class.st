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

	^ 0
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

{ #category : 'testing' }
Card >> isMercenary [

	^ false
]

{ #category : 'testing' }
Card >> isReverse [

	^ false
]

{ #category : 'as yet unclassified' }
Card >> originalCard [

	^ self
]

{ #category : 'converting' }
Card >> reversed [

	^ Reversal reversing: self
]

{ #category : 'as yet unclassified' }
Card >> targetIndexBasedOn: aTargetIndex [

	^ aTargetIndex
]
