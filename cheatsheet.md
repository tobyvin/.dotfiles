My personal cheatsheet of commands for various tools and workflows

- [Git](#git)
  - [Split out subfolder into new repository](#split-out-subfolder-into-new-repository)
  - [OLD WAY (git filter-branch)](#old-way-git-filter-branch)

## Git

### Split out subfolder into new repository

Run inside the original repo

```sh
username=tobyvin-cs340
subdir=src/Plotter
newrepo="$(basename $subdir)"
oldrepo="$(pwd)"

git subtree split -P $subdir -b $newrepo

cd $(mktemp -d)

git init && git pull $oldrepo $newrepo

cp $oldrepo/.gitignore ./
cp $oldrepo/.gitattributes ./

git add -A && git commit -m "split out $newrepo into submodule"

gh repo create $username/$newrepo

git push -u origin master

cd $oldrepo

git rm -rf $subdir

rm -rf $subdir

git submodule add git@github.com:$username/$newrepo $subdir

git submodule update --init --recursive

git commit -m "split out $newrepo into submodule"

git push -u origin master
```

### OLD WAY (git filter-branch)

Variables for the original repo and subdirectory you want to split out: 

```sh
read -p 'Username: ' username
read -p 'Repo: ' baserepo
read -p 'Folder: ' subdir 
newrepo=$(basename $subdir) 
```

Clone the repo locally into the new repo name and switch to it: 

```sh
git clone git@github.com:$username/$baserepo $newrepo
cd $newrepo
```

Filter repository using filter-branch:

```sh
git filter-branch --subdirectory-filter $subdir -- --all
```

Remove the original remote

```sh
git remote remove origin
```

Create and add new github remote

```sh
gh repo create $username/$newrepo
```

Push changes to new remote

```sh 
git push -u origin master
```