"
An Intune mobile app from the Microsoft Graph API. Covers store apps, LOB apps, and other types.

Key fields: displayName, odataType, publisher, developer, fileName, size, packageId (Android), bundleId (iOS), versionName, versionCode, appStoreUrl.

Use #isLobApp to test if this is a Line of Business app.
Use #storageUri to walk the full content chain and retrieve the Azure Blob SAS download URL (LOB apps only).
"
Class {
	#name : 'IntuneMobileApp',
	#superclass : 'IntuneDataEntity',
	#instVars : [
		'id',
		'displayName',
		'odataType',
		'publisher',
		'fileName',
		'description',
		'developer',
		'owner',
		'createdDateTime',
		'lastModifiedDateTime',
		'size',
		'uploadState',
		'publishingState',
		'isAssigned',
		'committedContentVersion',
		'versionName',
		'versionCode',
		'packageId',
		'bundleId',
		'appStoreUrl'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'serialization' }
IntuneMobileApp class >> serializationProperties [
	^ {
		'id' -> #id.
		'@odata.type' -> #odataType.
		'displayName' -> #displayName.
		'description' -> #description.
		'publisher' -> #publisher.
		'developer' -> #developer.
		'owner' -> #owner.
		'fileName' -> #fileName.
		'size' -> #size.
		'createdDateTime' -> #createdDateTime.
		'lastModifiedDateTime' -> #lastModifiedDateTime.
		'uploadState' -> #uploadState.
		'publishingState' -> #publishingState.
		'isAssigned' -> #isAssigned.
		'committedContentVersion' -> #committedContentVersion.
		'versionName' -> #versionName.
		'versionCode' -> #versionCode.
		'packageId' -> #packageId.
		'bundleId' -> #bundleId.
		'appStoreUrl' -> #appStoreUrl
	}
]

