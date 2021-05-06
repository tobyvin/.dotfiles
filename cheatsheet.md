My personal cheatsheet of commands for various tools and workflows

- [Git](#git)
  - [Split out subfolder into new repository](#split-out-subfolder-into-new-repository)

## Git

### Split out subfolder into new repository

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
gh repo create
```
