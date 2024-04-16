import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:expense_tracker/common/widget/buttons/create_button.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/common/widget/custom_text_field.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:flutter/material.dart';
import '../../common/functions/reusable.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/category_select_button.dart';
import '../../common/widget/category_select_card.dart';
import '../../plans/model/plan.dart';
import 'camera_screen.dart';

class NewPurchase extends StatefulWidget {
  const NewPurchase({super.key});

  @override
  State<NewPurchase> createState() => _NewPurchaseState();
}

class _NewPurchaseState extends State<NewPurchase> {
  final _purchaseService = get<PurchaseService>();
  final _planService = get<PlanService>();

  List<List<ItemCategory>> chunks = chunk(ItemCategory.values.toList(), 3);

  ItemCategory selectedCategory = ItemCategory.other;
  double setPrice = 0.0;
  DateTime selectedDate = DateTime.now();

  final name = TextEditingController();
  final description = TextEditingController();
  final cost = TextEditingController();

  bool _isPurchaseNameValid = true;
  bool _isPurchaseCostValid = true;
  String _invalidPurchaseCostLabel = "This field can't be empty!";

  void _showDatePicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            initialDate: DateTime.now())
        .then((value) => setState(() {
              selectedDate = value ?? DateTime.now();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New purchase"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              buildCategorySelectCard(
                  (category) => buildCategorySelectButton(category, () {
                        setState(() {
                          selectedCategory = category;
                        });
                      }, selectedCategory == category, context)),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    ..._buildPurchaseInputFields(),
                    const SizedBox(height: 30),
                    ..._buildOptionsButtons(),
                    const SizedBox(height: 30)
                  ])),
              CustomStreamBuilder(
                stream: _planService.selectedPlanStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SelectedPlan> snapshot) {
                  return CustomStreamBuilder(
                    stream: _planService
                        .observeSelectedPlan(snapshot.data!.plan.id),
                    builder: (context, AsyncSnapshot<Plan> snapshot) {
                      return CreateButton(
                          onButtonPressed: () =>
                              _handleCreatePurchaseButtonClick(snapshot.data!));
                    },
                  );
                },
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreatePurchaseButtonClick(Plan plan) {
    var costDouble = double.tryParse(cost.text);

    setState(() {
      _isPurchaseNameValid = name.text.isNotEmpty;
      _isPurchaseCostValid = cost.text.isNotEmpty && costDouble != null;
      _invalidPurchaseCostLabel = cost.text.isEmpty
          ? "This field can't be empty!"
          : "Only numbers in decimal format!";
    });

    if (_isPurchaseNameValid && _isPurchaseCostValid) {
      _purchaseService.createPurchase(name.text, description.text,
          double.parse(cost.text), selectedCategory, selectedDate, plan);
      Navigator.of(context).pop();
    }
  }

  List<Widget> _buildPurchaseInputFields() {
    return [
      CustomTextField(
          label: "Name",
          hint: "My new car",
          controller: name,
          isInputValid: _isPurchaseNameValid,
          lengthLimit: 20),
      CustomTextField(
          label: "Description",
          hint: "Red Tesla",
          controller: description,
          lengthLimit: 255),
      CustomTextField(
          label: "Cost",
          hint: "69.23",
          controller: cost,
          isNumber: true,
          isInputValid: _isPurchaseCostValid,
          invalidInputLabel: _invalidPurchaseCostLabel)
    ];
  }

  List<Widget> _buildOptionsButtons() {
    return [
      _buildSelectPurchaseOptionsButton(const Icon(Icons.calendar_month),
          formatDate(selectedDate), context, _showDatePicker),
      _buildSelectPurchaseOptionsButton(
          const Icon(Icons.list_alt),
          "Add check photo",
          context,
          () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CameraScreen())))
    ];
  }
}

Widget _buildSelectPurchaseOptionsButton(Icon icon, String text,
    BuildContext context, void Function() onButtonPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
    child: IconButton.filledTonal(
        onPressed: onButtonPressed,
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
          child: Row(
            children: [
              const VerticalDivider(width: 4),
              icon,
              const VerticalDivider(width: 18),
              Text(text),
            ],
          ),
        )),
  );
}
