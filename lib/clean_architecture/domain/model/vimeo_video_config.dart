// To parse this JSON data, do
//
//     final vimeoVideoConfig = vimeoVideoConfigFromMap(jsonString);

import 'dart:convert';

VimeoVideoConfig vimeoVideoConfigFromMap(String str) => VimeoVideoConfig.fromMap(json.decode(str));

String vimeoVideoConfigToMap(VimeoVideoConfig data) => json.encode(data.toMap());

class VimeoVideoConfig {
  VimeoVideoConfig({
    this.cdnUrl,
    this.vimeoApiUrl,
    this.request,
    this.playerUrl,
    this.video,
    this.user,
    this.embed,
    this.view,
    this.vimeoUrl,
  });

  final String? cdnUrl;
  final String? vimeoApiUrl;
  final Request? request;
  final String? playerUrl;
  final Video? video;
  final User? user;
  final Embed? embed;
  final int? view;
  final String? vimeoUrl;

  factory VimeoVideoConfig.fromMap(Map<String, dynamic> json) => VimeoVideoConfig(
    cdnUrl: json["cdn_url"] == null ? null : json["cdn_url"],
    vimeoApiUrl: json["vimeo_api_url"] == null ? null : json["vimeo_api_url"],
    request: json["request"] == null ? null : Request.fromMap(json["request"]),
    playerUrl: json["player_url"] == null ? null : json["player_url"],
    video: json["video"] == null ? null : Video.fromMap(json["video"]),
    user: json["user"] == null ? null : User.fromMap(json["user"]),
    embed: json["embed"] == null ? null : Embed.fromMap(json["embed"]),
    view: json["view"] == null ? null : json["view"],
    vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
  );

  Map<String, dynamic> toMap() => {
    "cdn_url": cdnUrl == null ? null : cdnUrl,
    "vimeo_api_url": vimeoApiUrl == null ? null : vimeoApiUrl,
    "request": request == null ? null : request!.toMap(),
    "player_url": playerUrl == null ? null : playerUrl,
    "video": video == null ? null : video!.toMap(),
    "user": user == null ? null : user!.toMap(),
    "embed": embed == null ? null : embed!.toMap(),
    "view": view == null ? null : view,
    "vimeo_url": vimeoUrl == null ? null : vimeoUrl,
  };
}

class Embed {
  Embed({
    this.autopause,
    this.playsinline,
    this.settings,
    this.color,
    this.texttrack,
    this.onSite,
    this.appId,
    this.muted,
    this.dnt,
    this.playerId,
    this.api,
    this.editor,
    this.context,
    this.keyboard,
    this.outro,
    this.transparent,
    this.logPlays,
    this.quality,
    this.time,
    this.loop,
    this.autoplay,
  });

  final int? autopause;
  final int? playsinline;
  final Map<String, int>? settings;
  final String? color;
  final String? texttrack;
  final int? onSite;
  final String? appId;
  final int? muted;
  final int? dnt;
  final String? playerId;
  final dynamic? api;
  final bool? editor;
  final String? context;
  final int? keyboard;
  final String? outro;
  final int? transparent;
  final int? logPlays;
  final dynamic? quality;
  final int? time;
  final int? loop;
  final int? autoplay;

  factory Embed.fromMap(Map<String, dynamic> json) => Embed(
    autopause: json["autopause"] == null ? null : json["autopause"],
    playsinline: json["playsinline"] == null ? null : json["playsinline"],
    settings: json["settings"] == null ? null : Map.from(json["settings"]).map((k, v) => MapEntry<String, int>(k, v)),
    color: json["color"] == null ? null : json["color"],
    texttrack: json["texttrack"] == null ? null : json["texttrack"],
    onSite: json["on_site"] == null ? null : json["on_site"],
    appId: json["app_id"] == null ? null : json["app_id"],
    muted: json["muted"] == null ? null : json["muted"],
    dnt: json["dnt"] == null ? null : json["dnt"],
    playerId: json["player_id"] == null ? null : json["player_id"],
    api: json["api"],
    editor: json["editor"] == null ? null : json["editor"],
    context: json["context"] == null ? null : json["context"],
    keyboard: json["keyboard"] == null ? null : json["keyboard"],
    outro: json["outro"] == null ? null : json["outro"],
    transparent: json["transparent"] == null ? null : json["transparent"],
    logPlays: json["log_plays"] == null ? null : json["log_plays"],
    quality: json["quality"],
    time: json["time"] == null ? null : json["time"],
    loop: json["loop"] == null ? null : json["loop"],
    autoplay: json["autoplay"] == null ? null : json["autoplay"],
  );

