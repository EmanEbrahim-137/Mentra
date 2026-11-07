import 'package:flutter/material.dart';

class CtaBanner extends StatelessWidget {
  final VoidCallback onTap;

  const CtaBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: const Color(0xFF234B3C),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // Plus icon box
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5E4D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              // Title and Subtitle
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Something not working?',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Report a maintenance issue in under a minute.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA8C5B8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Trailing arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFA8C5B8),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
