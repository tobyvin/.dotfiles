// Most of the hardening comes from https://github.com/arkenfox/user.js

user_pref("_user.js.parrot", "0000 syntax error: Oh yes, the Norwegian Blue... what's wrong with it?");
user_pref("browser.aboutConfig.showWarning", false);

/*** [SECTION 0100]: STARTUP ***/
user_pref("_user.js.parrot", "0100 syntax error: the parrot's dead!");
user_pref("browser.startup.page", 3);
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.quitShortcut.disabled", false);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.tabClipWidth", 999);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.feeds.recommendationprovider", false);
user_pref("browser.newtabpage.activity-stream.feeds.recommendationproviderswitcher", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.dataFeatureRecommendations.enabled", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("extensions.pocket.enabled", false);
user_pref("ui.key.menuAccessKeyFocuses", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

/*** [SECTION 0200]: GEOLOCATION ***/
user_pref("browser.newtabpage.activity-stream.feeds.recommendationproviderswitcher", false);
user_pref("_user.js.parrot", "0200 syntax error: the parrot's definitely deceased!");
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
user_pref("geo.provider.network.logging.enabled", true);
user_pref("geo.provider.ms-windows-location", false);
user_pref("geo.provider.use_corelocation", false);
user_pref("geo.provider.use_gpsd", false);
user_pref("geo.provider.use_geoclue", false);

/*** [SECTION 0300]: QUIETER FOX ***/
user_pref("_user.js.parrot", "0300 syntax error: the parrot's not pinin' for the fjords!");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shopping.experience2023.enabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);

/*** [SECTION 0400]: SAFE BROWSING (SB) ***/
user_pref("_user.js.parrot", "0400 syntax error: the parrot's passed on!");
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);

/*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ***/
user_pref("_user.js.parrot", "0600 syntax error: the parrot's no more!");
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("browser.send_pings", false);

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS ***/
user_pref("_user.js.parrot", "0700 syntax error: the parrot's given up the ghost!");
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.file.disable_unc_paths", true);
user_pref("network.gio.supported-protocols", "");

/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
user_pref("_user.js.parrot", "0800 syntax error: the parrot's ceased to be!");
user_pref("browser.urlbar.showSearchTerms.enabled", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.addons.featureGate", false);
user_pref("browser.urlbar.mdn.featureGate", false);
user_pref("browser.urlbar.pocket.featureGate", false);
user_pref("browser.urlbar.weather.featureGate", false);
user_pref("browser.formfill.enable", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.search.separatePrivateDefault", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);

/*** [SECTION 0900]: PASSWORDS ***/
user_pref("_user.js.parrot", "0900 syntax error: the parrot's expired!");
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);

/*** [SECTION 1000]: DISK AVOIDANCE ***/
user_pref("_user.js.parrot", "1000 syntax error: the parrot's gone to meet 'is maker!");
user_pref("browser.cache.disk.enable", false);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.sessionhistory.max_total_viewers", 0);
user_pref("browser.sessionstore.interval", 1000000);
user_pref("media.cache_size", 102400);
user_pref("media.memory_cache_max_size", 65536);
user_pref("media.memory_caches_combined_limit_kb", 102400);
user_pref("image.mem.surfacecache.max_size_kb", 102400);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("browser.shell.shortcutFavicons", false);

/*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ***/
user_pref("_user.js.parrot", "1200 syntax error: the parrot's a stiff!");
// user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.OCSP.enabled", 1);
user_pref("security.OCSP.require", true);
user_pref("security.cert_pinning.enforcement_level", 2);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);
// user_pref("security.mixed_content.block_display_content", true);
user_pref("dom.security.https_only_mode", true);
// user_pref("dom.security.https_only_mode_pbm", true);
user_pref("dom.security.https_only_mode_send_http_background_request", false);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);

/*** [SECTION 1600]: REFERERS ***/
user_pref("_user.js.parrot", "1600 syntax error: the parrot rests in peace!");
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/*** [SECTION 1700]: CONTAINERS ***/
user_pref("_user.js.parrot", "1700 syntax error: the parrot's bit the dust!");
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
user_pref("_user.js.parrot", "2000 syntax error: the parrot's snuffed it!");
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);

/*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
user_pref("_user.js.parrot", "2400 syntax error: the parrot's kicked the bucket!");
user_pref("dom.disable_window_move_resize", true);

/*** [SECTION 2600]: MISCELLANEOUS ***/
user_pref("_user.js.parrot", "2600 syntax error: the parrot's run down the curtain!");
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.uitour.enabled", false);
user_pref("browser.uitour.url", "");
user_pref("devtools.debugger.remote-enabled", false);
// user_pref("permissions.default.shortcuts", 2);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("webchannel.allowObject.urlWhitelist", "");
user_pref("network.IDN_show_punycode", true);
user_pref("pdfjs.disabled", false);
user_pref("pdfjs.enableScripting", false);
user_pref("browser.tabs.searchclipboardfor.middleclick", false);
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("extensions.enabledScopes", 5);
user_pref("extensions.postDownloadThirdPartyPrompt", false);
user_pref("extensions.webextensions.restrictedDomains", "");

/*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
user_pref("_user.js.parrot", "2700 syntax error: the parrot's joined the bleedin' choir invisible!");
user_pref("browser.contentblocking.category", "strict");

/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("_user.js.parrot", "2800 syntax error: the parrot's bleedin' demised!");
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.clearOnShutdown.siteSettings", false);
user_pref("privacy.clearOnShutdown.openWindows", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.offlineApps", false);
user_pref("privacy.cpd.cache", true);
user_pref("privacy.cpd.formdata", true);
user_pref("privacy.cpd.history", true);
user_pref("privacy.cpd.sessions", true);
user_pref("privacy.cpd.offlineApps", false);
user_pref("privacy.cpd.cookies", false);
user_pref("privacy.cpd.downloads", true);
user_pref("privacy.cpd.openWindows", false);
user_pref("privacy.cpd.passwords", false);
user_pref("privacy.cpd.siteSettings", false);
user_pref("privacy.sanitize.timeSpan", 4);

/*** [SECTION 4000]: FPP (fingerprintingProtection) ***/
user_pref("_user.js.parrot", "1400 syntax error: the parrot's bereft of life!");
user_pref("privacy.fingerprintingProtection.pbmode", true);

/* END: internal custom pref to test for syntax errors ***/
user_pref("_user.js.parrot", "SUCCESS: No no he's not dead, he's, he's restin'!");
