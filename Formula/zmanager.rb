class Zmanager < Formula
  desc "Fast, safe archive utility for ZIP, 7z, TAR.ZST, and broad extraction"
  homepage "https://github.com/frankmanzhu/zmanager"
  license all_of: ["Apache-2.0", :cannot_represent]
  version "1.0.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/frankmanzhu/zmanager/releases/download/v1.0.0/zm-aarch64-apple-darwin.tar.gz"
      sha256 "25487039f6a77cfb84638d73d7fad331b3cbe916ff883aa7bbc1e96084cf3807"
    else
      url "https://github.com/frankmanzhu/zmanager/releases/download/v1.0.0/zm-x86_64-apple-darwin.tar.gz"
      sha256 "f4495e2ea754090ce87ad57c290bd43ea2c98b7ed8c297c02747580544449a14"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/frankmanzhu/zmanager/releases/download/v1.0.0/zm-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97f41cb96c9df117b2206fbe68447b8b42308e6bd145127220ea5ac3c83052c6"
    else
      url "https://github.com/frankmanzhu/zmanager/releases/download/v1.0.0/zm-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0705e0f22eeec80ce0acbcafa1c7509104362f476f67209169c91cdbb779a786"
    end
  end

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "acl"
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "openssl@3"
    depends_on "zlib"
  end

  def install
    bin.install "zm"
    man1.install "man/man1/zm.1"
    bash_completion.install "completions/zm.bash" => "zm"
    zsh_completion.install "completions/_zm" => "_zm"
    fish_completion.install "completions/zm.fish"
    doc.install "README.md", "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md"
  end

  test do
    assert_match "zm 1.0.0", shell_output("#{bin}/zm --version")

    (testpath/"payload.txt").write("hello from Homebrew\n")
    system bin/"zm", "create", "payload.zip", "payload.txt"
    system bin/"zm", "test", "payload.zip"
  end
end
