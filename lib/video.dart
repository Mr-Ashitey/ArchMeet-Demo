import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

// Creating Page
class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  VideoCallState createState() => VideoCallState();
}

class VideoCallState extends State<VideoCall> {
  // You can use these to add more control over the meet
  late TextEditingController serverText;
  late TextEditingController roomText;
  late TextEditingController subjectText;
  late TextEditingController nameText;
  late TextEditingController emailText;

  // Self-explainable bools
  var isAudioOnly = false;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    // Intitalising variables
    serverText = TextEditingController();
    roomText = TextEditingController(text: "demoroom");
    subjectText = TextEditingController(text: "Meeting");
    nameText = TextEditingController(text: "Akshay");
    emailText = TextEditingController(text: "email@gmail.com");
    // Adding a Listener
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onPictureInPictureWillEnter: _onPictureInPictureWillEnter,
        onPictureInPictureTerminated: _onPictureInPictureTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    // Designing the page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.videocam_rounded,
                    size: MediaQuery.of(context).size.width,
                    color: const Color(0xffAA66CC),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 3.5,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xffD64467),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  )
                ],
              ),
              const Spacer(flex: 65),
              Container(
                margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: const Text(
                  "Join the Meet",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 65),
              Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xfff3f3f3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: nameText,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      suffixIcon: Icon(Icons.person, color: Colors.black),
                      hintText: "Name"),
                ),
              ),
              const Spacer(flex: 58),
              const SizedBox(
                width: 350,
                child: Text(
                  "Meet Guidelines -\n1) For privacy reasons you may change your name if you want.\n2) By default your audio & video are muted.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff898989),
                  ),
                ),
              ),
              const Spacer(flex: 58),
              Row(
                children: [
                  const Spacer(flex: 32),
                  GestureDetector(
                    onTap: () {
                      _onAudioMutedChanged(!isAudioMuted);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: isAudioMuted
                              ? const Color(0xffD64467)
                              : const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.06),
                                offset: const Offset(0, 4)),
                          ]),
                      width: 72,
                      height: 72,
                      child: Icon(
                        isAudioMuted
                            ? Icons.mic_off_sharp
                            : Icons.mic_none_sharp,
                        color: isAudioMuted ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(flex: 16),
                  GestureDetector(
                    onTap: () {
                      _onVideoMutedChanged(!isVideoMuted);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: isVideoMuted
                              ? const Color(0xffD64467)
                              : const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.06),
                                offset: const Offset(0, 4)),
                          ]),
                      width: 72,
                      height: 72,
                      child: Icon(
                        isVideoMuted
                            ? Icons.videocam_off_sharp
                            : Icons.videocam,
                        color: isVideoMuted ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(flex: 16),
                  GestureDetector(
                    onTap: () {
                      _joinMeeting(); // Join meet on tap
                    },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                            color: const Color(0xffAA66CC),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.06),
                                  offset: const Offset(0, 4)),
                            ]),
                        width: 174,
                        height: 72,
                        child: const Center(
                          child: Text(
                            "JOIN MEET",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                  const Spacer(flex: 32),
                ],
              ),
              const Spacer(flex: 38),
            ],
          ),
        ),
      ),
    );
  }
// Can use this, to add one more button which makes the meet Audio only.
  // _onAudioOnlyChanged(bool? value) {
  //   setState(() {
  //     isAudioOnly = value!;
  //   });
  // }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

// Defining Join meeting function
  _joinMeeting() async {
    // Using default serverUrl that is https://meet.jit.si/
    String? serverUrl =
        (serverText.text.trim().isEmpty ? null : serverText.text);

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };
      if (!kIsWeb) {
        // Here is an example, disabling features for each platform
        if (Platform.isAndroid) {
          // Disable ConnectionService usage on Android to avoid issues (see README)
          featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        } else if (Platform.isIOS) {
          // Disable PIP on iOS as it looks weird
          featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        }
      }

      //uncomment to modify video resolution
      // featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions(room: roomText.text)
        // ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        // ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);
      // ..webOptions = {
      //   "roomName": roomText.text,
      //   "width": "100%",
      //   "height": "100%",
      //   "enableWelcomePage": false,
      //   "chromeExtensionBanner": null,
      //   "userInfo": {"displayName": nameText.text}
      // };
      // ..featureFlag = featureFlag;

      debugPrint("JitsiMeetingOptions: $options");
      // Joining meet
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
        }, onPictureInPictureWillEnter: (message) {
          debugPrint("${options.room} entered PIP mode with message: $message");
        }, onPictureInPictureTerminated: (message) {
          debugPrint("${options.room} exited PIP mode with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
      // I added a 50 minutes time limit, you can remove it if you want.
      Future.delayed(const Duration(minutes: 50))
          .then((value) => JitsiMeet.closeMeeting());
    } catch (error) {
      debugPrint("error: $error");
    }
  }

// Define your own constraints
  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onPictureInPictureWillEnter(message) {
    debugPrint(
        "_onPictureInPictureWillEnter broadcasted with message: $message");
  }

  void _onPictureInPictureTerminated(message) {
    debugPrint(
        "_onPictureInPictureTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
