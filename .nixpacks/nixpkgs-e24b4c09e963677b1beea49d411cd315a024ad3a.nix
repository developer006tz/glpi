{ pkgs ? import <nixpkgs> {} }:

let
  php = pkgs.php82;
  phpExtensions = pkgs.php82Extensions;
in
pkgs.buildEnv {
  name = "env";
  paths = with pkgs; [
    php
    nginx
    libmysqlclient
    phpPackages.composer
    nodejs_22
    npm-9_x
    python311Packages.supervisor
    imagemagick
    ffmpeg
    # PHP extensions (exclude nonexistent 'hash')
    phpExtensions.imagick
    phpExtensions.ldap
    phpExtensions.opcache
    phpExtensions.bz2
    phpExtensions.zip
    phpExtensions.pdo
    phpExtensions.pdo_mysql
  ];
}

