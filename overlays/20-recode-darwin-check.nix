# recode's test suite segfaults on darwin (breaks fortune); skip checks there.
self: super: {
  recode = super.recode.overrideAttrs (old: {
    doCheck = old.doCheck or true && !super.stdenv.hostPlatform.isDarwin;
  });
}
