"
Microsoft Graph API client for Intune operations. Handles OAuth2 client_credentials token flow automatically with expiry-based caching.

Primary use case: retrieving Azure Storage SAS URIs for LOB (Line of Business) app binaries managed in Intune.

API chain: mobileApps → contentVersions → files → azureStorageUri

Usage:
  client := IntuneGraphClient new
    tenantId: 'your-tenant-id';
    clientId: 'your-client-id';
    clientSecret: 'your-client-secret'.
  apps := client lobApps.
  uri := apps items first storageUri.
"
Class {
	#name : 'IntuneGraphClient',
	#superclass : 'Object',
	#instVars : [
		'baseUrl',
		'tenantId',
		'clientId',
		'clientSecret',
		'token',
		'tokenExpiry',
		'history'
	],
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'examples' }
IntuneGraphClient class >> example [
	<gtExample>
	<noTest>
	| config |
	config := IntuneGraphClientExamples new clientConfig.
	^ self new
		tenantId: (config at: #tenantId);
		clientId: (config at: #clientId);
		clientSecret: (config at: #clientSecret)
]

{ #category : 'accessing' }
IntuneGraphClient >> baseUrl [
	^ baseUrl
]

{ #category : 'accessing' }
IntuneGraphClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : 'private' }
IntuneGraphClient >> checkForErrors: aResponse [
	(aResponse isKindOf: Dictionary)
		ifFalse: [ ^ aResponse ].
	(aResponse includesKey: 'error')
		ifFalse: [ ^ aResponse ].
	Error signal: ((aResponse at: 'error') at: 'message' ifAbsent: [ 'Unknown Graph API error' ]).
	^ aResponse
]

{ #category : 'accessing' }
IntuneGraphClient >> clientId [
	^ clientId
]

{ #category : 'accessing' }
IntuneGraphClient >> clientId: anObject [
	clientId := anObject
]

{ #category : 'accessing' }
IntuneGraphClient >> clientSecret [
	^ clientSecret
]

{ #category : 'accessing' }
IntuneGraphClient >> clientSecret: anObject [
	clientSecret := anObject
]

{ #category : 'api - apps' }
IntuneGraphClient >> contentFileForApp: appId lobType: lobType versionId: versionId fileId: fileId [
	| path response |
	path := 'deviceAppManagement/mobileApps/' , appId , '/' , lobType , '/contentVersions/' , versionId , '/files/' , fileId.
	response := self get: path.
	^ (IntuneContentFile from: response) client: self
]

{ #category : 'api - apps' }
IntuneGraphClient >> contentFilesForApp: appId lobType: lobType versionId: versionId [
	| path response files |
	path := 'deviceAppManagement/mobileApps/' , appId , '/' , lobType , '/contentVersions/' , versionId , '/files'.
	response := self get: path.
	files := (response at: 'value') collect: [ :each |
		(IntuneContentFile from: each)
			client: self;
			appId: appId;
			lobTypeSegment: lobType;
			versionId: versionId ].
	^ IntuneContentFiles withAll: files
]

{ #category : 'api - apps' }
IntuneGraphClient >> contentVersionsForApp: anApp [
	| path response versions |
	path := 'deviceAppManagement/mobileApps/' , anApp id , '/' , anApp lobTypeSegment , '/contentVersions'.
	response := self get: path.
	versions := (response at: 'value') collect: [ :each |
		(IntuneContentVersion from: each)
			client: self;
			appId: anApp id;
			lobTypeSegment: anApp lobTypeSegment ].
	^ IntuneContentVersions withAll: versions
]

{ #category : 'authentication' }
IntuneGraphClient >> ensureValidToken [
	token ifNil: [ ^ self fetchToken ].
	DateAndTime now >= tokenExpiry ifTrue: [ ^ self fetchToken ]
]

{ #category : 'authentication' }
IntuneGraphClient >> fetchToken [
	| response expiresIn |
	response := ZnClient new
		url: self tokenEndpoint;
		formAt: 'grant_type' put: 'client_credentials';
		formAt: 'client_id' put: clientId;
		formAt: 'client_secret' put: clientSecret;
		formAt: 'scope' put: 'https://graph.microsoft.com/.default';
		post.
	response := STONJSON fromString: response.
	token := response at: 'access_token'.
	expiresIn := response at: 'expires_in'.
	tokenExpiry := DateAndTime now + (expiresIn - 60) seconds
]

{ #category : 'api' }
IntuneGraphClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : 'api' }
IntuneGraphClient >> get: aUrl withParams: aListOfAssocs [
	| aClient result |
	aClient := self initializeClient.
	aClient url: baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].
	aClient entity: nil.
	result := aClient get.
	history add: aClient.
	^ self checkForErrors: result
]

{ #category : 'gt-views' }
IntuneGraphClient >> gtHistoryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'History';
		priority: 10;
		items: [ history reversed ];
		column: 'Request' text: [ :c | c request ifNotNil: [ :r | r method , ' ' , r uri asString ] ifNil: [ '' ] ] weight: 0.6;
		column: 'Status' text: [ :c | c response ifNotNil: #code ifNil: [ '' ] ] weight: 0.15;
		column: 'Size' text: [ :c | c response ifNotNil: [ :r | r entity contentLength ] ifNil: [ '' ] ] weight: 0.25
]

{ #category : 'gt-views' }
IntuneGraphClient >> gtMobileAppsFor: aView [
	<gtView>
	^ aView forward
		title: 'Mobile Apps';
		priority: 1;
		object: [ self mobileApps ];
		view: #gtItemsFor:
]

{ #category : 'accessing' }
IntuneGraphClient >> history [
	^ history
]

{ #category : 'initialization' }
IntuneGraphClient >> initialize [
	super initialize.
	baseUrl := 'https://graph.microsoft.com/beta' asZnUrl.
	history := OrderedCollection new
]

{ #category : 'private' }
IntuneGraphClient >> initializeClient [
	self ensureValidToken.
	^ ZnClient new
		forJsonREST;
		timeout: 120;
		setBearerAuthentication: token;
		headerAt: 'user-agent' put: 'IntuneGraphClient'
]

{ #category : 'api - apps' }
IntuneGraphClient >> lobApps [
	^ self mobileApps lobApps
]

{ #category : 'api - apps' }
IntuneGraphClient >> mobileApps [
	| response apps |
	response := self get: 'deviceAppManagement/mobileApps'.
	apps := (response at: 'value') collect: [ :each |
		(IntuneMobileApp from: each) client: self ].
	^ IntuneMobileApps withAll: apps
]

{ #category : 'printing' }
IntuneGraphClient >> printOn: aStream [
	aStream
		nextPutAll: 'IntuneGraphClient(';
		nextPutAll: baseUrl asString;
		nextPut: $)
]

{ #category : 'api - apps' }
IntuneGraphClient >> storageUriForApp: anApp [
	| versions latestVersion files file |
	versions := self contentVersionsForApp: anApp.
	versions items ifEmpty: [ ^ nil ].
	latestVersion := versions items last.
	files := latestVersion files.
	files items ifEmpty: [ ^ nil ].
	file := files items first fetchDetails.
	^ file azureStorageUri
]

{ #category : 'accessing' }
IntuneGraphClient >> tenantId [
	^ tenantId
]

{ #category : 'accessing' }
IntuneGraphClient >> tenantId: anObject [
	tenantId := anObject
]

{ #category : 'accessing' }
IntuneGraphClient >> token [
	^ token
]

{ #category : 'authentication' }
IntuneGraphClient >> tokenEndpoint [
	^ 'https://login.microsoftonline.com/' , tenantId , '/oauth2/v2.0/token'
]
