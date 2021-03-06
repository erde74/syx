"
Copyright (c) 2007 Luca Bruno

This file is part of Smalltalk YX.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
"

!SystemDictionary methodsFor: 'initialize-release'!

at: aSymbol put: anObject
    aSymbol isSymbol
	ifFalse: [ self error: 'system dictionary may have only symbol keys' ].
    ^super at: aSymbol put: anObject
!

quit: exitStatus
    "Quit Syx with exitStatus"
    <primitive: 'Smalltalk_quit'>
	self primitiveFailed
!

quit
    "Quit Syx"
    ^self quit: 0
!

registerForSystemInitialization: anObject
    systemInitializationRequests add: anObject
!

initializeFirstSystem
    "This method is called on image creation"
    systemInitializationRequests := Set new.

    Object allSubclassesDo: [ :ea |
	ea initialize ].
!

startupObject: anObject
    startupObject := anObject
!

initializeSystem: commandLineArguments
    commandLine := CommandLine new: commandLineArguments.

    self
	at: #stdin put: (StdIOStream on: 0 for: FileStream read);
	at: #stdout put: (StdIOStream on: 1 for: FileStream write);
	at: #stderr put: (StdIOStream on: 2 for: FileStream write);
	at: #Transcript put: (TextCollector proxyMessage: stdout -> #nextPutAll:).

    systemInitializationRequests do: [ :ea |
	ea initializeSystem ].
!

startupSystem
    | continueStartup evalString |
    startupProcess := Processor activeProcess.

    commandLine parse: #(c e:).
    continueStartup := commandLine options at: #c ifAbsent: [ false ].
    evalString := commandLine options at: #e: ifAbsent: [ nil ].
    evalString
        ifNotNil: [ evalString doIt ].

    commandLine arguments do: [ :fileName |
        FileStream fileIn: fileName ].

    commandLine commandLineArguments isEmpty | continueStartup
        ifFalse: [ ^self ].

    startupObject isNil
        ifTrue: [
	     Console startup ]
	ifFalse: [
	     startupObject startup ]
! !

!SystemDictionary methodsFor: 'private'!

rehashClass
    ^self class superclass
! !

!SystemDictionary methodsFor: 'accessing'!

commandLine
    ^commandLine
! !

!SystemDictionary methodsFor: 'plugins'!

plugin: pluginName cCall: functionName withArguments: anArray
    <primitive: 'Smalltalk_pluginCall'>
	self primitiveFailed
!

cCall: functionName withArguments: anArray
    ^self plugin: nil cCall: functionName withArguments: anArray
!

plugin: pluginName cSymbol: symbolName
    <primitive: 'Smalltalk_pluginSymbol'>
	self primitiveFailed
!

loadPlugin: name
    <primitive: 'Smalltalk_loadPlugin'>
	self primitiveFailed
!

unloadPlugin: name
    <primitive: 'Smalltalk_unloadPlugin'>
	self primitiveFailed
! !

!SystemDictionary methodsFor: 'platform'!

environmentVariableAt: aStringOrSymbol
    <primitive: 'Smalltalk_environmentVariableAt'>
	self primitiveFailed
!

version
    ^'Smalltalk YX 0.1.6'
! !
