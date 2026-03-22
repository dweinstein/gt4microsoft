Class {
	#name : 'BaselineOfGt4Microsoft',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGt4Microsoft',
	#package : 'BaselineOfGt4Microsoft'
}

{ #category : 'baseline' }
BaselineOfGt4Microsoft >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Microsoft'
		]
]