  Map<String, dynamic> toMap() => {
    "autopause": autopause == null ? null : autopause,
    "playsinline": playsinline == null ? null : playsinline,
    "settings": settings == null ? null : Map.from(settings!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "color": color == null ? null : color,
    "texttrack": texttrack == null ? null : texttrack,
    "on_site": onSite == null ? null : onSite,
    "app_id": appId == null ? null : appId,
    "muted": muted == null ? null : muted,
    "dnt": dnt == null ? null : dnt,
    "player_id": playerId == null ? null : playerId,
    "api": api,
    "editor": editor == null ? null : editor,
    "context": context == null ? null : context,
    "keyboard": keyboard == null ? null : keyboard,
    "outro": outro == null ? null : outro,
    "transparent": transparent == null ? null : transparent,
    "log_plays": logPlays == null ? null : logPlays,
    "quality": quality,
    "time": time == null ? null : time,
    "loop": loop == null ? null : loop,
    "autoplay": autoplay == null ? null : autoplay,
  };
}

class Request {
  Request({
    this.files,
    this.lang,
    this.sentry,
    this.thumbPreview,
    this.referrer,
    this.cookieDomain,
    this.timestamp,
    this.gcDebug,
    this.expires,
    this.client,
    this.currency,
    this.session,
    this.cookie,
    this.build,
    this.urls,
    this.signature,
    this.flags,
    this.country,
    this.fileCodecs,
    this.abTests,
  });

  final Files? files;
  final String? lang;
  final Sentry? sentry;
  final ThumbPreview? thumbPreview;
  final dynamic? referrer;
  final String? cookieDomain;
  final int? timestamp;
  final GcDebug? gcDebug;
  final int? expires;
  final Client? client;
  final String? currency;
  final String? session;
  final Cookie? cookie;
  final Build? build;
  final Urls? urls;
  final String? signature;
  final Flags? flags;
  final String? country;
  final FileCodecs? fileCodecs;
  final AbTests? abTests;

  factory Request.fromMap(Map<String, dynamic> json) => Request(
    files: json["files"] == null ? null : Files.fromMap(json["files"]),
    lang: json["lang"] == null ? null : json["lang"],
    sentry: json["sentry"] == null ? null : Sentry.fromMap(json["sentry"]),
    thumbPreview: json["thumb_preview"] == null ? null : ThumbPreview.fromMap(json["thumb_preview"]),
    referrer: json["referrer"],
    cookieDomain: json["cookie_domain"] == null ? null : json["cookie_domain"],
    timestamp: json["timestamp"] == null ? null : json["timestamp"],
    gcDebug: json["gc_debug"] == null ? null : GcDebug.fromMap(json["gc_debug"]),
    expires: json["expires"] == null ? null : json["expires"],
    client: json["client"] == null ? null : Client.fromMap(json["client"]),
    currency: json["currency"] == null ? null : json["currency"],
    session: json["session"] == null ? null : json["session"],
    cookie: json["cookie"] == null ? null : Cookie.fromMap(json["cookie"]),
    build: json["build"] == null ? null : Build.fromMap(json["build"]),
    urls: json["urls"] == null ? null : Urls.fromMap(json["urls"]),
    signature: json["signature"] == null ? null : json["signature"],
    flags: json["flags"] == null ? null : Flags.fromMap(json["flags"]),
    country: json["country"] == null ? null : json["country"],
    fileCodecs: json["file_codecs"] == null ? null : FileCodecs.fromMap(json["file_codecs"]),
    abTests: json["ab_tests"] == null ? null : AbTests.fromMap(json["ab_tests"]),
  );

  Map<String, dynamic> toMap() => {
    "files": files == null ? null : files!.toMap(),
    "lang": lang == null ? null : lang,
    "sentry": sentry == null ? null : sentry!.toMap(),
    "thumb_preview": thumbPreview == null ? null : thumbPreview!.toMap(),
    "referrer": referrer,
    "cookie_domain": cookieDomain == null ? null : cookieDomain,
    "timestamp": timestamp == null ? null : timestamp,
    "gc_debug": gcDebug == null ? null : gcDebug!.toMap(),
    "expires": expires == null ? null : expires,
    "client": client == null ? null : client!.toMap(),
    "currency": currency == null ? null : currency,
    "session": session == null ? null : session,
    "cookie": cookie == null ? null : cookie!.toMap(),
    "build": build == null ? null : build!.toMap(),
    "urls": urls == null ? null : urls!.toMap(),
    "signature": signature == null ? null : signature,
    "flags": flags == null ? null : flags!.toMap(),
    "country": country == null ? null : country,
    "file_codecs": fileCodecs == null ? null : fileCodecs!.toMap(),
    "ab_tests": abTests == null ? null : abTests!.toMap(),
  };
}

class AbTests {
  AbTests({
    this.chromecast,
    this.statsFresnel,
    this.llhlsTimeout,
    this.cmcd,
  });

