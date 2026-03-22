"
A content version for an Intune LOB app. Each LOB app can have multiple content versions. Navigate to #files to access the content files with Azure Storage URIs.
"
Class {
	#name : 'IntuneContentVersion',
	#superclass : 'IntuneDataEntity',
	#instVars : [
		'id',
		'appId',
		'lobTypeSegment'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'serialization' }
IntuneContentVersion class >> serializationProperties [
	^ {
		'id' -> #id
	}
]

{ #category : 'accessing' }
IntuneContentVersion >> appId [
	^ appId
]

{ #category : 'accessing' }
IntuneContentVersion >> appId: anObject [
	appId := anObject
]

{ #category : 'accessing' }
IntuneContentVersion >> files [
	^ client contentFilesForApp: appId lobType: lobTypeSegment versionId: id
]

{ #category : 'gt-views' }
IntuneContentVersion >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ {
			'ID' -> (id ifNil: [ '' ]).
			'App ID' -> (appId ifNil: [ '' ]).
			'LOB Type' -> (lobTypeSegment ifNil: [ '' ])
		} ];
		column: 'Property' text: #key weight: 0.3;
		column: 'Value' text: #value
]

{ #category : 'gt-views' }
IntuneContentVersion >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 2;
		object: [ self files ];
		view: #gtItemsFor:
]

{ #category : 'accessing' }
IntuneContentVersion >> id [
	^ id
]

{ #category : 'accessing' }
IntuneContentVersion >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
IntuneContentVersion >> lobTypeSegment [
	^ lobTypeSegment
]

{ #category : 'accessing' }
IntuneContentVersion >> lobTypeSegment: anObject [
	lobTypeSegment := anObject
]

{ #category : 'printing' }
IntuneContentVersion >> printOn: aStream [
	aStream
		nextPutAll: 'ContentVersion(';
		nextPutAll: (id ifNil: [ '?' ]);
		nextPut: $)
]
