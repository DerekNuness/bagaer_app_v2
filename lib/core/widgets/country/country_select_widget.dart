import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/utils/country/country_documents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


/// Define o modo de uso do CountrySelect
enum CountrySelectMode {
  dialCode,
  document,
  countyOnly
}

class CountrySelect extends StatefulWidget {
  final CountrySelectMode mode;
  final ValueChanged<CountryDocument> onSelect;

  /// País selecionado inicialmente (ex: Brasil)
  final CountryDocument initialCountry;

  /// Tamanho do dropdown (independente do botão)
  final double dropdownWidth;
  final double dropdownHeight;


  /// Decoração do botão
  final BoxDecoration decoration;

  const CountrySelect({
    super.key,
    required this.mode,
    required this.onSelect,
    required this.initialCountry,
    required this.decoration,
    this.dropdownWidth = 320,
    this.dropdownHeight = 280,
  });

  @override
  State<CountrySelect> createState() => _CountrySelectState();
}
class _CountrySelectState extends State<CountrySelect> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropDownOpen = false;

  late CountryDocument _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleDropdown() {
    if (!mounted) return;

    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);

      if (mounted) {
        setState(() => isDropDownOpen = true);
      }
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() => isDropDownOpen = false);
    }
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - size.height;

    final openUpwards = spaceBelow < widget.dropdownHeight;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap:  _removeOverlay,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  0,
                  openUpwards
                      ? -(widget.dropdownHeight + 6)
                      : size.height + 6,
                ),
                child: _AnimatedDropdown(
                  width: widget.dropdownWidth,
                  height: widget.dropdownHeight,
                  mode: widget.mode,
                  onSelect: (country) {
                    setState(() => _selected = country);
                    widget.onSelect(country);
                    _removeOverlay();
                  },
                  selected: _selected,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == CountrySelectMode.countyOnly) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: InkWell(
          onTap: () {
            _toggleDropdown();
            // widget.onTap;
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.centerLeft,
            decoration: widget.decoration,
            child: Row(
              children: [
                _selected.getFlagWidget(
                  25.w,
                  19.h
                ),
                SizedBox(width: 13.w),
                _ArrowIcon(isOpen: isDropDownOpen),
                SizedBox(width: 10.w),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _selected.countryName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          _toggleDropdown();
          // widget.onTap;
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.centerLeft,
          decoration: widget.decoration,
          child: Row(
            children: [
              _selected.getFlagWidget(
                25.w,
                19.h
              ),
              SizedBox(width: 13.w),
              _ArrowIcon(isOpen: isDropDownOpen),
              SizedBox(width: 10.w),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.mode == CountrySelectMode.dialCode ? _selected.phoneDialCode : _selected.documentCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================================
/// Icone animado
/// =======================================
class _ArrowIcon extends StatefulWidget {
  final bool isOpen;

  const _ArrowIcon({required this.isOpen});

  @override
  State<_ArrowIcon> createState() => _ArrowIconState();
}

class _ArrowIconState extends State<_ArrowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 👈 180 graus
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeInQuart,
      ),
    );

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _ArrowIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotation,
      child: SvgPicture.asset(
        'assets/icons/arrowDownFill.svg',
        width: 15.w,
        height: 12.h,
        colorFilter: const ColorFilter.mode(
          AppColors.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// =======================================
/// Dropdown animado (overlay flutuante)
/// =======================================

class _AnimatedDropdown extends StatefulWidget {
  final double width;
  final double height;
  final CountrySelectMode mode;
  final ValueChanged<CountryDocument> onSelect;
  final CountryDocument selected;

  const _AnimatedDropdown({
    required this.width,
    required this.height,
    required this.mode,
    required this.onSelect,
    required this.selected,
  });

  @override
  State<_AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<_AnimatedDropdown> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  late final ScrollController _scrollController;

  late CountryDocument _selected;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 160),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(curve);
    _scale = Tween(begin: 0.95, end: 1.0).animate(curve);

    _controller.forward();

    _selected = widget.selected;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = CountryDocuments.getAllDocuments();

    final filtered = widget.mode == CountrySelectMode.dialCode
        ? allItems.where((c) => c.countryCode != 'UN').toList()
        : allItems;

    final items = reorderWithSelectedOnTop(
      baseList: filtered,
      selected: _selected, 
    );

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias, 
          child: Container(
            width: widget.width,
            height: widget.height,
            color: AppColors.lightInputColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                15.w,
                16.h,
                0.w,
                20.h
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: RawScrollbar(
                  mainAxisMargin: 10.h,
                  crossAxisMargin: 5.w,
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 4.w,
                  radius: Radius.circular(8.r),
                  child: ListView.builder(
                    controller: _scrollController,
                    primary: false,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final doc = items[index];
                      final isSelected = _selected.countryCode == doc.countryCode;
                
                      return InkWell(
                        onTap: () => widget.onSelect(doc),
                        child: Padding(
                          padding: EdgeInsets.only(right: 19.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.lightSelectedCountry : Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(15.r))
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                                  child: Row(
                                    children: [
                                      doc.getFlagWidget(25.w, 19.h),
                                      SizedBox(width: 12.w),
                                      if (widget.mode == CountrySelectMode.dialCode)
                                        Text(
                                          "${doc.countryName} (${doc.phoneDialCode})",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.lightGreyText
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (widget.mode == CountrySelectMode.document)
                                        Text(
                                          "${doc.countryName} - ${doc.documentCode}",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.lightGreyText
                                          ),
                                        ),
                                      if (widget.mode == CountrySelectMode.countyOnly)
                                        Text(
                                          doc.countryName,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.lightGreyText
                                          ),
                                        ),
                                      if (isSelected) ...[
                                        Spacer(),
                                        SizedBox(
                                          width: 15.w,
                                          height: 10.h,
                                          child: Image.asset(
                                            "assets/icons/check.png"
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              if(index == 0)
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 10.h),
                                  child: Divider(
                                    thickness: 2.w,
                                    height: 0,
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<CountryDocument> reorderWithSelectedOnTop({
    required List<CountryDocument> baseList,
    required CountryDocument selected,
  }) {
    final sorted = List<CountryDocument>.from(baseList)
      ..sort(
        (a, b) => a.countryName
            .toLowerCase()
            .compareTo(b.countryName.toLowerCase()),
      );

    final index = sorted.indexOf(selected);
    if (index > 0) {
      sorted.removeAt(index);
      sorted.insert(0, selected);
    }

    return sorted;
  }
}