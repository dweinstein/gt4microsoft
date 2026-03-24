Class {
	#name : 'BaselineOfGt4Microsoft',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGt4Microsoft',
	#package : 'BaselineOfGt4Microsoft'
}

{ #category : 'loading' }
BaselineOfGt4Microsoft class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4microsoft' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : 'baseline' }
BaselineOfGt4Microsoft >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Microsoft'
		]
]
