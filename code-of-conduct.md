# Open Source activity

This document contains all decisions and agreements made by ustwo tech and
acts as a reference for anyone creating open source projects in ustwo. You
might be interested in [Open Source in the context of client
work](client-work-oss.md) as well.

Use our [#open-source][oss-slack] Slack channel or open an issue or a pull
request here to discuss anything regarding this topic.


## What license do we use?

It is required that you add a license to your open source project. The default
license for any open source ustwo work is [MIT][mit-license].

Where `<year>` should be the current year and `<copyright holders>` should be
“Ustwo Fampany Ltd.” as shown in the [LICENSE template][license-template].

If the MIT License doesn't suit your needs, please reach
[#open-source][oss-slack] on Slack and let us know why so we can adapt.


## Contact

Add `open.source@ustwo.com` as a contact in the `README.md`.

This is a complement to the usual [Maintainers](#maintainers) section with the
list of active maintainers of the project.

It would look like:

```markdown
## Maintainers

* Arnau Siches (@arnau)

## Contact

[open.source@ustwo.com](mailto:open.source@ustwo.com)
```

You might find useful the [README template][readme-template]. For real example
with a long readme check [Mastermind][mastermind]. For a more concise one
check the one from [Brunel][brunel].


## Maintainers

This section is required to have at least the main maintainer name and
surname. A good practice is to add the Github username in the form of
`@username` so Github will autolink it.

```markdown
## Maintainers

* Arnau Siches (@arnau)
```

If you find it useful for your project, feel free to add your email address
as well.


```markdown
## Maintainers

* [Arnau Siches](mailto:arnau@ustwo.com) (@arnau)
```


## Code of conduct

Place a copy of [`CODE_OF_CONDUCT.md`](../templates/CODE_OF_CONDUCT.md) in your repository.


## Contributing

Add a clear description of how to contribute to the project using a
[`CONTRIBUTING.md`][gh-post-contributing] file. You can start with our [basic
template][contributing-template]. We encourage you to place such file in the
`.github` directory.

Then, put a section “Contributing” in your README with a link to the document.

To allow external contributions read [manage the contribution][contribution-rights].


## Issues and Pull Requests

Consider adding [Issues and Pull Requests templates][gh-post-templates] under
a `.github` directory. You can start with our [issue
template][issue-template] and our [pull request template][pr-template].

Other examples to get inspiration from:

* [Angular][angular-templates]
* [CocoaPods][cocoapods-templates]
* [Docker][docker-templates]
* [Homebrew][homebrew-templates]
* [NPM][npm-templates]
* [React Native][react-native-templates]


## Libraries used on our Open Source projects

Always check that the licenses of the libraries you use play well with our
choice.

Consider adding a `NOTICE` document close to `LICENSE` with the compiled
licenses used by your project. Not mandatory, just being nice.

You can find an example for `NOTICE` in the [Mastermind][mastermind]
repository.


## Versioning

The default versioning system for any open source ustwo work is [Semantic
Versioning][semver]. In short, given a version number MAJOR.MINOR.PATCH,
increment the:

1. MAJOR version when you make incompatible API changes,
2. MINOR version when you add functionality in a backwards-compatible manner, and
3. PATCH version when you make backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as
extensions to the MAJOR.MINOR.PATCH format.

If Semantic Versioning doesn't fit your needs let us know at
[#open-source][oss-slack] so we can improve this document.


## Releases

Releases should be tagged in Git using the same convention used in
[Versioning](#versioning). If your release has bundled artifacts you can use
a tool like [Github Release][github-release] to automate the release.

For example, in [Mastermind][mastermind] there is a `make` task to deal with
the bundling and pushing process.


## Distribution

Make sure your project explains the intended way to get a copy of a release.

For example, [Mastermind][mastermind] is distributed via Homebrew via our
[Homebrew Tools repository][homebrew-tools]. Equally, the README explains
how to install it from source which uses *pip* given it's a Python tool.

Other projects like [UIImage+Color.swift][image-color-swift] describe the
intended package manager to use, in this case *CocoaPods*.

In short, be nice and welcoming to anyone unfamiliar with the technology stack
you chose for your project.


## How to engage with non-ustwo open source projects

For details of how to deal with open source in client work, make sure you read
[client-work-oss][client-work-oss].

You can and should give back to open source projects whenever you can. For
example, when you are in-between projects it's the perfect opportunity to
spend some time giving back to the open source tools you used in your last
project.

If you find an issue or have a suggestion, might be better to submit a
detailed ticket explaining the case. Doing it straight away makes sure you
have the use case at hand. If you are worried about how to express this when
logging your hours, check with your Tech Director, they are nice and well
aware of this.

Now that you know when to engage with open source projects and you know how to
log these hours you have to do it. To do so, the preferred way when enhancing
an open source project is to fork it, work on it and make a Pull Request to
the original repository. Make sure you follow their code of conduct, code
style, issue/pull request templates, etc.

If the Pull Request is rejected and the contribution has enough value for
ustwo to keep a healthy fork and the license lets us, make a case to your
peers and your Tech Director to keep it.


[oss-slack]: https://ustwo.slack.com/messages/open-source/
[mit-license]: https://opensource.org/licenses/MIT
[license-template]: ../resources/common/LICENSE
[contributing-template]: resources/common/CONTRIBUTING.md
[issue-template]: resources/github/ISSUE_TEMPLATE.md
[readme-template]: resources/common/README.md
[pr-template]: resources/github/PULL_REQUEST_TEMPLATE.md
[semver]: http://semver.org/
[homebrew-tools]: https://github.com/ustwo/homebrew-tools
[gh-post-templates]: https://github.com/blog/2111-issue-and-pull-request-templates
[gh-post-contributing]: https://github.com/blog/1184-contributing-guidelines
[mastermind]: https://github.com/ustwo/mastermind
[image-color-swift]: https://github.com/ustwo/image-color-swift
[brunel]: https://github.com/ustwo/brunel
[github-release]: https://github.com/aktau/github-release
[client-work-oss]: client-work-oss.md
[angular-templates]: https://github.com/angular/angular/tree/master/.github
[cocoapods-templates]: https://github.com/CocoaPods/CocoaPods/tree/master/.github
[docker-templates]: https://github.com/docker/docker/tree/master/.github
[homebrew-templates]: https://github.com/Homebrew/homebrew-core/tree/master/.github
[npm-templates]: https://github.com/npm/npm/tree/master/.github
[react-native-templates]: https://github.com/facebook/react-native/tree/master/.github
[contribution-rights]: managing-contributions-rights.md
