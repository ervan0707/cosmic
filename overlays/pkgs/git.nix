{
  symlinkJoin,
  makeWrapper,
  writeShellScript,
  git,
}:

config:
symlinkJoin {
  name = "git-with-config";
  paths = [ git ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/git \
      --run "${writeShellScript "git-config" ''
        ${git}/bin/git config --file $HOME/.gitconfig.local user.email "$(cat ${config.sops.secrets.email.path})"
        ${git}/bin/git config --file $HOME/.gitconfig.local user.name "$(cat ${config.sops.secrets.username.path})"
      ''}"
  '';
}
