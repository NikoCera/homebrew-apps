cask "snow-shot" do
  version :latest
  sha256 :no_check

  # 从 GitHub Releases 的“最新发布”里挑第一个 .dmg
  url do
    require "open-uri"
    require "json"

    api = "https://api.github.com/repos/mg-chao/snow-shot/releases/latest"
    json = URI.parse(api).open.read
    assets = JSON.parse(json)["assets"] || []
    dmg = assets.find { |a| a["name"].end_with?(".dmg") }
    dmg ? dmg["browser_download_url"] : "https://github.com/mg-chao/snow-shot/releases/latest"
  end

  name "Snow Shot"
  desc "简单优雅的截图/标注工具，支持 OCR/翻译/AI 对话等"
  homepage "https://github.com/mg-chao/snow-shot"

  auto_updates true

  app "Snow Shot.app"

  # 可选：卸载残留（暂不确定具体路径，先留空）
  # zap trash: [
  #   "~/Library/Preferences/xxx.plist",
  #   "~/Library/Application Support/Snow Shot",
  # ]
end