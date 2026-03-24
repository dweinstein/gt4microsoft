"
Examples for the IntuneGraphClient and its domain model classes. 

Mock data examples (safe to run as tests) use real API response shapes with sanitized data. Integration examples (marked <noTest>) hit the live Microsoft Graph API and require valid credentials.
"
Class {
	#name : 'IntuneGraphClientExamples',
	#superclass : 'Object',
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'examples - integration' }
IntuneGraphClientExamples >> client [
	<gtExample>
	<noTest>
	| client config |
	config := self clientConfig.
	client := IntuneGraphClient new
		tenantId: (config at: #tenantId);
		clientId: (config at: #clientId);
		clientSecret: (config at: #clientSecret).
	self assert: client baseUrl asString equals: 'https://graph.microsoft.com/beta'.
	^ client
]

{ #category : 'private' }
IntuneGraphClientExamples >> clientConfig [
	"Reads credentials from ~/.secrets/intune-graph-config.json
	Expected format: { ""tenantId"": ""..."", ""clientId"": ""..."", ""clientSecret"": ""..."" }
	Alternatively, clientSecret can be a file path starting with '/' which will be read."
	| path json config secret |
	path := FileLocator home / '.secrets' / 'intune-graph-config.json'.
	path exists ifFalse: [ self error: 'Missing config file: ' , path fullName ].
	json := path contents.
	config := STONJSON fromString: json.
	secret := config at: 'clientSecret'.
	(secret beginsWith: '/')
		ifTrue: [ secret := secret asFileReference contents trimBoth ].
	^ {
		#tenantId -> (config at: 'tenantId').
		#clientId -> (config at: 'clientId').
		#clientSecret -> secret
	} asDictionary
]

{ #category : 'examples - content files' }
IntuneGraphClientExamples >> contentFile [
	<gtExample>
	| file |
	file := IntuneContentFile from: self contentFileRawData.
	self assert: file name equals: 'OmniNotes-playRelease-6.3.1.apk'.
	self assert: file size equals: 8406639.
	self assert: file sizeEncrypted equals: 8406688.
	self assert: file hasStorageUri.
	self assert: file isCommitted.
	self assert: file uploadState equals: 'commitFileSuccess'.
	^ file
]

{ #category : 'examples - mock data' }
IntuneGraphClientExamples >> contentFileRawData [
	^ {
		'id' -> '6e48eebe-e6b8-40d9-af20-5416957e5274'.
		'name' -> 'OmniNotes-playRelease-6.3.1.apk'.
		'size' -> 8406639.
		'sizeEncrypted' -> 8406688.
		'azureStorageUri' -> 'https://mmcswda01.blob.core.windows.net/test-container/test-blob.apk.bin'.
		'azureStorageUriExpirationDateTime' -> '2099-12-31T23:59:59Z'.
		'uploadState' -> 'commitFileSuccess'.
		'isCommitted' -> true
	} asDictionary
]

{ #category : 'examples - content files' }
IntuneGraphClientExamples >> contentFileWithoutUri [
	<gtExample>
	| data file |
	data := self contentFileRawData copy.
	data removeKey: 'azureStorageUri'.
	data removeKey: 'azureStorageUriExpirationDateTime'.
	file := IntuneContentFile from: data.
	self assert: file hasStorageUri not.
	^ file
]

{ #category : 'examples - content files' }
IntuneGraphClientExamples >> contentVersion [
	<gtExample>
	| version |
	version := IntuneContentVersion from: { 'id' -> '1' } asDictionary.
	version
		appId: '74378b29-8e05-4205-86fe-5caf3de1cf42';
		lobTypeSegment: 'microsoft.graph.androidLobApp'.
	self assert: version id equals: '1'.
	self assert: version appId equals: '74378b29-8e05-4205-86fe-5caf3de1cf42'.
	self assert: version lobTypeSegment equals: 'microsoft.graph.androidLobApp'.
	^ version
]

{ #category : 'examples - mobile apps' }
IntuneGraphClientExamples >> lobApp [
	<gtExample>
	| app |
	app := IntuneMobileApp from: self lobAppRawData.
	self assert: app displayName equals: 'Omni Notes'.
	self assert: app odataType equals: '#microsoft.graph.androidLobApp'.
	self assert: app isLobApp.
	self assert: app lobTypeSegment equals: 'microsoft.graph.androidLobApp'.
	self assert: app packageId equals: 'it.feio.android.omninotes'.
	self assert: app versionName equals: '6.3.1'.
	self assert: app fileName equals: 'OmniNotes-playRelease-6.3.1.apk'.
	self assert: app size equals: 8406688.
	^ app
]

{ #category : 'examples - mock data' }
IntuneGraphClientExamples >> lobAppRawData [
	^ {
		'@odata.type' -> '#microsoft.graph.androidLobApp'.
		'id' -> '74378b29-8e05-4205-86fe-5caf3de1cf42'.
		'displayName' -> 'Omni Notes'.
		'description' -> 'OmniNotes-playRelease-6.3.1.apk'.
		'publisher' -> 'Federico Iosue'.
		'developer' -> 'Federico Iosue'.
		'owner' -> 'DW'.
		'fileName' -> 'OmniNotes-playRelease-6.3.1.apk'.
		'size' -> 8406688.
		'createdDateTime' -> '2026-03-21T21:16:29Z'.
		'lastModifiedDateTime' -> '2026-03-21T21:16:29Z'.
		'uploadState' -> 1.
		'publishingState' -> 'published'.
		'isAssigned' -> false.
		'committedContentVersion' -> '1'.
		'packageId' -> 'it.feio.android.omninotes'.
		'versionName' -> '6.3.1'.
		'versionCode' -> '331'
	} asDictionary
]

{ #category : 'examples - integration' }
IntuneGraphClientExamples >> lobAppsWithStorageUri [
	<gtExample>
	<noTest>
	| client lobs app uri |
	client := self client.
	lobs := client lobApps.
	lobs items ifEmpty: [ ^ lobs ].
	app := lobs items first.
	uri := app storageUri.
	self assert: uri isNotNil.
	self assert: (uri beginsWith: 'https://').
	^ app
]

{ #category : 'examples - integration' }
IntuneGraphClientExamples >> mobileApps [
	<gtExample>
	<noTest>
	| apps |
	apps := self client mobileApps.
	self assert: apps isNotEmpty.
	self assert: (apps items allSatisfy: [ :a | a displayName isNotNil ]).
	^ apps
]

{ #category : 'examples - mobile apps' }
IntuneGraphClientExamples >> mobileAppsGroup [
	<gtExample>
	| lob store apps |
	lob := self lobApp.
	store := self storeApp.
	apps := IntuneMobileApps withAll: { lob. store }.
	self assert: apps size equals: 2.
	self assert: apps lobApps size equals: 1.
	self assert: apps lobApps items first equals: lob.
	^ apps
]

{ #category : 'examples - mobile apps' }
IntuneGraphClientExamples >> storeApp [
	<gtExample>
	| app |
	app := IntuneMobileApp from: self storeAppRawData.
	self assert: app displayName equals: 'CamScanner - PDF Scanner App'.
	self assert: app odataType equals: '#microsoft.graph.iosStoreApp'.
	self assert: app isLobApp not.
	self assert: app bundleId equals: 'com.intsig.CamScannerLite'.
	self assert: app appStoreUrl isNotNil.
	^ app
]

{ #category : 'examples - mock data' }
IntuneGraphClientExamples >> storeAppRawData [
	^ {
		'@odata.type' -> '#microsoft.graph.iosStoreApp'.
		'id' -> '001b2f13-2043-4a92-9a71-b6a14d149c60'.
		'displayName' -> 'CamScanner - PDF Scanner App'.
		'description' -> 'The most intelligent scanner app'.
		'publisher' -> 'INTSIG Information Co.,Ltd'.
		'developer' -> 'INTSIG Information Co.,Ltd'.
		'owner' -> ''.
		'createdDateTime' -> '2026-03-21T20:00:00Z'.
		'lastModifiedDateTime' -> '2026-03-21T20:00:00Z'.
		'uploadState' -> 1.
		'publishingState' -> 'published'.
		'isAssigned' -> false.
		'bundleId' -> 'com.intsig.CamScannerLite'.
		'appStoreUrl' -> 'https://apps.apple.com/us/app/camscanner-pdf-scanner-app/id388627783?uo=4'
	} asDictionary
]