  final Chromecast? chromecast;
  final Chromecast? statsFresnel;
  final Chromecast? llhlsTimeout;
  final Chromecast? cmcd;

  factory AbTests.fromMap(Map<String, dynamic> json) => AbTests(
    chromecast: json["chromecast"] == null ? null : Chromecast.fromMap(json["chromecast"]),
    statsFresnel: json["stats_fresnel"] == null ? null : Chromecast.fromMap(json["stats_fresnel"]),
    llhlsTimeout: json["llhls_timeout"] == null ? null : Chromecast.fromMap(json["llhls_timeout"]),
    cmcd: json["cmcd"] == null ? null : Chromecast.fromMap(json["cmcd"]),
  );

  Map<String, dynamic> toMap() => {
    "chromecast": chromecast == null ? null : chromecast!.toMap(),
    "stats_fresnel": statsFresnel == null ? null : statsFresnel!.toMap(),
    "llhls_timeout": llhlsTimeout == null ? null : llhlsTimeout!.toMap(),
    "cmcd": cmcd == null ? null : cmcd!.toMap(),
  };
}

class Chromecast {
  Chromecast({
    this.track,
    this.data,
    this.group,
  });

  final bool? track;
  final Data? data;
  final bool? group;

  factory Chromecast.fromMap(Map<String, dynamic> json) => Chromecast(
    track: json["track"] == null ? null : json["track"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
    group: json["group"] == null ? null : json["group"],
  );

  Map<String, dynamic> toMap() => {
    "track": track == null ? null : track,
    "data": data == null ? null : data!.toMap(),
    "group": group == null ? null : group,
  };
}

class Data {
  Data();

  factory Data.fromMap(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toMap() => {
  };
}

class Build {
  Build({
    this.backend,
    this.js,
  });

  final String? backend;
  final String? js;

  factory Build.fromMap(Map<String, dynamic> json) => Build(
    backend: json["backend"] == null ? null : json["backend"],
    js: json["js"] == null ? null : json["js"],
  );

  Map<String, dynamic> toMap() => {
    "backend": backend == null ? null : backend,
    "js": js == null ? null : js,
  };
}

class Client {
  Client({
    this.ip,
  });

  final String? ip;

  factory Client.fromMap(Map<String, dynamic> json) => Client(
    ip: json["ip"] == null ? null : json["ip"],
  );

  Map<String, dynamic> toMap() => {
    "ip": ip == null ? null : ip,
  };
}

class Cookie {
  Cookie({
    this.scaling,
    this.volume,
    this.quality,
    this.hd,
    this.captions,
  });

  final int? scaling;
  final double? volume;
  final dynamic quality;
  final int? hd;
  final dynamic captions;

  factory Cookie.fromMap(Map<String, dynamic> json) => Cookie(
    scaling: json["scaling"] == null ? null : json["scaling"],
    volume: json["volume"] == null ? null : double.parse(json["volume"].toString()),
    quality: json["quality"],
    hd: json["hd"] == null ? null : json["hd"],
    captions: json["captions"],
  );

  Map<String, dynamic> toMap() => {
    "scaling": scaling == null ? null : scaling,
    "volume": volume == null ? null : volume,
    "quality": quality,
    "hd": hd == null ? null : hd,
    "captions": captions,
  };
}

class FileCodecs {
  FileCodecs({
    this.hevc,
    this.av1,
    this.avc,
  });

  final Hevc? hevc;
  final List<dynamic>? av1;
  final List<String>? avc;

