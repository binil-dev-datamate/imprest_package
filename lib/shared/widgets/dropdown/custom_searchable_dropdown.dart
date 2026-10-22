import 'package:imprest_cash/shared/widgets/clearable_dropdown_suffix_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class _SearchableDropdownDialog<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) searchStringBuilder;
  final void Function(T? item) onItemSelected;
  final String searchHint;
  final EdgeInsetsGeometry? innerPadding;
  final Color selectedColor;
  final InputDecoration? searchInputDecoration;
  final TextStyle? hintTextStyle;
  final TextStyle? selectedItemTextStyle;
  final IconData searchIcon;
  final BorderRadius? borderRadius;
  final String? initialSearchText;
  final String title;
  final T? initialSelectedItem;
  final Widget? buttonWidget;
  final ValueNotifier<List<T>> itemsNotifier;
  final Widget? buttonFilterWidget;

  const _SearchableDropdownDialog(
      {required this.items,
      required this.itemsNotifier,
      required this.itemBuilder,
      required this.title,
      this.initialSearchText,
      this.initialSelectedItem,
      required this.searchStringBuilder,
      required this.onItemSelected,
      this.searchHint = 'Search...',
      this.selectedColor = Colors.blue,
      this.searchInputDecoration,
      this.hintTextStyle,
      this.innerPadding,
      this.selectedItemTextStyle,
      this.searchIcon = Icons.search,
      this.borderRadius = const BorderRadius.all(Radius.circular(8)),
      this.buttonWidget,
      this.buttonFilterWidget});

  @override
  State<_SearchableDropdownDialog<T>> createState() =>
      _SearchableDropdownDialogState<T>();
}

