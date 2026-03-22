Class {
	#name : 'IntuneWarehouseModelCollection',
	#superclass : 'IntuneDataEntity',
	#instVars : [
		'name',
		'kind',
		'url'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'as yet unclassified' }
IntuneWarehouseModelCollection class >> serializationProperties [
	^ {#name -> #name.
		#kind -> #kind.
		#url -> #url}
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> kind [
	^ kind
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> kind: anObject [
	kind := anObject
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> name [
	^ name
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> url [
	^ url
]

{ #category : 'accessing' }
IntuneWarehouseModelCollection >> url: anObject [
	url := anObject
]
