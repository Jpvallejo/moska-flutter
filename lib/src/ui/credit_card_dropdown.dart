import 'package:flutter/material.dart';
import 'package:moska_app/src/models/credit_card_view_model.dart';
import 'package:moska_app/src/services/credit_card_service.dart';

class CreditCardDropDown extends StatefulWidget {
  CreditCardDropDown() : super();

  @override
  CreditCardDropDownState createState() => CreditCardDropDownState();
}

class CreditCardDropDownState extends State<CreditCardDropDown> {
  //
  List<CreditCardViewModel> _creditCards = new List<CreditCardViewModel>();
  List<DropdownMenuItem<CreditCardViewModel>> _dropdownMenuItems;
  CreditCardViewModel _selectedCreditCard;

  @override
  void initState() {
    getCreditCards().then((cards) => {
      _creditCards = cards,
      _selectedCreditCard = cards[0]
    });
    _dropdownMenuItems = buildDropdownMenuItems(_creditCards);
    super.initState();
  }

  List<DropdownMenuItem<CreditCardViewModel>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<CreditCardViewModel>> items = List();
    for (CreditCardViewModel company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(CreditCardViewModel selectedCreditCard) {
    setState(() {
      _selectedCreditCard = selectedCreditCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Select a company"),
        SizedBox(
          height: 20.0,
        ),
        DropdownButton(
          value: _selectedCreditCard,
          items: _dropdownMenuItems,
          onChanged: onChangeDropdownItem,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Selected: ${_selectedCreditCard?.name ?? ''}'),
      ],
    ));
  }
}
