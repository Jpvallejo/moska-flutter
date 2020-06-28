import 'package:flutter/material.dart';
import 'package:moska_app/src/models/credit_card_model.dart';
import 'package:moska_app/src/services/credit_card_service.dart';

class CreditCardDropDown extends StatefulWidget {
  CreditCardDropDown() : super();

  @override
  CreditCardDropDownState createState() => CreditCardDropDownState();
}

class CreditCardDropDownState extends State<CreditCardDropDown> {
  //
  List<CreditCard> _creditCards = new List<CreditCard>();
  List<DropdownMenuItem<CreditCard>> _dropdownMenuItems;
  CreditCard _selectedCreditCard;

  @override
  void initState() {
    getCreditCards().then((cards) => {
      _creditCards = cards,
      _selectedCreditCard = cards[0]
    });
    _dropdownMenuItems = buildDropdownMenuItems(_creditCards);
    super.initState();
  }

  List<DropdownMenuItem<CreditCard>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<CreditCard>> items = List();
    for (CreditCard company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(CreditCard selectedCreditCard) {
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