class _SearchableDropdownDialogState<T>
    extends State<_SearchableDropdownDialog<T>> {
  final FocusNode searchFocusNode = FocusNode();
  final FocusNode listFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<T> filteredItems = [];
  int? selectedIndex;
  final Map<int, GlobalKey> itemKeys = {};

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.itemsNotifier.value);
    widget.itemsNotifier.addListener(_onItemsChanged);

    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        selectedIndex = null;
      }
    });

    final initialSearchText = widget.initialSearchText;
    if (initialSearchText != null) {
      searchController.value = TextEditingValue(
        text: initialSearchText,
        selection: TextSelection.collapsed(offset: initialSearchText.length),
        composing: TextRange.empty,
      );
      filteredItems = _filteredForQuery(initialSearchText);
      selectedIndex = null;
      itemKeys.clear();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final text = searchController.text;
        if (text.isNotEmpty) {
          searchController.selection =
              TextSelection.collapsed(offset: text.length);
        }
      });

      if (widget.initialSelectedItem != null) {
        final listToSearch =
            widget.initialSearchText != null ? filteredItems : widget.items;
        final index = listToSearch.indexOf(widget.initialSelectedItem as T);
        if (index != -1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedIndex = index;
            });
            scrollToSelectedItem(context);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    widget.itemsNotifier.removeListener(_onItemsChanged);
    searchFocusNode.dispose();
    listFocusNode.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onItemsChanged() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        filterItems(searchController.text);
      }
    });
  }

  List<T> _filteredForQuery(String query) {
    return widget.itemsNotifier.value.where((item) {
      final searchString = widget.searchStringBuilder(item).toLowerCase();
      return searchString.contains(query.toLowerCase());
    }).toList();
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = _filteredForQuery(query);
      selectedIndex = null;
      itemKeys.clear();
    });
  }

  void scrollToSelectedItem(BuildContext context) {
    if (selectedIndex == null || !itemKeys.containsKey(selectedIndex)) return;
    final key = itemKeys[selectedIndex!]!;
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  void handleKeyPress(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        if (selectedIndex == null) {
          selectedIndex = 0;
          listFocusNode.requestFocus();
        } else if (selectedIndex! < filteredItems.length - 1) {
          selectedIndex = selectedIndex! + 1;
        }
      });
      scrollToSelectedItem(context);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        if (selectedIndex == null || selectedIndex == 0) {
          selectedIndex = null;
          searchFocusNode.requestFocus();
        } else {
          selectedIndex = selectedIndex! - 1;
        }
      });
      scrollToSelectedItem(context);
    } else if ((event.physicalKey == PhysicalKeyboardKey.altLeft ||
            event.physicalKey == PhysicalKeyboardKey.altRight) &&
        event.logicalKey == LogicalKeyboardKey.keyS) {
      searchFocusNode.requestFocus();
      selectedIndex = null;
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (selectedIndex != null) {
        widget.onItemSelected(filteredItems[selectedIndex!]);
        FocusScope.of(context).requestFocus(FocusNode());
      } else if (filteredItems.length == 1) {
        widget.onItemSelected(filteredItems[0]);
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: listFocusNode,
      onKeyEvent: handleKeyPress,
      child: Padding(
        padding: widget.innerPadding ??
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.titleMedium)),
                if (widget.buttonFilterWidget != null)
                  widget.buttonFilterWidget!,
                const Gap(16),
                if (widget.buttonWidget != null) widget.buttonWidget!,
              ],
            ),
            const Gap(16),
            TextField(
              // enableInteractiveSelection: false,
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: widget.searchInputDecoration ??
                  InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: Icon(widget.searchIcon),
                    border: OutlineInputBorder(
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(8),
                    ),
                  ),
              style: widget.hintTextStyle,
              onChanged: filterItems,
            ),
            const Gap(16),
            Expanded(
              child: Focus(
                canRequestFocus: false,
                child: FocusTraversalGroup(
                  descendantsAreFocusable: false,
                  descendantsAreTraversable: false,
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            "No items found",
                            style: widget.selectedItemTextStyle ??
                                Theme.of(context).textTheme.bodyMedium ??
                                const TextStyle(),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = selectedIndex == index;
                            itemKeys.putIfAbsent(index, () => GlobalKey());
                            return InkWell(
                              key: itemKeys[index],
                              onTap: () {
                                widget.onItemSelected(item);
                                setState(() => selectedIndex = index);
                              },
                              child: Container(
                                color: isSelected
                                    ? widget.selectedColor
                                        .withValues(alpha: 0.2)
                                    : null,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: DefaultTextStyle(
                                  style: widget.selectedItemTextStyle ??
                                      Theme.of(context).textTheme.bodyMedium ??
                                      const TextStyle(),
                                  child: widget.itemBuilder(item),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> _showCustomSearchableDropdownDialog<T>(
  BuildContext context, {
  required List<T> items,
  required Widget Function(T item) itemBuilder,
  required String Function(T item) searchStringBuilder,
  required void Function(T? item) onItemSelected,
  required String searchHint,
  required double dropdownBoxHeight,
  required double dropdownBoxWidth,
  required double dropdownItemHeight,
  required String title,
  required BuildContext buttonContext,
  EdgeInsetsGeometry? innerPadding,
  Color? focusedColor,
  InputDecoration? searchInputDecoration,
  TextStyle? hintTextStyle,
  TextStyle? selectedItemTextStyle,
  String? initialSearchText,
  IconData searchIcon = Icons.search,
  final T? initialSelectedItem,
  BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(5)),
  Widget? buttonWidget,
  required ValueNotifier<List<T>> itemsNotifier,
  Widget? buttonFilterWidget,
}) {
  final renderObject = buttonContext.findRenderObject();
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;

  double top;
  double left;

  if (renderObject is RenderBox) {
    final position = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;

    top = position.dy + size.height + 10;
    left = position.dx;

    if (left + dropdownBoxWidth > screenWidth) {
      left = screenWidth - dropdownBoxWidth - 10;
    }
    if (top + dropdownBoxHeight > screenHeight) {
      top = position.dy - dropdownBoxHeight - 10;
      if (top < 10) {
        top = 10;
      }
    }
    if (left < 0) {
      left = 10;
    }
  } else {
    // Fallback to centered positioning when render object is unavailable.
    left = (screenWidth - dropdownBoxWidth) / 2;
    top = (screenHeight - dropdownBoxHeight) / 2;
    if (left < 10) left = 10;
    if (top < 10) top = 10;
  }

  return showGeneralDialog<T>(
    context: context,
    pageBuilder: (ncontext, anim1, anim2) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(ncontext).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: top,
            left: left,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.white,
              elevation: 8.0,
              borderRadius: borderRadius,
              child: SizedBox(
                height: dropdownBoxHeight,
                width: dropdownBoxWidth,
                child: _SearchableDropdownDialog<T>(
                  title: title,
                  initialSelectedItem: initialSelectedItem,
                  initialSearchText: initialSearchText,
                  items: items,
                  innerPadding: innerPadding,
                  itemBuilder: itemBuilder,
                  searchStringBuilder: searchStringBuilder,
                  onItemSelected: (item) {
                    Navigator.pop(ncontext);
                    onItemSelected(item);
                  },
                  searchHint: searchHint,
                  selectedColor: focusedColor ?? Colors.transparent,
                  searchInputDecoration: searchInputDecoration,
                  hintTextStyle: hintTextStyle,
                  selectedItemTextStyle: selectedItemTextStyle,
                  searchIcon: searchIcon,
                  borderRadius: borderRadius,
                  buttonWidget: buttonWidget,
                  itemsNotifier: itemsNotifier,
                  buttonFilterWidget: buttonFilterWidget,
                ),
              ),
            ),
          ),
        ],
      );
    },
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    transitionDuration: const Duration(milliseconds: 200),
  );
}

