Class {
	#name : 'IntuneWarehouseModelCollections',
	#superclass : 'IntuneDataGroup',
	#category : 'Microsoft-Intune',
	#package : 'Microsoft',
	#tag : 'Intune'
}

{ #category : 'as yet unclassified' }
IntuneWarehouseModelCollections class >> itemClass [
	^ IntuneWarehouseModelCollection
]

{ #category : 'as yet unclassified' }
IntuneWarehouseModelCollections >> gtCollectionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Collections';
		items: [ self ];
		column: 'Name'
			text: #name
			weight: 0.22;
		column: 'Kind'
			text: #kind
			width: 100;
		column: 'Url'
			text: #url
			weight: 0.3;
		send: [ :item | client get: item url ]
]
