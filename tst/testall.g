LoadPackage("mapclass");
dir := DirectoriesPackageLibrary("mapclass", "tst");
TestDirectory(dir, rec(exitGAP := true));

FORCE_QUIT_GAP(1);
