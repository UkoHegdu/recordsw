# Tech debt

- **Admin config limits not implemented** – The `admin_config` table and admin UI (GET/PUT `/api/v1/admin/config`) let you view and edit `max_maps_per_user`, `max_driver_notifications`, `max_users_registration`, `max_new_records_per_map`. The backend does **not** read these values; it uses env vars only (`MAX_MAPS_PER_USER`, etc.). So changing settings in the admin UI has no effect. Either wire the backend to read limits from `admin_config`, or remove the admin config UI/API and rely on env only.

- **Login: clearer wrong-password message** – When login fails due to wrong password, return/show a clear message (e.g. “Incorrect email or password”) instead of a generic error, so the user knows it was an auth failure and not a server/network issue.

- **Login: limit wrong password attempts** – Rate-limit or cap failed login attempts (e.g. ~25 wrong attempts per email or per IP) to reduce brute-force and lockout abuse. Optionally show a “too many attempts, try again later” message when the limit is hit.
