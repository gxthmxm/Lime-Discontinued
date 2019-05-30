IDEVICE_IP ?= 192.168.1.100
IDEVICE_PORT ?= 22

build:
	xcodebuild clean build CODE_SIGNING_REQUIRED=NO -UseModernBuildSystem=NO -project Lime.xcodeproj
	ldid -S ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -r ./build/Release-iphoneos/Lime.app ./deb/Applications/
	dpkg -b deb

install:
	cat deb.deb | ssh -p22 root@$(IDEVICE_IP) "cat > /tmp/_.deb; dpkg -i /tmp/_.deb; rm /tmp/_.deb; su mobile -c uicache"

clean:
	xcodebuild -UseModernBuildSystem=NO clean
	rm -rf build
	rm -f deb.deb
	rm -rf deb/Applications/*