// Accounting original mutates [selectedItem] from its state; keep that
// behaviour in the copy.
// ignore: must_be_immutable
class CustomSearchableDropdownWidget<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) searchStringBuilder;
  final void Function(T? item)? onChanged;
  final String hint;
  final double dropdownBoxHeight;
  final double dropdownBoxWidth;
  final double? radius;
  final String Function(T item) titleBuilder;
  final double dropdownItemHeight;
  final Color? focusedColor;
  final InputDecoration? searchInputDecoration;
  final TextStyle? hintTextStyle;
  final TextStyle? selectedItemTextStyle;
  final IconData searchIcon;
  final BorderRadius? searchFieldBorderRadius;
  final EdgeInsetsGeometry? innerPadding;
  final InputDecoration? buttonInputDecoration;
  final FocusNode focusNode;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? borderColor;
  final Color? fieldFillColor;
  T? selectedItem;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool clearable;
  final Widget? buttonWidget;
  final Widget? buttonFilterWidget;
  final VoidCallback? onFieldSubmitted;

  CustomSearchableDropdownWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.titleBuilder,
    required this.searchStringBuilder,
    required this.onChanged,
    required this.focusNode,
    this.hint = 'Select an item',
    this.dropdownBoxHeight = 500,
    this.dropdownBoxWidth = 450,
    this.dropdownItemHeight = 56,
    this.focusedColor,
    this.selectedItem,
    this.buttonInputDecoration,
    this.innerPadding,
    this.searchInputDecoration,
    this.hintTextStyle,
    this.selectedItemTextStyle,
    this.searchIcon = Icons.search,
    this.searchFieldBorderRadius,
    this.radius,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.borderColor,
    this.fieldFillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled,
    this.clearable = false,
    this.buttonWidget,
    this.buttonFilterWidget,
    this.onFieldSubmitted,
  });

  @override
  State<CustomSearchableDropdownWidget<T>> createState() =>
      _CustomSearchableDropdownWidgetState<T>();
}

