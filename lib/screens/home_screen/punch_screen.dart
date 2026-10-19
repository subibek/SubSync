import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/site_model.dart';
import 'package:subsync/services/geo_cache_service.dart';
import 'package:subsync/services/location_service.dart';
import 'package:subsync/services/site_service.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_error_message.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart' as p;
import 'package:subsync/widgets/custom_text_field.dart';

class PunchScreen extends StatefulWidget {
  const PunchScreen({super.key});

  @override
  State<PunchScreen> createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen> with SingleTickerProviderStateMixin{

  String dropdownValue = '';
  List<DropdownMenuItem> dropdownMenuItems = [];
  bool isCircularProgressCompleted = false;
  bool showCircularProgressIndicator = false;
  bool? isClockInSuccess;
  String message = '';
  AllSitesModel? allSites;

  late AnimationController animationController;
  final ImagePicker _picker = ImagePicker();
  File? imageUrl;
  TextEditingController completionNotesController = TextEditingController();
  bool isAddImagesButtonDiasabled = false;

  @override
  void initState() {
    initializeDropdownMenuItems();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    super.initState();
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  initializeDropdownMenuItems() async {

    allSites = await SiteService.getAllSites();

    if(allSites != null){
      dropdownMenuItems = [];
      for(final site in allSites!.data.results)
        {
          dropdownMenuItems.add(DropdownMenuItem(value: site.address, alignment: AlignmentGeometry.center, child: Text(site.name)));
        }
    } else {
      dropdownMenuItems = [
      DropdownMenuItem(alignment: AlignmentGeometry.center, value: 'Error', child: Text('Failed to load sites.')),
    ];
    }

    setState((){
      DropdownMenuItem firstItem = dropdownMenuItems.first;
      dropdownValue = firstItem.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30),
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownValue,
                    items: dropdownMenuItems,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    underline: const SizedBox.shrink(), 
                    icon: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: SvgPicture.asset('assets/icons/CaretDown.svg', colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),)),
                    onChanged: (value) {
                      setState(() => dropdownValue = value);
                    },
                    menuWidth: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                if (showCircularProgressIndicator) 
                  AspectRatio(
                      aspectRatio: 4/4, 
                      child: 
                      RotationTransition(
                        turns: animationController,
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          value: 0.25,
                          strokeWidth: 8,
                          color: themeBloc.currentColor,
                        ),
                      ) 
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: 
                        (!showCircularProgressIndicator)
                        ? Border.all(
                          width: 10,
                          color: (isClockInSuccess!= null) 
                            ? isClockInSuccess! ? SubSyncColors.success60 : SubSyncColors.destructive60
                            : themeBloc.isDarkMode ? SubSyncColors.gray60 : SubSyncColors.gray40
                        )
                        : Border()
                      ),
                      child: AspectRatio(
                        aspectRatio: 4/4,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: 
                            showCircularProgressIndicator 
                            ? SizedBox.shrink()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    TimeOfDay.now().format(context),
                                    style: Theme.of(context).textTheme.textXl.copyWith(fontWeight: SubSyncTextStyles.bold),
                                  ),
                                 (isClockInSuccess != null) 
                                 ? Text(
                                     message,
                                     textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.text2xl.copyWith(fontWeight: SubSyncTextStyles.bold),
                                    )
                                  : SizedBox.shrink()
                                ],
                              )
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: 'Clock In',
                onTap: () async {
                  animationController.repeat();
                  
                  setState(() => showCircularProgressIndicator = true);
                  
                  final location = allSites!.data.results.firstWhere((site)=> site.address == dropdownValue);

                  final geoCache = GeoCacheService();

                  final coords = await geoCache.getLatLng(location.address);
                  if (coords != null) {
                  final locationService = LocationService(
                        siteLatitude: coords[0], 
                        siteLongitude: coords[1], 
                        allowRadiusMeters: 100
                      );
                      

                      final result = await locationService.canClockIn(dropdownValue);
                      if(result == "Success") {
                        if(animationController.isAnimating) animationController.stop();
                        if(mounted) {
                          setState(() {
                          showCircularProgressIndicator = false;
                          isClockInSuccess = true;
                          message = "Clocked in successfully";
                        });
                        }
                      } else {
                          if(animationController.isAnimating) animationController.stop();
                        setState(() {
                          showCircularProgressIndicator = false;
                          isClockInSuccess = false;
                          message = result;
                        });
                      }
                  } else {
                          if(animationController.isAnimating) animationController.stop();
                        setState(() {
                          showCircularProgressIndicator = false;
                          isClockInSuccess = false;
                        });
                      }
                }, 
                outlinedBorder: true
              ),
              const SizedBox(height: 10),
              CustomButton(onTap: () async {
                animationController.repeat();
                                  
                  setState(() => showCircularProgressIndicator = true);

                  final geoCache = GeoCacheService();

                   final location = allSites!.data.results.firstWhere((site)=> site.address == dropdownValue);

                  final coords = await geoCache.getLatLng(location.address);
                  if (coords != null) {
                    final locationService = LocationService(
                    siteLatitude: coords[0], 
                    siteLongitude: coords[1], 
                    allowRadiusMeters: 100
                  );

                  final canClockOut = await locationService.canClockOut(dropdownValue);
                  if(canClockOut == "True"){
                    showClockOutDialog(locationService);
                  }
                  else {
                        if(animationController.isAnimating) animationController.stop();
                      setState(() {
                        showCircularProgressIndicator = false;
                        isClockInSuccess = false;
                        message = canClockOut;
                      });
                    }
                  }
                  
                  else {
                        if(animationController.isAnimating) animationController.stop();
                      setState(() {
                        showCircularProgressIndicator = false;
                        isClockInSuccess = false;
                        message = "Could Not Clock Out";
                      });
                    }
                  
              }, outlinedBorder: true, title: 'Clock Out',)
            ],
          ),
        )
    );
  }


  void showClockOutDialog(LocationService locationService) {

    imageUrl = null;

    showDialog(
      barrierColor: themeBloc.isDarkMode ? Colors.black.withValues(alpha: 0.8): SubSyncColors.gray10.withValues(alpha: 0.4),
      context: context, 
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: themeBloc.isDarkMode ? SubSyncColors.gray90: SubSyncColors.gray10,
            insetPadding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(SubSyncBorderRadius.radius2xl)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Completion Notes:'),
                  CustomTextField(
                    controller: completionNotesController, 
                    hintText: 'Completion Notes..',
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 6,
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  const SizedBox(height: 10),
                  if (imageUrl == null)
                   CustomButton(
                      title: 'Add Images',
                      width: 150,
                      onTap: () async {
                        final picked = await selectImages(dialogContext);
                        if(picked != null){
                          setDialogState(() => imageUrl = picked);
                        }
                      }, 
                      outlinedBorder: true
                    )
                  else Text('Image ${p.basename(imageUrl!.path)} uploaded.'),
                  const SizedBox(height: 10),
                  CustomButton(
                    title: 'Submit',
                    onTap: () async {

                    final result = await locationService.clockOut(dropdownValue,null,[imageUrl]);
                      if(result == "Success") {
                        if(animationController.isAnimating) animationController.stop();
                        setState(() {
                          showCircularProgressIndicator = false;
                          isClockInSuccess = true;
                          message = "Clocked out successfully";
                        });
                      } else {
                        setState(() {
                          message = result;
                        });
                      } 
                          Navigator.of(dialogContext).pop();

              
                    }, 
                    outlinedBorder: false
                  )
                ],
              ),
            )
          );
        }
      )
    );
  }


  void clockInWithGeoCoding (dynamic location) async {
     Geocoding geo = Geocoding();
        final longAndLat = await geo.locationFromAddress(location.address);

        final locationService = LocationService(
          siteLatitude: longAndLat.first.latitude, 
          siteLongitude: longAndLat.first.longitude, 
          allowRadiusMeters: 100
        );
        

        final result = await locationService.canClockIn(dropdownValue);
        if(result == "Success") {
          if(animationController.isAnimating) animationController.stop();
          if(mounted) {
            setState(() {
            showCircularProgressIndicator = false;
            isClockInSuccess = true;
            message = "Clocked in successfully";
          });
          }
        } else {
            if(animationController.isAnimating) animationController.stop();
          setState(() {
            showCircularProgressIndicator = false;
            isClockInSuccess = false;
            message = result;
          });
        }
  }

    Future<File?> selectImages(BuildContext bottomSheetContext) async {

    final source = await showModalBottomSheet(
      context: bottomSheetContext, 
      useRootNavigator: true,
      enableDrag: false,
      showDragHandle: false,
      builder: (context) => BottomSheet(
      onClosing: (){},
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera'),
            onTap: (){
              Navigator.of(sheetContext).pop(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image_search_outlined),
            title: Text('Gallery'),
            onTap: (){
              Navigator.of(sheetContext).pop(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Cancel'),
            onTap: (){
              Navigator.of(sheetContext).pop();
              // Navigator.pop(context);
            },
          ),
        ],
      )
      )
      );

      if(source == null) return null;
      return _pickImage(source);
  }

  Future<File?> _pickImage(ImageSource source) async {
    
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null){
      return null;
    }

      ImageCropper cropper = ImageCropper();
    var file = await cropper.cropImage(
      sourcePath: pickedFile.path,
      );

    if (file == null){
      return null;
    }

    String compressedImage = await compressImage(file.path,44);

    // setState(() {
    //   imageUrl = File(compressedImage);
    // });

    return File(compressedImage);
  }

   Future<String> compressImage(String path, int quality) async {
      final newPath = p.join((await getTemporaryDirectory()).path, '${DateTime.now().millisecondsSinceEpoch}${p.extension(path)}');

      final result = await FlutterImageCompress.compressAndGetFile(
        path,
        newPath,
        quality: quality
        );

      return result!.path;
  }
}