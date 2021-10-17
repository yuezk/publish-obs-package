# Publish OBS Package

GitHub action to publish the OBS ([Open Build Service](https://openbuildservice.org/)) packages.

## Inputs

### `api`

**Optional** The OBS API url. Default `https://api.opensuse.org`

### `project`

**Required** The OBS project name. E.g., `home:yuezk`

### `package`

**Required** The OBS package name. E.g., `globalprotect-openconnect`

### `username`

**Required** The OBS username.

### `password`

**Required** The OBS password.

### `files`

**Required** The OBS package files to be submitted.

Newline-separated glob patterns, which will be expanded by bash when copying the files to the package.

### `commit_message`

**Optional** Commit message to use when submitting the package. Default: `OBS release: git#${GITHUB_SHA}"`

## Example usage

```yml
name: Publish OBS package
uses: yuezk/publish-obs-package@main
with:
    project: yuezk
    package: globalprotect-openconnect
    username: yuezk
    password: ${{ secrets.OBS_PASSWORD }}
    files: ./artifacts/obs/*
```

## Real-world applications

- [GlobalProtect-openconnect](https://github.com/yuezk/GlobalProtect-openconnect): A GlobalProtect VPN client (GUI) for Linux based on OpenConnect and built with Qt5, supports SAML auth mode.

## LICENSE

[MIT](./LICENSE)
