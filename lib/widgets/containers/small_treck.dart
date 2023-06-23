import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';

import '../../models/track.dart';
import '../../utils/fonts.dart';

class SmallTrekScreen extends StatefulWidget {
  final Track track;
  final Function(int) onTap;
  final int? customId;

  const SmallTrekScreen(
      {super.key, required this.track, required this.onTap, this.customId});

  @override
  State<SmallTrekScreen> createState() => _SmallTrekScreenState();
}

class _SmallTrekScreenState extends State<SmallTrekScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.track.isPlay
              ? AppColors.currentTrackColor
              : AppColors.blackColor),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: widget.track.imageUrl == ''
                                ? const AssetImage('Assets/image_not_found.jpg')
                                    as ImageProvider
                                : NetworkImage(widget.track.imageUrl),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      widget.track.name,
                      style: AppTypography.font20fff,
                    ),
                  ),
                ],
              ),
              onTap: () {
                widget.onTap(widget.customId ?? widget.track.id);
                setState(() {
                  widget.track.isPlay = true;
                });
              },
            ),
            const InkWell(
              child: Icon(
                Icons.heart_broken_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
