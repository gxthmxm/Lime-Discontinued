build:
	xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -project Lime.xcodeproj
	ldid -S ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -r ./build/Release-iphoneos/Lime.app ./deb/Applications/
	dpkg -b deb

install:
	scp deb.deb root@192.168.1.100:/var/mobile
	ssh root@192.168.1.100 "dpkg -i /var/mobile/deb.deb && rm /var/mobile/deb.deb && uicache"

clean:
	xcodebuild clean
	rm deb.deb
	rm -rf deb/Applications/*
