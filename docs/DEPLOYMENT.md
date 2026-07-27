# Phoenix Journeys Deployment

## Production target

- Platform: Cloudflare Workers Static Assets
- Worker: `phoenix-journeys-alpha`
- Flutter project directory: `app/`
- Build output: `app/build/web/`

## Local verification

```bash
cd app
flutter pub get
flutter analyze
flutter test
flutter build web --release
```

Serve the release output locally before deployment:

```bash
cd build/web
python -m http.server 8000
```

Then open `http://localhost:8000`.

## Cloudflare deployment

From the repository root:

```bash
cd app
flutter build web --release
cd ..
npx wrangler deploy
```

`wrangler.toml` publishes `app/build/web` as static assets and uses SPA fallback routing so direct navigation continues to load the Flutter application.

## Cloudflare Git integration

When Cloudflare builds directly from GitHub, use:

- Root directory: repository root
- Build command: `cd app && flutter build web --release`
- Deploy command: `npx wrangler deploy`
- Asset directory: configured by `wrangler.toml`

## Release gate

Do not deploy unless all of these pass:

1. `flutter analyze`
2. `flutter test`
3. `flutter build web --release`
4. Founder mobile smoke test
