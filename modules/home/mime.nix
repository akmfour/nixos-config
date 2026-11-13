# Default applications (~/.config/mimeapps.list).
{ lib, ... }:
let
  browser = "brave-browser.desktop";
  video = "org.kde.haruna.desktop";
  editor = "com.system76.CosmicEdit.desktop";
  files = "com.system76.CosmicFiles.desktop";

  assign = app: types: lib.genAttrs types (_: app);
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      assign browser [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
        "application/pdf"
      ]
      // assign video [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/x-flv"
        "video/mpeg"
        "video/ogg"
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/x-wav"
        "audio/mp4"
      ]
      // assign editor [
        "text/plain"
        "text/markdown"
        "application/json"
        "application/x-shellscript"
      ]
      // assign files [ "inode/directory" ]
      // {
        # Registered by Claude Code at runtime; keep it once Home Manager owns the file.
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
  };
}
