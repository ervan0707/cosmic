## Declarative dotfiles configuration using Nix Darwin and Home Manager **(Always WIP)**

### TLDR

This config exists because I was tired of:
- Opening a new laptop/machine and spending a whole day setting it up
- Having different versions of dotfiles scattered everywhere
- Forgetting what I installed or changed on my machine
- Trying to remember "what was that package again?"
- Making things work on one machine but break on another
- Having my work and personal setups drift apart

So I made this. It's basically my entire system written in Nix - one config that:
- Sets up everything the same way, every time
- Works on all my Macs (it's Darwin/macOS focused, but you can tweak it for other systems)
- Keeps my work and personal setups in sync, but separate when needed

## 📋 Features

- 🛠 Development environments for multiple languages
- 💻 Go, Python, Rust, Lua, PHP, Node.js, Nix
- 📝 Extensive Neovim configuration with LSP support (NixVim)
- 🐟 Fish shell with custom configuration
- 🔐 Secure secret management with sops-nix
- 📦 Reproducible package management
- 🖥️ Cross-machine configuration (work/personal)
- 🪟 macOS window management with Yabai and SKHD
- 🎨 Custom status bar with SketchyBar **WIP**

## 🚀 Project Structure

```
cosmic/
├── lib/                    # Helper functions
│   ├── default.nix        # Library entry point
│   └── utils.nix          # Utility functions
├── nix/                   # Core configuration
│   ├── darwin/            # Darwin-specific settings
│   │   ├── services/     # System services (yabai, skhd, etc.)
│   │   └── system.nix    # System configuration
│   ├── devShells/        # Development environments
│   ├── home-manager/     # Home Manager configuration
│   │   └── modules/      # Home Manager modules
├── nixvim/               # Neovim configuration
│   └── config/          # NixVim modules
├── overlays/            # Custom package overlays
│   └── pkgs/           # Custom packages
└── secrets/            # Encrypted secrets
```

## 🚀 Getting Started

### 1. Install Nix

This command installs the Nix package manager based on the [DeterminateSystem/nix-installer](https://github.com/DeterminateSystems/nix-installer), based on the explanation by the [Zero to Nix](https://zero-to-nix.com/), it gives better error messages, an installation plan (like Terraform), and other cool features that bring a better installation experience for you.

Just follow the step by step of the installation flow and everything will be fine.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

After installation, restart your terminal.

### 2. Enable Nix Flakes

Create or edit `~/.config/nix/nix.conf`:

```bash
experimental-features = nix-command flakes
```

### 3. Clone the Repository

```bash
git clone https://github.com/Ervan0707/cosmic.git
cd cosmic
```

### 4. Set Up Age Keys for Secret Management

#### Important Note ⚠️
When using SSH keys to generate age keys, only Ed25519 keys are supported. RSA or other key types are not compatible.

Generate a new age key (Option 1):
```bash
# Create directory for age keys
mkdir -p ~/.config/sops/age

# Generate new key
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
```

Generate from existing SSH key (Option 2 - Only for Ed25519):
```bash
# Ensure you're using an Ed25519 key
# Your SSH key should look like this when you cat it:
# -----BEGIN OPENSSH PRIVATE KEY-----
# ... (key contents)
# -----END OPENSSH PRIVATE KEY-----
# The public key should start with 'ssh-ed25519'

# Convert Ed25519 SSH key to age key
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

# If you don't have an Ed25519 key, create one:
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Get the public key for .sops.yaml:
```bash
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

The output will look something like:
```
age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Update `.sops.yaml` with your public key:
```yaml
keys:
  - &personal age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # your public key here
```

Test your setup:
```bash
# Try to view encrypted secrets (Note: You won't be able to decrypt existing secrets)
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d secrets/personal.yaml

# Create new encrypted secrets with your key
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/personal.yaml
```

The existing encrypted secrets in this repository are encrypted with a different key, so you'll need to create your own encrypted secrets. The default template includes:

```yaml
github_token: "your-github-token"
codestats_api_key: "your-codestats-api-key"
email: "your-email"
username: "your-username"
```

After saving, your secrets will be encrypted with your key and can be safely committed to the repository.

Remember to create both `personal.yaml` and `work.yaml` if you're using both configurations.

### 5. Configure Your Environment

Edit the following files according to your needs:
- `lib/utils.nix`: Update system configurations
- `secrets/personal.yaml`: Personal secrets
- `secrets/work.yaml`: Work-related secrets

### 6. Deploy Configuration

#### Option A: Full System Configuration (recommended for macOS)

This includes both nix-darwin (system configuration) and home-manager:
```bash
# For work setup
nix build .#darwinConfigurations.work.system
./result/sw/bin/darwin-rebuild switch --flake .#work

# For personal setup
nix build .#darwinConfigurations.personal.system
./result/sw/bin/darwin-rebuild switch --flake .#personal
```

> **Why `./result/sw/bin/...`?** On a brand-new machine `darwin-rebuild` isn't
> on your `PATH` yet, so you build it first and call it out of `./result`. This
> is a **one-time bootstrap step**. After the first switch, `darwin-rebuild` is
> installed system-wide and you should use the `rebuild` helper below instead.

After the initial build, **never type the long command again** — use the shell
helpers (see [Daily Workflow](#-daily-workflow)):

```bash
rebuild         # build & switch the right profile, from the published config
rebuild-local   # same, but from your local working copy (for testing edits)
```

#### Option B: Home Manager Only (for non-system configuration)

If you only want to manage user-level configuration without system modifications:
```bash
# For work setup
nix build .#homeConfigurations.work.activationPackage
./result/activate

# For personal setup
nix build .#homeConfigurations.personal.activationPackage
./result/activate
```

**Note:** Using nix-darwin (Option A) is recommended for macOS as it provides:
- System-level configuration (keyboard, dock, etc.)
- Window management with Yabai
- Custom status bar with SketchyBar
- Keyboard shortcuts with SKHD
- Touch ID integration
- System-wide package management

Choose Option B if you:
- Only need user-level configuration
- Are using a non-macOS system
- Don't want to modify system settings
- Need a more portable configuration

## 🔁 Daily Workflow

The whole point of this setup: **CI builds, machines pull.** You edit config on
one machine, push, and every machine syncs by pulling prebuilt binaries from the
cache — no local compilation.

```
edit config → git push → GitHub Actions builds work + personal → pushes to skinnyvans cache
                                                                         │
                              any machine:  rebuild  ◀── pulls binaries ─┘
```

### The two helper commands

Both are defined declaratively in `nix/home-manager/modules/fish.nix` and
auto-select the profile from `$USER` (`ss` → work, `ervan` → personal), so the
**same command works on every machine**:

| Command | Builds from | When to use |
|---|---|---|
| `rebuild` | `github:Ervan0707/cosmic` (the published config) | Normal sync — consume changes on any machine. No local clone needed. |
| `rebuild-local` | `.#<profile>` (current directory) | While editing config — test uncommitted changes before pushing. Run from inside your clone. |

### Typical loop

```bash
# On the machine where you make changes:
#   ...edit files...
rebuild-local          # test the change locally
git add -A && git commit -m "..." && git push   # publish → CI warms the cache

# On every other machine (after CI's green check):
rebuild                # pulls flake from GitHub + binaries from cachix, then switches
```

> **Notes**
> - `rebuild` runs `sudo darwin-rebuild switch` under the hood (system activation
>   needs root; you'll get a Touch ID prompt). It resolves the absolute path so
>   sudo's restricted `PATH` doesn't cause "command not found".
> - These are **macOS-only**. On the Linux `vm` profile use `home-manager switch`.
> - **Timing:** if you `rebuild` before CI finishes building, that machine will
>   compile locally once (slower, but not broken). Wait for the green check to
>   get the cache benefit.

### 🤖 CI: automated cache builds

`.github/workflows/build-cache.yml` builds both profiles on every push to `main`
(that touches the closure) and pushes the results to `skinnyvans`. It runs on an
Apple-Silicon `macos-15` runner so the store paths match your machines exactly.

**One-time setup:** add a repository secret named `CACHIX_AUTH_TOKEN`
(GitHub → Settings → Secrets and variables → Actions) with a **write**-scoped
token from app.cachix.org → `skinnyvans` → Auth Tokens. Building needs **no** age
key — secrets are only decrypted at activation time on the machine, not at build.

You can also trigger a cache build manually from the Actions tab
(`workflow_dispatch`), e.g. after a `nix flake update`.

## 💻 Development Shells

Enter different development environments:

```bash
# Full development environment
nix develop .

# Language-specific environments
nix develop .#go
nix develop .#python
nix develop .#rust
nix develop .#lua
nix develop .#php
nix develop .#node
nix develop .#nix
```


## 🛠️ Neovim Configuration

The Neovim configuration includes:
- LSP support for multiple languages
- Code completion with nvim-cmp
- Telescope for fuzzy finding
- Git integration with gitsigns
- File explorer with nvim-tree
- Beautiful UI with Gruvbox themes
- Custom keybindings with which-key

Access Neovim:
```bash
# Use the configured Neovim
nix run .#nixvim
```

## 🗄️ Cachix (Binary Cache)

This project uses [Cachix](https://cachix.org/) so machines pull prebuilt
binaries instead of compiling. Pre-built packages are served from the
`skinnyvans` cache. In normal use **[CI](#-ci-automated-cache-builds) is the only
thing that pushes** — your machines are pull-only and need no auth token.

### Pulling (automatic)

The cache is configured system-wide in `nix/darwin/nix.nix`, so after the first
switch every `rebuild` automatically pulls from `skinnyvans.cachix.org` before
attempting a local build. Nothing to do.

**Chicken-and-egg on a fresh machine:** that config only takes effect *after* the
first switch, so the very first build won't use the cache unless you add it
manually first (see step 0 of [New Machine Setup](#-new-machine-setup)):

```bash
nix profile install nixpkgs#cachix
cachix use skinnyvans
```

### Pushing (manual fallback)

CI handles pushing. You only need this if you build something locally that CI
hasn't cached and want to share it:

```bash
cachix authtoken <write-scoped-token>   # from app.cachix.org → Auth Tokens
sudo (command -v darwin-rebuild) switch --flake .#personal |& cachix push skinnyvans
```

## 🆕 New Machine Setup

Getting a fresh machine fully synced:

```bash
# 0. Add the cache BEFORE the first build (otherwise it compiles from source)
nix profile install nixpkgs#cachix
cachix use skinnyvans

# 1. Put your age key in place (decrypts sops secrets) — copy from another
#    machine or your password manager:
mkdir -p ~/.config/sops/age
#    → place keys.txt at ~/.config/sops/age/keys.txt

# 2. First bootstrap (darwin-rebuild isn't on PATH yet, so call it from ./result)
nix build github:Ervan0707/cosmic#darwinConfigurations.personal.system   # or work
sudo ./result/sw/bin/darwin-rebuild switch --flake github:Ervan0707/cosmic#personal
```

After this first switch you're done — `darwin-rebuild` and the `rebuild` helper
are installed system-wide. **From now on it's just `rebuild`** (see
[Daily Workflow](#-daily-workflow)). You don't even need a local clone unless you
want to edit the config.

**What to carry over (not in git):**
- **Age key** → `~/.config/sops/age/keys.txt` (required — secrets won't decrypt without it)
- **Cachix token** → only if this machine should *push* to the cache (read/pull needs none)

## 📦 Updating Dependencies

Update Nix flake inputs (or let the weekly `update-flakes.yml` workflow open a PR):
```bash
nix flake update
git add flake.lock && git commit -m "chore: update flake.lock" && git push
# CI rebuilds and warms the cache; then `rebuild` on each machine pulls binaries
```

## 🎯 Quick Run Cheatsheet

Run configurations directly from GitHub without cloning:

### 🏃‍♂️ Direct From GitHub
```bash
# Run Neovim configuration
nix run github:Ervan0707/cosmic#nixvim

# Build and activate complete configuration (includes both nix-darwin and home-manager)
nix build github:Ervan0707/cosmic#darwinConfigurations.work.system
./result/sw/bin/darwin-rebuild switch --flake github:Ervan0707/cosmic#work

nix build github:Ervan0707/cosmic#darwinConfigurations.personal.system
./result/sw/bin/darwin-rebuild switch --flake github:Ervan0707/cosmic#personal

# For non-macOS systems only: build home-manager configuration
nix build github:Ervan0707/cosmic#homeConfigurations.work.activationPackage
nix build github:Ervan0707/cosmic#homeConfigurations.personal.activationPackage
```

> **Note:** For macOS users, use the nix-darwin configurations as they automatically include home-manager settings. The home-manager only configurations are provided separately for non-macOS systems or special use cases.



**Note:** After activating nix-darwin and home-manager configurations, your system will inherit:

**System Level (nix-darwin):**
- 🪟 Yabai window management
- ⌨️ SKHD keyboard shortcuts
- 📊 SketchyBar
- 🔒 Touch ID for sudo authentication
- ⚡️ System-wide keyboard settings
- 🖥️ macOS system preferences

**User Level (home-manager):**
- 🐟 Fish shell with custom configuration
- 🔐 Decrypted secrets as environment variables
- 🔧 Git with separate work/personal profiles
- 📝 Development tools and language servers
- ⌨️ Tmux with custom configuration
- 🚀 Neovim with full IDE setup
- 📦 User-specific packages

**Development Environments:**
- 💻 Language-specific toolchains
- 🛠️ Project-specific dependencies
- 🔍 LSP and debugging tools
- 📚 Documentation tools
- 🧪 Testing frameworks

## 🙏 Acknowledgments

- [Nix](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Nixvim](https://github.com/nix-community/nixvim)
- [Sops-Nix](https://github.com/Mic92/sops-nix)
- [Yabai](https://github.com/koekeishiya/yabai)
- [SketchyBar](https://github.com/FelixKratz/SketchyBar)
