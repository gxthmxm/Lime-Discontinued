IDEVICE_IP ?= 0
IDEVICE_PORT ?= 2222

build:
	xcodebuild clean build CODE_SIGNING_REQUIRED=NO -UseModernBuildSystem=NO -project Lime.xcodeproj
	ldid -S ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -r ./build/Release-iphoneos/Lime.app ./deb/Applications/
	dpkg -b deb

install:
	scp -P $(IDEVICE_PORT) deb.deb root@$(IDEVICE_IP):/var/mobile
	ssh -p$(IDEVICE_PORT) root@$(IDEVICE_IP) "dpkg -i /var/mobile/deb.deb && rm /var/mobile/deb.deb && uicache"

clean:
	xcodebuild clean
	rm -f deb.deb
	rm -rf deb/Applications/*
