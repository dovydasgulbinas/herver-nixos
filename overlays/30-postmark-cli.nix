# postmark-cli isn't in nixpkgs or Homebrew; build it from the upstream npm project.
self: super: {
  postmark-cli = super.buildNpmPackage rec {
    pname = "postmark-cli";
    version = "1.6.19";
    src = super.fetchFromGitHub {
      owner = "activecampaign";
      repo = "postmark-cli";
      rev = "ee9d750a82ad96848c93a97bdabb2a1b07477b00";
      hash = "sha256-+puCNgaTzjDG/Uo33x38S9yS49q2Fv95Cv28JCVIHPs=";
    };
    npmDepsHash = "sha256-Bd129MipMdv1TyF1dKqzrGBvXxr/35L7m5DZpp/CgzE=";
    meta = {
      description = "CLI tool for managing templates, sending emails, and fetching servers on Postmark";
      homepage = "https://github.com/activecampaign/postmark-cli";
      license = super.lib.licenses.mit;
      mainProgram = "postmark";
    };
  };
}
