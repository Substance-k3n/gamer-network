# End-to-end tests

`app_e2e_test.dart` drives the real app on an Android emulator against a
local API, as one new player: sign up with the emailed code, onboard, post
a listing, connect from a listing and from a profile, report, join the
Groups waitlist, edit the profile; then Dave accepts and invites them to
play, they accept, answer the check-in, close the listing, block and
unblock, reset the password and delete the account.

`tour_test.dart` signs in as Hana and screenshots the main screens into
`build/screenshots/` (run it with `flutter drive`, below).

## Running them

From the repo root, with Docker and an emulator running:

```bash
docker compose -f infra/docker/dev/compose.yml up -d
pnpm --filter @app/api db:migrate && pnpm --filter @app/api db:seed

# The API's console is where local email codes land; keep a copy.
pnpm --filter @app/api dev 2>&1 | tee /tmp/gn-api.log
```

The tests need three players. Sign them up through the API (or the app),
confirm their emails, onboard them with CoD Mobile or another launch game,
and give Dave and Yonas a live listing:

| Email              | Username    | Password      |
| ------------------ | ----------- | ------------- |
| `dave@rally.test`  | `dave.exe`  | `password123` |
| `hana@rally.test`  | `hanaplays` | `password123` |
| `yonas@rally.test` | `yonasjg`   | `password123` |

Then, in another terminal:

```bash
cd apps/mobile
node integration_test/e2e_helper.mjs /tmp/gn-api.log   # codes and due check-ins
adb reverse tcp:3300 tcp:3300 && adb reverse tcp:3399 tcp:3399 && adb reverse tcp:9470 tcp:9470

flutter test integration_test/app_e2e_test.dart -d emulator-5554 \
  --dart-define=API_URL=http://localhost:3300

flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/tour_test.dart -d emulator-5554 \
  --dart-define=API_URL=http://localhost:3300
```

`e2e_helper.mjs` serves the newest emailed code for an address and can
make someone's check-ins due now (they normally fall due the next day).
It is for local runs only: it reads the API's log and writes to the dev
database.

## Against the deployed API

There is no helper there, so the players are made beforehand: sign up
`dave.exe`, `yonasjg`, `hanaplays` and the test player through the API,
confirm their emails with the codes from the inbox, onboard all but the
test player, and give Dave and Yonas a live listing. Then:

```bash
flutter test integration_test/app_e2e_test.dart -d emulator-5554 \
  --dart-define=API_URL=https://gn-api-c763.onrender.com \
  --dart-define=E2E_EMAIL=<the test player's email>
```

With `E2E_EMAIL` the test logs that player in instead of signing up, and
skips the check-in (it can't be made due remotely) and the password reset
(it needs another emailed code). It still deletes the test player at the
end; delete the other three with `DELETE /v1/me`.
