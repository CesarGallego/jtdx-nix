{ lib, stdenv, fetchFromGitHub, asciidoc, asciidoctor, autoconf, automake, cmake,
  docbook_xsl, fftw, fftwFloat, gfortran, libtool, libusb1, qtbase,
  qtmultimedia, qtserialport, qttools, boost, texinfo, 
  wrapQtAppsHook, hamlib, callPackage }:
let
  jtdxHamlib = hamlib.overrideAttrs (oldAttrs:  {
    src = fetchFromGitHub {
      owner = "jtdx-project";
      repo = "jtdxhamlib";
      rev = "159";
      sha256 = "sha256-20nrI+XICdYGgsydFP7DM/zMMcOMBCHz8JZUM10IOmc=";
      };
    installPhase = ''
      make install-strip
    '';
    });
  pepito = callPackage jtdxHamlib {};
in
stdenv.mkDerivation rec {
  pname = "jtdx";
  version = "2.2.159";

  # This is a "superbuild" tarball containing both wsjtx and a hamlib fork
  src = fetchFromGitHub {
    owner = "jtdx-project";
    repo = "jtdx";
    rev = "159";
    sha256 = "sha256-5KlFBlzG3hKFFGO37c+VN+FvZKSnTQXvSorB+Grns8w=";
  };

  # Hamlib builds with autotools, wsjtx builds with cmake
  # Omitting pkg-config because it causes issues locating the built hamlib
  nativeBuildInputs = [
    asciidoc asciidoctor autoconf automake cmake docbook_xsl gfortran libtool
    qttools texinfo wrapQtAppsHook pepito
  ];
  buildInputs = [ fftw fftwFloat libusb1 qtbase qtmultimedia qtserialport boost ];

  # Remove Git dependency from superbuild since sources are included
  # patches = [ ./super.patch ];

  meta = with lib; {
    description = "waka waka";
    longDescription = ''
      Implements communication protocols or "modes" called FT4, FT8, JT4,
      JT9, JT65, QRA64, ISCAT, MSK144, and WSPR, as well as one called Echo for
      detecting and measuring your own radio signals reflected from the Moon.
      These modes were all designed for making reliable, confirmed ham radio
      contacts under extreme weak-signal conditions.
    '';
    homepage = "https://physics.princeton.edu/pulsar/k1jt/wsjtx.html";
    # Older licenses are for the statically-linked hamlib
    license = with licenses; [ gpl3Plus gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ lasandell numinit ];
  };
}
