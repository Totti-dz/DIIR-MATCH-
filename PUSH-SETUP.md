# Push setup for DIIR MATCH

## Important: this migration targets the legacy web app schema

The current app expects `users`, `stadiums`, and `bookings` with text/numeric identifiers and the fields listed in `supabase/push_migration.sql`. The separate `football_booking_sql.zip` schema uses UUID profiles/fields and is not a drop-in schema for this frontend. Do not apply both data models to the same project. Before running the migration, confirm that the existing `public.bookings` table has `field_id`, `field_name`, `user_id`, `booking_date`, `booking_time`, and `status`.

## Deploy

1. Apply `supabase/push_migration.sql` in the Supabase SQL Editor.
2. Generate a random webhook secret (at least 32 characters). In Supabase SQL Editor, save the project URL and that same secret to Vault:

   ```sql
   select vault.create_secret('https://YOUR_PROJECT_REF.supabase.co', 'project_url');
   select vault.create_secret('PASTE_A_NEW_RANDOM_SECRET_HERE', 'push_webhook_secret');
   ```

   Also add the same random value as the Edge Function secret `PUSH_WEBHOOK_SECRET` in Supabase Dashboard → Edge Functions → Secrets.
3. Add the remaining Edge Function secrets in Supabase Dashboard → Edge Functions → Secrets:


   ```text
   SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are supplied by Supabase to Edge Functions. Do not put either in the app.
   PUSH_WEBHOOK_SECRET=the same random value stored in Vault
   FIREBASE_PROJECT_ID=...
   FIREBASE_CLIENT_EMAIL=... (service account email)
   FIREBASE_PRIVATE_KEY=... (service account private_key; keep it out of source control)
   ```

4. Deploy both functions from the repository root:

   ```sh
   supabase functions deploy register-token
   supabase functions deploy send-push
   ```

5. Register the device by signing in to the Android app, then check `app_device_tokens` for the device. Insert a test booking and check Edge Function logs for `send-push`. Change its status to `approved` or `rejected` to test the customer notification.

The `register-token` endpoint follows the app's current local numeric identity scheme. That scheme is not authenticated by Supabase Auth: a determined caller can claim another user ID. Before production, migrate sign-in to Supabase Auth and verify the caller's `auth.uid()` in `register-token`, then link bookings and tokens to that UUID. Do not treat the current organizer PINs or local user IDs as secure credentials.

## Android build secret

Set repository Actions secret `GOOGLE_SERVICES_JSON` to the complete contents of the Firebase Android `google-services.json`. The workflow now fails if the secret is missing. Its Android package name must match `dz.sougueur.diirmatch`.


The site bundle and Android build use the same root `index.html` after this update. The PWA service worker remains in `public/sw.js`; upload the contents of `htdocs` to the hosting document root.
