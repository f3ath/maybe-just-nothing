# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.3] - 2023-03-15
### Changed
- ifPresent() and ifNothing() return self

## [0.5.2] - 2023-03-15
### Changed
- Repackaged to hide internal interfaces

## [0.5.1] - 2023-03-15
### Added
- merge2() method

## [0.5.0] - 2023-03-04
### Added
- tryMap() method

### Changed
- BC-BREAKING. The generic type of `Maybe` is made unbounded.

### Removed
- BC-BREAKING. `Maybe` does not have a constructor anymore.

## [0.4.0] - 2021-03-14
### Changed
- This is a BC-breaking change to support null safety. Please refer to the tests and documentation.
- `ifPresent()` and `ifNothing()` were made `void`.

## [0.3.1] - 2020-07-20
### Fixed
- README update

## [0.3.0] - 2020-07-20
### Changed
- Allow `map` to return a null. Hence, the BC-breaking change in `Just.map` signature.

## [0.2.0] - 2020-07-11
### Added
- Method `fallback()`
- Equality operator support

### Changed
- Method `chain()` now accepts a value instead of a function. The old method is available as `fallback()`

### Removed
- Method `filter()`

## [0.1.9] - 2020-06-27
### Changed
- ifPresent() and ifNothing() return Maybe<T> instead of null

## [0.1.8] - 2020-06-13
### Added
- `const` constructor to `Nothing`

## [0.1.7] - 2020-06-13
### Changed
- Relaxed `cast()` type constraint

## [0.1.6] - 2020-06-13
### Added
- `chain()` method

## [0.1.5] - 2020-06-13
### Fixed
- "`Future` was not exported" in tests

## [0.1.4] - 2020-06-13
### Changed
- `Just` and `Nothing` return more narrow types in certain cases

## [0.1.3] - 2020-06-13
### Fixed
- `Future` was not exported

## [0.1.2] - 2020-06-13
### Changed
- relaxed min Dart version to 2.0.0
- minor readme fixes

## [0.1.1] - 2020-06-13
### Added
- `where` is an alias for `filter`

## [0.1.0] - 2020-05-24
### Added
- New methods: `cast()`, `orAsync()`, `orGetAsync()`, `flatMap()`, `merge()`

## 0.0.1 - 2020-05-23
### Added
- Initial version.

[0.5.3]: https://github.com/f3ath/maybe-just-nothing/compare/0.5.2...0.5.3
[0.5.2]: https://github.com/f3ath/maybe-just-nothing/compare/0.5.1...0.5.2
[0.5.1]: https://github.com/f3ath/maybe-just-nothing/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/f3ath/maybe-just-nothing/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/f3ath/maybe-just-nothing/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/f3ath/maybe-just-nothing/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/f3ath/maybe-just-nothing/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.9...0.2.0
[0.1.9]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.8...0.1.9
[0.1.8]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.7..0.1.8
[0.1.7]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.6..0.1.7
[0.1.6]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.5..0.1.6
[0.1.5]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.4..0.1.5
[0.1.4]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.3..0.1.4
[0.1.3]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.2..0.1.3
[0.1.2]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.1..0.1.2
[0.1.1]: https://github.com/f3ath/maybe-just-nothing/compare/0.1.0..0.1.1
[0.1.0]: https://github.com/f3ath/maybe-just-nothing/compare/0.0.1..0.1.0