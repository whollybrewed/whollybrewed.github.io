---
layout: post
title: "Snapshots in BTRFS"
date: 2026-05-23
categories: linux
draft: false
---

Similar to doomsday prepping, system snapshots are often overlooked and mocked for
“being right once” when extraordinary catastrophe arrives.

As Fedora 44 is being rolled out, I’ve came upon that time of the year to review my
system restoration strategy. And to be honest, most of the steps can be answered
easily by AI chatbots nowadays. However, for matters as critical as system integrity,
the old-school side of me still prefers to refer to a static hand-typed note
that has been tested by experience, especially in this era where information
promptness (pun intended) and digestibility are valued over accuracy and deep
consideration. Consider this post as my system admin note-to-self.

## Btrfs
As of today both openSUSE and Fedora ship their distro with btrfs by default. btrfs
was originally proposed by Ohad Rodeh at IBM during 2007. There's also a paper[^1]
authored by him outlining the overall concepts and architecture. Two features of
btrfs that became imperative to snapshot are **CoW** (Copy on Write) and
**subvolume**. CoW enables the modified data to be copied while keeping the old
data intact, allowing both the old and the new inodes to coexist; subvolume defines the
boundary of a snapshot. A lot more details can be discussed, my favorite is a
series[^2] of high quality articles published on Fedora Magazine, see the footnotes.

[^1]: [BTRFS: The linux B-tree filesystem](https://www.researchgate.net/publication/262177144_BTRFS_The_linux_B-tree_filesystem)
[^2]: [Fedora Magazine - Working with Btrfs](https://fedoramagazine.org/working-with-btrfs-general-concepts/)

## Snapshot with snapper

One could configure snapshot using the btrfs commands alone, but I prefer a tool like
`snapper`[^3] for convenience. There's also a GUI tool called `btrfs-assistant`[^4] but I
lack the experience with it.

[^3]: [openSUSE snapper](https://github.com/openSUSE/snapper)
[^4]: [Btrfs Assistant](https://gitlab.com/btrfs-assistant/btrfs-assistant)

On Fedora `snapper` can be installed via `dnf`. It is also recommended to install
libdnf5 callback hooks for dnf integration, so that snapshots can be automatically
taken `pre_transaction` and `post_transaction`.

```bash
sudo dnf install -y snapper libdnf5-plugin-actions
```

And then create snapper configuration for root file system `/`:
```bash
sudo snapper -c root create-config /
```

Afterwards, check that config `root` and subvolume `/` appear:
```bash
$ sudo snapper list-configs
```

Enable timer in systemd for automatic snapshot and cleanup:
```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

Check that snapper has the correct SELinux context:
```bash
ls -Zd /.snapshots
```
Expect to see:
```
drwxr-x---. 1 root root system_u:object_r:snapperd_data_t:s0
```

To configure the behaviors, edit `/etc/snapper/configs/root`.
```
# subvolume to snapshot
SUBVOLUME="/"

# filesystem type
FSTYPE="btrfs"


# btrfs qgroup for space aware cleanup algorithms
QGROUP=""


# fraction or absolute size of the filesystems space the snapshots may use
SPACE_LIMIT="0.5"

# fraction or absolute size of the filesystems space that should be free
FREE_LIMIT="0.2"


# users and groups allowed to work with config
ALLOW_USERS=""
ALLOW_GROUPS=""

# sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots
# directory
SYNC_ACL="no"


# start comparing pre- and post-snapshot in background after creating
# post-snapshot
BACKGROUND_COMPARISON="yes"


# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup
NUMBER_MIN_AGE="3600"
NUMBER_LIMIT="30"
NUMBER_LIMIT_IMPORTANT="10"


# create hourly snapshots
TIMELINE_CREATE="yes"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup
TIMELINE_MIN_AGE="3600"
TIMELINE_LIMIT_HOURLY="6"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="3"
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="0"


# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="3600"
```

`NUMBER_MIN_AGE="3600"` means "do not delete a numbered snapshot less than 1 hour old."

`NUMBER_LIMIT="30"` means "keep up to 30 regular numbered snapshots." Each `dnf`
update equals two snapshots due to pre and post.

`TIMELINE_LIMIT_HOURLY="6"` means "keep the last 6 hourly snapshots."

From now on snapper will automatically take snapshots based on timeline and
transaction, such as `dnf`. To check the snapshots, use:
```bash
sudo snapper list
```

It is optional to enable btrfs qgroups so that `snapper list` will display the used
space by each snapshot.

```bash
sudo btrfs quota enable /
sudo btrfs quota rescan -w /
```

However, my experience is that it will make `snapper list` run very slow.
`--disable-used-space` can be added to the list command to bypass calculating. I
prefer to disable qgroups and just use the btrfs commands:

```bash
sudo btrfs filesystem du -s /.snapshots/<number>/
```

---

Before I ran the Fedora upgrade, I created a pre-snapshot:
```bash
sudo snapper create --type pre -d "upgrade from fedora 43"
```
And immediately after the upgrade, I created a post-snapshot. They will be linked
by snapper.
```bash
sudo snapper create --type post -d "upgraded to fedora 44"
```

## Cheatsheet
Here is a cheatsheet of some common commands
```bash
# Create a normal manual snapshot
sudo snapper create --description "my snapshot"

# Mark snapshot before a system change (upgrade, install, etc.)
sudo snapper create --type pre --description "before upgrade"

# Mark snapshot after the change (pairs with PRE)
sudo snapper create --type post --description "after upgrade"

# Create snapshot with automatic cleanup policy
sudo snapper create --description "test" --cleanup-algorithm number

# Show file-level changes between two snapshots
sudo snapper status PRE..POST

# Show detailed diff of changes between snapshots
sudo snapper diff PRE..POST

# Revert filesystem changes between PRE and POST snapshot pair
sudo snapper undochange PRE..POST

# Roll entire system state back to a snapshot (boot-level rollback)
sudo snapper rollback <snapshot-id>

# Delete a single snapshot
sudo snapper delete <id>

# Delete a range of snapshots
sudo snapper delete <id1>..<id2>

# Remove old timeline snapshots based on config rules
sudo snapper cleanup timeline

# Remove snapshots based on numbering policy
sudo snapper cleanup number

# Show current config values
sudo snapper get-config

# Modify snapper configuration
sudo snapper set-config "KEY=VALUE"

# List all subvolumes and snapshots
sudo btrfs subvolume list /
```

## Final Remark
It is important to remember that snapshots are a *rollback* strategy rather than a
*backup* strategy. Since snapshot subvolumes reside within the same filesystem as
the original subvolume, any disk failure or data corruption affects them all equally.
