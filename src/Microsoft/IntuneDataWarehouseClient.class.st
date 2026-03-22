Class {
	#name : 'IntuneDataWarehouseClient',
	#superclass : 'Object',
	#instVars : [
		'client',
		'baseUrl',
		'users',
		'announcer',
		'token'
	],
	#classVars : [
		'ApiKeyFile'
	],
	#category : 'Microsoft-Intune',
	#package : 'Microsoft',
	#tag : 'Intune'
}

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient class >> new [
	^ self basicNew initialize
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> announcer [
	^ announcer
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> announcer: anObject [
	announcer := anObject
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> baseUrl [
	^ baseUrl
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> checkForErrors: aResponse [
	"((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: Collection)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ ^ (IntuneError from: (aResponse at: 'error')) signal ]."

	^ aResponse
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> client [
	^ client
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> client: anObject [
	client := anObject
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> defaultClient [
	^ ZnClient new
		headerAt: 'user-agent' put: 'IntuneWarehouseClient';
		beOneShot;
		forJsonREST
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> get: aUrl withParams: aListOfAssocs [
	client url: self baseUrl/ aUrl.
	aListOfAssocs do: [ :aPair | client queryAt: aPair key put: aPair value ].
	client entity: nil.
	^ client get
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> initialize [
	super initialize.
	self client: self defaultClient
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> listCollections [
	| res |
	res := self get: '/'.
	^ (IntuneWarehouseModelCollections from: (res at: 'value')) client: self
]

{ #category : 'as yet unclassified' }
IntuneDataWarehouseClient >> post: aString withEntity: anEntity [
	| resp |
	resp := client
			url: self baseUrl / aString;
			contents: anEntity;
			post.
	^ STONJSON fromString: resp
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> token [
	^ token ifNil: [ token := self defaultApiKeyFile contents trimBoth ]
]

{ #category : 'accessing' }
IntuneDataWarehouseClient >> token: anObject [
	token := anObject.
	client setBearerAuthentication: token
]
