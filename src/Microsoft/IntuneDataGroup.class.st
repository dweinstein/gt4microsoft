Class {
	#name : 'IntuneDataGroup',
	#superclass : 'Object',
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'client'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'as yet unclassified' }
IntuneDataGroup class >> from: aList [
	^ self withAll: (aList collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : 'as yet unclassified' }
IntuneDataGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
IntuneDataGroup >> client [
	^ client
]

{ #category : 'accessing' }
IntuneDataGroup >> client: anObject [
	client := anObject
]
