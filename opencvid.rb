require 'formula'

class Opencvid < Formula
  homepage 'http://opencv.org/'
  url 'https://github.com/Itseez/opencv/archive/2.4.7.1.tar.gz'
  sha1 'b6b0dd72356822a482ca3a27a7a88145aca6f34c'


  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'numpy' => :python
  depends_on :python

  depends_on 'eigen'  
  depends_on 'libtiff'
  depends_on 'jasper' 
  depends_on 'tbb'    
  depends_on 'qt' 
  depends_on 'openni' 
  depends_on :libpng

  depends_on 'ffmpeg'

  conflicts_with 'opencv' if Formula.installed.join.include? "opencv"

  def patches
    DATA
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DWITH_CUDA=OFF
      -DBUILD_ZLIB=ON
      -DBUILD_TIFF=ON
      -DBUILD_PNG=ON
      -DBUILD_JPEG=ON
      -DBUILD_JASPER=ON
      -DBUILD_TESTS=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_EXAMPLES=ON
      -DWITH_FFMPEG=ON
      -DWITH_OPENCL=ON
      -DWITH_OPENNI=ON
      -DWITH_QT=ON
      -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
    ]

    args << '-DWITH_QT=ON' 
    args << '-DWITH_TBB=ON' 
    args << '-DWITH_OPENNI=ON' 
    args << '-DWITH_OPENCL=ON'
    args << '-DWITH_FFMPEG=ON'

    if ENV.compiler == :clang and !build.bottle?
      args << '-DENABLE_SSSE3=ON' if Hardware::CPU.ssse3?
      args << '-DENABLE_SSE41=ON' if Hardware::CPU.sse4?
      args << '-DENABLE_SSE42=ON' if Hardware::CPU.sse4_2?
      args << '-DENABLE_AVX=ON' if Hardware::CPU.avx?
    end

    mkdir 'macbuild' do
      system 'cmake', '..', *args
      system "make"
      system "make install"
      FileUtils.cp_r(Dir["#{buildpath}/macbuild/bin/*"],"#{prefix}/bin")      
    end
    
     
  end
end
__END__
diff --git a/cmake/OpenCVFindOpenNI.cmake b/cmake/OpenCVFindOpenNI.cmake
index 7541868..f1455e8 100644
--- a/cmake/OpenCVFindOpenNI.cmake
+++ b/cmake/OpenCVFindOpenNI.cmake
@@ -26,8 +26,8 @@ if(WIN32)
         find_library(OPENNI_LIBRARY "OpenNI64" PATHS $ENV{OPEN_NI_LIB64} DOC "OpenNI library")
     endif()
 elseif(UNIX OR APPLE)
-    find_file(OPENNI_INCLUDES "XnCppWrapper.h" PATHS "/usr/include/ni" "/usr/include/openni" DOC "OpenNI c++ interface header")
-    find_library(OPENNI_LIBRARY "OpenNI" PATHS "/usr/lib" DOC "OpenNI library")
+    find_file(OPENNI_INCLUDES "XnCppWrapper.h" PATHS "HOMEBREW_PREFIX/include/ni" "/usr/include/ni" "/usr/include/openni" DOC "OpenNI c++ interface header")
+    find_library(OPENNI_LIBRARY "OpenNI" PATHS "HOMEBREW_PREFIX/lib" "/usr/lib" DOC "OpenNI library")
 endif()

 if(OPENNI_LIBRARY AND OPENNI_INCLUDES)
