"
A group of IntuneMobileApp instances. Use #lobApps to get a filtered group containing only LOB app types.
"
Class {
	#name : 'IntuneMobileApps',
	#superclass : 'IntuneDataGroup',
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'gt-views' }
IntuneMobileApps >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Apps';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #displayName weight: 0.4;
		column: 'Type' text: #odataType weight: 0.35;
		column: 'Publisher' text: [ :app | app publisher ifNil: [ '' ] ] weight: 0.25
]

{ #category : 'accessing' }
IntuneMobileApps >> lobApps [
	^ self class withAll: (self items select: #isLobApp)
]
