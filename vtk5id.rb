require 'formula'

class Vtk5id < Formula
  homepage 'http://www.vtk.org'
  url 'http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz'  # update libdir below, too!
  sha1 'deb834f46b3f7fc3e122ddff45e2354d69d2adc3'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on :python
  depends_on 'sip'
  depends_on 'pyqt'
  conflicts_with 'vtk' if Formula.installed.join(" ").include? "vtk"
  #conflicts_with 'vtk5' if Formula.installed.join(" ").include? "vtk5"
  
  def patches
    DATA
  end

  def install
    libdir = if build.head? then lib; else "#{lib}/vtk-5.10"; end

    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_CARBON=OFF
      -DVTK_USE_TK=OFF
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DIOKit:FILEPATH=#{MacOS.sdk_path}/System/Library/Frameworks/IOKit.framework
      -DCMAKE_INSTALL_RPATH:STRING=#{libdir}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{libdir}
    ]

    args << '-DBUILD_EXAMPLES=ON'

    if build.with? 'qt' or build.include? 'qt-extern'
      args << '-DVTK_USE_GUISUPPORT=ON'
      args << '-DVTK_USE_QT=ON'
      args << '-DVTK_USE_QVTK=ON'
    end

    args << '-DVTK_WRAP_TCL=ON'
    args << '-DVTK_USE_COCOA=ON'

    unless MacOS::CLT.installed?
      args << "-DTK_INCLUDE_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers"
      args << "-DTK_INTERNAL_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers/tk-private"
    end

    mkdir 'build' do
      args << '-DVTK_WRAP_PYTHON=ON'
      args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      args << "-DVTK_PYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
      args << '-DVTK_WRAP_PYTHON_SIP=ON'
      args << "-DSIP_PYQT_DIR='#{HOMEBREW_PREFIX}/share/sip'"
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    (share+'vtk').install 'Examples'
  end

  def caveats
    s = ''
    s += <<-EOS.undent
        Even without the --with-qt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Read more:
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

    EOS

    if build.include? 'examples'
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    return s.empty? ? nil : s
  end

end

__END__
diff --git a/Wrapping/Python/setup_install_paths.py b/Wrapping/Python/setup_install_paths.py
index 00f48c8..014b906 100755
--- a/Wrapping/Python/setup_install_paths.py
+++ b/Wrapping/Python/setup_install_paths.py
@@ -35,7 +35,7 @@ def get_install_path(command, *args):
                 option, value = string.split(arg,"=")
                 options[option] = value
             except ValueError:
-                options[option] = 1
+                options[arg] = 1

     # check for the prefix and exec_prefix
     try:

diff --git a/Utilities/vtktiff/tif_config.h.in b/Utilities/vtktiff/tif_config.h.in
index eca77f8..0273231 100644
--- a/Utilities/vtktiff/tif_config.h.in
+++ b/Utilities/vtktiff/tif_config.h.in
@@ -238,11 +238,12 @@ the sizes can be different.*/
 /* Define to empty if `const' does not conform to ANSI C. */
 #cmakedefine const

-/* Define to `__inline__' or `__inline' if that's what the C compiler
-   calls it, or to nothing if 'inline' is not supported under any name.  */
+/* MSVC does not support C99 inline, so just make the inline keyword
+   disappear for C.  */
 #ifndef __cplusplus
-#define inline
-//#cmakedefine inline
+#  ifdef _MSC_VER
+#    define inline
+#  endif
 #endif

 /* Define to `long' if <sys/types.h> does not define. */
