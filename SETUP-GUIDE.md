# SAN Blinds — Setup Guide (shared version for 4 staff)

This puts your job system online so all staff open one web address, log in, and
see the same live job list. It uses two free services:

- **GitHub Pages** — hosts the app (you already use GitHub).
- **Supabase** — the shared database + staff logins.

Total cost: **$0**. Set-up time: about **20–30 minutes**, done once.

You will end up with three files: `index.html` (the app), `schema.sql` (the
database setup), and this guide.

---

## Part A — Create the database (Supabase)

1. Go to **supabase.com** and sign up (free, no card needed). Click **New project**.
   - Give it a name (e.g. *SAN Blinds*), set a **database password** (save it
     somewhere safe), and choose the region closest to you (**Sydney** for Tasmania).
   - Wait ~2 minutes while it sets up.

2. **Create the tables.** In the left sidebar click **SQL Editor → New query**.
   Open `schema.sql`, copy **everything**, paste it in, and click **Run**.
   You should see *Success*. (This also adds one sample client and job so the app
   isn't empty on first login — you can delete those later.)

3. **Add your staff logins.** Left sidebar → **Authentication → Users → Add user**.
   Enter each staff member's email and a password, tick **Auto Confirm User**, and
   create. Repeat for up to 4 staff.

4. *(Recommended)* **Stop strangers signing up.** Authentication → **Sign-in / Providers**
   (or **Settings**) → turn **off** “Allow new users to sign up”. Now only you can
   add staff.

5. **Copy your two keys.** Click the **gear (Project Settings) → API**. Copy:
   - **Project URL** (looks like `https://abcd1234.supabase.co`)
   - the **anon / public key** (the long one marked safe for browsers)

---

## Part B — Put your keys into the app

6. Open **`index.html`** in a plain text editor (Notepad works; VS Code is nicer).
   Near the top you'll see:

   ```
   var SUPABASE_URL = "PASTE_YOUR_PROJECT_URL_HERE";
   var SUPABASE_KEY = "PASTE_YOUR_ANON_PUBLIC_KEY_HERE";
   ```

   Replace the text inside the quotes with your **Project URL** and **anon key**
   from step 5. Keep the quotes and semicolons. **Save.**

   > Test it: double-click `index.html`. You should get a **login screen**. Sign in
   > with one of the staff emails/passwords from step 3. If you see the job list,
   > it's working.

---

## Part C — Put it online (GitHub Pages)

7. On GitHub, create a **new repository** (e.g. `san-blinds`). Make it **Public** —
   free GitHub Pages needs a public repo. That's fine: the code and the anon key are
   safe to be public, and your actual client data lives in Supabase behind the staff
   logins, **not** in the code.

8. **Upload `index.html`** to the repo (drag-and-drop on the repo page → Commit).
   You can add `schema.sql` and this guide too, for your own records.

9. **Turn on Pages.** Repo → **Settings → Pages**. Under *Build and deployment*:
   Source = **Deploy from a branch**, Branch = **main**, folder = **/ (root)** → **Save**.
   Wait ~1 minute.

10. The page shows your live address, like
    `https://YOURNAME.github.io/san-blinds/`. **Share that link with your staff.**

---

## Part D — Everyday use

- **Staff:** open the link, log in, work. Changes sync to everyone automatically.
- **Holidays:** in the app → **Holidays** tab → add your local public-holiday dates.
  They're skipped in the “expected completion” (25 working-day) estimate.
- **Backup:** click **Backup** (top-right) now and then to download a copy of all
  data. The free plan keeps no automatic backups, so a weekly download is wise.
- **Client view:** on the Jobs screen, tick **Client view** for a clean, read-only
  screen you can show a client (just Job / Client / Stage / Expected date).

---

## Good to know

- **The database pauses after 7 days of no activity** on the free plan. Normal
  weekday use keeps it awake. If the workshop closes for more than a week (e.g.
  Christmas), it may pause — your data is safe; just log into supabase.com and click
  **Restore project**.
- **Want no pausing + automatic daily backups?** Upgrade Supabase to **Pro (~$25/mo)**
  later. Not needed to start.

## If something's not right

| What you see | Fix |
|---|---|
| “Almost there” screen | Keys not pasted correctly in step 6. |
| Login fails | Staff user not created, wrong password, or “Auto Confirm” wasn't ticked. |
| Job list won't load | Re-run `schema.sql` (step 2) — the grants section must run. |
| Pages link 404s | Wait a minute; confirm Branch = main, folder = root; repo is Public. |

That's it — you're running a shared, multi-user system for $0.
