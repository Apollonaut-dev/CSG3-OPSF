<!-- # TODO
- shift changes
- dynamic MOOSE-based persistency
- blue CAP stations for MOOSE AWACS
    - need additional MOOSE#AWACS objects; one per station

My todo list for the deployment in decreasing priority is:
- blue player CAP station automation via MOOSE AWACS + threat missions upon player check-in. Idea here is for players on off nights to just check in as a CAP flight and defend from red threats as directed by MOOSE AWACS AI. May also add option for players to check in for a certain amount of time and adjust probability of threats to guarantee at least one threat dispatched during player CAP shift
- side missions. @Unjust_Flame#7118 created some template secondary objectives which I'll try to dispatch dynamically when players are in the server
- integration of both of the above with @BrotherBloat#8409  bot. Bloat if you could give me some assistance here when you're free I'd highly appreciate it!
- MOOSE-based persistency. DSMC is kind of rudimentary, MOOSE allows more flexibility in persistency (for example with MOOSE it is possible to not only respawn units at their last location but also re-assign their last objectives upon mission restart. Also prevents unit accumulation of dynamically spawned ground units
- Ground war simulation. Not happening for this deployment. I won't be able to figure out a performant, scalable, general way to automate ground war for January, but the rest of the above will set the stage for this for the next deployment. Deployment phase divisions intended to replace this aspect. Side missions provided by @Unjust_Flame#7118 should add dynamism to the ground war aspect
-- tankers replaced as soon as current tanker departs station

-- CHECK FOR AND AVOID HEAP ALLOCATIONS IN SCHEDULED FUNCTIONS

-- fix red air script, intercept flights landing immediately after takeoff

-- mission idea: chainsaw SEAD
-- 4-ship, 4xAGM88 each
1. drop to 10 nm trail. -4 is 30 nm behind -1.
2. establish orbit at LP with LP as inbound fix
3. very 4 minutes, each pilot fires
4. AGM 88 launches should be 60 +/- 15 s apart

dynamic campaign ideas:
- allow automatic tasking system to interface with manual set-pieces
setpiece = {
    success()
    failure()
    zone: zone_1
}

# Mission Generation
- random selection complete
- mission 1 and validation logic complete
- TODO optimize random selection and validation logic
- TODO test bot trigger-missions and mission-trigger discord message -->

# Updated TODO 4 Feb 2023

## Optimization
- CHECK FOR AND AVOID HEAP ALLOCATIONS IN SCHEDULED FUNCTIONS

## Mission Generation
- optimize random selection and validation logic
- more missions
- implement in 247 environment
-- create regions and opszones in 247 environment
- refactor scripts to separate border calculation and mission generation
- need success/failure/cancelled discord messaging
- finish escort mission
    - cruise altitude
    - AI escorts depart when player escorts arrive
    - despawn all AI at Ramstein/Incirlik zone
- Refactor to use SET_GROUP, FilterZones, FilterSart
- Only activate ground unites in BorderZones after every restart
- make DSMC re-spawn all units as late activated

## Red Air
- shift changes
- set CAP point at the centre every red border zone
    - mission can automatically retreat CAP points as regions are captured
    - too many aircraft
- ~~Refactor QRF logic using SET_GROUP, FilterZones, :FilterStart~~ deleted QRF logic

## Briefing
- Mechanics Brief

## Blue Air
- TODO add multiple MOOSE AWACS to support multiple CAP points

## Mission 1
- logistic vessels for 513 during alpha strike

## Performance Testing
- latest results
- set squadron grouping to 2
- skynet-only version (-1-4) ran 10 hours with extremely stable performance
- -1-2-3-4 run for over 12 hours with unstable performance, spiking at 100% CPU usage regularly, possibly once every few minutes. Bottomed-out at 40 fps. Average FPS ~65 but very choppy/inconsistent
- -1-2-3-4-6 ran for over 8 hours with unstable performance, spiking at 100% CPU *once* but bottoming-out at ~30 fps
-   -   too many aircraft, change group size to 2 for combat elements
-   - ACCESS_VIOLATION at 00000000000 after 9 hours 20 minutes
- -1-2-3-4-5 with airspawn scripts crashed after 3.5 h this is most likely the worst culprit.
- OPSF_247 5-2-2023-RB3-2-2023 no warehousing 1-2-4-6b
    - Red Air + IADS
    - up for 24 hours
    - by the end of it there was only 1 IL tanker, 2 A50s and one A50 escort flying. Many aircraft parked.
    - One A50 was completely out of sync, diving into and out of the treetops like a dolphin.
    - My client lost connection after a few minutes
- - OPSF_247 5-2-2023-RB3-2-2023 no warehousing 1-2-4-6b
    - edited mission since Krivak-1 was superimposed with Krivak-3 and somehow breaking the whole naval patrol script

## DSMC
- can use server bot to edit .miz
- groups stored in a lua table in .miz/mission
- need to ensure region zones are returned to proper state
- perhaps save state of regions before restart
- or perhaps place a static in each zone
- SAMs need to be activated on mission start or at least before IADS script executes

## Replace AirSpawn Script
- Implement Ramstein

## Versioning Notes
### V1.0.0 14-2-2023
- same as legacy V12 (V10 with cut down units, airspawning that doesn't crash server)

### V1.1.0 14-2-2023
- reduced REDFOR CAP, removed QRF scanners changed all aircraft to CAP with between 60 and 90 nm EngageRadius

### TODO PERFORMANCE
- TODO cut two tankers out
- cut one AWACS out
- should start deployment thursday. Need to run large scale test of nearly-empty mission with all players on tuesday night. Only startup + fly around for ~5 min. need cooperation of all squadrons. Maybe TTS is the cuprit

Test 1: minimalist mission with 30+ jets
Test 2: minimalist + TTS
Test 3: ~1000 units minimal scripting


## Wing Mission Testing 21-2-2023
- collisions not killing people
### Test 1
- 32 fps initial frame rate
- ~ 26-27 fps average (mkI eyeball not calculated)
- 15 fps min framerate, 24 fps 99% framerate
- 38 max connected
- 1 deck rubber band crash (Fett)
- had some unable to cat launch
- some dsync observed in F2 view

Tex — Today at 8:56 PM
we had very slight rubber band about 3/4 way through it.... super minor

theHazard203 — Today at 8:56 PM
rubber banding with cam 2, towards the end. maybe 20 mins before end

### Test 2
- Wile E spawned upside down
- initial 31 fps
- average  25 fps maybe 22 fps
- minimum 15 fps
- some F2 desync
- 33 players

BrotherBloat — Today at 9:33 PM
nice! 😄
Image
90fps at the tanker with so many jets is unreal

9:36 Member LtCol Knuckles Iazzetta 50 (CO) (ucid=7ad6a621b721a2f4b5cfe72aacc329fa) is killing team members. Please investigate.

### Test 3
- min 18 fps
- 27 fps average
- Bones reports 20 fps on the deck at mission start
- 26 players

- Tex reports high-30s fps vs high 60s in test 2 VR
- Dingo reports high-40s fps vs ~65 in test 2 VR
- Wile E - max FPS locked to 30 fps no issues, no stutters which is abnormaly good  VR
- Wulfweird - 50 fps TrackIR - 3 4k screens
- Bones - 35-45 fps TrackIR 4 screens
- POTUS - 30-36 fps VR
- Blic - 36 fps VR
- Cyborg 34 fps, ultrawide TrackIR
- Fever 3 screens 50 fps on deck trackIR

-- MOOSE errors:
```
2023-03-03 03:00:07.080 INFO    Scripting (6912): event:weapon_type=27992708,type=shot,target_unit_type=AGM_88,target_coalition=2,t=5608.316,weapon=SA9M83,targetMissionID=0,initiator_unit_type=S-300V 9A83 ln,target_ws_type1=4,initiator_object_id=16975617,initiator_ws_type1=2,target=AGM_88,initiator_coalition=1,initiatorMissionID=3319,target_object_id=16900124,
2023-03-03 03:00:07.600 INFO    Scripting (6912): event:weapon_type=1443604,type=hit,target_unit_type=Su-30,target_coalition=1,weapon=AIM-9M,t=5608.823,initiator_ws_type1=1,targetMissionID=1000088,initiator_unit_type=F-14B,target_ws_type1=1,initiator_object_id=16777479,initiator_coalition=2,target=Su-30,initiatorPilotName=CSG-3 | Mando | 107,initiatorMissionID=3461,target_object_id=17145089,
2023-03-03 03:00:07.600 INFO    Scripting (6912): event:initiator_unit_type=Su-30,type=ai abort mission,initiator_object_id=17145089,initiator_ws_type1=1,t=5608.823,initiator_coalition=1,initiatorMissionID=1000088,
2023-03-03 03:00:08.106 INFO    Scripting (6912): event:weapon_type=27992708,type=shot,target_unit_type=AGM_88,target_coalition=2,t=5609.33,weapon=SA9M83,targetMissionID=0,initiator_unit_type=S-300V 9A83 ln,target_ws_type1=4,initiator_object_id=16972545,initiator_ws_type1=2,target=AGM_88,initiator_coalition=1,initiatorMissionID=3327,target_object_id=16898070,
2023-03-03 03:00:09.155 INFO    Scripting (6912): event:weapon_type=27992708,type=shot,target_unit_type=AGM_88,target_coalition=2,t=5610.382,weapon=SA9M83,targetMissionID=0,initiator_unit_type=S-300V 9A83 ln,target_ws_type1=4,initiator_object_id=16975361,initiator_ws_type1=2,target=AGM_88,initiator_coalition=1,initiatorMissionID=3317,target_object_id=16898070,
2023-03-03 03:00:10.152 INFO    Scripting (6912): event:weapon_type=27992708,type=shot,target_unit_type=AGM_88,target_coalition=2,t=5611.375,weapon=SA9M83,targetMissionID=0,initiator_unit_type=S-300V 9A83 ln,target_ws_type1=4,initiator_object_id=16975873,initiator_ws_type1=2,target=AGM_88,initiator_coalition=1,initiatorMissionID=3337,target_object_id=16900380,
2023-03-03 03:00:11.127 INFO    Scripting (6912): event:weapon_type=27992708,type=shot,target_unit_type=AGM_88,target_coalition=2,t=5612.353,weapon=SA9M83,targetMissionID=0,initiator_unit_type=S-300V 9A83 ln,target_ws_type1=4,initiator_object_id=16973825,initiator_ws_type1=2,target=AGM_88,initiator_coalition=1,initiatorMissionID=3324,target_object_id=16900380,
2023-03-03 03:00:11.678 INFO    SCRIPTING (6912):  25407( 23864)/E:                          UNIT18383.GetCoordinate({[1]=Cannot GetCoordinate,[Positionable]={[coordinate]={[WaypointType]={[LandingReFuAr]=LandingReFuAr,[TakeOff]=TakeOffParkingHot,[Land]=Land,[TakeOffParking]=TakeOffParking,[TakeOffParkingHot]=TakeOffParkingHot,[TurningPoint]=Turning Point,[TakeOffGround]=TakeOffGround,[TakeOffGroundHot]=TakeOffGroundHot,},[WaypointAction]={[LandingReFuAr]=LandingReFuAr,[FromRunway]=From Runway,[FromParkingArea]=From Parking Area,[TurningPoint]=Turning Point,[FromParkingAreaHot]=From Parking Area Hot,[Landing]=Landing,[FromGroundAreaHot]=From Ground Area Hot,[FromGroundArea]=From Ground Area,[FlyoverPoint]=Fly Over Point,},[y]=45.239154815674,[z]=244674.94149463,[x]=-5305.8660914027,[ClassName]=COORDINATE,[WaypointAltType]={[RADIO]=RADIO,[BARO]=BARO,},},[GroupName]=19th Fighter SQ_AID-219,[UnitName]=19th Fighter SQ_AID-219-02,[ClassName]=UNIT,},})
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912):  23872( 64731)/E:                          BASE00000.GetCoordinate({[1]=Cannot GetCoordinate,[Group]={[Attribute]={[AIR_OTHER]=Air_OtherAir,[AIR_TRANSPORTHELO]=Air_TransportHelo,[GROUND_APC]=Ground_APC,[AIR_FIGHTER]=Air_Fighter,[NAVAL_AIRCRAFTCARRIER]=Naval_AircraftCarrier,[AIR_UAV]=Air_UAV,[AIR_BOMBER]=Air_Bomber,[GROUND_SAM]=Ground_SAM,[AIR_ATTACKHELO]=Air_AttackHelo,[GROUND_AAA]=Ground_AAA,[GROUND_IFV]=Ground_IFV,[AIR_TRANSPORTPLANE]=Air_TransportPlane,[AIR_AWACS]=Air_AWACS,[GROUND_INFANTRY]=Ground_Infantry,[AIR_TANKER]=Air_Tanker,[NAVAL_OTHER]=Naval_OtherNaval,[GROUND_ARTILLERY]=Ground_Artillery,[GROUND_TANK]=Ground_Tank,[GROUND_TRAIN]=Ground_Train,[GROUND_EWR]=Ground_EWR,[GROUND_OTHER]=Ground_OtherGround,[NAVAL_WARSHIP]=Naval_WarShip,[NAVAL_ARMEDSHIP]=Naval_ArmedShip,[NAVAL_UNARMEDSHIP]=Naval_UnarmedShip,[GROUND_TRUCK]=Ground_Truck,[OTHER_UNKNOWN]=Other_Unknown,},[Takeoff]={[Air]=1,[Hot]=3,[Runway]=2,[Cold]=4,},[GroupName]=19th Fighter SQ_AID-219,[ClassName]=GROUP,},[Alive]=true,})
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912): Error in timer function: [string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:64731: attempt to index a nil value
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912): stack traceback:
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11546: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11543>
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:64731: in function 'GetMissionWaypointCoord'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:88836: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:88749>
	(tail call): ?
	[C]: in function 'xpcall'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11583: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11537>
```
```
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912):  25407( 23864)/E:                          UNIT05334.GetCoordinate({[1]=Cannot GetCoordinate,[Positionable]={[GroupName]=TDR_TDRS3B_01#001,[UnitName]=TDR_TDRS3B_01#001-01,[ClassName]=UNIT,},})
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912):  23872( 98177)/E:                          BASE00000.GetCoordinate({[1]=Cannot GetCoordinate,[Group]={[Attribute]={[AIR_OTHER]=Air_OtherAir,[AIR_TRANSPORTHELO]=Air_TransportHelo,[GROUND_APC]=Ground_APC,[AIR_FIGHTER]=Air_Fighter,[NAVAL_AIRCRAFTCARRIER]=Naval_AircraftCarrier,[AIR_UAV]=Air_UAV,[AIR_BOMBER]=Air_Bomber,[GROUND_SAM]=Ground_SAM,[AIR_ATTACKHELO]=Air_AttackHelo,[GROUND_AAA]=Ground_AAA,[GROUND_IFV]=Ground_IFV,[AIR_TRANSPORTPLANE]=Air_TransportPlane,[AIR_AWACS]=Air_AWACS,[GROUND_INFANTRY]=Ground_Infantry,[AIR_TANKER]=Air_Tanker,[NAVAL_OTHER]=Naval_OtherNaval,[GROUND_ARTILLERY]=Ground_Artillery,[GROUND_TANK]=Ground_Tank,[GROUND_TRAIN]=Ground_Train,[GROUND_EWR]=Ground_EWR,[GROUND_OTHER]=Ground_OtherGround,[NAVAL_WARSHIP]=Naval_WarShip,[NAVAL_ARMEDSHIP]=Naval_ArmedShip,[NAVAL_UNARMEDSHIP]=Naval_UnarmedShip,[GROUND_TRUCK]=Ground_Truck,[OTHER_UNKNOWN]=Other_Unknown,},[Takeoff]={[Air]=1,[Hot]=3,[Runway]=2,[Cold]=4,},[InitRespawnModu]=0,[InitRespawnHeading]=208,[WayPoints]={[1]={[speed_locked]=true,[type]=Turning Point,[action]=Turning Point,[alt_type]=RADIO,[y]=-272933.99679973,[x]=-266604.07165563,[name]=Current Position,[ETA]=0,[speed]=177.12363157462,[ETA_locked]=false,[task]={[id]=ComboTask,[params]={[tasks]={},},},[alt]=4268.0711567222,},[2]={[speed_locked]=true,[type]=Turning Point,[action]=Turning Point,[alt_type]=RADIO,[y]=-272837.07060877,[x]=-268453.53355399,[name]=Tanker Orbit,[ETA]=0,[speed]=177.12363157462,[ETA_locked]=false,[task]={[id]=ComboTask,[params]={[tasks]={[1]={[id]=Orbit,[params]={[altitude]=4267.2,[pattern]=Race-Track,[speed]=177.12363157462,[point2]={[y]=-244711.67677344,[x]=-213722.36713809,},[point]={[y]=-254338.29332802,[x]=-259010.53616391,},},},},},},[alt]=4268.0711567222,},},[GroupName]=TDR_TDRS3B_01#001,[InitRespawnFreq]=251.1,[InitRespawnRadio]=true,[ClassName]=GROUP,[InitRespawnModex]=701,},[Alive]=true,})
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912): Error in SCHEDULER function:[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:98177: attempt to index a nil value
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912): stack traceback:
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912): Error in SCHEDULER function:[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:98177: attempt to index a nil value
2023-03-03 03:24:25.416 INFO    SCRIPTING (6912): stack traceback:
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:8400: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:8397>
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:98177: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:98171>
	(tail call): ?
	[C]: in function 'xpcall'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:8404: in function '_call_handler'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:8482: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:8410>
	(tail call): ?
	[C]: in function 'xpcall'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11575: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11537>
```
```
2023-03-03 03:00:11.678 INFO    SCRIPTING (6912):  25407( 23864)/E:                          UNIT18383.GetCoordinate({[1]=Cannot GetCoordinate,[Positionable]={[coordinate]={[WaypointType]={[LandingReFuAr]=LandingReFuAr,[TakeOff]=TakeOffParkingHot,[Land]=Land,[TakeOffParking]=TakeOffParking,[TakeOffParkingHot]=TakeOffParkingHot,[TurningPoint]=Turning Point,[TakeOffGround]=TakeOffGround,[TakeOffGroundHot]=TakeOffGroundHot,},[WaypointAction]={[LandingReFuAr]=LandingReFuAr,[FromRunway]=From Runway,[FromParkingArea]=From Parking Area,[TurningPoint]=Turning Point,[FromParkingAreaHot]=From Parking Area Hot,[Landing]=Landing,[FromGroundAreaHot]=From Ground Area Hot,[FromGroundArea]=From Ground Area,[FlyoverPoint]=Fly Over Point,},[y]=45.239154815674,[z]=244674.94149463,[x]=-5305.8660914027,[ClassName]=COORDINATE,[WaypointAltType]={[RADIO]=RADIO,[BARO]=BARO,},},[GroupName]=19th Fighter SQ_AID-219,[UnitName]=19th Fighter SQ_AID-219-02,[ClassName]=UNIT,},})
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912):  23872( 64731)/E:                          BASE00000.GetCoordinate({[1]=Cannot GetCoordinate,[Group]={[Attribute]={[AIR_OTHER]=Air_OtherAir,[AIR_TRANSPORTHELO]=Air_TransportHelo,[GROUND_APC]=Ground_APC,[AIR_FIGHTER]=Air_Fighter,[NAVAL_AIRCRAFTCARRIER]=Naval_AircraftCarrier,[AIR_UAV]=Air_UAV,[AIR_BOMBER]=Air_Bomber,[GROUND_SAM]=Ground_SAM,[AIR_ATTACKHELO]=Air_AttackHelo,[GROUND_AAA]=Ground_AAA,[GROUND_IFV]=Ground_IFV,[AIR_TRANSPORTPLANE]=Air_TransportPlane,[AIR_AWACS]=Air_AWACS,[GROUND_INFANTRY]=Ground_Infantry,[AIR_TANKER]=Air_Tanker,[NAVAL_OTHER]=Naval_OtherNaval,[GROUND_ARTILLERY]=Ground_Artillery,[GROUND_TANK]=Ground_Tank,[GROUND_TRAIN]=Ground_Train,[GROUND_EWR]=Ground_EWR,[GROUND_OTHER]=Ground_OtherGround,[NAVAL_WARSHIP]=Naval_WarShip,[NAVAL_ARMEDSHIP]=Naval_ArmedShip,[NAVAL_UNARMEDSHIP]=Naval_UnarmedShip,[GROUND_TRUCK]=Ground_Truck,[OTHER_UNKNOWN]=Other_Unknown,},[Takeoff]={[Air]=1,[Hot]=3,[Runway]=2,[Cold]=4,},[GroupName]=19th Fighter SQ_AID-219,[ClassName]=GROUP,},[Alive]=true,})
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912): Error in timer function: [string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:64731: attempt to index a nil value
2023-03-03 03:00:11.679 INFO    SCRIPTING (6912): stack traceback:
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11546: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11543>
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:64731: in function 'GetMissionWaypointCoord'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:88836: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:88749>
	(tail call): ?
	[C]: in function 'xpcall'
	[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11583: in function <[string "C:\Users\admin\AppData\Local\Temp\1\Server_2\/~mis00004B76.lua"]:11537>
```

# TODO 3-3-2023
- HOUND custom callsigns
- Skynet mobile SA11, SA6, SHORAD, reposition on nearby impact
- MOOSE OPSAREA/OPS Campaign

# TODO 9-3-2023
- squirters mechanic
- when bomb lands in zone make infantry run away from the explosion for 2 min.


# TODO 19-3-2023


## IADS
- Power sources look like this: image
- Connection Nodes look like this and this: mobile and static
- power sources = SAM neturalized
- connection nodes = either SAM neutralized or SAM easier to neutralize

- SA10s are considered static 
- Precise coords will be on intel map
- Connected to Power Sources and Connection Nodes
- All the SA10s and SA12s that will ever be on the map are on the map currently, except Georgia, with precise coordinates

- SA11s are mobile
- Hound should be used to locate them
- Red has a limited inventory (say 60)
- They can be moved between server restarts
- Players may place SA11 markers on the intel map based on information gathered in-mission

## Red Air
- CAP spawns in shifts of 2 hours
- if shot down CAP will be replaced
- 2x2-ships per CAP point
- attrition after crimea
- Su30s, Su27s, Su33s, MiG29s, MiG31s
- No, I will not do MiG23s and MiG21s.
- QRF within XX nm of base, up to 3x2-ships intercepting.
- We need to do more CAP, not bitch about being outnumbered. 2 Flights minimum. 
- in fact, pretty much every wing night, we should have minimum 2 flights CAP, 2 flights SEAD ad-hoc capable, and 1 flight fighter-escort. Bulk of ground pounding should be done by 513. 