import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/converter_logic.dart';
import '../models/converter_category.dart';

class ConverterScreen extends StatefulWidget {
  final ConverterCategory category;

  const ConverterScreen({
    super.key,
    required this.category,
  });

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late final TextEditingController _inputController;
  late String _fromUnit;
  late String _toUnit;
  ConversionResult _result = const ConversionResult.empty();

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: '1');
    _fromUnit = widget.category.defaultFromUnit;
    _toUnit = widget.category.defaultToUnit;
    _calculateConversion();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _calculateConversion() {
    setState(() {
      _result = ConverterLogic.convert(
        category: widget.category.type,
        input: _inputController.text,
        fromUnit: _fromUnit,
        toUnit: _toUnit,
      );
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _calculateConversion();
  }

  void _copyResultToClipboard() {
    if (_result.isValid && !_result.isEmpty) {
      final textToCopy = '${_result.formattedValue} ${ConverterLogic.getSymbol(_toUnit)}';
      Clipboard.setData(ClipboardData(text: textToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied "$textToCopy" to clipboard'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E88E5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        title: Text(
          '${widget.category.title} Converter',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        leading: IconButton(
          key: const Key('appBarBackButton'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Categories',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildInputCard(),
                  const SizedBox(height: 16),
                  _buildUnitsSelectionCard(),
                  const SizedBox(height: 16),
                  _buildResultCard(),
                  const SizedBox(height: 24),
                  _buildBottomBackButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD6E4F0), width: 1.2),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.category.icon,
                color: const Color(0xFF1E88E5),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.category.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      shadowColor: const Color(0x1F1E88E5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD6E4F0), width: 1.2),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('converterInputField'),
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
              decoration: InputDecoration(
                hintText: '0',
                filled: true,
                fillColor: const Color(0xFFF5F8FC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixText: ConverterLogic.getSymbol(_fromUnit),
                suffixStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
                suffixIcon: _inputController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        color: Colors.blueGrey[400],
                        onPressed: () {
                          _inputController.clear();
                          _calculateConversion();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1E88E5),
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => _calculateConversion(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitsSelectionCard() {
    return Card(
      elevation: 2,
      shadowColor: const Color(0x1F1E88E5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD6E4F0), width: 1.2),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Convert Between',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'From Unit',
                    keyName: 'fromUnitDropdown',
                    value: _fromUnit,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _fromUnit = newValue;
                        });
                        _calculateConversion();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Tooltip(
                    message: 'Swap Units',
                    child: Material(
                      color: const Color(0xFFE3F2FD),
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: const Key('swapUnitsButton'),
                        customBorder: const CircleBorder(),
                        onTap: _swapUnits,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.swap_horiz_rounded,
                            color: Color(0xFF1E88E5),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: 'To Unit',
                    keyName: 'toUnitDropdown',
                    value: _toUnit,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _toUnit = newValue;
                        });
                        _calculateConversion();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String keyName,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCFD8DC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              key: Key(keyName),
              isExpanded: true,
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF1E88E5),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
              items: widget.category.units.map((unit) {
                final symbol = ConverterLogic.getSymbol(unit);
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(
                    symbol.isNotEmpty ? '$unit ($symbol)' : unit,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    if (!_result.isValid) {
      return Card(
        elevation: 2,
        color: const Color(0xFFFFF4E5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFFCC80), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE65100),
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _result.errorMessage ?? 'Invalid conversion input',
                  key: const Key('converterErrorMessage'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB71C1C),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_result.isEmpty) {
      return Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD6E4F0), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 40,
                color: Colors.blueGrey[300],
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a value to see the converted result immediately',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final toSymbol = ConverterLogic.getSymbol(_toUnit);
    final fromSymbol = ConverterLogic.getSymbol(_fromUnit);
    final inputVal = _inputController.text.trim();

    return Card(
      elevation: 3,
      shadowColor: const Color(0x2E1E88E5),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Converted Result',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: const Color(0xFF1E88E5),
                  tooltip: 'Copy Result',
                  onPressed: _copyResultToClipboard,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              _result.formattedValue,
              key: const Key('converterResultText'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              toSymbol.isNotEmpty ? '$_toUnit ($toSymbol)' : _toUnit,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[700],
              ),
            ),
            const Divider(height: 24, color: Color(0xFFE3EDF7)),
            Text(
              '$inputVal $fromSymbol = ${_result.formattedValue} $toSymbol',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBackButton() {
    return OutlinedButton.icon(
      key: const Key('bottomBackButton'),
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_rounded, size: 18),
      label: const Text(
        'Back to Categories',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1E88E5),
        side: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
