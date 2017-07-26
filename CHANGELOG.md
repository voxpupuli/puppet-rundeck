# Change log

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not impact the functionality of the module.

## [v4.0.1](https://github.com/voxpupuli/puppet-rundeck/tree/v4.0.1) (2017-07-04)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- Add missing undeckd= in profile.erb [\#323](https://github.com/voxpupuli/puppet-rundeck/pull/323) ([stigboyeandersen](https://github.com/stigboyeandersen))
- Change to use `fqdn\_uuid\(\)` function [\#322](https://github.com/voxpupuli/puppet-rundeck/pull/322) ([petems](https://github.com/petems))

**Closed issues:**

- Rundeck service not starting [\#319](https://github.com/voxpupuli/puppet-rundeck/issues/319)

## [v4.0.0](https://github.com/voxpupuli/puppet-rundeck/tree/v4.0.0) (2017-06-27)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v3.3.0...v4.0.0)

**Fixed bugs:**

- Fix ini settings for aws-ec2 resource source [\#320](https://github.com/voxpupuli/puppet-rundeck/pull/320) ([ortz](https://github.com/ortz))
- Adding missing api config settings. [\#310](https://github.com/voxpupuli/puppet-rundeck/pull/310) ([attachmentgenie](https://github.com/attachmentgenie))

**Closed issues:**

- No code to manage cacert \(ldaps\) and rundeck's private key [\#182](https://github.com/voxpupuli/puppet-rundeck/issues/182)

**Merged pull requests:**

- release 4.0.0 [\#321](https://github.com/voxpupuli/puppet-rundeck/pull/321) ([bastelfreak](https://github.com/bastelfreak))
- Set debian apt\_repo as default debian installation method [\#308](https://github.com/voxpupuli/puppet-rundeck/pull/308) ([cy4n](https://github.com/cy4n))
- Update readme apt install [\#307](https://github.com/voxpupuli/puppet-rundeck/pull/307) ([cy4n](https://github.com/cy4n))

## [v3.3.0](https://github.com/voxpupuli/puppet-rundeck/tree/v3.3.0) (2017-01-12)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v3.2.0...v3.3.0)

**Closed issues:**

- puppet adding double quotes to allow parameters [\#292](https://github.com/voxpupuli/puppet-rundeck/issues/292)
- Add Quartz job threadCount variable [\#289](https://github.com/voxpupuli/puppet-rundeck/issues/289)
- key storage definition using puppet-rundeck module [\#287](https://github.com/voxpupuli/puppet-rundeck/issues/287)
- /etc/rundeck/profile format changed with rundeck-2.6.10 [\#284](https://github.com/voxpupuli/puppet-rundeck/issues/284)
- Metadata declare dependency of version 1.0.3 of puppetlabs-inifile but it doesn't contain create\_ini\_settings [\#268](https://github.com/voxpupuli/puppet-rundeck/issues/268)

**Merged pull requests:**

- release 3.3.0 [\#305](https://github.com/voxpupuli/puppet-rundeck/pull/305) ([bastelfreak](https://github.com/bastelfreak))
- added userPasswordAttribute to ldap config, like AD config [\#299](https://github.com/voxpupuli/puppet-rundeck/pull/299) ([sjsmit](https://github.com/sjsmit))
- Set minimum version dependencies \(for Puppet 4\) [\#298](https://github.com/voxpupuli/puppet-rundeck/pull/298) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Set puppet minimum version\_requirement to 3.8.7 [\#295](https://github.com/voxpupuli/puppet-rundeck/pull/295) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Add variable quartz\_job\_threadCount [\#290](https://github.com/voxpupuli/puppet-rundeck/pull/290) ([danifr](https://github.com/danifr))
- install rundeck from apt for osfamily debian [\#286](https://github.com/voxpupuli/puppet-rundeck/pull/286) ([cy4n](https://github.com/cy4n))
- Rubocop fixes [\#281](https://github.com/voxpupuli/puppet-rundeck/pull/281) ([alexjfisher](https://github.com/alexjfisher))
- Add missing badges [\#280](https://github.com/voxpupuli/puppet-rundeck/pull/280) ([dhoppe](https://github.com/dhoppe))
- Revert "Add missing node resource properties to acltemplate" [\#274](https://github.com/voxpupuli/puppet-rundeck/pull/274) ([bastelfreak](https://github.com/bastelfreak))
- Add missing node resource properties to acltemplate [\#273](https://github.com/voxpupuli/puppet-rundeck/pull/273) ([cy4n](https://github.com/cy4n))
- This adds a boolean class parameter to the rundeck class to allow people [\#271](https://github.com/voxpupuli/puppet-rundeck/pull/271) ([dustinak](https://github.com/dustinak))
- Fix issue \#268. [\#269](https://github.com/voxpupuli/puppet-rundeck/pull/269) ([jairojunior](https://github.com/jairojunior))
- add: tags to fix aclpolicy [\#265](https://github.com/voxpupuli/puppet-rundeck/pull/265) ([zlanyi](https://github.com/zlanyi))

## [v3.2.0](https://github.com/voxpupuli/puppet-rundeck/tree/v3.2.0) (2016-10-05)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v3.1.0...v3.2.0)

**Closed issues:**

- puppet/archive dependency break compatibility with camptocamp/archive [\#263](https://github.com/voxpupuli/puppet-rundeck/issues/263)
- resource\_source.pp does not support puppetenterprise parameter puppetdb\_ssl\_dir [\#257](https://github.com/voxpupuli/puppet-rundeck/issues/257)
- job\_type branch and deps on File\[/usr/bin/gem\] File\[/usr/bin/ruby\] [\#119](https://github.com/voxpupuli/puppet-rundeck/issues/119)

**Merged pull requests:**

- Modulesync 0.12.8 & Release 3.2.0 [\#270](https://github.com/voxpupuli/puppet-rundeck/pull/270) ([bastelfreak](https://github.com/bastelfreak))
- Update puppet/archive dependency [\#267](https://github.com/voxpupuli/puppet-rundeck/pull/267) ([alexjfisher](https://github.com/alexjfisher))
- this change allow puppet/archive to live together with camptocamp/archive [\#264](https://github.com/voxpupuli/puppet-rundeck/pull/264) ([lzecca78](https://github.com/lzecca78))
- Add missing 'rd\_auditlevel' parameter to config.pp [\#262](https://github.com/voxpupuli/puppet-rundeck/pull/262) ([tomtheun](https://github.com/tomtheun))
- Feature: Keytool [\#261](https://github.com/voxpupuli/puppet-rundeck/pull/261) ([zlanyi](https://github.com/zlanyi))
- puppetdb\_ssl\_dir is added as parameter [\#258](https://github.com/voxpupuli/puppet-rundeck/pull/258) ([ltutar](https://github.com/ltutar))
- feature: set user and group id because of NFS Share [\#254](https://github.com/voxpupuli/puppet-rundeck/pull/254) ([zlanyi](https://github.com/zlanyi))

## [v3.1.0](https://github.com/voxpupuli/puppet-rundeck/tree/v3.1.0) (2016-07-11)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v3.0.0...v3.1.0)

**Closed issues:**

- feature request: able to change the ssl port [\#248](https://github.com/voxpupuli/puppet-rundeck/issues/248)
- Release v2.3.0 [\#224](https://github.com/voxpupuli/puppet-rundeck/issues/224)

**Merged pull requests:**

- add: support to set more roles in web.xml [\#250](https://github.com/voxpupuli/puppet-rundeck/pull/250) ([zlanyi](https://github.com/zlanyi))
- able to change ssl port through parameter [\#249](https://github.com/voxpupuli/puppet-rundeck/pull/249) ([ltutar](https://github.com/ltutar))
- Sync metadata.json license to be same as LICENSE \(MIT\) [\#244](https://github.com/voxpupuli/puppet-rundeck/pull/244) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Remove `tests` directory [\#243](https://github.com/voxpupuli/puppet-rundeck/pull/243) ([alexjfisher](https://github.com/alexjfisher))
- Example manifest to demo-install Rundeck on EL7 [\#242](https://github.com/voxpupuli/puppet-rundeck/pull/242) ([vinzent](https://github.com/vinzent))
- added puppet enterprise resource type [\#241](https://github.com/voxpupuli/puppet-rundeck/pull/241) ([dalisch](https://github.com/dalisch))
- Modulesync 0.7.0 [\#240](https://github.com/voxpupuli/puppet-rundeck/pull/240) ([bastelfreak](https://github.com/bastelfreak))
- fixed management of $file\_keystore\_dir [\#239](https://github.com/voxpupuli/puppet-rundeck/pull/239) ([dalisch](https://github.com/dalisch))

## [v3.0.0](https://github.com/voxpupuli/puppet-rundeck/tree/v3.0.0) (2016-05-30)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v2.3.0...v3.0.0)

**Merged pull requests:**

- modulesync 0.7.0 + release 3.0.0 [\#237](https://github.com/voxpupuli/puppet-rundeck/pull/237) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-rundeck/tree/v2.3.0) (2016-05-27)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v2.2.0...v2.3.0)

**Closed issues:**

- Could not autoload puppet/parser/functions/validate\_rd\_policy: no such file to load -- puppetx/rundeck/acl [\#235](https://github.com/voxpupuli/puppet-rundeck/issues/235)
-  undefined method `each' for nil:NilClass [\#208](https://github.com/voxpupuli/puppet-rundeck/issues/208)
- Add possibility to change loglevel for some rundeck logs [\#207](https://github.com/voxpupuli/puppet-rundeck/issues/207)
- Change "required" to "sufficient" in \_auth\_file.erb as workaround for rundeck bug [\#206](https://github.com/voxpupuli/puppet-rundeck/issues/206)
- Rundeck private key id\_rsa incorrectly set to mode '0640' [\#196](https://github.com/voxpupuli/puppet-rundeck/issues/196)
- All module variables should be ordered alphabetically [\#188](https://github.com/voxpupuli/puppet-rundeck/issues/188)
- Evaluation Error on require of puppet/util/rundeck\_acl [\#125](https://github.com/voxpupuli/puppet-rundeck/issues/125)

**Merged pull requests:**

- updating changelog for version 2.3.0 [\#236](https://github.com/voxpupuli/puppet-rundeck/pull/236) ([danifr](https://github.com/danifr))
- Do not write non-existent mail configuration [\#234](https://github.com/voxpupuli/puppet-rundeck/pull/234) ([danifr](https://github.com/danifr))
- Added option to template : 'forceBindingLoginUseRootContextForRoles' [\#228](https://github.com/voxpupuli/puppet-rundeck/pull/228) ([zlanyi](https://github.com/zlanyi))
- Add param to configure service state [\#223](https://github.com/voxpupuli/puppet-rundeck/pull/223) ([danifr](https://github.com/danifr))
- Simple fix aclpolicy.erb template [\#222](https://github.com/voxpupuli/puppet-rundeck/pull/222) ([devcfgc](https://github.com/devcfgc))
- Correcting values of project.organization and projection.description [\#221](https://github.com/voxpupuli/puppet-rundeck/pull/221) ([brmorris](https://github.com/brmorris))
- Simple fix qualify command [\#220](https://github.com/voxpupuli/puppet-rundeck/pull/220) ([devcfgc](https://github.com/devcfgc))
- Allow disabling download of debian package. [\#219](https://github.com/voxpupuli/puppet-rundeck/pull/219) ([aequitas](https://github.com/aequitas))
- Automate configuration of SCM export properties in a project [\#218](https://github.com/voxpupuli/puppet-rundeck/pull/218) ([dalisch](https://github.com/dalisch))
-  - Added ability to specify node executor settings [\#217](https://github.com/voxpupuli/puppet-rundeck/pull/217) ([DevOpsFu](https://github.com/DevOpsFu))
- Amend default policy for full storage control [\#216](https://github.com/voxpupuli/puppet-rundeck/pull/216) ([zleswomp](https://github.com/zleswomp))
- Documentation fixes [\#215](https://github.com/voxpupuli/puppet-rundeck/pull/215) ([zleswomp](https://github.com/zleswomp))
- Add CentOS 7 to tested platforms [\#214](https://github.com/voxpupuli/puppet-rundeck/pull/214) ([zleswomp](https://github.com/zleswomp))
- Add note and example about using an external MySQL DB [\#213](https://github.com/voxpupuli/puppet-rundeck/pull/213) ([zleswomp](https://github.com/zleswomp))
- Fix audit loglevel 207 [\#212](https://github.com/voxpupuli/puppet-rundeck/pull/212) ([remixtj](https://github.com/remixtj))
- Update \_auth\_file.erb \(fixes \#206\) [\#211](https://github.com/voxpupuli/puppet-rundeck/pull/211) ([remixtj](https://github.com/remixtj))
- Add Rundeck GUI customization properties [\#210](https://github.com/voxpupuli/puppet-rundeck/pull/210) ([dalisch](https://github.com/dalisch))
- Fix indentation for nodename property in aclpolicy template [\#209](https://github.com/voxpupuli/puppet-rundeck/pull/209) ([cy4n](https://github.com/cy4n))
- refactored file permissions management [\#204](https://github.com/voxpupuli/puppet-rundeck/pull/204) ([dalisch](https://github.com/dalisch))
- fix\(validate\_rd\_policy\) expand relative path for require [\#201](https://github.com/voxpupuli/puppet-rundeck/pull/201) ([igalic](https://github.com/igalic))
- Pin rake to avoid rubocop/rake 11 incompatibility [\#200](https://github.com/voxpupuli/puppet-rundeck/pull/200) ([roidelapluie](https://github.com/roidelapluie))
- Revert "Simplify the acl template" [\#195](https://github.com/voxpupuli/puppet-rundeck/pull/195) ([jyaworski](https://github.com/jyaworski))
- Added management of scm-import.properties [\#193](https://github.com/voxpupuli/puppet-rundeck/pull/193) ([dalisch](https://github.com/dalisch))
- Ensure rundeck directories are owned by $user and $group [\#191](https://github.com/voxpupuli/puppet-rundeck/pull/191) ([danifr](https://github.com/danifr))
- Remove auth-constraint from web.xml if preauthenticated mode enabled [\#190](https://github.com/voxpupuli/puppet-rundeck/pull/190) ([danifr](https://github.com/danifr))
- Order variables alphabetically [\#189](https://github.com/voxpupuli/puppet-rundeck/pull/189) ([danifr](https://github.com/danifr))
- Update from voxpupuli modulesync\_config [\#187](https://github.com/voxpupuli/puppet-rundeck/pull/187) ([jyaworski](https://github.com/jyaworski))
- Linting changes and rubocop updates [\#185](https://github.com/voxpupuli/puppet-rundeck/pull/185) ([jyaworski](https://github.com/jyaworski))
- default policy management is now optional [\#184](https://github.com/voxpupuli/puppet-rundeck/pull/184) ([bovy89](https://github.com/bovy89))
- Support preauthenticated mode config [\#175](https://github.com/voxpupuli/puppet-rundeck/pull/175) ([danifr](https://github.com/danifr))
- Add support for customizing profile [\#174](https://github.com/voxpupuli/puppet-rundeck/pull/174) ([danifr](https://github.com/danifr))
- Simplify the acl template [\#173](https://github.com/voxpupuli/puppet-rundeck/pull/173) ([grafjo](https://github.com/grafjo))
- Add ability to specify different project and key storage types [\#167](https://github.com/voxpupuli/puppet-rundeck/pull/167) ([jyaworski](https://github.com/jyaworski))

## [v2.2.0](https://github.com/voxpupuli/puppet-rundeck/tree/v2.2.0) (2016-02-19)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v2.1.0...v2.2.0)

**Merged pull requests:**

- fixing spec tests [\#180](https://github.com/voxpupuli/puppet-rundeck/pull/180) ([liamjbennett](https://github.com/liamjbennett))
- updating changelog for version 2.2.0 [\#179](https://github.com/voxpupuli/puppet-rundeck/pull/179) ([liamjbennett](https://github.com/liamjbennett))
- adding required .gitignore entries [\#178](https://github.com/voxpupuli/puppet-rundeck/pull/178) ([liamjbennett](https://github.com/liamjbennett))

## [v2.1.0](https://github.com/voxpupuli/puppet-rundeck/tree/v2.1.0) (2016-02-19)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Validate ACL policy [\#103](https://github.com/voxpupuli/puppet-rundeck/issues/103)
- log4j config needs update [\#85](https://github.com/voxpupuli/puppet-rundeck/issues/85)
- params list are huge now, no instruction on how to use them properly. [\#82](https://github.com/voxpupuli/puppet-rundeck/issues/82)
- Add support for JettyCombinedLdapLoginModule [\#68](https://github.com/voxpupuli/puppet-rundeck/issues/68)
- Add support for rundeck.projectsStorageType setting [\#66](https://github.com/voxpupuli/puppet-rundeck/issues/66)
- Jetty combined ldap [\#98](https://github.com/voxpupuli/puppet-rundeck/pull/98) ([rooty0](https://github.com/rooty0))
- Add class to manage security-role in web.xml [\#86](https://github.com/voxpupuli/puppet-rundeck/pull/86) ([wcooley](https://github.com/wcooley))

**Closed issues:**

- Aclpolicy is getting null pointer [\#160](https://github.com/voxpupuli/puppet-rundeck/issues/160)
- resource\_source's validation of $number is too restrictive [\#157](https://github.com/voxpupuli/puppet-rundeck/issues/157)
- PE2015.2.3 Error: Facter: error while processing "/etc/facter/facts.d/rundeck\_facts.rb" for external facts: child process returned non-zero exit status \(127\). [\#156](https://github.com/voxpupuli/puppet-rundeck/issues/156)
- Invalid parameter: 'ssh\_keypath' [\#150](https://github.com/voxpupuli/puppet-rundeck/issues/150)
- Modulesync? [\#133](https://github.com/voxpupuli/puppet-rundeck/issues/133)
- Error on rundeck::facts crashing old puppetdb [\#132](https://github.com/voxpupuli/puppet-rundeck/issues/132)
- Librarian-puppet can't find puppet/archive [\#131](https://github.com/voxpupuli/puppet-rundeck/issues/131)
- What about a new module release? [\#126](https://github.com/voxpupuli/puppet-rundeck/issues/126)
- Changing the database doesn't move project data [\#124](https://github.com/voxpupuli/puppet-rundeck/issues/124)
- Project define doesn't have ssh\_keypath parameter [\#118](https://github.com/voxpupuli/puppet-rundeck/issues/118)
- Ensure that puppet-archive dependency is correctly installed [\#115](https://github.com/voxpupuli/puppet-rundeck/issues/115)
- Add aws-ec2 as resource\_source [\#112](https://github.com/voxpupuli/puppet-rundeck/issues/112)
- Add support for customizing realm.properties [\#110](https://github.com/voxpupuli/puppet-rundeck/issues/110)
- Add support for customizing rundeck-config [\#108](https://github.com/voxpupuli/puppet-rundeck/issues/108)

**Merged pull requests:**

- added provisioning of file-based keystores via hiera [\#172](https://github.com/voxpupuli/puppet-rundeck/pull/172) ([dalisch](https://github.com/dalisch))
- Fixes GH-157 [\#171](https://github.com/voxpupuli/puppet-rundeck/pull/171) ([jyaworski](https://github.com/jyaworski))
- fix typo: voxpupuliy -\> voxpupuli [\#170](https://github.com/voxpupuli/puppet-rundeck/pull/170) ([bastelfreak](https://github.com/bastelfreak))
- Rename to voxpupuli [\#169](https://github.com/voxpupuli/puppet-rundeck/pull/169) ([petems](https://github.com/petems))
- Move to rundeck\_version as a fact [\#165](https://github.com/voxpupuli/puppet-rundeck/pull/165) ([jyaworski](https://github.com/jyaworski))
- value field in ini\_setting is now always a string [\#164](https://github.com/voxpupuli/puppet-rundeck/pull/164) ([bovy89](https://github.com/bovy89))
- should contain JettyCachingLdapLoginModule and be sufficient [\#163](https://github.com/voxpupuli/puppet-rundeck/pull/163) ([dalisch](https://github.com/dalisch))
- disable H2 database logging in log4j.properties [\#161](https://github.com/voxpupuli/puppet-rundeck/pull/161) ([dalisch](https://github.com/dalisch))
- Make ssh\_keypath and projects\_dir parameters of the project defined type [\#153](https://github.com/voxpupuli/puppet-rundeck/pull/153) ([jyaworski](https://github.com/jyaworski))
- updating metadata and changelog for 2.1.0 release [\#152](https://github.com/voxpupuli/puppet-rundeck/pull/152) ([liamjbennett](https://github.com/liamjbennett))
- Updating module\_sync exceptions for rubocop in files directory. [\#151](https://github.com/voxpupuli/puppet-rundeck/pull/151) ([liamjbennett](https://github.com/liamjbennett))
- Implement \#137, adding the rundeck\_server parameter [\#148](https://github.com/voxpupuli/puppet-rundeck/pull/148) ([jyaworski](https://github.com/jyaworski))
- Fixing the autoload of the rundeck\_acl function. [\#146](https://github.com/voxpupuli/puppet-rundeck/pull/146) ([liamjbennett](https://github.com/liamjbennett))
- key storage non-default dir path support [\#145](https://github.com/voxpupuli/puppet-rundeck/pull/145) ([rooty0](https://github.com/rooty0))
- add gui session timeout support [\#144](https://github.com/voxpupuli/puppet-rundeck/pull/144) ([rooty0](https://github.com/rooty0))
- removing old example related to java install [\#143](https://github.com/voxpupuli/puppet-rundeck/pull/143) ([rooty0](https://github.com/rooty0))
- remove java dependency from deb [\#141](https://github.com/voxpupuli/puppet-rundeck/pull/141) ([rooty0](https://github.com/rooty0))
- Validate ACLs against rd-acl recommendations [\#139](https://github.com/voxpupuli/puppet-rundeck/pull/139) ([jyaworski](https://github.com/jyaworski))
- \(\#132\) Fixing bad syntax on rundeck\_version fact [\#138](https://github.com/voxpupuli/puppet-rundeck/pull/138) ([jbehrends](https://github.com/jbehrends))
- Add .sync.yml for modulesync [\#136](https://github.com/voxpupuli/puppet-rundeck/pull/136) ([jyaworski](https://github.com/jyaworski))
- Add RHEL7/CentOS7 to supported OS list [\#135](https://github.com/voxpupuli/puppet-rundeck/pull/135) ([jyaworski](https://github.com/jyaworski))
- Update from puppet-community modulesync\_configs [\#134](https://github.com/voxpupuli/puppet-rundeck/pull/134) ([jyaworski](https://github.com/jyaworski))
- adding usage section with shared ldap configuration example [\#130](https://github.com/voxpupuli/puppet-rundeck/pull/130) ([rooty0](https://github.com/rooty0))
- Documentation fix for option auth\_type [\#129](https://github.com/voxpupuli/puppet-rundeck/pull/129) ([rooty0](https://github.com/rooty0))
- Only include ssl bits when ssl is enabled [\#128](https://github.com/voxpupuli/puppet-rundeck/pull/128) ([jyaworski](https://github.com/jyaworski))
- Add rundeck::projects to specify projects in your rundeck instance [\#127](https://github.com/voxpupuli/puppet-rundeck/pull/127) ([jyaworski](https://github.com/jyaworski))
- \(\#112\) Add `aws-ec2` as resource\_source to support Rundeck EC2 Nodes Plugin [\#113](https://github.com/voxpupuli/puppet-rundeck/pull/113) ([patcadelina](https://github.com/patcadelina))
- \(\#110\) Add support for customizing realm.properties [\#111](https://github.com/voxpupuli/puppet-rundeck/pull/111) ([patcadelina](https://github.com/patcadelina))
- \(\#108\) Add support for customizing rundeck-config [\#109](https://github.com/voxpupuli/puppet-rundeck/pull/109) ([patcadelina](https://github.com/patcadelina))

## [v2.0.0](https://github.com/voxpupuli/puppet-rundeck/tree/v2.0.0) (2015-09-11)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v1.2.0...v2.0.0)

**Implemented enhancements:**

- Add ability to use LDAPS for JAAS auth [\#61](https://github.com/voxpupuli/puppet-rundeck/issues/61)
- Add server.web.context argument [\#92](https://github.com/voxpupuli/puppet-rundeck/pull/92) ([oloc](https://github.com/oloc))

**Fixed bugs:**

- bug in Rundeck::Install [\#91](https://github.com/voxpupuli/puppet-rundeck/issues/91)
- bindDn define are different in ldap and AD [\#84](https://github.com/voxpupuli/puppet-rundeck/issues/84)
- Duplicate declaration $properties\_file project.pp vs resource\_source.pp [\#83](https://github.com/voxpupuli/puppet-rundeck/issues/83)
- use ${pd} variable to replace /var/lib/rundeck/libext, if not default value [\#79](https://github.com/voxpupuli/puppet-rundeck/issues/79)
- Resource \["File", "/var/lib/rundeck/libext"\] already declared [\#77](https://github.com/voxpupuli/puppet-rundeck/issues/77)
- bug report - rundeck user account  [\#72](https://github.com/voxpupuli/puppet-rundeck/issues/72)
- Default JDK versions are out of date [\#48](https://github.com/voxpupuli/puppet-rundeck/issues/48)
- puppet-omnibus didn't work with puppet-rundeck. [\#45](https://github.com/voxpupuli/puppet-rundeck/issues/45)
- Storage access for admin group [\#44](https://github.com/voxpupuli/puppet-rundeck/issues/44)

**Closed issues:**

- Invalid acl policies generated? [\#121](https://github.com/voxpupuli/puppet-rundeck/issues/121)
- Support for self signed certificate [\#107](https://github.com/voxpupuli/puppet-rundeck/issues/107)
- PR \#76 breaks due to incomplete "framework\_config" [\#100](https://github.com/voxpupuli/puppet-rundeck/issues/100)
- ldap template typo [\#96](https://github.com/voxpupuli/puppet-rundeck/issues/96)
- jre\_manage is broken [\#94](https://github.com/voxpupuli/puppet-rundeck/issues/94)
- doesn't have ldaps support [\#93](https://github.com/voxpupuli/puppet-rundeck/issues/93)
- rd-jobs is failed after change admin password [\#87](https://github.com/voxpupuli/puppet-rundeck/issues/87)
- How to prepare the hiera yaml file for `auth\_config` in `templates/realm.properties.erb` [\#78](https://github.com/voxpupuli/puppet-rundeck/issues/78)

**Merged pull requests:**

- Fix ACL format [\#123](https://github.com/voxpupuli/puppet-rundeck/pull/123) ([jyaworski](https://github.com/jyaworski))
- Make supplemental\_roles an array, not a string [\#122](https://github.com/voxpupuli/puppet-rundeck/pull/122) ([jyaworski](https://github.com/jyaworski))
- Add pam support to authentication [\#120](https://github.com/voxpupuli/puppet-rundeck/pull/120) ([jyaworski](https://github.com/jyaworski))
- A new function to validate the acl policies [\#117](https://github.com/voxpupuli/puppet-rundeck/pull/117) ([liamjbennett](https://github.com/liamjbennett))
- Removed stale resource\_source documentation [\#116](https://github.com/voxpupuli/puppet-rundeck/pull/116) ([grafjo](https://github.com/grafjo))
- Set java\_home directory [\#114](https://github.com/voxpupuli/puppet-rundeck/pull/114) ([BobVanB](https://github.com/BobVanB))
- fetching packages over tls instead of clear test [\#106](https://github.com/voxpupuli/puppet-rundeck/pull/106) ([gcmalloc](https://github.com/gcmalloc))
- Fix for \#100 deep merging issue with aclpolicyfile [\#105](https://github.com/voxpupuli/puppet-rundeck/pull/105) ([liamjbennett](https://github.com/liamjbennett))
- Fix the projects directory default in framework.properies. [\#104](https://github.com/voxpupuli/puppet-rundeck/pull/104) ([liamjbennett](https://github.com/liamjbennett))
- Fixed invalid metadata.json [\#101](https://github.com/voxpupuli/puppet-rundeck/pull/101) ([grafjo](https://github.com/grafjo))
- fix typo in ldap template [\#97](https://github.com/voxpupuli/puppet-rundeck/pull/97) ([rooty0](https://github.com/rooty0))
- Fix for \#72 - bug with non-default user and group [\#90](https://github.com/voxpupuli/puppet-rundeck/pull/90) ([liamjbennett](https://github.com/liamjbennett))
- Refactoring \(again\) how the rundeck\_version fact is generated. [\#89](https://github.com/voxpupuli/puppet-rundeck/pull/89) ([liamjbennett](https://github.com/liamjbennett))
- Option 2 - removing the management of the java jre [\#88](https://github.com/voxpupuli/puppet-rundeck/pull/88) ([liamjbennett](https://github.com/liamjbennett))
- bugfix/\#81 - service need be restarted if config is changed. [\#81](https://github.com/voxpupuli/puppet-rundeck/pull/81) ([ozbillwang](https://github.com/ozbillwang))
- Enhanced acl policy files with rundeck::config::aclpolicyfile [\#76](https://github.com/voxpupuli/puppet-rundeck/pull/76) ([grafjo](https://github.com/grafjo))

## [v1.2.0](https://github.com/voxpupuli/puppet-rundeck/tree/v1.2.0) (2015-05-22)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v1.1.0...v1.2.0)

**Closed issues:**

- Wrong user & group variables for project dir in resource\_source [\#73](https://github.com/voxpupuli/puppet-rundeck/issues/73)
- Why /etc/rundeck/rundeck-config.properties is removed and replaced by rundeck-config.groovy [\#70](https://github.com/voxpupuli/puppet-rundeck/issues/70)
- Add ability to use "roleUsernameMemberAttribute" for JAAS LDAP auth [\#62](https://github.com/voxpupuli/puppet-rundeck/issues/62)
- Add ability to replace $rundeck::params::jvm\_args [\#59](https://github.com/voxpupuli/puppet-rundeck/issues/59)
- log4j config for access log is truncated [\#57](https://github.com/voxpupuli/puppet-rundeck/issues/57)
- package\_version and package\_source \(baseurl\) are not supported for Redhat/CentOS. [\#43](https://github.com/voxpupuli/puppet-rundeck/issues/43)
- Fact rundeck\_version is not OS aware [\#41](https://github.com/voxpupuli/puppet-rundeck/issues/41)
- rundeck url change to http://localhost:4440 [\#40](https://github.com/voxpupuli/puppet-rundeck/issues/40)
- New owner, what happen? [\#39](https://github.com/voxpupuli/puppet-rundeck/issues/39)
- Build fails, so no commits to forge.puppetlabs.com [\#36](https://github.com/voxpupuli/puppet-rundeck/issues/36)

**Merged pull requests:**

- Fixed admin.aclpolicy params [\#75](https://github.com/voxpupuli/puppet-rundeck/pull/75) ([grafjo](https://github.com/grafjo))
- Fix \#73 - Wrong user & group variables for project dir in resource\_source [\#74](https://github.com/voxpupuli/puppet-rundeck/pull/74) ([wcooley](https://github.com/wcooley))
- bugfix/\#43 - rundeck service is not restarted after upgraded in CentOS [\#69](https://github.com/voxpupuli/puppet-rundeck/pull/69) ([ozbillwang](https://github.com/ozbillwang))
- Enable "roleUsernameMemberAttribute" for LDAP auth \(issue \#62\) [\#65](https://github.com/voxpupuli/puppet-rundeck/pull/65) ([wcooley](https://github.com/wcooley))
- Allow an "url" parameter for LDAP connection \(issue \#61\) [\#64](https://github.com/voxpupuli/puppet-rundeck/pull/64) ([wcooley](https://github.com/wcooley))
- Add context for merging potentially conflicting LDAP tests \(issues \#61 & \#62\) [\#63](https://github.com/voxpupuli/puppet-rundeck/pull/63) ([wcooley](https://github.com/wcooley))
- Add support for setting jvm\_args \(issue \#59\) [\#60](https://github.com/voxpupuli/puppet-rundeck/pull/60) ([wcooley](https://github.com/wcooley))
- Fix clipped log format without newline \(issue \#57\) [\#58](https://github.com/voxpupuli/puppet-rundeck/pull/58) ([wcooley](https://github.com/wcooley))
- Require Java 1.7 for RHEL, per Rundeck reqs \(\#48\) [\#56](https://github.com/voxpupuli/puppet-rundeck/pull/56) ([wcooley](https://github.com/wcooley))
- Fix little typo in docs. [\#55](https://github.com/voxpupuli/puppet-rundeck/pull/55) ([eperdeme](https://github.com/eperdeme))
- Extracted grails.mail.default.from as property again [\#54](https://github.com/voxpupuli/puppet-rundeck/pull/54) ([grafjo](https://github.com/grafjo))
- Fixed templates/\_auth\_ldap.erb [\#53](https://github.com/voxpupuli/puppet-rundeck/pull/53) ([grafjo](https://github.com/grafjo))
- Like \#46, fix puppet/facter \#45, but w/rpm [\#51](https://github.com/voxpupuli/puppet-rundeck/pull/51) ([wcooley](https://github.com/wcooley))
- spdx compatible license [\#50](https://github.com/voxpupuli/puppet-rundeck/pull/50) ([igalic](https://github.com/igalic))
- Fix minor README formatting issues [\#47](https://github.com/voxpupuli/puppet-rundeck/pull/47) ([wcooley](https://github.com/wcooley))
- This should work on any OS. [\#42](https://github.com/voxpupuli/puppet-rundeck/pull/42) ([robertdebock](https://github.com/robertdebock))
- Add option to configure API acls [\#38](https://github.com/voxpupuli/puppet-rundeck/pull/38) ([ak0ska](https://github.com/ak0ska))
- Multiple auth users [\#37](https://github.com/voxpupuli/puppet-rundeck/pull/37) ([rkcpi](https://github.com/rkcpi))
- Syntax problem mixed public and private classes [\#35](https://github.com/voxpupuli/puppet-rundeck/pull/35) ([robertdebock](https://github.com/robertdebock))

## [v1.1.0](https://github.com/voxpupuli/puppet-rundeck/tree/v1.1.0) (2015-03-24)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v1.0.0...v1.1.0)

**Implemented enhancements:**

- switch the rundeck-config file from properties file to groovy file [\#15](https://github.com/voxpupuli/puppet-rundeck/issues/15)
- Add support for passing in e-mail configuration [\#14](https://github.com/voxpupuli/puppet-rundeck/issues/14)
- manage the /etc/init/rundeckd.conf file [\#5](https://github.com/voxpupuli/puppet-rundeck/issues/5)
- Add support for configuring a non-default DB [\#4](https://github.com/voxpupuli/puppet-rundeck/issues/4)

**Closed issues:**

- Add support for cluster mode [\#27](https://github.com/voxpupuli/puppet-rundeck/issues/27)
- Avoid using hard coded versions [\#18](https://github.com/voxpupuli/puppet-rundeck/issues/18)
- Initscript not compatible with chkconfig on CentOS 6 [\#16](https://github.com/voxpupuli/puppet-rundeck/issues/16)
- admin\_password should be a parameter [\#12](https://github.com/voxpupuli/puppet-rundeck/issues/12)

**Merged pull requests:**

- Resource source refactor [\#34](https://github.com/voxpupuli/puppet-rundeck/pull/34) ([smithtrevor](https://github.com/smithtrevor))
- Add a jre\_manage parameter [\#32](https://github.com/voxpupuli/puppet-rundeck/pull/32) ([beezly](https://github.com/beezly))
- Plugin refactor [\#31](https://github.com/voxpupuli/puppet-rundeck/pull/31) ([smithtrevor](https://github.com/smithtrevor))
- Ad auth [\#29](https://github.com/voxpupuli/puppet-rundeck/pull/29) ([smithtrevor](https://github.com/smithtrevor))
- \#27 Add support for cluster mode [\#28](https://github.com/voxpupuli/puppet-rundeck/pull/28) ([danifr](https://github.com/danifr))
- Project refactor [\#26](https://github.com/voxpupuli/puppet-rundeck/pull/26) ([smithtrevor](https://github.com/smithtrevor))
- Add ldap login support [\#25](https://github.com/voxpupuli/puppet-rundeck/pull/25) ([ak0ska](https://github.com/ak0ska))
- Make yum repo optional \(default on\) [\#24](https://github.com/voxpupuli/puppet-rundeck/pull/24) ([ak0ska](https://github.com/ak0ska))
- Add service notifications [\#23](https://github.com/voxpupuli/puppet-rundeck/pull/23) ([smithtrevor](https://github.com/smithtrevor))
- Fix beaker tests [\#21](https://github.com/voxpupuli/puppet-rundeck/pull/21) ([pall-valmundsson](https://github.com/pall-valmundsson))
- Add support for configuring a non-default DB [\#20](https://github.com/voxpupuli/puppet-rundeck/pull/20) ([danifr](https://github.com/danifr))
- Fix rundeck-config.groovy [\#17](https://github.com/voxpupuli/puppet-rundeck/pull/17) ([taylorleese](https://github.com/taylorleese))

## [v1.0.0](https://github.com/voxpupuli/puppet-rundeck/tree/v1.0.0) (2014-10-13)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v0.2.0...v1.0.0)

**Closed issues:**

- Update the default rundeck version to 2.2.3-1-GA [\#11](https://github.com/voxpupuli/puppet-rundeck/issues/11)
- Grails server url in '/etc/rundeck/rundeck-config.properties' doesn't respect server url [\#10](https://github.com/voxpupuli/puppet-rundeck/issues/10)
- Indentation in admin.aclpolicy and apitoken.aclpolicy is wrong [\#9](https://github.com/voxpupuli/puppet-rundeck/issues/9)
- Error 'Could not find package rundeck-2.0.3-1.14.GA' under CentOS 5.6 [\#6](https://github.com/voxpupuli/puppet-rundeck/issues/6)
- Incorrect tag on puppetforge [\#1](https://github.com/voxpupuli/puppet-rundeck/issues/1)

**Merged pull requests:**

- Allow admin access to everything [\#8](https://github.com/voxpupuli/puppet-rundeck/pull/8) ([crayfishx](https://github.com/crayfishx))
- Fixed YAML indentation in aclpolicy file [\#7](https://github.com/voxpupuli/puppet-rundeck/pull/7) ([crayfishx](https://github.com/crayfishx))
- Fixing debian install check [\#3](https://github.com/voxpupuli/puppet-rundeck/pull/3) ([stack72](https://github.com/stack72))
- Implement installing as a package repo for redhat [\#2](https://github.com/voxpupuli/puppet-rundeck/pull/2) ([benh57](https://github.com/benh57))

## [v0.2.0](https://github.com/voxpupuli/puppet-rundeck/tree/v0.2.0) (2014-04-03)
[Full Changelog](https://github.com/voxpupuli/puppet-rundeck/compare/v0.1.0...v0.2.0)

## [v0.1.0](https://github.com/voxpupuli/puppet-rundeck/tree/v0.1.0) (2014-03-28)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*