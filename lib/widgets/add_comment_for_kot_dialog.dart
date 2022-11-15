//AddCommentForKOTDialog
import 'package:waiterr/Model/comment_for_kot_suggestion_model.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global_class.dart';
import '../theme.dart';

class AddCommentForKOTDialog extends StatefulWidget {
  final Function() onTapAdd;
  final Function(CommentForKotSuggestionsModel) setCommentForKOT;
  final CommentForKotSuggestionsModel previousValue;
  final String itemId;
  const AddCommentForKOTDialog(
      {Key? key,
      required this.onTapAdd,
      required this.setCommentForKOT,
      required this.previousValue,
      required this.itemId})
      : super(key: key);
  @override
  State<AddCommentForKOTDialog> createState() => _AddCommentForKOTDialogState();
}

class _AddCommentForKOTDialogState extends State<AddCommentForKOTDialog> {
  // This widget is the root of your application.
  bool? _isLoading, _dataLoaded, _showCross;
  TextEditingController remarksController = TextEditingController();
  Future<List<CommentForKotSuggestionsModel>>? _futureitems;
  late List<CommentForKotSuggestionsModel> items;
  Future<List<CommentForKotSuggestionsModel>> fetchList() async {
    List<CommentForKotSuggestionsModel> runningOrderList = [];
    await postForCommentOnKot(widget.itemId).then(
        (List<CommentForKotSuggestionsModel> rList) =>
            {runningOrderList.addAll(rList), items = runningOrderList});
    setState(() {
      _isLoading = false;
      _dataLoaded = true;
    });
    return runningOrderList;
  }

  //Overrides
  @override
  void initState() {
    super.initState();
    _futureitems = fetchList();
    _isLoading = true;
    _dataLoaded = false;
    _showCross = widget.previousValue.toString().isNotEmpty;
    remarksController.text = widget.previousValue.commentForKOT ?? "";
    widget.setCommentForKOT(widget.previousValue);
    //this.items=_futureitems as List<RunningOrderModel>;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: _dataLoaded!
            ? MediaQuery.of(context).size.height / 2
            : _isLoading!
                ? 140
                : 190,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: remarksController,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Remarks',
                  suffixIcon: _showCross!
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            remarksController.text = "";
                            widget.setCommentForKOT(
                                CommentForKotSuggestionsModel());
                            setState(() {
                              _showCross = false;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  widget.setCommentForKOT(
                      CommentForKotSuggestionsModel(commentForKOT: value));
                  if (value == "" && _showCross!) {
                    setState(() {
                      _showCross = false;
                    });
                  } else if (!_showCross!) {
                    setState(() {
                      _showCross = true;
                    });
                  }
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                width: 320.0,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onTapAdd();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: GlobalTheme.waiterrPrimaryColor),
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      padding: const EdgeInsets.only(top: 10),
                      child: FutureBuilder<List<CommentForKotSuggestionsModel>>(
                          future: _futureitems,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          items[index].commentForKOT!,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        onTap: () {
                                          widget.setCommentForKOT(items[index]);
                                          remarksController.text =
                                              items[index].commentForKOT!;
                                          if (!_showCross!) {
                                            setState(() {
                                              _showCross = true;
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              if (snapshot.error.toString() == "NoData") {
                                return const ListTile(
                                  title: Text(
                                    "No Suggestions available",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                );
                              } else {
                                _isLoading = false;
                                return ListTile(
                                  title: const Text(
                                    "Error occured, Tap to retry.",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onTap: () {
                                    _futureitems = fetchList();
                                  },
                                );
                              }
                            }
                            // By default, show a loading spinner.
                            return const SizedBox(
                                height: 5, child: LinearProgressIndicator());
                          }))),
            ],
          ),
        ),
      ),
    );
  }
}
