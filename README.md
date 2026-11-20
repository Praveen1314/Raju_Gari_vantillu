# Raju Gari Pindi Vantalu · రాజు గారి పిండి వంటలు

A one-page ordering website for Raju garu's homemade organic millet snacks.
Customers pick snacks, fill a short form, and the order opens in WhatsApp (wa.me).
Everything is in one file, `index.html` (inline CSS and JS). There's no build step.

## Features

**Shopping**
- **Snack menu**: Jantikalu, Karapusa, Gavvalu (sweet and hot), Gorumeeti, Ribbon Pakoda and Mixture, each with an English name, a Telugu name, its millet and a taste badge.
- **Pack sizes**: ½ kg ₹300, 1 kg ₹600, 5 kg ₹3,000 (editable).
- **Live search** by English name, Telugu name or millet.
- **Sort**: Default, Name A–Z, Hot first, Sweet first. Works together with the filter chips.
- **Filter chips**: All, Hot, Sweet and Favourites.
- **Favourites**: a heart on each card, saved on the device (`rgpv-fav`).
- **Quick view**: tap a snack picture for a larger view with all its prices.
- **Cart drawer** with quantity controls, total weight and total price. The cart is saved on the device (`rgpv-cart-v2`).

**Checkout**
- Name, phone, address and notes. They're remembered for next time (`rgpv-cust`).
- **Preferred delivery date** (today or later) and **time slot**. Both appear in the WhatsApp message.
- **Reorder last order** restores the previous cart (`rgpv-last`).

**Extras**
- **Dark mode** toggle. It's saved (`rgpv-theme`) and defaults to the phone or computer setting.
- **Share** button: uses the phone's share sheet, or copies the link and shows a message.
- **Back-to-top** button that appears after scrolling.
- Respects "reduce motion". Works at 375px phone width and on desktop. Mobile has a bottom bar showing the cart total.

**Look and animation**
- The hero shows the **whole** picture of Raju garu and his wife (the frame matches the picture's shape, so nothing is cut off). It opens like doors, tilts in 3D with the mouse, and has floating snack stickers and drifting spice particles.
- The headline reveals word by word. There's a scroll-progress bar, wavy gold underlines under each heading, prices that count up, two-row scrolling strips, cards that tilt with a light glare, and a snack that flies into the cart when you tap Add.
- Everything turns off automatically for people who set "reduce motion".

**Reviews and ratings**
- A reviews section near the bottom shows the average rating, a 5★ to 1★ breakdown and review cards (sort by newest, highest or lowest).
- Customers tap **Write a review**: they pick 1–5 stars, add their name, area and snack, write the review, and it's **sent to Raju garu on WhatsApp**. They see it on their own device marked "waiting for approval".
- Approved reviews show for everyone. Snack cards then show their own star rating, and the hero shows the overall rating.

**Owner panel**
- **Add, edit, delete, reorder** snacks, and mark them **sold out**.
- Upload a **photo** per snack. It's resized automatically.
- Edit the **standard pack prices**, or add and remove pack sizes.
- Give any single snack its **own price** (for example, a costly special).
- **Download updated index.html** to publish the changes. Backup and restore with a .json file.

## Picture of Raju garu

The newest cartoon of Raju garu must be saved as **`images/raju-logo.webp`** (it's used as the logo).
The full picture of Raju garu and his wife is `images/raju-family.webp` (hero), with a smaller copy in `raju-family-sm.webp`.
`images/snack-plate.webp` is a close-up of the snack plate from the same picture.

## Run it on your computer

Double-click `start-site.bat` (uses Windows PowerShell, so no installs are needed). If you have Python, this also works:

```
python -m http.server 8090
```

Then open **http://localhost:8090** (the .bat uses port 8090 so it never clashes with an older server on 8080).

## Settings (top of the `<script>` in index.html)

```js
const CONFIG = {
  phone: "919999999999",   // ← put Raju garu's WhatsApp number here
  adminPin: "1234",        // ← change the owner PIN
  photos: { "jantikalu": "", ... }
};
```

- **CONFIG.phone**: country code + number, with no `+`, spaces or dashes. Example: `919876543210`.
- **CONFIG.adminPin**: the PIN for the Owner panel. Note that this is a simple lock, not real security. Anyone who reads the page source can see it. It also only changes what *that browser* sees, never the live site.

## Adding real photos through CONFIG.photos

1. Save each photo in `images/`, ideally as `.webp` around 900×600 (landscape 3:2). For example: `images/jantikalu.webp`.
2. Put the path next to the product id:
   ```js
   photos: { "jantikalu": "images/jantikalu.webp", "karapusa": "images/karapusa.webp", ... }
   ```
3. The current pictures in `images/snacks/` are drawings. Replace them with real photos, keeping the same file names, and nothing else needs to change.
4. Snacks without any picture (for example new ones added in the Owner panel) get a drawing automatically.

Product ids: `jantikalu`, `karapusa`, `gavvalu-sweet`, `gavvalu-hot`, `gorumeeti`, `ribbon-pakoda`, `mixture`.
(Or upload a photo straight from the Owner panel, under Edit, then Photo.)

## Adding snacks and changing prices (Owner panel)

1. Start the site locally (see above) and open http://localhost:8090.
2. Scroll to the footer and click **Owner: edit snacks & prices** (or open `http://localhost:8090/#owner`). Enter the PIN.
3. **Snacks** tab: use **+ Add new snack**, **Edit**, **Delete**, ↑ ↓ to reorder, and **In stock / Sold out**.
4. **Pack prices** tab: change prices or weights, then click **Save prices**.
5. **Publish** tab: click **Download updated index.html**. Replace the old `index.html` in this folder with the downloaded one, then publish it (below).

> Edits are saved in your browser straight away, but customers only see them after you publish the downloaded `index.html`.
> You can also edit the menu by hand. It's the JSON between `/*CATALOG-START*/` and `/*CATALOG-END*/` in index.html.

## Approving reviews

1. A review arrives on Raju garu's WhatsApp.
2. Open the site locally, go to **Owner → Reviews → + Add a review**, copy in the name, stars, snack and text, then click **Add review**. If the review was written on this same device, just click **Approve**.
3. Go to **Publish → Download updated index.html**, replace `index.html` and push (see below).
4. Use **Edit** or **Delete** to change or remove a review.

Only add real reviews from real customers.

## Publish free (GitHub + Cloudflare Pages, auto-updates)

1. Create a free GitHub repository, e.g. `raju-gari-vantalu`, and push this folder to it.
2. In Cloudflare go to **Workers & Pages → Create → Pages → Connect to Git**, then pick the repository.
3. Use these build settings: Framework preset **None**, build command **empty**, build output directory **/** . Then click **Save and Deploy**.
4. Your site goes live at `https://raju-gari-vantalu.pages.dev`.
5. **To update:** change files (or use the Owner panel's *Download updated index.html* and replace `index.html`), then:
   ```
   git add -A
   git commit -m "Update menu"
   git push
   ```
   Cloudflare redeploys automatically in about a minute.

Netlify Drop (https://app.netlify.com/drop) also works for a quick one-off upload.

## Files

```
index.html        the whole website
manifest.json     lets phones "Add to Home screen"
start-site.bat    starts a local server on port 8090 (Windows, no Python needed)
serve.ps1         the small PowerShell server that start-site.bat runs
images/           raju-logo.webp, raju-family.webp, raju-family-sm.webp, snack-plate.webp, icon-192.png, icon-512.png
images/snacks/    one picture per snack (jantikalu.webp, karapusa.webp, gavvalu-sweet.webp, ...)
```
