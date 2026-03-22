Class {
	#name : 'IntuneDataEntity',
	#superclass : 'Object',
	#instVars : [
		'rawData',
		'client'
	],
	#category : 'Microsoft-Intune',
	#package : 'Microsoft',
	#tag : 'Intune'
}

{ #category : 'accessing' }
IntuneDataEntity class >> from: aDictionary [
	| entity |
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	entity := self new.

	entity from: aDictionary.

	^ entity
]

{ #category : 'accessing' }
IntuneDataEntity class >> serializationProperties [
	^ #()
]

{ #category : 'accessing' }
IntuneDataEntity >> client [
	^ client
]

{ #category : 'accessing' }
IntuneDataEntity >> client: anObject [
	client := anObject
]

{ #category : 'as yet unclassified' }
IntuneDataEntity >> deserializeTime: anObject [
	^ (anObject isNil or: [ anObject isKindOf: DateAndTime ])
		ifTrue: [ anObject ]
		ifFalse: [ DateAndTime fromUnixTime: anObject ]
]

{ #category : 'as yet unclassified' }
IntuneDataEntity >> from: aDictionary [
	self rawData: aDictionary.

	self class serializationProperties
		do: [ :aPair | 
			self
				perform: (aPair value , ':') asSymbol
				withArguments: {aDictionary at: aPair key asString ifAbsent: [ nil ]} ]
]

{ #category : 'as yet unclassified' }
IntuneDataEntity >> merge: anotherEntity [
	self rawData: anotherEntity rawData.

	self class serializationProperties
		do: [ :aPair | 
			| aValue |
			aValue := anotherEntity perform: aPair value.
			aValue
				ifNotNil: [ self perform: (aPair value , ':') asSymbol withArguments: {aValue} ] ]
]

{ #category : 'accessing' }
IntuneDataEntity >> rawData [
	^ rawData
]

{ #category : 'accessing' }
IntuneDataEntity >> rawData: anObject [
	rawData := anObject
]

{ #category : 'accessing' }
IntuneDataEntity >> serialize [
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
		reject: [ :aValue | aValue isNil ]
]
