# This Is a Rebuild #
Lessons learned:
	Put the entire projectƒ into another ProjectF.
	Git from there
	keep it entirely Modular.
	_Do_ Take the time to make your entities and controllers
	_Do_ All Access through EntityControllers
### Actual Re-Ignition ###


# ReadMe - A'iight! #
This is actually a preamble. I have been over this project a few times. And as I not a comp-sci student. I may have had less exposure to these OSS Ideas or whatnot. I don't care. CocoaPods / Swift Package Manager is important. This is funny b\c for the past few years I did not Need Libraries, I Write Libraries. Yannow, so I don't want to sound arrogant. Then there is the eveer present what if it breaks my Kit?… But I am fairly strict about CVS, and if need be I can re-assemble this kit from scratch As I just did to make it back into tricorder. (and I only forgot the Plist, and one Segue in the process) SO it is already sort of a library.
## Good Commands: ##
Pod Init; then edit the podfile, pod install, pod deintegrate, edit the podfile some more, pod install.

This is what I just did When I realized that I was in the Master Branch and hardly compliant. So as I close that commit I'll add some tips at the tippy-top!

# In Memory TestMOC: #
Well it actually is far from heroic but it seems to work So Now I can start tests on this stuff. Seriously it makes too much sens to test. I cannot think of a reason why not to at this point, and since I am Still in the master branch I do not want to leave until I can init something into the Test Rig. As Usual Xcode is finicky about me importing myself as testable adn I had to remember to turn coverage on and to turn UITests Off. While they are included I am not in that place as of yet. SO I am waiting for the derived data and cahces to delete. I can take the time to work a test.
This, well at least my part of this code has been thoroughly tested in the Ares005 branch. But all of the back end has changed to the new PSK.viewContainer and that is not so hard. SO if I abstract that off to a class named AbsDataCon and set it's generic<T:NSMObj> and my AppClass <T:KVRootEntity> then I can just init whatever I want in test - - OH OK it is running prod-Data is test But as r/o as far as I can see. I don't like that It seems to much like a side effect or something to be avoided. 
### But then again I may be holding it wrong: ###
See what is the real difference between testing that these controllers really do it OR if they are 

# 1001-a-BugFixes: ###
First and best The location manager can give me a garbage value. Even if my value is set to something it will try to geocode on nil. And that is a no-no. It can happen at any time so we must 'take action' i set a ?? to give it a default location of downtown baltimore. Still did it in the sim but very rare. trigger is open app delete many objects. add
Event and Message Do Not Update the view properly This is unsigltly and looks unprofessional. Place and Person do so that is good.
Hmm, could be the coffe, what if I make an array of [mkpins] and return THAT from a function / Nope that is incorrect. I already know I make pins. Another interesting thing is; Event and message belong to a person. Could that be part of the problem EITHER Way event is still marked "From:" AND More importantly it needs to go straicht to an editor. So That when I press the Event button it does everything that it does now then launches a seg. to a view, nothing big or fancy could even be a popover. to do this i would need to have a list of types for the events / messages. Expanded entity types to include all current classes. this way it is easier to use. Hey I need to delete RootDataType
NOPE that Is NOT what happened what I did was to comb through the controllers and make sure that they are all using the same constructor. and using an EntityTypes.[] for entityClassName. Both of these are written to work and they do. 
