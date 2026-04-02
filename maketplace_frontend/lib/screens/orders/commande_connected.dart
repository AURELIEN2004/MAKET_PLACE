// lib/screens/orders/commande_connected.dart
// ============================================
// Écran de commande connecté — remplace commande.dart
// ============================================
import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../models/api_models.dart';

class CommandeConnected extends StatefulWidget {
  final CartModel cart;
  const CommandeConnected({super.key, required this.cart});

  @override
  State<CommandeConnected> createState() => _CommandeConnectedState();
}

class _CommandeConnectedState extends State<CommandeConnected> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: 'Yaoundé');
  final _noteCtrl = TextEditingController();

  // ✅ Correspond aux choices Django : 'mobile_money' | 'cash_on_delivery'
  String _paymentMethod = 'mobile_money';
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _phoneCtrl, _addressCtrl, _cityCtrl, _noteCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await OrderService.createOrder(
      deliveryName: _nameCtrl.text.trim(),
      deliveryPhone: _phoneCtrl.text.trim(),
      deliveryAddress: _addressCtrl.text.trim(),
      deliveryCity: _cityCtrl.text.trim(),
      paymentMethod: _paymentMethod,
      note: _noteCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.green, size: 70),
              const SizedBox(height: 16),
              const Text('Commande confirmée !',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Commande #${result.order!.id}\nTotal: ${result.order!.total} FCFA',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ferme dialog
                Navigator.pop(context); // retour panier
                Navigator.pop(context); // retour accueil
              },
              child: const Text('Retour à l\'accueil',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erreur lors de la commande'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Commande',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Infos livraison ───────────────
              _SectionTitle('Informations de livraison'),
              const SizedBox(height: 12),

              _Field(ctrl: _nameCtrl, label: 'Nom complet', icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'Nom requis' : null),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _Field(
                        ctrl: _phoneCtrl,
                        label: 'Téléphone',
                        icon: Icons.phone_outlined,
                        inputType: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? 'Requis' : null),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                        ctrl: _cityCtrl,
                        label: 'Ville',
                        icon: Icons.location_city_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _addressCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Adresse de livraison',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v!.isEmpty ? 'Adresse requise' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _noteCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Note (optionnel)',
                  hintText: 'Ex: Laisser au gardien...',
                  prefixIcon: const Icon(Icons.note_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // ── Mode de paiement ──────────────
              _SectionTitle('Mode de paiement'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _PaymentOption(
                      label: 'Mobile Money',
                      subtitle: 'MTN, Orange Money...',
                      icon: Icons.phone_android,
                      value: 'mobile_money',
                      groupValue: _paymentMethod,
                      onChanged: (v) =>
                          setState(() => _paymentMethod = v!),
                    ),
                    const Divider(height: 1),
                    _PaymentOption(
                      label: 'Paiement à la livraison',
                      subtitle: 'Payez en cash à la réception',
                      icon: Icons.payments_outlined,
                      value: 'cash_on_delivery',
                      groupValue: _paymentMethod,
                      onChanged: (v) =>
                          setState(() => _paymentMethod = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Récapitulatif ─────────────────
              _SectionTitle('Récapitulatif de la commande'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _SummaryRow('Sous-total',
                        '${widget.cart.subtotal} FCFA'),
                    const SizedBox(height: 8),
                    _SummaryRow('Frais de livraison',
                        '${widget.cart.deliveryFee} FCFA'),
                    const Divider(height: 16),
                    _SummaryRow('Total', '${widget.cart.total} FCFA',
                        bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Bouton confirmation ───────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Confirmer la commande',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.inputType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final void Function(String?) onChanged;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, size: 20, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      groupValue: groupValue,
      activeColor: Colors.redAccent,
      onChanged: onChanged,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style)],
    );
  }
}
