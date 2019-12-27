build:
	xcodebuild clean build CODE_SIGNING_ALLOWED=NO
	ldid -S./Lime/Lime.entitlements ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -vr ./build/Release-iphoneos/Lime.app ./deb/Applications/Lime.app/
	dpkg -b deb

install:
	cat deb.deb | ssh root@$(LIMEIP) "cat > /tmp/_.deb; dpkg -i /tmp/_.deb; rm /tmp/_.deb; su mobile -c uicache"

remove:
	ssh root@$LIMEIP "rm -rf /Applications/Lime.app; su mobile -c uicache"

clean:
	xcodebuild clean
	rm -rf build
	rm -f deb.deb
	rm -rf deb/Applications/*

compile:
	make clean build package install
