import 'package:flutter/material.dart';
import '../../../data/models/claim_model.dart';
import '../../../data/repositories/claim_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../presentation/widgets/common/item_card.dart';

class MyClaimsScreen extends StatefulWidget {
  const MyClaimsScreen({super.key});

  @override
  State<MyClaimsScreen> createState() => _MyClaimsScreenState();
}

class _MyClaimsScreenState extends State<MyClaimsScreen> {
  final ClaimRepository _claimRepository = ClaimRepository();
  final ItemRepository _itemRepository = ItemRepository();

  List<ClaimModel> _myClaims = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final claims = await _claimRepository.getClaimsByUser('user1');
    if (!mounted) {
      return;
    }
    setState(() {
      _myClaims = claims;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Claims'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _myClaims.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No claims yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Open an item and tap Request Claim first.'),
                            ),
                          );
                        },
                        child: const Text('Make a Claim'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._myClaims.map((claim) {
                        return FutureBuilder(
                          future: _itemRepository.getItemById(claim.itemId),
                          builder: (context, snapshot) {
                            final item = snapshot.data;

                            if (item == null) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ItemCard(
                                itemName: item.name,
                                category: item.category,
                                location: item.location,
                                status: claim.status,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Claim ${claim.id} is ${claim.status}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
