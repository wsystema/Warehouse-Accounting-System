// Column(
// crossAxisAlignment:
// CrossAxisAlignment.end,
// children: [
// IconButton(
// onPressed: () => deleteProduct(
// widget.docId, data.docId)
//     .then((value) =>
// showProductDeleteComplete()),
// icon: const Icon(
// Icons.delete,
// color: Colors.red,
// )),
// IconButton(
// onPressed: () {
// showUpdateDialog(data);
// },
// icon: Icon(Icons
//     .published_with_changes_sharp))
// ],
// // )
//
// Align(
// alignment: Alignment.centerLeft,
// child: Row(
// children: [
// Column(
// mainAxisAlignment:
// MainAxisAlignment.start,
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Text(AppLocalizations.of(context)!
//     .description),
// Text(
//   data.description,
//   // softWrap: true,
//   maxLines: 10,
//     overflow: TextOverflow.ellipsis
// ),
// Text(AppLocalizations.of(context)!
//     .name),
// Text(data.name),
// Text(AppLocalizations.of(context)!
//     .sender),
// Text(data.sender),
// Text(AppLocalizations.of(context)!
//     .numberOfUnits),
// Text(data.numberOfUnits.toString()),
// Text(AppLocalizations.of(context)!
//     .uId),
// Text(data.id),
// Text(AppLocalizations.of(context)!
//     .price),
// Text(data.price.toString())
// ],
// ),
//
// ],
// ),
// ),