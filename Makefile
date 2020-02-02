build:
	xcodebuild build CODE_SIGNING_ALLOWED=NO
	@ldid -S./Lime/Lime.entitlements ./build/Release-iphoneos/Lime.app/Lime

package:
	@rm -rf ./LimePackage/Applications/Lime.app
	@mkdir -p LimePackage/Applications/Lime.app/
	@cp -r ./build/Release-iphoneos/Lime.app/** ./LimePackage/Applications/Lime.app
	dpkg -b LimePackage

install:
	@export PWD $(/usr/bin/pwd)
	cat LimePackage.deb | $(PWD)/helpers/remotecmd.helper "cat > /tmp/_.deb; dpkg -i /tmp/_.deb; rm /tmp/_.deb; uicache -a; killall -9 Lime"

clean:
	@xcodebuild clean
	@rm -rf build
	@rm -f LimePackage.deb
	@rm -rf LimePackage/Applications/*

do:
	make build package install
