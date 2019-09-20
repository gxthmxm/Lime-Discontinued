build:
	xcodebuild clean build CODE_SIGNING_REQUIRED=NO -UseModernBuildSystem=NO -project Lime.xcodeproj
	ldid -S ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -vr ./build/Release-iphoneos/Lime.app ./deb/Applications/
	dpkg -b deb

install:
	cat deb.deb | ssh -p 22 root@192.168.0.87 "cat > /tmp/_.deb; dpkg -i /tmp/_.deb; rm /tmp/_.deb; su mobile -c uicache"

clean:
	xcodebuild -UseModernBuildSystem=NO clean
	rm -rf build
	rm -f deb.deb
	rm -rf deb/Applications/*
