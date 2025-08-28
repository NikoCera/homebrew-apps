cask "snow-shot" do
  version :latest
  sha256 :no_check

  # 动态获取“最新发布”里的 .dmg 资源（优先匹配本机架构）
  url do
    require "open-uri"
    require "json"

    api = "https://api.github.com/repos/mg-chao/snow-shot/releases/latest"
    data = JSON.parse(URI(api).open.read)
    assets = data["assets"] || []

    arch_hint = if Hardware::CPU.arm?
      # 项目目前用 aarch64 命名 Apple Silicon
      "aarch64"
    else
      # 如果将来有 Intel 包，常见命名是 x64 / amd64
      "x64"
    end

    dmg = assets.find { |a| a["name"].end_with?(".dmg") && a["name"].include?(arch_hint) } ||
          assets.find { |a| a["name"].end_with?(".dmg") }

    raise "No DMG asset found in latest release" unless dmg
    dmg["browser_download_url"]
  end

  name "Snow Shot"
  desc "截图/标注、OCR、翻译、AI 对话工具"
  homepage "https://github.com/mg-chao/snow-shot"

  auto_updates true
  app "Snow Shot.app"

  # 只有 ARM 包时，可以启用这一行强制限制：
  # depends_on arch: :arm

  # 可选清理路径，按需补充
  # zap trash: [
  #   "~/Library/Preferences/com.mgchao.snow-shot.plist",
  #   "~/Library/Application Support/Snow Shot",
  #   "~/Library/Saved Application State/com.mgchao.snow-shot.savedState",
  # ]
end