{ #category : 'accessing' }
IntuneMobileApp >> appStoreUrl [
	^ appStoreUrl
]

{ #category : 'accessing' }
IntuneMobileApp >> appStoreUrl: anObject [
	appStoreUrl := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> bundleId [
	^ bundleId
]

{ #category : 'accessing' }
IntuneMobileApp >> bundleId: anObject [
	bundleId := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> committedContentVersion [
	^ committedContentVersion
]

{ #category : 'accessing' }
IntuneMobileApp >> committedContentVersion: anObject [
	committedContentVersion := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> contentVersions [
	^ client contentVersionsForApp: self
]

{ #category : 'accessing' }
IntuneMobileApp >> createdDateTime [
	^ createdDateTime
]

{ #category : 'accessing' }
IntuneMobileApp >> createdDateTime: anObject [
	createdDateTime := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> description [
	^ description
]

{ #category : 'accessing' }
IntuneMobileApp >> description: anObject [
	description := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> developer [
	^ developer
]

{ #category : 'accessing' }
IntuneMobileApp >> developer: anObject [
	developer := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> displayName [
	^ displayName
]

{ #category : 'accessing' }
IntuneMobileApp >> displayName: anObject [
	displayName := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> fileName [
	^ fileName
]

{ #category : 'accessing' }
IntuneMobileApp >> fileName: anObject [
	fileName := anObject
]

{ #category : 'gt-views' }
IntuneMobileApp >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ 
			{
				'Display Name' -> (displayName ifNil: [ '' ]).
				'Type' -> (odataType ifNil: [ '' ]).
				'ID' -> (id ifNil: [ '' ]).
				'Description' -> (description ifNil: [ '' ]).
				'Publisher' -> (publisher ifNil: [ '' ]).
				'Developer' -> (developer ifNil: [ '' ]).
				'Owner' -> (owner ifNil: [ '' ]).
				'File Name' -> (fileName ifNil: [ '' ]).
				'Size' -> (size ifNil: [ '' ]).
				'Version Name' -> (versionName ifNil: [ '' ]).
				'Version Code' -> (versionCode ifNil: [ '' ]).
				'Package ID' -> (packageId ifNil: [ '' ]).
				'Bundle ID' -> (bundleId ifNil: [ '' ]).
				'App Store URL' -> (appStoreUrl ifNil: [ '' ]).
				'Upload State' -> (uploadState ifNil: [ '' ]).
				'Publishing State' -> (publishingState ifNil: [ '' ]).
				'Is Assigned' -> (isAssigned ifNil: [ '' ]).
				'Content Version' -> (committedContentVersion ifNil: [ '' ]).
				'Created' -> (createdDateTime ifNil: [ '' ]).
				'Last Modified' -> (lastModifiedDateTime ifNil: [ '' ]).
				'Is LOB App' -> self isLobApp
			} reject: [ :assoc | assoc value = '' ] ];
		column: 'Property' text: #key weight: 0.3;
		column: 'Value' text: #value
]

{ #category : 'accessing' }
IntuneMobileApp >> id [
	^ id
]

{ #category : 'accessing' }
IntuneMobileApp >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> isAssigned [
	^ isAssigned
]

{ #category : 'accessing' }
IntuneMobileApp >> isAssigned: anObject [
	isAssigned := anObject
]

{ #category : 'testing' }
IntuneMobileApp >> isLobApp [
	odataType ifNil: [ ^ false ].
	^ odataType includesSubstring: 'LobApp'
]

{ #category : 'accessing' }
IntuneMobileApp >> lastModifiedDateTime [
	^ lastModifiedDateTime
]

{ #category : 'accessing' }
IntuneMobileApp >> lastModifiedDateTime: anObject [
	lastModifiedDateTime := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> lobTypeSegment [
	"Derives e.g. 'microsoft.graph.iosLobApp' from '#microsoft.graph.iosLobApp'"
	^ odataType copyWithout: $#
]

{ #category : 'accessing' }
IntuneMobileApp >> odataType [
	^ odataType
]

{ #category : 'accessing' }
IntuneMobileApp >> odataType: anObject [
	odataType := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> owner [
	^ owner
]

{ #category : 'accessing' }
IntuneMobileApp >> owner: anObject [
	owner := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> packageId [
	^ packageId
]

{ #category : 'accessing' }
IntuneMobileApp >> packageId: anObject [
	packageId := anObject
]

{ #category : 'printing' }
IntuneMobileApp >> printOn: aStream [
	aStream nextPutAll: (displayName ifNil: [ 'IntuneMobileApp' ])
]

{ #category : 'accessing' }
IntuneMobileApp >> publisher [
	^ publisher
]

{ #category : 'accessing' }
IntuneMobileApp >> publisher: anObject [
	publisher := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> publishingState [
	^ publishingState
]

{ #category : 'accessing' }
IntuneMobileApp >> publishingState: anObject [
	publishingState := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> size [
	^ size
]

{ #category : 'accessing' }
IntuneMobileApp >> size: anObject [
	size := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> storageUri [
	"Walk contentVersions → files → fetchDetails to get the Azure SAS URI"
	| versions files |
	self isLobApp ifFalse: [ ^ nil ].
	versions := self contentVersions.
	versions items ifEmpty: [ ^ nil ].
	files := versions items last files.
	files items ifEmpty: [ ^ nil ].
	^ files items first fetchDetails azureStorageUri
]

{ #category : 'accessing' }
IntuneMobileApp >> uploadState [
	^ uploadState
]

{ #category : 'accessing' }
IntuneMobileApp >> uploadState: anObject [
	uploadState := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> versionCode [
	^ versionCode
]

{ #category : 'accessing' }
IntuneMobileApp >> versionCode: anObject [
	versionCode := anObject
]

{ #category : 'accessing' }
IntuneMobileApp >> versionName [
	^ versionName
]

{ #category : 'accessing' }
IntuneMobileApp >> versionName: anObject [
	versionName := anObject
]
