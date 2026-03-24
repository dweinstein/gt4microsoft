"
A content file within an Intune LOB app content version. Contains the azureStorageUri — a time-limited SAS URL to download the app binary from Azure Blob Storage.

Important: The list endpoint does not return azureStorageUri. Call #fetchDetails to GET the individual file resource and populate the URI. Use #isStorageUriValid to check if the URI has expired.
"
Class {
	#name : 'IntuneContentFile',
	#superclass : 'IntuneDataEntity',
	#instVars : [
		'id',
		'name',
		'size',
		'sizeEncrypted',
		'azureStorageUri',
		'azureStorageUriExpirationDateTime',
		'uploadState',
		'isCommitted',
		'appId',
		'lobTypeSegment',
		'versionId'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'serialization' }
IntuneContentFile class >> serializationProperties [
	^ {
		'id' -> #id.
		'name' -> #name.
		'size' -> #size.
		'sizeEncrypted' -> #sizeEncrypted.
		'azureStorageUri' -> #azureStorageUri.
		'azureStorageUriExpirationDateTime' -> #azureStorageUriExpirationDateTime.
		'uploadState' -> #uploadState.
		'isCommitted' -> #isCommitted
	}
]

{ #category : 'accessing' }
IntuneContentFile >> appId [
	^ appId
]

{ #category : 'accessing' }
IntuneContentFile >> appId: anObject [
	appId := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> azureStorageUri [
	^ azureStorageUri
]

{ #category : 'accessing' }
IntuneContentFile >> azureStorageUri: anObject [
	azureStorageUri := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> azureStorageUriExpirationDateTime [
	^ azureStorageUriExpirationDateTime
]

{ #category : 'accessing' }
IntuneContentFile >> azureStorageUriExpirationDateTime: anObject [
	azureStorageUriExpirationDateTime := anObject
]

{ #category : 'actions' }
IntuneContentFile >> download [
	"Download to a default location (~/Downloads/intune/)"
	| dir |
	dir := FileLocator temp / 'intune'.
	dir ensureCreateDirectory.
	^ self downloadTo: dir
]

{ #category : 'actions' }
IntuneContentFile >> downloadTo: aDirectory [
	"Download the app binary from the Azure SAS URI to the given directory. Returns the file reference."
	| targetFile |
	self hasStorageUri ifFalse: [ self error: 'No storage URI available. Call fetchDetails first.' ].
	targetFile := aDirectory asFileReference / (name ifNil: [ 'download.bin' ]).
	ZnClient new
		url: azureStorageUri;
		downloadTo: targetFile.
	^ targetFile
]

{ #category : 'api' }
IntuneContentFile >> fetchDetails [
	"Fetch individual file details from the API to populate azureStorageUri"
	| detailed |
	detailed := client
		contentFileForApp: appId
		lobType: lobTypeSegment
		versionId: versionId
		fileId: id.
	self merge: detailed.
	^ self
]

{ #category : 'gt-views' }
IntuneContentFile >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ {
			'ID' -> (id ifNil: [ '' ]).
			'Name' -> (name ifNil: [ '' ]).
			'Size' -> (size ifNotNil: [ size humanReadableSISizeString ] ifNil: [ '' ]).
			'Size Encrypted' -> (sizeEncrypted ifNotNil: [ sizeEncrypted humanReadableSISizeString ] ifNil: [ '' ]).
			'Upload State' -> (uploadState ifNil: [ '' ]).
			'Is Committed' -> (isCommitted ifNil: [ '' ]).
			'Azure Storage URI' -> (azureStorageUri ifNil: [ '' ]).
			'URI Expiration' -> (azureStorageUriExpirationDateTime ifNil: [ '' ]).
			'Has Storage URI' -> self hasStorageUri
		} reject: [ :assoc | assoc value = '' ] ];
		column: 'Property' text: #key weight: 0.3;
		column: 'Value' text: #value
]

{ #category : 'gt-views' }
IntuneContentFile >> gtDownloadActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons savetodisk;
		tooltip: 'Download to /tmp/intune/';
		action: [ :aButton | 
			| file |
			file := self download.
			aButton phlow spawnObject: file ]
]

{ #category : 'testing' }
IntuneContentFile >> hasStorageUri [
	^ azureStorageUri isNotNil and: [ azureStorageUri isNotEmpty ]
]

{ #category : 'accessing' }
IntuneContentFile >> id [
	^ id
]

{ #category : 'accessing' }
IntuneContentFile >> id: anObject [
	id := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> isCommitted [
	^ isCommitted
]

{ #category : 'accessing' }
IntuneContentFile >> isCommitted: anObject [
	isCommitted := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> lobTypeSegment [
	^ lobTypeSegment
]

{ #category : 'accessing' }
IntuneContentFile >> lobTypeSegment: anObject [
	lobTypeSegment := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> name [
	^ name
]

{ #category : 'accessing' }
IntuneContentFile >> name: anObject [
	name := anObject
]

{ #category : 'printing' }
IntuneContentFile >> printOn: aStream [
	aStream nextPutAll: (name ifNil: [ 'IntuneContentFile' ])
]

{ #category : 'accessing' }
IntuneContentFile >> size [
	^ size
]

{ #category : 'accessing' }
IntuneContentFile >> size: anObject [
	size := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> sizeEncrypted [
	^ sizeEncrypted
]

{ #category : 'accessing' }
IntuneContentFile >> sizeEncrypted: anObject [
	sizeEncrypted := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> uploadState [
	^ uploadState
]

{ #category : 'accessing' }
IntuneContentFile >> uploadState: anObject [
	uploadState := anObject
]

{ #category : 'accessing' }
IntuneContentFile >> versionId [
	^ versionId
]

{ #category : 'accessing' }
IntuneContentFile >> versionId: anObject [
	versionId := anObject
]