  factory FileCodecs.fromMap(Map<String, dynamic> json) => FileCodecs(
    hevc: json["hevc"] == null ? null : Hevc.fromMap(json["hevc"]),
    av1: json["av1"] == null ? null : List<dynamic>.from(json["av1"].map((x) => x)),
    avc: json["avc"] == null ? null : List<String>.from(json["avc"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "hevc": hevc == null ? null : hevc!.toMap(),
    "av1": av1 == null ? null : List<dynamic>.from(av1!.map((x) => x)),
    "avc": avc == null ? null : List<dynamic>.from(avc!.map((x) => x)),
  };
}

class Hevc {
  Hevc({
    this.hdr,
    this.sdr,
    this.dvh1,
  });

  final List<dynamic>? hdr;
  final List<dynamic>? sdr;
  final List<dynamic>? dvh1;

  factory Hevc.fromMap(Map<String, dynamic> json) => Hevc(
    hdr: json["hdr"] == null ? null : List<dynamic>.from(json["hdr"].map((x) => x)),
    sdr: json["sdr"] == null ? null : List<dynamic>.from(json["sdr"].map((x) => x)),
    dvh1: json["dvh1"] == null ? null : List<dynamic>.from(json["dvh1"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "hdr": hdr == null ? null : List<dynamic>.from(hdr!.map((x) => x)),
    "sdr": sdr == null ? null : List<dynamic>.from(sdr!.map((x) => x)),
    "dvh1": dvh1 == null ? null : List<dynamic>.from(dvh1!.map((x) => x)),
  };
}

class Files {
  Files({
    this.dash,
    this.hls,
    this.progressive,
  });

  final Dash? dash;
  final Hls? hls;
  final List<Progressive>? progressive;

  factory Files.fromMap(Map<String, dynamic> json) => Files(
    dash: json["dash"] == null ? null : Dash.fromMap(json["dash"]),
    hls: json["hls"] == null ? null : Hls.fromMap(json["hls"]),
    progressive: json["progressive"] == null ? null : List<Progressive>.from(json["progressive"].map((x) => Progressive.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "dash": dash == null ? null : dash!.toMap(),
    "hls": hls == null ? null : hls!.toMap(),
    "progressive": progressive == null ? null : List<dynamic>.from(progressive!.map((x) => x.toMap())),
  };
}

class Dash {
  Dash({
    this.separateAv,
    this.streams,
    this.cdns,
    this.streamsAvc,
    this.defaultCdn,
  });

  final bool? separateAv;
  final List<Stream>? streams;
  final Cdns? cdns;
  final List<Stream>? streamsAvc;
  final String? defaultCdn;

  factory Dash.fromMap(Map<String, dynamic> json) => Dash(
    separateAv: json["separate_av"] == null ? null : json["separate_av"],
    streams: json["streams"] == null ? null : List<Stream>.from(json["streams"].map((x) => Stream.fromMap(x))),
    cdns: json["cdns"] == null ? null : Cdns.fromMap(json["cdns"]),
    streamsAvc: json["streams_avc"] == null ? null : List<Stream>.from(json["streams_avc"].map((x) => Stream.fromMap(x))),
    defaultCdn: json["default_cdn"] == null ? null : json["default_cdn"],
  );

  Map<String, dynamic> toMap() => {
    "separate_av": separateAv == null ? null : separateAv,
    "streams": streams == null ? null : List<dynamic>.from(streams!.map((x) => x.toMap())),
    "cdns": cdns == null ? null : cdns!.toMap(),
    "streams_avc": streamsAvc == null ? null : List<dynamic>.from(streamsAvc!.map((x) => x.toMap())),
    "default_cdn": defaultCdn == null ? null : defaultCdn,
  };
}

class Cdns {
  Cdns({
    this.akfireInterconnectQuic,
    this.fastlySkyfire,
  });

  final AkfireInterconnectQuic? akfireInterconnectQuic;
  final AkfireInterconnectQuic? fastlySkyfire;

  factory Cdns.fromMap(Map<String, dynamic> json) => Cdns(
    akfireInterconnectQuic: json["akfire_interconnect_quic"] == null ? null : AkfireInterconnectQuic.fromMap(json["akfire_interconnect_quic"]),
    fastlySkyfire: json["fastly_skyfire"] == null ? null : AkfireInterconnectQuic.fromMap(json["fastly_skyfire"]),
  );

  Map<String, dynamic> toMap() => {
    "akfire_interconnect_quic": akfireInterconnectQuic == null ? null : akfireInterconnectQuic!.toMap(),
    "fastly_skyfire": fastlySkyfire == null ? null : fastlySkyfire!.toMap(),
  };
}

class AkfireInterconnectQuic {
  AkfireInterconnectQuic({
    this.url,
    this.origin,
    this.avcUrl,
  });

  final String? url;
  final String? origin;
  final String? avcUrl;

  factory AkfireInterconnectQuic.fromMap(Map<String, dynamic> json) => AkfireInterconnectQuic(
    url: json["url"] == null ? null : json["url"],
    origin: json["origin"] == null ? null : json["origin"],
    avcUrl: json["avc_url"] == null ? null : json["avc_url"],
  );

  Map<String, dynamic> toMap() => {
    "url": url == null ? null : url,
    "origin": origin == null ? null : origin,
    "avc_url": avcUrl == null ? null : avcUrl,
  };
}

class Stream {
  Stream({
    this.profile,
    this.quality,
    this.id,
    this.fps,
  });

  final dynamic profile;
  final String? quality;
  final String? id;
  final int? fps;

  factory Stream.fromMap(Map<String, dynamic> json) => Stream(
    profile: json["account"],
    quality: json["quality"] == null ? null : json["quality"],
    id: json["id"] == null ? null : json["id"],
    fps: json["fps"] == null ? null : json["fps"],
  );

  Map<String, dynamic> toMap() => {
    "account": profile,
    "quality": quality == null ? null : quality,
    "id": id == null ? null : id,
    "fps": fps == null ? null : fps,
  };
}

class Hls {
  Hls({
    this.separateAv,
    this.defaultCdn,
    this.cdns,
  });

  final bool? separateAv;
  final String? defaultCdn;
  final Cdns? cdns;

  factory Hls.fromMap(Map<String, dynamic> json) => Hls(
    separateAv: json["separate_av"] == null ? null : json["separate_av"],
    defaultCdn: json["default_cdn"] == null ? null : json["default_cdn"],
    cdns: json["cdns"] == null ? null : Cdns.fromMap(json["cdns"]),
  );

  Map<String, dynamic> toMap() => {
    "separate_av": separateAv == null ? null : separateAv,
    "default_cdn": defaultCdn == null ? null : defaultCdn,
    "cdns": cdns == null ? null : cdns!.toMap(),
  };
}

class Progressive {
  Progressive({
    this.profile,
    this.width,
    this.mime,
    this.fps,
    this.url,
    this.cdn,
    this.quality,
    this.id,
    this.origin,
    this.height,
  });

  final String? profile;
  final int? width;
  final String? mime;
  final int? fps;
  final String? url;
  final String? cdn;
  final String? quality;
  final String? id;
  final String? origin;
  final int? height;

  factory Progressive.fromMap(Map<String, dynamic> json) => Progressive(
    profile: json["account"] == null ? null : json["account"],
    width: json["width"] == null ? null : json["width"],
    mime: json["mime"] == null ? null : json["mime"],
    fps: json["fps"] == null ? null : json["fps"],
    url: json["url"] == null ? null : json["url"],
    cdn: json["cdn"] == null ? null : json["cdn"],
    quality: json["quality"] == null ? null : json["quality"],
    id: json["id"] == null ? null : json["id"],
    origin: json["origin"] == null ? null : json["origin"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toMap() => {
    "account": profile == null ? null : profile,
    "width": width == null ? null : width,
    "mime": mime == null ? null : mime,
    "fps": fps == null ? null : fps,
    "url": url == null ? null : url,
    "cdn": cdn == null ? null : cdn,
    "quality": quality == null ? null : quality,
    "id": id == null ? null : id,
    "origin": origin == null ? null : origin,
    "height": height == null ? null : height,
  };
}

class Flags {
  Flags({
    this.dnt,
    this.preloadVideo,
    this.plays,
    this.partials,
    this.autohideControls,
  });

  final int? dnt;
  final String? preloadVideo;
  final int? plays;
  final int? partials;
  final int? autohideControls;

  factory Flags.fromMap(Map<String, dynamic> json) => Flags(
    dnt: json["dnt"] == null ? null : json["dnt"],
    preloadVideo: json["preload_video"] == null ? null : json["preload_video"],
    plays: json["plays"] == null ? null : json["plays"],
    partials: json["partials"] == null ? null : json["partials"],
    autohideControls: json["autohide_controls"] == null ? null : json["autohide_controls"],
  );

  Map<String, dynamic> toMap() => {
    "dnt": dnt == null ? null : dnt,
    "preload_video": preloadVideo == null ? null : preloadVideo,
    "plays": plays == null ? null : plays,
    "partials": partials == null ? null : partials,
    "autohide_controls": autohideControls == null ? null : autohideControls,
  };
}

class GcDebug {
  GcDebug({
    this.bucket,
  });

  final String? bucket;

  factory GcDebug.fromMap(Map<String, dynamic> json) => GcDebug(
    bucket: json["bucket"] == null ? null : json["bucket"],
  );

  Map<String, dynamic> toMap() => {
    "bucket": bucket == null ? null : bucket,
  };
}

class Sentry {
  Sentry({
    this.url,
    this.enabled,
    this.debugEnabled,
    this.debugIntent,
  });

  final String? url;
  final bool? enabled;
  final bool? debugEnabled;
  final int? debugIntent;

  factory Sentry.fromMap(Map<String, dynamic> json) => Sentry(
    url: json["url"] == null ? null : json["url"],
    enabled: json["enabled"] == null ? null : json["enabled"],
    debugEnabled: json["debug_enabled"] == null ? null : json["debug_enabled"],
    debugIntent: json["debug_intent"] == null ? null : json["debug_intent"],
  );

  Map<String, dynamic> toMap() => {
    "url": url == null ? null : url,
    "enabled": enabled == null ? null : enabled,
    "debug_enabled": debugEnabled == null ? null : debugEnabled,
    "debug_intent": debugIntent == null ? null : debugIntent,
  };
}

class ThumbPreview {
  ThumbPreview({
    this.url,
    this.frameWidth,
    this.height,
    this.width,
    this.frameHeight,
    this.frames,
    this.columns,
  });

  final String? url;
  final int? frameWidth;
  final double? height;
  final int? width;
  final double? frameHeight;
  final int? frames;
  final int? columns;

  factory ThumbPreview.fromMap(Map<String, dynamic> json) => ThumbPreview(
    url: json["url"] == null ? null : json["url"],
    frameWidth: json["frame_width"] == null ? null : json["frame_width"],
    height: json["height"] == null ? null : double.parse(json["height"].toString()),
    width: json["width"] == null ? null : json["width"],
    frameHeight: json["frame_height"] == null ? null : double.parse(json["frame_height"].toString()),
    frames: json["frames"] == null ? null : json["frames"],
    columns: json["columns"] == null ? null : json["columns"],
  );

  Map<String, dynamic> toMap() => {
    "url": url == null ? null : url,
    "frame_width": frameWidth == null ? null : frameWidth,
    "height": height == null ? null : height,
    "width": width == null ? null : width,
    "frame_height": frameHeight == null ? null : frameHeight,
    "frames": frames == null ? null : frames,
    "columns": columns == null ? null : columns,
  };
}

class Urls {
  Urls({
    this.bareboneJs,
    this.testImp,
    this.jsBase,
    this.fresnel,
    this.js,
    this.proxy,
    this.muxUrl,
    this.fresnelMimirInputsUrl,
    this.fresnelChunkUrl,
    this.threeJs,
    this.vuidJs,
    this.fresnelManifestUrl,
    this.chromelessCss,
    this.playerTelemetryUrl,
    this.chromelessJs,
    this.css,
  });

  final String? bareboneJs;
  final String? testImp;
  final String? jsBase;
  final String? fresnel;
  final String? js;
  final String? proxy;
  final String? muxUrl;
  final String? fresnelMimirInputsUrl;
  final String? fresnelChunkUrl;
  final String? threeJs;
  final String? vuidJs;
  final String? fresnelManifestUrl;
  final String? chromelessCss;
  final String? playerTelemetryUrl;
  final String? chromelessJs;
  final String? css;

  factory Urls.fromMap(Map<String, dynamic> json) => Urls(
    bareboneJs: json["barebone_js"] == null ? null : json["barebone_js"],
    testImp: json["test_imp"] == null ? null : json["test_imp"],
    jsBase: json["js_base"] == null ? null : json["js_base"],
    fresnel: json["fresnel"] == null ? null : json["fresnel"],
    js: json["js"] == null ? null : json["js"],
    proxy: json["proxy"] == null ? null : json["proxy"],
    muxUrl: json["mux_url"] == null ? null : json["mux_url"],
    fresnelMimirInputsUrl: json["fresnel_mimir_inputs_url"] == null ? null : json["fresnel_mimir_inputs_url"],
    fresnelChunkUrl: json["fresnel_chunk_url"] == null ? null : json["fresnel_chunk_url"],
    threeJs: json["three_js"] == null ? null : json["three_js"],
    vuidJs: json["vuid_js"] == null ? null : json["vuid_js"],
    fresnelManifestUrl: json["fresnel_manifest_url"] == null ? null : json["fresnel_manifest_url"],
    chromelessCss: json["chromeless_css"] == null ? null : json["chromeless_css"],
    playerTelemetryUrl: json["player_telemetry_url"] == null ? null : json["player_telemetry_url"],
    chromelessJs: json["chromeless_js"] == null ? null : json["chromeless_js"],
    css: json["css"] == null ? null : json["css"],
  );

  Map<String, dynamic> toMap() => {
    "barebone_js": bareboneJs == null ? null : bareboneJs,
    "test_imp": testImp == null ? null : testImp,
    "js_base": jsBase == null ? null : jsBase,
    "fresnel": fresnel == null ? null : fresnel,
    "js": js == null ? null : js,
    "proxy": proxy == null ? null : proxy,
    "mux_url": muxUrl == null ? null : muxUrl,
    "fresnel_mimir_inputs_url": fresnelMimirInputsUrl == null ? null : fresnelMimirInputsUrl,
    "fresnel_chunk_url": fresnelChunkUrl == null ? null : fresnelChunkUrl,
    "three_js": threeJs == null ? null : threeJs,
    "vuid_js": vuidJs == null ? null : vuidJs,
    "fresnel_manifest_url": fresnelManifestUrl == null ? null : fresnelManifestUrl,
    "chromeless_css": chromelessCss == null ? null : chromelessCss,
    "player_telemetry_url": playerTelemetryUrl == null ? null : playerTelemetryUrl,
    "chromeless_js": chromelessJs == null ? null : chromelessJs,
    "css": css == null ? null : css,
  };
}

class User {
  User({
    this.teamOriginUserId,
    this.liked,
    this.accountType,
    this.vimeoApiClientToken,
    this.vimeoApiInteractionTokens,
    this.teamId,
    this.watchLater,
    this.owner,
    this.id,
    this.mod,
    this.privateModeEnabled,
    this.loggedIn,
  });

  final int? teamOriginUserId;
  final int? liked;
  final String? accountType;
  final dynamic vimeoApiClientToken;
  final dynamic vimeoApiInteractionTokens;
  final int? teamId;
  final int? watchLater;
  final int? owner;
  final int? id;
  final int? mod;
  final int? privateModeEnabled;
  final int? loggedIn;

  factory User.fromMap(Map<String, dynamic> json) => User(
    teamOriginUserId: json["team_origin_user_id"] == null ? null : json["team_origin_user_id"],
    liked: json["liked"] == null ? null : json["liked"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    vimeoApiClientToken: json["vimeo_api_client_token"],
    vimeoApiInteractionTokens: json["vimeo_api_interaction_tokens"],
    teamId: json["team_id"] == null ? null : json["team_id"],
    watchLater: json["watch_later"] == null ? null : json["watch_later"],
    owner: json["owner"] == null ? null : json["owner"],
    id: json["id"] == null ? null : json["id"],
    mod: json["mod"] == null ? null : json["mod"],
    privateModeEnabled: json["private_mode_enabled"] == null ? null : json["private_mode_enabled"],
    loggedIn: json["logged_in"] == null ? null : json["logged_in"],
  );

  Map<String, dynamic> toMap() => {
    "team_origin_user_id": teamOriginUserId == null ? null : teamOriginUserId,
    "liked": liked == null ? null : liked,
    "account_type": accountType == null ? null : accountType,
    "vimeo_api_client_token": vimeoApiClientToken,
    "vimeo_api_interaction_tokens": vimeoApiInteractionTokens,
    "team_id": teamId == null ? null : teamId,
    "watch_later": watchLater == null ? null : watchLater,
    "owner": owner == null ? null : owner,
    "id": id == null ? null : id,
    "mod": mod == null ? null : mod,
    "private_mode_enabled": privateModeEnabled == null ? null : privateModeEnabled,
    "logged_in": loggedIn == null ? null : loggedIn,
  };
}

class Video {
  Video({
    this.version,
    this.height,
    this.duration,
    this.thumbs,
    this.owner,
    this.id,
    this.embedCode,
    this.title,
    this.shareUrl,
    this.width,
    this.embedPermission,
    this.fps,
    this.spatial,
    this.liveEvent,
    this.allowHd,
    this.hd,
    this.lang,
    this.defaultToHd,
    this.url,
    this.privacy,
    this.bypassToken,
    this.unlistedHash,
  });

  final Version? version;
  final int? height;
  final int? duration;
  final Thumbs? thumbs;
  final Owner? owner;
  final int? id;
  final String? embedCode;
  final String? title;
  final String? shareUrl;
  final int? width;
  final String? embedPermission;
  final double? fps;
  final int? spatial;
  final dynamic liveEvent;
  final int? allowHd;
  final int? hd;
  final dynamic lang;
  final int? defaultToHd;
  final String? url;
  final String? privacy;
  final String? bypassToken;
  final dynamic unlistedHash;

  factory Video.fromMap(Map<String, dynamic> json) => Video(
    version: json["version"] == null ? null : Version.fromMap(json["version"]),
    height: json["height"] == null ? null : json["height"],
    duration: json["duration"] == null ? null : json["duration"],
    thumbs: json["thumbs"] == null ? null : Thumbs.fromMap(json["thumbs"]),
    owner: json["owner"] == null ? null : Owner.fromMap(json["owner"]),
    id: json["id"] == null ? null : json["id"],
    embedCode: json["embed_code"] == null ? null : json["embed_code"],
    title: json["title"] == null ? null : json["title"],
    shareUrl: json["share_url"] == null ? null : json["share_url"],
    width: json["width"] == null ? null : json["width"],
    embedPermission: json["embed_permission"] == null ? null : json["embed_permission"],
    fps: json["fps"] == null ? null : double.parse(json["fps"].toString()),
    spatial: json["spatial"] == null ? null : json["spatial"],
    liveEvent: json["live_event"],
    allowHd: json["allow_hd"] == null ? null : json["allow_hd"],
    hd: json["hd"] == null ? null : json["hd"],
    lang: json["lang"],
    defaultToHd: json["default_to_hd"] == null ? null : json["default_to_hd"],
    url: json["url"] == null ? null : json["url"],
    privacy: json["privacy"] == null ? null : json["privacy"],
    bypassToken: json["bypass_token"] == null ? null : json["bypass_token"],
    unlistedHash: json["unlisted_hash"],
  );

  Map<String, dynamic> toMap() => {
    "version": version == null ? null : version!.toMap(),
    "height": height == null ? null : height,
    "duration": duration == null ? null : duration,
    "thumbs": thumbs == null ? null : thumbs!.toMap(),
    "owner": owner == null ? null : owner!.toMap(),
    "id": id == null ? null : id,
    "embed_code": embedCode == null ? null : embedCode,
    "title": title == null ? null : title,
    "share_url": shareUrl == null ? null : shareUrl,
    "width": width == null ? null : width,
    "embed_permission": embedPermission == null ? null : embedPermission,
    "fps": fps == null ? null : fps,
    "spatial": spatial == null ? null : spatial,
    "live_event": liveEvent,
    "allow_hd": allowHd == null ? null : allowHd,
    "hd": hd == null ? null : hd,
    "lang": lang,
    "default_to_hd": defaultToHd == null ? null : defaultToHd,
    "url": url == null ? null : url,
    "privacy": privacy == null ? null : privacy,
    "bypass_token": bypassToken == null ? null : bypassToken,
    "unlisted_hash": unlistedHash,
  };
}

class Owner {
  Owner({
    this.accountType,
    this.name,
    this.img,
    this.url,
    this.img2X,
    this.id,
  });

  final String? accountType;
  final String? name;
  final String? img;
  final String? url;
  final String? img2X;
  final int? id;

  factory Owner.fromMap(Map<String, dynamic> json) => Owner(
    accountType: json["account_type"] == null ? null : json["account_type"],
    name: json["name"] == null ? null : json["name"],
    img: json["img"] == null ? null : json["img"],
    url: json["url"] == null ? null : json["url"],
    img2X: json["img_2x"] == null ? null : json["img_2x"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toMap() => {
    "account_type": accountType == null ? null : accountType,
    "name": name == null ? null : name,
    "img": img == null ? null : img,
    "url": url == null ? null : url,
    "img_2x": img2X == null ? null : img2X,
    "id": id == null ? null : id,
  };
}

class Thumbs {
  Thumbs({
    this.the640,
    this.the960,
    this.the1280,
    this.base,
  });

  final String? the640;
  final String? the960;
  final String? the1280;
  final String? base;

  factory Thumbs.fromMap(Map<String, dynamic> json) => Thumbs(
    the640: json["640"] == null ? null : json["640"],
    the960: json["960"] == null ? null : json["960"],
    the1280: json["1280"] == null ? null : json["1280"],
    base: json["base"] == null ? null : json["base"],
  );

  Map<String, dynamic> toMap() => {
    "640": the640 == null ? null : the640,
    "960": the960 == null ? null : the960,
    "1280": the1280 == null ? null : the1280,
    "base": base == null ? null : base,
  };
}

class Version {
  Version({
    this.current,
    this.available,
  });

  final dynamic current;
  final dynamic available;

  factory Version.fromMap(Map<String, dynamic> json) => Version(
    current: json["current"],
    available: json["available"],
  );

  Map<String, dynamic> toMap() => {
    "current": current,
    "available": available,
  };
}
