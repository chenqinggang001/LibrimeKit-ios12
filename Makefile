mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

COCOAPODS_EXISTS:=$(shell gem list -i cocoapods)

BOOST_FRAMEWORK_PATH=boost-iosx
ICU_FRAMEWORK_PATH=boost-iosx/scripts/Pods/icu4c-iosx/product/frameworks

.PHONY: cocoapads boost-build boost-clean librime-check librime-build librime-clean

cocoapods:
	$(info gem cocoapads check)
ifeq ($(COCOAPODS_EXISTS), true)
	$(info cocoapads installed)
else
	$(info need install cocoapads)
	sudo gem install cocoapods
endif

boost-build: cocoapods
	$(info boost build begin)
	${MAKE} -C boost-iosx build
	rm -rf Frameworks/Headers Frameworks/boost*.xcframework Frameworks/icu*.xcframework && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_atomic.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_filesystem.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_regex.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_locale.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_system.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/Headers Frameworks/Headers && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icudata.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icui18n.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icuio.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icuuc.xcframework Frameworks

boost-copy:
	rm -rf Frameworks/Headers Frameworks/boost*.xcframework Frameworks/icu*.xcframework  && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_atomic.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_filesystem.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_regex.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_locale.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/boost_system.xcframework Frameworks && \
		cp -rf ${BOOST_FRAMEWORK_PATH}/frameworks/Headers Frameworks/Headers && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icudata.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icui18n.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icuio.xcframework Frameworks && \
		cp -rf ${ICU_FRAMEWORK_PATH}/icuuc.xcframework Frameworks

boost-clean:
	${MAKE} -C boost-iosx clean

librime-check:
	# brew install cmake
	@[ -f `which cmake` ] || { echo "Install cmake first"; exit 1; }

librime-build: librime-check
	# git submodule update --init
	${mkfile_dir}/librimeBuild.sh

librime-clean:
	rm -rf include lib
	rm -rf ${mkfile_dir}/librime*.patch.apply
	rm -rf librime Frameworks/lib*.xcframework lib/*
