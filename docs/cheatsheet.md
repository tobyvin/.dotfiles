My personal cheatsheet of commands for various tools and workflows

- [Git](#git)

## Git

### Split out subfolder into new repository

<details>
  <summary>Steps</summary>

  - *Be sure you are inside the original repo*
    ```sh
    cd <orignal_repository>
    ```

  - Set local variables for use

    ```sh
    username=tobyvin-cs340
    subdir=src/Plotter
    newrepo="$(basename $subdir)"
    oldrepo="$(pwd)"
    ```

  - Create a new branch containing only the subdir using `git subtree`

    ```sh
    git subtree split -P $subdir -b $newrepo
    ```

  - Create a temp git repo and pull in the newly created branch

    ```sh
    cd $(mktemp -d)

    git init && git pull $oldrepo $newrepo
    ```

  - Copy over the git artifacts from original repo's root directory

    ```sh
    cp $oldrepo/.gitignore ./
    cp $oldrepo/.gitattributes ./
    ```

  - Commit changes

    ```sh
    git add -A && git commit -m "split out $newrepo into submodule"
    ```

  - Create the repository on a remote (github) and push  

    ```sh
    gh repo create $username/$newrepo
    git push -u origin master
    ```

  - Switch back into the original repository

    ```sh
    cd $oldrepo
    ```

  - Remove the subdir from git and the filesystem

    ```sh
    git rm -rf $subdir
    rm -rf $subdir
    ```

  - Add the newly created remote repository as a submodule at the subdir's path

    ```sh
    git submodule add git@github.com:$username/$newrepo $subdir
    git submodule update --init --recursive
    ```

  - Commit the changes to the original repository and push to remote

    ```sh
    git commit -m "split out $newrepo into submodule"
    git push -u origin master
    ```
</details>

## WSL2

  ### Windows Enviornment

  ### SSH Agent
 
  - Download [wsl-ssh-pageant](https://github.com/benpye/wsl-ssh-pageant)
  
    ```powershell
    # Using scoop (https://scoop.sh/)
    scoop install wsl-ssh-pageant
    ```

  - Set variables

    Note: The version with '-gui', i.e. 'wsl-ssh-pageant-gui', ***has no*** gui/systray, while 'wsl-ssh-pageant' ***has*** a gui/systray. Choose which ever you find most useful

    ```powershell
    # Can be any name
    $pipe = "ssh-pageant"

    # Path to either wsl-ssh-pageant or wsl-ssh-pageant-gui executable
    $pageant = "$env:SCOOP\apps\wsl-ssh-pageant\current\wsl-ssh-pageant-gui.exe"
    
    [System.Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK',"\\.\pipe\$pipe")
    ```

  - Set it to autostart on login

    ```powershell
    $path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    $cmdl = "$pageant --winssh $pipe"
    $key = try {
        Get-Item -Path $path -ErrorAction Stop
    }
    catch {
        New-Item -Path $path -Force
    }

    New-ItemProperty -Path $key.PSPath -Name "wsl-ssh-pageant" -Value "$cmdl"
    ```


  ### GPG Agent

    - Download [gpg-bridge](https://github.com/BusyJay/gpg-bridge)

    - Set variables

      ```powershell
      # Can be any free port
      $port = 4444

      $bridge = "~/.cargo/bin/gpg-bridge"
      ```

    - Set it to autostart on login

      ```powershell
      $path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
      $cmdl = "$bridge 127.0.0.1:$port --detach"
      $key = try {
          Get-Item -Path $path -ErrorAction Stop
      }
      catch {
          New-Item -Path $path -Force
      }

      New-ItemProperty -Path $key.PSPath -Name "gpg-bridge" -Value "$cmdl"
    ```