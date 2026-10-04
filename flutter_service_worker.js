'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "54a2418e9bf6a85d594e099e66f7d77c",
"assets/AssetManifest.bin.json": "63513a5220a9893cb103267e20c7f96b",
"assets/assets/avatars/avatar_lvl1.png": "ea0364028d30ca43beafcc9cd1b251b8",
"assets/assets/avatars/avatar_lvl2.png": "6cf81c28d604d2e305691e1e3ad349ff",
"assets/assets/avatars/avatar_lvl3.png": "68fb79e36fbf43923e0a0b7fce19457a",
"assets/assets/avatars/avatar_lvl4.png": "21fba39a2cbe40700a7a06519b13e924",
"assets/assets/avatars/avatar_lvl5.png": "685de18463c6a9dadc34a4441da7d4b1",
"assets/assets/google_fonts/OFL.txt": "a0083270a0b813743654f7fe43edd8a4",
"assets/assets/google_fonts/VarelaRound-Regular.ttf": "4c52198bb1b5ab80b1e3f8e41ec157aa",
"assets/assets/images/q01_bread.png": "e29c75484549e895619a06e786b2432b",
"assets/assets/images/q02_spread.png": "78066ea6d68956737b03cd262fd0f433",
"assets/assets/images/q03_cereal.png": "5034f34c0ccde1043f15b67215a8ef10",
"assets/assets/images/q04_drink.png": "3bd22c7859ee7ad52a7046c46bb23386",
"assets/assets/images/q05_fruit.png": "1c5f0d80c2cc1c82c771b32b52db0596",
"assets/assets/images/q06_dried_vs_fresh.png": "50be6251793c601b32ffddf5bc89b178",
"assets/assets/images/q07_melons_berries.png": "b4aaf0840ef7932b1bc8b5b686ab678b",
"assets/assets/images/q07_milk.png": "77fc8c17463ad1cce0d23bbeb5e4440f",
"assets/assets/images/q08_sweet_treat.png": "e5ff7f8c60a35edc0e4258fc68c94560",
"assets/assets/images/q09_potato_prep.png": "73691e658eef67d3cc16850655baeee2",
"assets/assets/images/q10_double_boil.png": "de8429d6b7720f617f10db3a3d314db1",
"assets/assets/images/q11_cooking_water.png": "bf0b5b492ab1e30cc37ac94ee7533fc2",
"assets/assets/images/q12_chips.png": "660f0973f2b3791300e7829d0f9249e2",
"assets/assets/images/q13_soak_veggies.png": "c555254d9d2fa583b0dead57116c196e",
"assets/assets/images/q14_potatoes_rice.png": "6d76a91d97ce10db50058bb1a55213f6",
"assets/assets/images/q14_potato_best.png": "3834189f83e0e7e8a52ebba1890a2d49",
"assets/assets/images/q15_pasta_rice.png": "92eeeb05a3731ff383731123d0b7ef65",
"assets/assets/images/q16_discard_soak.png": "eb35ba3ac0f299fac39085b18ad1ea2a",
"assets/assets/images/q17_school_drink.png": "04d5d85d97a940694a291837107335dd",
"assets/assets/images/q18_salty_snack.png": "c45337c7cb75ba7bdced7534dd899cb3",
"assets/assets/images/q19_festive_drink.png": "7076b83b6575ee0029fdfc1de7805349",
"assets/assets/images/q20_movie_snack.png": "b22943ea80af2eed4575ae9364a22aa5",
"assets/assets/images/q21_ice_cream.png": "45062bcaaebcc4393b55fb1167958a74",
"assets/assets/images/q22_snack_between.png": "766d14adcfae04c63a587595849bba1a",
"assets/assets/images/q23_birthday_cake.png": "71a7bd7d6ce3ba7a562827db835a2010",
"assets/assets/images/q24_canned_fruit.png": "d7b7b29a349b61bca650a7015a625d56",
"assets/assets/images/q25_meat.png": "0d243f91545f7703a97d17592bd13543",
"assets/assets/images/q26_cheese.png": "ecd6c813ff7e20532a91b11ff375c59b",
"assets/assets/images/q27_baking.png": "10fbddd26a8a005ac86ed0e45060cbea",
"assets/assets/images/q28_nuts.png": "34f3221419e4890e73c09cb2a13f6566",
"assets/assets/images/q29_avocado_vs_oil.png": "713709fa8c20cf4c38b1dfc0b33fcc73",
"assets/assets/images/q29_milk_types.png": "27ec5eb13470117c6725c3215110440f",
"assets/assets/images/q30_dinner.png": "ed78650cf1d4577ab45b0daaf30e8fa5",
"assets/assets/images/q31_bread_type.png": "7ff8d72401c7fc5b129f62447125c33e",
"assets/assets/images/q31_tomato_vs_pepper.png": "2afe4be04be5c9d725a22a220bebd0a7",
"assets/assets/images/q32_salt_sub.png": "9dd6bc7f1ec94bc1d1b2eb47c81b5ee3",
"assets/assets/images/q33_phosphate.png": "c1524b4328a7f17ce903b97231bfd8ec",
"assets/assets/images/q34_e450.png": "caa009c4ed8c82e085760c240e7ae02c",
"assets/assets/images/q35_e202.png": "d8ae52bebc63650d39936d78ecd83cd4",
"assets/assets/images/q36_absorption.png": "23cd19fed0312a8fe544c0f56a17390d",
"assets/assets/images/q37_binder_med.png": "b9eb9d9a1bb2fc459c9e398616209907",
"assets/assets/images/q38_e341.png": "61cf87cefe6b4a13c1e1046d5414619a",
"assets/assets/images/q39_plant_protein.png": "ffe5ea2fc5429193e508046700907c13",
"assets/assets/images/q40_medications.png": "e9eaa18f397249ac75ab982ef67f1dbe",
"assets/assets/logo/KidniLogo.jpg": "aa3c7501aa971c5867d6425604391cb9",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63f2a78b90dc8706f08f47853b62cdae",
"assets/NOTICES": "859e0466d383edcaa7f12abac76ef529",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "fe8f627360962eec8f03f3610806e69a",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "bd490f0e60a2a126dccb9b4db70de332",
"icons/Icon-192.png": "4aa49b1bf00040258bfeb7ea02c30467",
"icons/Icon-512.png": "badbdbb52db29e12c3247a0f1ead3203",
"icons/Icon-maskable-192.png": "4aa49b1bf00040258bfeb7ea02c30467",
"icons/Icon-maskable-512.png": "badbdbb52db29e12c3247a0f1ead3203",
"index.html": "ccb59bd29e7bba1b1befb225deab5375",
"/": "ccb59bd29e7bba1b1befb225deab5375",
"main.dart.js": "1afd0577a0e5be0de68835bdd9e44c9e",
"manifest.json": "ddb245e9a7703a488ecb71869b564672",
"version.json": "442673773482dadc8d9bda9ad3a8b5f8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
