# puppet-rundeck — PR Review Context
Fork of voxpupuli/puppet-rundeck; almost all code is upstream. Review the diff, not the module.

## What this is
- Puppet module installing/configuring Rundeck (the ops job scheduler/orchestrator): package+repo, service, ACLs, JAAS auth, SSL keystores, key storage, projects/jobs via the `rd` CLI.
- FORK of `voxpupuli/puppet-rundeck` (metadata `author`=Vox Pupuli, `source`=voxpupuli; HEAD is a voxpupuli modulesync merge). The only Apica change observed is `.github/workflows/claude-review.yml` (thin caller for the org review). Treat all `.pp`/`.epp`/`lib` code as upstream unless the PR touches it.
- metadata.json: version 9.2.1-rc0; `requirements` pins OpenVox `>= 8.19.0 < 9.0.0` (no puppetlabs `puppet` pin). RHEL/Oracle/Rocky/Alma/CentOS + Debian/Ubuntu only.
- Deps: puppetlabs/stdlib, puppetlabs/java_ks, puppet/archive. Soft: puppetlabs/java, puppetlabs/apt.

## Layout
- manifests/init.pp — `rundeck` class: all params + defaults, contains install→config→service, optional `rundeck::cli`.
- manifests/{install,config,service,cli}.pp — package/repo/user; core config+dirs+ACLs+templates; service; CLI package+env+`rd system info` conn check.
- manifests/config/*.pp — jaas_auth, framework, ssl, aclpolicyfile (define), secret (define), plugin (define), project (define, `rd projects/jobs/scm`).
- templates/*.epp — EPP (not ERB): rundeck-config.properties, realm.properties, jaas-loginmodule.conf, ssl.properties, aclpolicy, log4j2, framework, profile_overrides.
- types/*.pp — data types (auth_config, db_config, key_storage_config, mail_config, project, scm, job, loglevel).
- lib/ — custom fact rundeck_version.rb, puppetx/rundeck/acl.rb, parser function validate_rd_policy.rb.
- data/ + hiera.yaml — per-OS repo/override defaults (Debian.yaml, RedHat.yaml).
- files/*.sh — rd_{job,project,scm}_diff.sh: CLI idempotency helpers.

## Build / conventions
- Standard modulesync-managed module: Hiera module data (data/, hiera.yaml), EPP templating, puppet-lint (.puppet-lint.rc), rubocop, rspec-puppet (spec/), overcommit, .fixtures.yml.
- FORK: focus on the diff / Apica changes; do not review upstream code as if newly written. Upstream churn arrives via modulesync PRs.
- Misread traps: `requirements`=OpenVox, not Puppet; EPP `<%- -%>` trim markers are intentional; validate_rd_policy is a custom parser function; secrets are `Sensitive()`-wrapped.

## Review focus (priority order)
1. Correctness (catalog-breaking): undefined vars, wrong/missing data types on new params, resource ordering (install→config→service `~>`/`->`), duplicate resource declarations, `.each` loops over hashes.
2. Security: new secrets (admin creds, API tokens, DB/LDAP bind passwords) must stay `Sensitive()` + file mode `0400` (as realm.properties/jaas/ssl already are); watch CLI `RD_TOKEN`/`RD_PASSWORD` leaking via exec `environment`; broad file modes / world-readable secrets; unescaped interpolation in `exec` commands (shell injection via project/job/key names); ACL/auth policy weakening; SSL/keystore config.
3. Template correctness: EPP var access on optional hash keys, trim-marker whitespace, plaintext rendered into managed files.
4. If a change is Apica-specific, prioritize it over upstream style nits.

## Do NOT flag (known-intentional)
- Upstream module code not touched by the PR (manifests/templates/types/lib) — it is voxpupuli/modulesync-maintained.
- spec/, .fixtures.yml, spec/fixtures — test scaffolding.
- CHANGELOG.md, REFERENCE.md — generated (puppet-strings/modulesync).
- Default creds `admin`/`admin` and keystore/truststore `adminadmin` — documented module defaults; only flag if a PR hardcodes a REAL secret.
- realm.properties rendering `admin_user:admin_password` in cleartext — that is Rundeck HashUserRealm format; file is `Sensitive()` + `0400`.
- CLI `token`/`password` typed as `String` (not `Sensitive`) — upstream API.
- modulesync/CI scaffolding (.msync.yml, .sync.yml, .rubocop.yml, Gemfile, Rakefile, other .github workflows).
