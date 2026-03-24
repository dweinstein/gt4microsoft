"
A group of IntuneContentFile instances for an Intune LOB app content version.
"
Class {
	#name : 'IntuneContentFiles',
	#superclass : 'IntuneDataGroup',
	#category : 'Microsoft',
	#package : 'Microsoft'
}

{ #category : 'gt-views' }
IntuneContentFiles >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #name weight: 0.5;
		column: 'Size' text: [ :f | f size ifNotNil: [ :s | s humanReadableSISizeString ] ifNil: [ '' ] ] weight: 0.25;
		column: 'State' text: [ :f | f uploadState ifNil: [ '' ] ] weight: 0.25;
		send: [ :f | f fetchDetails ]
]
