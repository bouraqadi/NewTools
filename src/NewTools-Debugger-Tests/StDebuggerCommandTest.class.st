Class {
	#name : #StDebuggerCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'session'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithDNUContext [
	[ Object new toto ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithErrorContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithFailingTestContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithMissingClassContext [
	[ MissingClass new]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext copy.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithMissingSubclassResponsibilityContext [
	[ 1/0 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> debuggerWithRunnableContext [
	[ Halt now ]
		on: Halt
		do: [ :err | 
			self sessionFor: err signalerContext.
			^ self newDebugger ]
]

{ #category : #helpers }
StDebuggerCommandTest >> newDebugger [
	^ StDebugger basicNew
		session: session;
		yourself
]

{ #category : #helpers }
StDebuggerCommandTest >> sessionFor: aContext [
	| process |
	process := Process
		forContext: aContext
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: 'test session'
		on: process
		startedAt: aContext
]

{ #category : #running }
StDebuggerCommandTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp
]

{ #category : #running }
StDebuggerCommandTest >> tearDown [ 
	session ifNotNil:[session terminate].
	super tearDown
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInDNUContext [

	|debugger|
	debugger := self debuggerWithDNUContext.
	
	"Executable commands relative to context"
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInErrorContext [

	|debugger|
	debugger := self debuggerWithErrorContext.
		
	"Executable commands relative to context"	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInFailingTestContext [

	|debugger|
	debugger := self debuggerWithDNUContext.
	self fail.
	
	"Executable commands relative to context"
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self deny: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self deny: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self deny: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self deny: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted.   
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInMissingClassContext [
	"When a class is missing, it is possible we are trying to send it a message.
	Define new class and define new method must be possible. "

	|debugger|
	debugger := self debuggerWithMissingClassContext.
	
	"Executable commands relative to context"	
	self assert: (StDefineClassCommand forContext: debugger) canBeExecuted.	
	self assert: (StDefineMethodCommand forContext: debugger) canBeExecuted.
	self assert: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted. 
	
	"Non-executable commands relative to context"
	self deny: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self deny: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self deny: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self deny: (StProceedCommand forContext: debugger) canBeExecuted. 
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.	
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInMissingSubclassResponsibilityContext [

	|debugger|
	self fail.
	debugger := self debuggerWithRunnableContext.
	
	"Executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self assert: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted. 	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.	
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.  	 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]

{ #category : #tests }
StDebuggerCommandTest >> testCommandsInRunnableContext [

	|debugger|
	debugger := self debuggerWithRunnableContext.
	
	"Executable commands relative to context"
	self assert: (StStepIntoCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepOverCommand forContext: debugger) canBeExecuted. 
	self assert: (StStepThroughCommand forContext: debugger) canBeExecuted. 
	self assert: (StRunToSelectionCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted. 	
	self assert: (StRestartCommand forContext: debugger) canBeExecuted. 
	self assert: (StReturnValueCommand forContext: debugger) canBeExecuted.
	
	"Non-executable commands relative to context"
	self deny: (StDefineSubclassResponsabilityCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMethodCommand forContext: debugger) canBeExecuted.	
	self deny: (StDefineClassCommand forContext: debugger) canBeExecuted.  
	self deny: (StDefineMissingEntityCommand forContext: debugger) canBeExecuted.  
	
	"Executable commands, whatever the context"
	self assert: (StCopyStackToClipboardCommand forContext: debugger) canBeExecuted. 
	self assert: (StFileOutMethodCommand forContext: debugger) canBeExecuted. 
	self assert: (StPeelToFirstCommand forContext: debugger) canBeExecuted. 
	self assert: (StShowFullStackCommand forContext: debugger) canBeExecuted.
	self assert: (StProceedCommand forContext: debugger) canBeExecuted.  	 
	self assert: (StWhereIsCommand forContext: debugger) canBeExecuted. 
]