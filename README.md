# Pixelora AI – Android starter

This is a Flutter starter project for the first Pixelora AI prototype.

## Included
- English home screen and app branding
- Gallery image selection and preview
- Daily 3-credit demo counter (stored locally)
- Feature entry points for background removal, background changer, crop/resize and product photos
- Premium placeholder screen

## Important: not production-ready yet
The AI button is currently a demo placeholder. It does NOT remove a background yet.
AdMob, rewarded ads, Google Play Billing, backend processing, account systems and a production privacy policy are not connected.

## Build
1. Install Flutter SDK and Android Studio.
2. Run `flutter pub get`.
3. Run `flutter run` on an Android device.
4. For an Android App Bundle, run `flutter build appbundle`.

## Next development tasks
1. Create a secure backend endpoint for image processing.
2. Connect a background-removal API or deploy a suitable open-source model.
3. Enforce daily free credits on the backend (local credits can be reset by reinstalling the app).
4. Integrate Google Mobile Ads and rewarded ads, following current Google policies.
5. Integrate Google Play Billing for subscriptions.
6. Add privacy policy, data deletion, consent and EU/UK privacy compliance.
7. Test on real Android devices and complete Play Console testing requirements.

## Security
Never put a private AI API key in the Flutter app. Keep it on a secure backend.
