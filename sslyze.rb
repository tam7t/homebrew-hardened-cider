require 'formula'

class Sslyze < Formula
  homepage 'https://github.com/nabla-c0d3/sslyze'
  url 'https://github.com/nabla-c0d3/sslyze/archive/c49f96813200701782e2e602f3792b778417d845.tar.gz'
  sha256 '21f9f5e6c01f3c871b56b74eb8b8651d063c354f8425b37d67402a9c2755f43b'
  version '0.11.0'

  depends_on :arch => :x86_64
  depends_on :python

  conflicts_with 'openssl', :because => 'nassl builds against its own openssl'

  resource 'nassl' do
    url 'https://github.com/nabla-c0d3/nassl/archive/9a5f0f1ad5bc1b12c8d69acbc4e1c0d975e41a19.tar.gz'
    sha256 'f363fe170e57343c2a5ac93a3eefdf6bd96268442dd4cdffe1027abf995eb974'
  end

  resource 'openssl' do
    url 'https://www.openssl.org/source/old/1.0.1/openssl-1.0.1i.tar.gz'
    sha256 '3c179f46ca77069a6a0bac70212a9b3b838b2f66129cb52d568837fc79d8fcc7'
  end

  resource 'zlib' do
    url 'http://zlib.net/zlib-1.2.8.tar.gz'
    sha256 '36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d'
  end

  def shim_script
    <<-EOS.undent
        #!/bin/sh
        python #{prefix}/sslyze.py "$@"
      EOS
  end

  def install
    ENV.deparallelize
    resource('nassl').stage do
      nasslpath = Pathname.new(Dir.pwd)

      resource('openssl').stage do
        (nasslpath/'openssl-1.0.1i').install Dir["*"]
      end

      resource('zlib').stage do
        (nasslpath/'zlib-1.2.8').install Dir["*"]
      end

      system 'python', 'buildAll_unix.py'
      prefix.install 'test/nassl'
    end

    prefix.install Dir['*']
    (bin + 'sslyze').write shim_script
  end

  test do
    system "#{bin}/sslyze", '--version'
  end
end