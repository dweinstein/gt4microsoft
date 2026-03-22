"
A group of IntuneContentVersion instances for an Intune LOB app.
"
Class {
	#name : 'IntuneContentVersions',
	#superclass : 'IntuneDataGroup',
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'gt-views' }
IntuneContentVersions >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Content Versions';
		priority: 1;
		items: [ self items ];
		column: 'ID' text: #id
]
