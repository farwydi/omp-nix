# omp-nix

Nix-пакет [oh-my-pi](https://github.com/can1357/oh-my-pi) (`omp`) — AI coding agent для терминала.

Ставит prebuilt Bun-standalone бинарь с GitHub releases. Бинарь не patchelf'ится
(JS-payload лежит после ELF), на Linux запускается через nix-загрузчик обёрткой.

- `package.nix` — деривейшн, версию и хэши читает из `sources.json`
- `update.sh` — перегенерирует `sources.json` (пин версии аргументом: `./update.sh 17.0.1`)
- `.github/workflows/update.yml` — ежедневный авто-апдейт (9:00 МСК) с проверкой сборки

Подключение в home-manager:

```nix
ompSrc = builtins.fetchTarball {
  url = "https://github.com/farwydi/omp-nix/archive/refs/heads/master.tar.gz";
};
omp = pkgs.callPackage "${ompSrc}/package.nix" { };
```
