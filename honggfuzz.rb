class Honggfuzz < Formula
  desc "General purpose fuzzer"
  homepage "http://google.github.io/honggfuzz/"
  url "https://github.com/google/honggfuzz/archive/master.tar.gz"
  sha256 "c056d606f33604e61769a67e32596d54bb9af3f1ef512217af78e461fd8528e0"
  version "0.5.head"

  patch :DATA

  def install
    system "make"
    bin.install "honggfuzz"
  end

  test do
    system "false"
  end
end

__END__
diff --git a/Makefile b/Makefile
index ae8d83a..1b5713e 100644
--- a/Makefile
+++ b/Makefile
@@ -83,7 +83,7 @@ endif
 	    -x objective-c \
 		-D_GNU_SOURCE \
 		-pedantic \
-		-Wall -Werror -Wimplicit -Wunused -Wcomment -Wchar-subscripts -Wuninitialized \
+		-Wall -Wimplicit -Wunused -Wcomment -Wchar-subscripts -Wuninitialized \
 		-Wreturn-type -Wpointer-arith -Wno-gnu-case-range -Wno-gnu-designator \
 		-Wno-deprecated-declarations -Wno-unknown-pragmas -Wno-attributes
 	LD = $(shell xcrun --sdk $(SDK_NAME) --find cc)

