# Git

My personal cheat sheet of commands for various tools and workflows

- [Git](#git)
  - [Split out subfolder into new repository](#split-out-subfolder-into-new-repository)
    - [(Optional) Migrate original subdir to submodule](#optional-migrate-original-subdir-to-submodule)

## Split out subfolder into new repository

*Be sure you are inside the original repo*

```sh
cd <orignal_repository>/<subdir-to-split>
```

Set local variables for use

```sh
username="$(git config user.username)"
subdir="$(git rev-parse --show-prefix)"
newrepo="$(basename $subdir)"
oldrepo="$(git rev-parse --show-toplevel)"
cd $oldrepo
```

Create a new branch containing only the sub-directory using `git subtree`

```sh
git subtree split -P $subdir -b $newrepo
```

Create a temp git repo and pull in the newly created branch

```sh
cd $(mktemp -d)

git init && git pull $oldrepo $newrepo
```

Copy over the git artifacts from original repo's root directory

```sh
cp -rt ./ $oldrepo/.gitignore $oldrepo/.gitattributes $oldrepo/.vscode
```

Commit changes

```sh
git add -A && git commit -m "split out $newrepo into submodule"
```

Create a new remote repository using something like [gh](https://github.com/cli/cli)

```sh
gh repo create $username/$newrepo
```

(Optional) You can also just create the new remote repository manually and set the new local repository's remote with

```sh
git remote add origin https://github.com/$username/$newrepo
```

Push newly created repository to remote

```sh
git push -u origin master
```

### (Optional) Migrate original subdir to submodule

Switch back into the original repository

```sh
cd $oldrepo
```

Remove the `subdir` from git and the filesystem

```sh
git rm -rf $subdir
rm -rf $subdir
```

Add the newly created remote repository as a submodule at the `subdir`'s path

```sh
git submodule add git@github.com:$username/$newrepo $subdir
git submodule update --init --recursive
```

Commit the changes to the original repository and push to remote

```sh
git commit -m "split out $newrepo into submodule"
git push -u origin master
```

