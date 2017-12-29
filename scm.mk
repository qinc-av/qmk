########################################
## file: //QInc/QCore/qmk/scm.mk
## born-on: Wednesday, January 1, 2014
## creator: Eric L. Hernes
##
## Makefile template to deal with git/svn operations
##

#
# Identify the repositories, their locations, and any optional branches
#
# We have choices-
#  1. List out the repositories/directories we want built; then have the rules logic
#     below generate the appropriate targets.  This will require a master list of
#     repositories, then some linkage from a repository name to a repository server.
#     From there we can perform the repository operation.
#
#     This mechanism makes more sense logically, because the administrator thinks about what reopsitories to include,
#     then defines details about each one.  It can get a bit more verbose because you need to explicitly set the
#     XXX-server variable for each repo.
#
#     For example:
#     qinc-git=git@scm.qinc.tv/...
#
#     default-git=${qinc-git}
#     default-branch=master
#
#     all-repos+=libSerialIo
#     ...
#
#     libSerialIo-git=${qinc-git}
#     libSerialIo-branch?=master
#

ifeq (${MAKECMDGOALS},)
$(info interesting goals:)
$(info status    - status of all repositories)
$(info clone     - clone all repositories)
$(info pull      - pull all repositories)
$(info diff      - diff all repositories)
$(info stash     - stash all repositories)
$(info stash-pop - stash pop all repositories)
$(info obj       - create obj.* directories)
$(info patch     - apply services.patch)
$(info clean     - remove build and obj.* directories)
$(info list-repo - list the known repositories)
$(info <repo>-<goal> - run a goal on a specific repository (i.e. libSerialIo-diff))
$(info )
$(error no goal specified)
endif

ifeq (${MAKECMDGOALS},list-repo)
$(info repositories:)
$(foreach r,${all-repos},$(if ${${r}-svn},$(info subversion: ${r}),$(info git: ${r} $(if ${${r}-branch},${${r}-branch},${default-branch})) ) )
$(error ${MAKECMDGOALS})
endif

all:  ${all-targets}
	@echo ${all-targets} complete

define mk-repo-rule
.PHONY: ${1}-${2}$(if ${3},-${3},)
${1}-${2}$(if ${3},-${3},): ${checkout-dir}/${1}
	-r=$(if ${${1}-svn},${${1}-svn},$(if ${${1}-git},${${1}-git},${default-git}) ); \
	b=$(if ${${1}-branch},${${1}-branch},${default-branch}); \
	cd ${checkout-dir}/${1}; ${scm_dbg} $(if ${${1}-svn},echo svn,git) ${2} ${3} ${4}
endef

define mk-git-clone
.PHONY: ${1}$(if ${2},-${2},)-clone
${1}$(if ${2},-${2},)-clone: ${checkout-dir}/${1}

${checkout-dir}/${1}:
	${scm_dbg} git ${2} clone -b $(if ${${1}-branch},${${1}-branch},${default-branch}) $(if ${${1}-git},${${1}-git},${default-git})/${1} ${checkout-dir}/${1}
endef

#
# svn-clone is mixed metaphores, but the upper level rules are set up for git
#           svn is only here for legacy repos
define mk-svn-checkout
.PHONY: ${1}-clone
${1}-clone: ${checkout-dir}/${1}

${checkout-dir}/${1}:
	${scm_dbg} svn checkout ${${1}-svn}$(if ${${1}-rev},@${${1}-rev},) ${checkout-dir}/${1}
endef

#
# this sets up the top level git targets
# so things like 'make pull' work
git-commands=pull status stash
$(foreach c, ${git-commands}, $(foreach r,${all-repos},$(eval $(call mk-repo-rule,${r},${c}) ) ) )

# diff and stash-pop are special...
$(foreach r,${all-repos},$(eval $(call mk-repo-rule,${r},diff,,--src-prefix=a/${checkout-dir}/${r}/ --dst-prefix=b/${checkout-dir}/${r}/) ) )
$(foreach r,${all-repos},$(eval $(call mk-repo-rule,${r},stash,pop) ) )


# check for XXX-svn, then default to git
$(foreach r,${all-repos},$(eval $(if ${${r}-svn},$(call mk-svn-checkout,${r}),$(call mk-git-clone,${r}) ) ))

# subrepo is a failed experiment
#$(foreach r,${all-repos},$(eval $(call mk-git-clone,${r},subrepo) ) )

iterate-repo=$(foreach r,${all-repos},${r}-${1})

define mk-git-target
.PHONY: ${1}
${1}: $(call iterate-repo,${1})
endef

git-targets=clone pull checkout diff status stash stash-pop
$(foreach t,${git-targets},$(eval $(if ${${t}-svn},,$(call mk-git-target,${t})) ) )

${checkout-dir}:
	mkdir -p ${checkout-dir}

dry-run=$(if ${scm_dbg},--dry-run,)

.PHONY: patch
patch:
	for p in ${patch-dir}/*.patch; do \
	  if [ -f "$${p}" ]; then \
	    repo=${checkout-dir}/$$(basename $${p} .patch); \
	    cat $${p} | ( cd $${repo}; patch -p1 ${dry-run}); \
	  fi; \
	done
	$(if ${extra-patch-file},[ -f ${extra-patch-file} ] && patch ${dry-run} -p1 < ${extra-patch-file},)

#
# Local Variables:
# mode: Makefile
# mode: font-lock
# tab-width: 8
# compile-command: "make"
# End:
#