class _CustomSearchableDropdownWidgetState<T>
    extends State<CustomSearchableDropdownWidget<T>> {
  late ValueNotifier<List<T>> _itemsNotifier;
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _itemsNotifier = ValueNotifier(widget.items);
    _displayController = TextEditingController(text: _displayText());
    widget.focusNode.addListener(_handleFocusChange);
  }

  String _displayText() {
    return widget.selectedItem != null
        ? widget.titleBuilder(widget.selectedItem as T)
        : '';
  }

  @override
  void didUpdateWidget(covariant CustomSearchableDropdownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _itemsNotifier.value = widget.items;
    }
    final text = _displayText();
    if (_displayController.text != text) {
      _displayController.text = text;
    }
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    _displayController.dispose();
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  void showDropdown(BuildContext context, {String? initialSearchText}) async {
    if (widget.onChanged == null || !(widget.enabled ?? true)) return;

    if (!mounted) return;
    _showCustomSearchableDropdownDialog<T>(
      buttonContext: context,
      context,
      title: widget.hint,
      initialSelectedItem: widget.selectedItem,
      items: widget.items,
      innerPadding: widget.innerPadding,
      itemBuilder: widget.itemBuilder,
      searchStringBuilder: widget.searchStringBuilder,
      onItemSelected: (item) {
        if (_enabled) {
          widget.onChanged!(item);
          setState(() {
            widget.selectedItem = item;
            _displayController.text = _displayText();
          });
        }
      },
      searchHint: 'Search...',
      dropdownBoxHeight: widget.dropdownBoxHeight,
      dropdownItemHeight: widget.dropdownItemHeight,
      dropdownBoxWidth: widget.dropdownBoxWidth,
      focusedColor: widget.focusedColor,
      searchInputDecoration: widget.searchInputDecoration,
      hintTextStyle: widget.hintTextStyle,
      selectedItemTextStyle: widget.selectedItemTextStyle,
      searchIcon: widget.searchIcon,
      borderRadius: widget.searchFieldBorderRadius,
      initialSearchText: initialSearchText,
      buttonWidget: widget.buttonWidget,
      itemsNotifier: _itemsNotifier,
      buttonFilterWidget: widget.buttonFilterWidget,
    );
  }

  bool get _enabled => widget.onChanged != null && (widget.enabled ?? true);

  Widget _buildDefaultArrowIcon() {
    return Icon(
      Icons.keyboard_arrow_down,
      size: 20,
      color: _enabled ? Theme.of(context).primaryColor : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showClear = widget.clearable &&
        widget.selectedItem != null &&
        widget.onChanged != null;
    final clearIcon = showClear
        ? ClearableDropdownSuffixIcon(
            enabled: widget.enabled ?? true,
            onClear: () => widget.onChanged!(null),
          )
        : null;
    final effectiveSuffixIcon = showClear
        ? (widget.suffixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [clearIcon!, widget.suffixIcon!],
              )
            : clearIcon!)
        : (widget.suffixIcon ?? _buildDefaultArrowIcon());

    return Builder(
      builder: (context) {
        return TextField(
          focusNode: widget.focusNode
            ..onKeyEvent = (node, event) {
              return handleKeyPress(event, context);
            },
          enabled: _enabled,
          readOnly: true,
          onTap: _enabled ? () => showDropdown(context) : null,
          controller: _displayController,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _enabled ? null : Colors.grey.shade600,
              ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
            filled: true,
            isDense: true,
            fillColor: _enabled
                ? (widget.fieldFillColor ??
                    Theme.of(context).inputDecorationTheme.fillColor)
                : Colors.grey.shade200,
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ??
                    widget.borderColor ??
                    Theme.of(context).primaryColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color: Theme.of(context)
                        .inputDecorationTheme
                        .disabledBorder
                        ?.borderSide
                        .color ??
                    Colors.grey.shade200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ??
                    widget.borderColor ??
                    Theme.of(context)
                        .inputDecorationTheme
                        .enabledBorder
                        ?.borderSide
                        .color ??
                    Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  KeyEventResult handleKeyPress(KeyEvent event, BuildContext context) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (widget.focusNode.hasFocus && _enabled) {
      if (HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isAltPressed ||
          HardwareKeyboard.instance.isMetaPressed ||
          HardwareKeyboard.instance.isShiftPressed) {
        return KeyEventResult.ignored;
      }

      final String? character = _getCharacterFromKeyEvent(event);
      if (character != null && _isAlphanumeric(character)) {
        showDropdown(context, initialSearchText: character);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (widget.selectedItem != null && widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!();
          return KeyEventResult.handled;
        }
        showDropdown(context);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        showDropdown(context);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  bool _isAlphanumeric(String character) {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]$');
    return alphanumericRegex.hasMatch(character);
  }

  String? _getCharacterFromKeyEvent(KeyEvent event) {
    if (event.logicalKey.keyLabel.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9]$').hasMatch(event.logicalKey.keyLabel)) {
      return event.logicalKey.keyLabel;
    }
    return null;
  }
}
