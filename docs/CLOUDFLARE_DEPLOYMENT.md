# Cloudflare production deployment

Phoenix Journeys is built as a Flutter web application and deployed to the Cloudflare Worker named `phoenix-journeys-alpha`.

## Why GitHub changes did not appear online

The Flutter CI workflow only analyzed, tested, and built the project. Its build directory existed only inside the temporary GitHub Actions runner and was never uploaded to Cloudflare. The Worker therefore continued serving the previous Alpha 0.5.1 deployment.

## One-time GitHub secrets

Add these repository secrets under **Settings → Secrets and variables → Actions**:

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

The API token needs permission to edit Workers Scripts for the Cloudflare account that owns `phoenix-journeys-alpha`.

Setup status: both repository secrets were added on 2026-07-17.

## Automatic production flow

After both secrets exist, every push to `main` runs `.github/workflows/deploy-cloudflare.yml`:

1. install Flutter dependencies
2. build `app/build/web`
3. run `wrangler deploy` from the repository root
4. publish the assets configured in `wrangler.toml`

The same workflow can be started manually from **GitHub → Actions → Deploy Cloudflare → Run workflow**.

## Production URL

`https://phoenix-journeys-alpha.7hn5tyrjgh.workers.dev/`
