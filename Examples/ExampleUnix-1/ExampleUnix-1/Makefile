OS := $(shell uname)
ifeq ($(OS), Darwin)
	# Run MacOS commands
	SWIFT = xcrun -sdk macosx swiftc
else
	# check for Linux and run other commands
	SWIFT = sudo swiftc
endif

all:
	$(SWIFT) main.swift\
		EKLinuxDataClasses.swift\
		../../../EngineKit/EngineKitCore/EKVector3.swift \
		../../../EngineKit/EngineKitCore/EKVector4.swift \
		../../../EngineKit/EngineKitCore/EKMatrix.swift \
		../../../EngineKit/EngineKitCore/EKVector2.swift \
		../../../EngineKit/EngineKitCore/EKSwiftExtensions.swift \
		../../../EngineKit/EngineKitCore/EKFileManager.swift \
		../../../EngineKit/EngineKitCore/EKOSFactory.swift \
		../../../EngineKit/EngineKitCore/EKLanguageEngine.swift \
		../../../EngineKit/EngineKitCore/EKEngine.swift \
		../../../EngineKit/EngineKitCore/EKEvent.swift \
		../../../EngineKit/EngineKitCore/EKColor.swift \
		../../../EngineKit/EngineKitCore/EKAddon.swift \
		../../../EngineKit/EngineKitCore/EKSwiftEngine.swift \
		../../../EngineKit/EngineKitUnix/EKUnixSwiftExtensions.swift
